From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.13 41/53] genirq/cpuhotplug: Enforce affinity setting on startup of managed irqs
Date: Mon, 16 Oct 2017 18:16:38 +0200
Message-ID: <20171016161443.962836398@linuxfoundation.org>
References: <20171016161442.263947886@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171016161442.263947886@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, axboe@kernel.dk, linux-scsi@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>, Marc Zyngier <marc.zyngier@arm.com>, mpe@ellerman.id.au, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, keith.busch@intel.com, peterz@infradead.org, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

4.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit e43b3b58548051f8809391eb7bec7a27ed3003ea upstream.

Managed interrupts can end up in a stale state on CPU hotplug. If the
interrupt is not targeting a single CPU, i.e. the affinity mask spawns
multiple CPUs then the following can happen:

After boot:

dstate:   0x01601200
            IRQD_ACTIVATED
            IRQD_IRQ_STARTED
            IRQD_SINGLE_TARGET
            IRQD_AFFINITY_SET
            IRQD_AFFINITY_MANAGED
node:     0
affinity: 24-31
effectiv: 24
pending:  0

After offlining CPU 31 - 24

dstate:   0x01a31000
            IRQD_IRQ_DISABLED
            IRQD_IRQ_MASKED
            IRQD_SINGLE_TARGET
            IRQD_AFFINITY_SET
            IRQD_AFFINITY_MANAGED
            IRQD_MANAGED_SHUTDOWN
node:     0
affinity: 24-31
effectiv: 24
pending:  0

Now CPU 25 gets onlined again, so it should get the effective interrupt
affinity for this interruopt, but due to the x86 interrupt affinity setter
restrictions this ends up after restarting the interrupt with:

dstate:   0x01601300
            IRQD_ACTIVATED
            IRQD_IRQ_STARTED
            IRQD_SINGLE_TARGET
            IRQD_AFFINITY_SET
            IRQD_SETAFFINITY_PENDING
            IRQD_AFFINITY_MANAGED
node:     0
affinity: 24-31
effectiv: 24
pending:  24-31

So the interrupt is still affine to CPU 24, which was the last CPU to go
offline of that affinity set and the move to an online CPU within 24-31,
in this case 25, is pending. This mechanism is x86/ia64 specific as those
architectures cannot move interrupts from thread context and do this when
an interrupt is actually handled. So the move is set to pending.

Whats worse is that offlining CPU 25 again results in:

dstate:   0x01601300
            IRQD_ACTIVATED
            IRQD_IRQ_STARTED
            IRQD_SINGLE_TARGET
            IRQD_AFFINITY_SET
            IRQD_SETAFFINITY_PENDING
            IRQD_AFFINITY_MANAGED
node:     0
affinity: 24-31
effectiv: 24
pending:  24-31

This means the interrupt has not been shut down, because the outgoing CPU
is not in the effective affinity mask, but of course nothing notices that
the effective affinity mask is pointing at an offline CPU.

In the case of restarting a managed interrupt the move restriction does not
apply, so the affinity setting can be made unconditional. This needs to be
done _before_ the interrupt is started up as otherwise the condition for
moving it from thread context would not longer be fulfilled.

With that change applied onlining CPU 25 after offlining 31-24 results in:

dstate:   0x01600200
            IRQD_ACTIVATED
            IRQD_IRQ_STARTED
            IRQD_SINGLE_TARGET
            IRQD_AFFINITY_MANAGED
node:     0
affinity: 24-31
effectiv: 25
pending:

And after offlining CPU 25:

dstate:   0x01a30000
            IRQD_IRQ_DISABLED
            IRQD_IRQ_MASKED
            IRQD_SINGLE_TARGET
            IRQD_AFFINITY_MANAGED
            IRQD_MANAGED_SHUTDOWN
node:     0
affinity: 24-31
effectiv: 25
pending:

which is the correct and expected result.

Fixes: 761ea388e8c4 ("genirq: Handle managed irqs gracefully in irq_startup()")
Reported-by: YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: mpe@ellerman.id.au
Cc: Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: keith.busch@intel.com
Cc: peterz@infradead.org
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Link: https://lkml.kernel.org/r/alpine.DEB.2.20.1710042208400.2406@nanos
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/chip.c   |    2 +-
 kernel/irq/manage.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -265,8 +265,8 @@ int irq_startup(struct irq_desc *desc, b
 			irq_setup_affinity(desc);
 			break;
 		case IRQ_STARTUP_MANAGED:
+			irq_do_set_affinity(d, aff, false);
 			ret = __irq_startup(desc);
-			irq_set_affinity_locked(d, aff, false);
 			break;
 		case IRQ_STARTUP_ABORT:
 			return 0;
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -175,6 +175,9 @@ int irq_do_set_affinity(struct irq_data
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	int ret;
 
+	if (!chip || !chip->irq_set_affinity)
+		return -EINVAL;
+
 	ret = chip->irq_set_affinity(data, mask, force);
 	switch (ret) {
 	case IRQ_SET_MASK_OK:

From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: Prevent busy looping
Date: Thu, 12 Jun 2008 13:32:52 +0200
Message-ID: <87d4mmubvf.fsf@denkblock.local>
References: <20080416151305.8788.63912.stgit@denkblock.local>
	<20080416163152.GK12774@kernel.dk> <87r6d5l9pb.fsf@denkblock.local>
	<20080417071335.GR12774@kernel.dk> <87ve2gc1bn.fsf@denkblock.local>
	<484F7A8D.1040809@gmail.com> <20080611080502.4aa43980@core>
	<484F86D4.8050907@gmail.com> <485092C9.3050309@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:40614 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbYFLLe1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jun 2008 07:34:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> wrote:
> Tejun Heo wrote:
>> Alan Cox wrote:
>
>>>> Elias's synthetic test case triggered infinite loop because it wasn't
>>>> a proper ->qc_defer().  ->qc_defer() should never defer commands when
>>>> the target is idle.
>>> Target or host ? We *do* defer commands in the case of an idle channel
>>> when dealing with certain simplex controllers that can only issue one
>>> command per host not one per cable (and in fact in the general case we
>>> can defer commands due to activity on the other drive on the cable).
>> 
>> The term was confusing.  I used target to mean both device
>> (ATA_DEFER_LINK) and host (ATA_DEFER_PORT).  Hmmm... in simplex case,
>> yeah, blocked counters need to be > 1.  We'll need to increase blocked
>> counts after all.  I'll test blocked counts of 2 w/ PMP and make sure it
>> doesn't incur unnecessary delays and post the patch.
>
> Setting blocked counts to 2 makes simplex scheduling starve one of the
> drives.  When a drive loses competition, it retries only after plug
> delay and of course it loses most of the time.  For now, it seems we'll
> have to live with busy loops (which doesn't lock up the machine) for
> simplex controllers.  Ewww... :-(

Since I'm a little confused by your comment, please explain again. Do
you mean to say that busy looping doesn't lock up the machine in general
or merely in the case of a simplex configuration?

The reason why I'm asking is this: The whole point of my synthetic
->qc_defer() function was to prove that command deferral could (under
certain conditions) lead to busy looping which *did* lock up my machine.
Lock up in this context means that there was no response whatsoever to
key presses and even timers didn't fire anymore. I can see your point
that my ->qc_defer() function doesn't reflect reality very well because
the device is idle at the time and therefore no interrupts can be
expected from there. However, I still think that interrupts won't even
be processed once busy looping has started (in some configurations at
least).

You can find a slightly modified version of my synthetic ->qc_defer()
function below (apply to 2.6.26-rc5) which demonstrates that at least
soft interrupts don't get serviced anymore once the busy looping has
started. Considering this, how can I be sure that an interrupt of the
target would be processed, even if it was not idle?

Regards,

Elias

 drivers/ata/ata_piix.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)


diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 81b7ae3..9816daa 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -167,6 +167,7 @@ static int ich_pata_cable_detect(struct ata_port *ap);
 static u8 piix_vmw_bmdma_status(struct ata_port *ap);
 static int piix_sidpr_scr_read(struct ata_port *ap, unsigned int reg, u32 *val);
 static int piix_sidpr_scr_write(struct ata_port *ap, unsigned int reg, u32 val);
+static int piix_qc_defer(struct ata_queued_cmd *qc);
 #ifdef CONFIG_PM
 static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int piix_pci_device_resume(struct pci_dev *pdev);
@@ -299,6 +300,7 @@ static struct ata_port_operations piix_pata_ops = {
 	.set_piomode		= piix_set_piomode,
 	.set_dmamode		= piix_set_dmamode,
 	.prereset		= piix_pata_prereset,
+	.qc_defer		= piix_qc_defer,
 };
 
 static struct ata_port_operations piix_vmw_ops = {
@@ -314,6 +316,7 @@ static struct ata_port_operations ich_pata_ops = {
 
 static struct ata_port_operations piix_sata_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.qc_defer		= piix_qc_defer,
 };
 
 static struct ata_port_operations piix_sidpr_sata_ops = {
@@ -323,6 +326,40 @@ static struct ata_port_operations piix_sidpr_sata_ops = {
 	.scr_write		= piix_sidpr_scr_write,
 };
 
+static unsigned int defer_count = 0;
+static struct timer_list defer_timer;
+
+static void piix_defer_timeout(unsigned long data)
+{
+	struct ata_port *ap = (struct ata_port *)data;
+
+	spin_lock_bh(ap->lock);
+	defer_count = 0;
+	spin_unlock_bh(ap->lock);
+}
+
+static int piix_qc_defer(struct ata_queued_cmd *qc)
+{
+	static struct ata_port *ap = NULL;
+#define PIIX_QC_DEFER_THRESHOLD 2000
+
+	if (!ap) {
+		ap = qc->ap;
+		defer_timer.data = (unsigned long)ap;
+		defer_timer.function = piix_defer_timeout;
+		init_timer(&defer_timer);
+	} else if (ap != qc->ap)
+		return 0;
+
+	defer_count++;
+	if (defer_count < PIIX_QC_DEFER_THRESHOLD)
+		return 0;
+
+        if (defer_count == PIIX_QC_DEFER_THRESHOLD)
+		mod_timer(&defer_timer, msecs_to_jiffies(5));
+	return ATA_DEFER_LINK;
+}
+
 static const struct piix_map_db ich5_map_db = {
 	.mask = 0x7,
 	.port_enable = 0x3,

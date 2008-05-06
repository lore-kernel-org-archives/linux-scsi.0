From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: lockdep warning in qla2xxx
Date: Tue, 6 May 2008 14:37:29 -0700
Message-ID: <20080506213729.GH57975@plap4.qlogic.org>
References: <20080506182341.GN19219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:35232 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbYEFVha (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2008 17:37:30 -0400
Content-Disposition: inline
In-Reply-To: <20080506182341.GN19219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Tue, 06 May 2008, Matthew Wilcox wrote:

> I'm in the middle of chasing something else right now, so I don't want
> to spend any time on this:
> 
> =================================
> [ INFO: inconsistent lock state ]
> 2.6.26-rc1-00115-g0340eda-dirty #60
> ---------------------------------
> inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
> swapper/1 [HC1[1]:SC0[0]:HE0:SE1] takes:
>  (&ha->hardware_lock){+-..}, at: [<c035495d>] qla2300_intr_handler+0x35/0x1f5
> {hardirq-on-W} state was registered at:
>   [<c0139a16>] __lock_acquire+0x459/0xb1d
>   [<c013a091>] __lock_acquire+0xad4/0xb1d
>   [<c013a142>] lock_acquire+0x68/0x82
>   [<c035495d>] qla2300_intr_handler+0x35/0x1f5
>   [<c0506da5>] _spin_lock+0x24/0x4d


Ok, admitently, my parsing of lockdep warnings is pretty weak, but I
guess what's happening here is that lockdep is detecting the
interrupt-handler is run in both process and interrupt context with
irqs-enabled in the former case.

During init-time and error-recovery (after a RISC reset), the driver
disables interrupts and 'polls' for completions by calling
qla2x00_poll():

	static inline void
	qla2x00_poll(scsi_qla_host_t *ha)
	{
		ha->isp_ops->intr_handler(0, ha);
	}

which in-turn calls the ISP registered interrupt handler.  One
possible solution to silence lockdep is to disable local interrupts
while the handler is polled...  This though seems fairly heavy handed.
Does something like the following make sense???

---

diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index e9bae27..92fafbd 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -34,7 +34,11 @@ qla2x00_debounce_register(volatile uint16_t __iomem *addr)
 static inline void
 qla2x00_poll(scsi_qla_host_t *ha)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	ha->isp_ops->intr_handler(0, ha);
+	local_irq_restore(flags);
 }
 
 static __inline__ scsi_qla_host_t *

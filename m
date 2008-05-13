From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 08/10] qla2xxx: Disable local-interrupts while polling for RISC status.
Date: Mon, 12 May 2008 22:21:14 -0700
Message-ID: <1210656076-54720-8-git-send-email-andrew.vasquez@qlogic.com>
References: <20080513051948.GN22377@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:52305 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679AbYEMFVW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 May 2008 01:21:22 -0400
In-Reply-To: <20080513051948.GN22377@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Matthew Wilcox <matthew@wil.cx> reported the following lockdep
warning:

 > =================================
 > [INFO:inconsistentlockstate]
 > 2.6.26-rc1-00115-g0340eda-dirty#60
 > ---------------------------------
 > inconsistent{hardirq-on-W}->{in-hardirq-W}usage.
 > swapper/1[HC1[1]:SC0[0]:HE0:SE1]takes:
 > (&ha->hardware_lock){+-..},at:[<c035495d>]qla2300_intr_handler+0x35/0x1f5
 > {hardirq-on-W}statewasregisteredat:
 > [<c0139a16>]__lock_acquire+0x459/0xb1d
 > [<c013a091>]__lock_acquire+0xad4/0xb1d
 > [<c013a142>]lock_acquire+0x68/0x82
 > [<c035495d>]qla2300_intr_handler+0x35/0x1f5
 > [<c0506da5>]_spin_lock+0x24/0x4d
 > [<c035495d>]qla2300_intr_handler+0x35/0x1f5
 > [<c035495d>]qla2300_intr_handler+0x35/0x1f5
 > [<c01391e4>]trace_hardirqs_on+0xe7/0x10e
 > [<c034f0a6>]qla2x00_mailbox_command+0x1c6/0x433
 ...
 > other info that might help us debug this:
 > no locks held by swapper/1.
 >
 > stack backtrace:
 > Pid:1,comm:swapperNottainted2.6.26-rc1-00115-g0340eda-dirty#60
 > [<c0138121>]print_usage_bug+0x100/0x10a
 > [<c0138d37>]mark_lock+0xaa/0x395
 > [<c01399af>]__lock_acquire+0x3f2/0xb1d
 > [<c013a091>]__lock_acquire+0xad4/0xb1d
 > [<c013a142>]lock_acquire+0x68/0x82
 > [<c035495d>]qla2300_intr_handler+0x35/0x1f5
 > [<c0506da5>]_spin_lock+0x24/0x4d
 > [<c035495d>]qla2300_intr_handler+0x35/0x1f5
 > [<c035495d>]qla2300_intr_handler+0x35/0x1f5
 > [<c014a37b>]handle_IRQ_event+0x13/0x3d
 > [<c014b366>]handle_fasteoi_irq+0x76/0xab

Which shows that lockdep is detecting the driver's
interrupt-handler is run in both process and interrupt context
with irqs-enabled in the former case.

During init-time and error-recovery (after a RISC reset), the
driver disables interrupts and 'polls' for completions by calling
qla2x00_poll():

	static inline void
	qla2x00_poll(scsi_qla_host_t *ha)
	{
		ha->isp_ops->intr_handler(0, ha);
	}

which in-turn calls the ISP registered interrupt handler.  This
patch corrects it by disabling local interrupts during polling.

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_inline.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

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
-- 
1.5.5.1.211.g65ea3


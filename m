From: akpm@osdl.org
Subject: [patch 14/20] megaraid_{mm,mbox}: fix a bug in reset handler
Date: Thu, 27 Apr 2006 02:33:06 -0700
Message-ID: <200604270934.k3R9YYeY025473@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:7632 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965035AbWD0Jel (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Apr 2006 05:34:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, Seokmann.Ju@lsil.com, seokmann.ju@lsil.com


From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>

When abort failed, the driver gets reset handleer called.  In the reset
handler, driver calls 'scsi_done()' callback for same SCSI command packet
(struct scsi_cmnd) multiple times if there are multiple SCSI command packet
in the pend_list.  More over, if there are entry in the pend_lsit with
IOCTL packet associated, the driver returns it to wrong free_list so that,
in turn, the driver could end up with 'NULL pointer dereference..' during
I/O command building with incorrect resource.

Also, the patch contains several minor/cosmetic changes besides this.

Signed-off-by: Seokmann Ju <seokmann.ju@lsil.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/scsi/ChangeLog.megaraid |   25 ++++++++++
 drivers/scsi/megaraid/megaraid_mbox.c |   59 ++++++++++++++++--------
 drivers/scsi/megaraid/megaraid_mbox.h |    7 ++
 3 files changed, 71 insertions(+), 20 deletions(-)

diff -puN Documentation/scsi/ChangeLog.megaraid~megaraid_mmmbox-fix-a-bug-in-reset-handler Documentation/scsi/ChangeLog.megaraid
--- devel/Documentation/scsi/ChangeLog.megaraid~megaraid_mmmbox-fix-a-bug-in-reset-handler	2006-04-17 21:42:59.000000000 -0700
+++ devel-akpm/Documentation/scsi/ChangeLog.megaraid	2006-04-17 21:42:59.000000000 -0700
@@ -1,3 +1,28 @@
+Release Date	: Mon Apr 11 12:27:22 EST 2006 - Seokmann Ju <sju@lsil.com>
+Current Version : 2.20.4.8 (scsi module), 2.20.2.6 (cmm module)
+Older Version	: 2.20.4.7 (scsi module), 2.20.2.6 (cmm module)
+
+1.	Fixed a bug in megaraid_reset_handler().
+	Customer reported "Unable to handle kernel NULL pointer dereference
+	at virtual address 00000000" when system goes to reset condition
+	for some reason. It happened randomly.
+	Root Cause: in the megaraid_reset_handler(), there is possibility not
+	returning pending packets in the pend_list if there are multiple
+	pending packets.
+	Fix: Made the change in the driver so that it will return all packets
+	in the pend_list.
+
+2.	Added change request.
+	As found in the following URL, rmb() only didn't help the
+	problem. I had to increase the loop counter to 0xFFFFFF. (6 F's)
+	http://marc.theaimsgroup.com/?l=linux-scsi&m=110971060502497&w=2
+
+	I attached a patch for your reference, too.
+	Could you check and get this fix in your driver?
+
+	Best Regards,
+	Jun'ichi Nomura
+
 Release Date	: Fri Nov 11 12:27:22 EST 2005 - Seokmann Ju <sju@lsil.com>
 Current Version : 2.20.4.7 (scsi module), 2.20.2.6 (cmm module)
 Older Version	: 2.20.4.6 (scsi module), 2.20.2.6 (cmm module)
diff -puN drivers/scsi/megaraid/megaraid_mbox.c~megaraid_mmmbox-fix-a-bug-in-reset-handler drivers/scsi/megaraid/megaraid_mbox.c
--- devel/drivers/scsi/megaraid/megaraid_mbox.c~megaraid_mmmbox-fix-a-bug-in-reset-handler	2006-04-17 21:42:59.000000000 -0700
+++ devel-akpm/drivers/scsi/megaraid/megaraid_mbox.c	2006-04-17 21:42:59.000000000 -0700
@@ -10,7 +10,7 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_mbox.c
- * Version	: v2.20.4.7 (Nov 14 2005)
+ * Version	: v2.20.4.8 (Apr 11 2006)
  *
  * Authors:
  * 	Atul Mukker		<Atul.Mukker@lsil.com>
@@ -2278,6 +2278,7 @@ megaraid_mbox_dpc(unsigned long devp)
 	unsigned long		flags;
 	uint8_t			c;
 	int			status;
+	uioc_t			*kioc;
 
 
 	if (!adapter) return;
@@ -2320,6 +2321,9 @@ megaraid_mbox_dpc(unsigned long devp)
 			// remove from local clist
 			list_del_init(&scb->list);
 
+			kioc			= (uioc_t *)scb->gp;
+			kioc->status		= 0;
+
 			megaraid_mbox_mm_done(adapter, scb);
 
 			continue;
@@ -2636,6 +2640,7 @@ megaraid_reset_handler(struct scsi_cmnd 
 	int		recovery_window;
 	int		recovering;
 	int		i;
+	uioc_t		*kioc;
 
 	adapter		= SCP2ADAPTER(scp);
 	raid_dev	= ADAP2RAIDDEV(adapter);
@@ -2655,32 +2660,51 @@ megaraid_reset_handler(struct scsi_cmnd 
 	// Also, reset all the commands currently owned by the driver
 	spin_lock_irqsave(PENDING_LIST_LOCK(adapter), flags);
 	list_for_each_entry_safe(scb, tmp, &adapter->pend_list, list) {
-
 		list_del_init(&scb->list);	// from pending list
 
-		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: %ld:%d[%d:%d], reset from pending list\n",
-				scp->serial_number, scb->sno,
-				scb->dev_channel, scb->dev_target));
+		if (scb->sno >= MBOX_MAX_SCSI_CMDS) {
+			con_log(CL_ANN, (KERN_WARNING
+			"megaraid: IOCTL packet with %d[%d:%d] being reset\n",
+			scb->sno, scb->dev_channel, scb->dev_target));
 
-		scp->result = (DID_RESET << 16);
-		scp->scsi_done(scp);
+			scb->status = -1;
 
-		megaraid_dealloc_scb(adapter, scb);
+			kioc			= (uioc_t *)scb->gp;
+			kioc->status		= -EFAULT;
+
+			megaraid_mbox_mm_done(adapter, scb);
+		} else {
+			if (scb->scp == scp) {	// Found command
+				con_log(CL_ANN, (KERN_WARNING
+					"megaraid: %ld:%d[%d:%d], reset from pending list\n",
+					scp->serial_number, scb->sno,
+					scb->dev_channel, scb->dev_target));
+			} else {
+				con_log(CL_ANN, (KERN_WARNING
+				"megaraid: IO packet with %d[%d:%d] being reset\n",
+				scb->sno, scb->dev_channel, scb->dev_target));
+			}
+
+			scb->scp->result = (DID_RESET << 16);
+			scb->scp->scsi_done(scb->scp);
+
+			megaraid_dealloc_scb(adapter, scb);
+		}
 	}
 	spin_unlock_irqrestore(PENDING_LIST_LOCK(adapter), flags);
 
 	if (adapter->outstanding_cmds) {
 		con_log(CL_ANN, (KERN_NOTICE
 			"megaraid: %d outstanding commands. Max wait %d sec\n",
-			adapter->outstanding_cmds, MBOX_RESET_WAIT));
+			adapter->outstanding_cmds,
+			(MBOX_RESET_WAIT + MBOX_RESET_EXT_WAIT)));
 	}
 
 	recovery_window = MBOX_RESET_WAIT + MBOX_RESET_EXT_WAIT;
 
 	recovering = adapter->outstanding_cmds;
 
-	for (i = 0; i < recovery_window && adapter->outstanding_cmds; i++) {
+	for (i = 0; i < recovery_window; i++) {
 
 		megaraid_ack_sequence(adapter);
 
@@ -2689,12 +2713,11 @@ megaraid_reset_handler(struct scsi_cmnd 
 			con_log(CL_ANN, (
 			"megaraid mbox: Wait for %d commands to complete:%d\n",
 				adapter->outstanding_cmds,
-				MBOX_RESET_WAIT - i));
+				(MBOX_RESET_WAIT + MBOX_RESET_EXT_WAIT) - i));
 		}
 
 		// bailout if no recovery happended in reset time
-		if ((i == MBOX_RESET_WAIT) &&
-			(recovering == adapter->outstanding_cmds)) {
+		if (adapter->outstanding_cmds == 0) {
 			break;
 		}
 
@@ -2918,12 +2941,13 @@ mbox_post_sync_cmd_fast(adapter_t *adapt
 	wmb();
 	WRINDOOR(raid_dev, raid_dev->mbox_dma | 0x1);
 
-	for (i = 0; i < 0xFFFFF; i++) {
+	for (i = 0; i < MBOX_SYNC_WAIT_CNT; i++) {
 		if (mbox->numstatus != 0xFF) break;
 		rmb();
+		udelay(MBOX_SYNC_DELAY_200);
 	}
 
-	if (i == 0xFFFFF) {
+	if (i == MBOX_SYNC_WAIT_CNT) {
 		// We may need to re-calibrate the counter
 		con_log(CL_ANN, (KERN_CRIT
 			"megaraid: fast sync command timed out\n"));
@@ -3475,7 +3499,7 @@ megaraid_cmm_register(adapter_t *adapter
 	adp.drvr_data		= (unsigned long)adapter;
 	adp.pdev		= adapter->pdev;
 	adp.issue_uioc		= megaraid_mbox_mm_handler;
-	adp.timeout		= 300;
+	adp.timeout		= MBOX_RESET_WAIT + MBOX_RESET_EXT_WAIT;
 	adp.max_kioc		= MBOX_MAX_USER_CMDS;
 
 	if ((rval = mraid_mm_register_adp(&adp)) != 0) {
@@ -3702,7 +3726,6 @@ megaraid_mbox_mm_done(adapter_t *adapter
 	unsigned long		flags;
 
 	kioc			= (uioc_t *)scb->gp;
-	kioc->status		= 0;
 	mbox64			= (mbox64_t *)(unsigned long)kioc->cmdbuf;
 	mbox64->mbox32.status	= scb->status;
 	raw_mbox		= (uint8_t *)&mbox64->mbox32;
diff -puN drivers/scsi/megaraid/megaraid_mbox.h~megaraid_mmmbox-fix-a-bug-in-reset-handler drivers/scsi/megaraid/megaraid_mbox.h
--- devel/drivers/scsi/megaraid/megaraid_mbox.h~megaraid_mmmbox-fix-a-bug-in-reset-handler	2006-04-17 21:42:59.000000000 -0700
+++ devel-akpm/drivers/scsi/megaraid/megaraid_mbox.h	2006-04-17 21:42:59.000000000 -0700
@@ -21,8 +21,8 @@
 #include "megaraid_ioctl.h"
 
 
-#define MEGARAID_VERSION	"2.20.4.7"
-#define MEGARAID_EXT_VERSION	"(Release Date: Mon Nov 14 12:27:22 EST 2005)"
+#define MEGARAID_VERSION	"2.20.4.8"
+#define MEGARAID_EXT_VERSION	"(Release Date: Mon Apr 11 12:27:22 EST 2006)"
 
 
 /*
@@ -100,6 +100,9 @@
 #define MBOX_BUSY_WAIT		10	// max usec to wait for busy mailbox
 #define MBOX_RESET_WAIT		180	// wait these many seconds in reset
 #define MBOX_RESET_EXT_WAIT	120	// extended wait reset
+#define MBOX_SYNC_WAIT_CNT	0xFFFF	// wait loop index for synchronous mode
+
+#define MBOX_SYNC_DELAY_200	200	// 200 micro-seconds
 
 /*
  * maximum transfer that can happen through the firmware commands issued
_

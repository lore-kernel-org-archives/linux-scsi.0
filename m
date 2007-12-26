From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 3/4] drivers/scsi/lpfc: Use time_before, time_before_eq, etc.
Date: Wed, 26 Dec 2007 16:23:05 +0100 (MET)
Message-ID: <Pine.LNX.4.58.0712261622240.1185@pc-041.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752595AbXLZPX3@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.smart@emulex.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the semantic patch making this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ change_compare_np @
expression E;
@@

(
- jiffies <= E
+ time_before_eq(jiffies,E)
|
- jiffies >= E
+ time_after_eq(jiffies,E)
|
- jiffies < E
+ time_before(jiffies,E)
|
- jiffies > E
+ time_after(jiffies,E)
)

@ include depends on change_compare_np @
@@

#include <linux/jiffies.h>

@ no_include depends on !include && change_compare_np @
@@

  #include <linux/...>
+ #include <linux/jiffies.h>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p linux-2.6/drivers/scsi/lpfc/lpfc_scsi.c linuxcopy/drivers/scsi/lpfc/lpfc_scsi.c
--- linux-2.6/drivers/scsi/lpfc/lpfc_scsi.c	2007-11-08 08:00:52.000000000 +0100
+++ linuxcopy/drivers/scsi/lpfc/lpfc_scsi.c	2007-12-25 20:53:54.000000000 +0100
@@ -22,6 +22,7 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/jiffies.h>

 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -55,7 +56,8 @@ lpfc_adjust_queue_depth(struct lpfc_hba
 	atomic_inc(&phba->num_rsrc_err);
 	phba->last_rsrc_error_time = jiffies;

-	if ((phba->last_ramp_down_time + QUEUE_RAMP_DOWN_INTERVAL) > jiffies) {
+	if (time_before(jiffies,
+			phba->last_ramp_down_time+QUEUE_RAMP_DOWN_INTERVAL)) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return;
 	}
@@ -94,8 +96,10 @@ lpfc_rampup_queue_depth(struct lpfc_vpor
 	if (vport->cfg_lun_queue_depth <= sdev->queue_depth)
 		return;
 	spin_lock_irqsave(&phba->hbalock, flags);
-	if (((phba->last_ramp_up_time + QUEUE_RAMP_UP_INTERVAL) > jiffies) ||
-	 ((phba->last_rsrc_error_time + QUEUE_RAMP_UP_INTERVAL ) > jiffies)) {
+	if ((time_before(jiffies,
+			 phba->last_ramp_up_time + QUEUE_RAMP_UP_INTERVAL)) ||
+	 (time_before(jiffies,
+		      phba->last_rsrc_error_time + QUEUE_RAMP_UP_INTERVAL))) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return;
 	}
@@ -617,10 +621,12 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba
 		lpfc_rampup_queue_depth(vport, sdev);

 	if (!result && pnode != NULL &&
-	   ((jiffies - pnode->last_ramp_up_time) >
-		LPFC_Q_RAMP_UP_INTERVAL * HZ) &&
-	   ((jiffies - pnode->last_q_full_time) >
-		LPFC_Q_RAMP_UP_INTERVAL * HZ) &&
+	   (time_after(jiffies,
+		       pnode->last_ramp_up_time +
+		       LPFC_Q_RAMP_UP_INTERVAL * HZ)) &&
+	   (time_after(jiffies,
+		       pnode->last_q_full_time +
+		       LPFC_Q_RAMP_UP_INTERVAL * HZ)) &&
 	   (vport->cfg_lun_queue_depth > sdev->queue_depth)) {
 		shost_for_each_device(tmp_sdev, sdev->host) {
 			if (vport->cfg_lun_queue_depth > tmp_sdev->queue_depth){

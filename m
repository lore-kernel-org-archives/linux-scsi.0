From: akpm@linux-foundation.org
Subject: [patch 10/10] drivers/scsi: use time_before, time_before_eq, etc
Date: Fri, 18 Apr 2008 13:57:27 -0700
Message-ID: <200804182057.m3IKvRKg015406@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761568AbYDRU6C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2008 16:58:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, julia@diku.dk

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/eata.c           |    3 ++-
 drivers/scsi/lpfc/lpfc_scsi.c |   20 +++++++++++++-------
 drivers/scsi/u14-34f.c        |    6 ++++--
 3 files changed, 19 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/eata.c~drivers-scsi-use-time_before-time_before_eq-etc drivers/scsi/eata.c
--- a/drivers/scsi/eata.c~drivers-scsi-use-time_before-time_before_eq-etc
+++ a/drivers/scsi/eata.c
@@ -927,6 +927,7 @@ static char boot_options[MAX_BOOT_OPTION
 #if defined(MODULE)
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/jiffies.h>
 
 module_param_string(eata, boot_options, MAX_BOOT_OPTIONS_SIZE, 0);
 MODULE_PARM_DESC(eata, " equivalent to the \"eata=...\" kernel boot option."
@@ -1995,7 +1996,7 @@ static int eata2x_eh_host_reset(struct s
 
 	/* FIXME: use a sleep instead */
 	time = jiffies;
-	while ((jiffies - time) < (10 * HZ) && limit++ < 200000)
+	while (time_before(jiffies, time + 10 * HZ) && limit++ < 200000)
 		udelay(100L);
 
 	spin_lock_irq(shost->host_lock);
diff -puN drivers/scsi/lpfc/lpfc_scsi.c~drivers-scsi-use-time_before-time_before_eq-etc drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c~drivers-scsi-use-time_before-time_before_eq-etc
+++ a/drivers/scsi/lpfc/lpfc_scsi.c
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
+			phba->last_ramp_down_time + QUEUE_RAMP_DOWN_INTERVAL)){
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
@@ -632,10 +636,12 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 		lpfc_rampup_queue_depth(vport, sdev);
 
 	if (!result && pnode && NLP_CHK_NODE_ACT(pnode) &&
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
diff -puN drivers/scsi/u14-34f.c~drivers-scsi-use-time_before-time_before_eq-etc drivers/scsi/u14-34f.c
--- a/drivers/scsi/u14-34f.c~drivers-scsi-use-time_before-time_before_eq-etc
+++ a/drivers/scsi/u14-34f.c
@@ -672,6 +672,7 @@ static char boot_options[MAX_BOOT_OPTION
 #if defined(MODULE)
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/jiffies.h>
 
 module_param_string(u14_34f, boot_options, MAX_BOOT_OPTIONS_SIZE, 0);
 MODULE_PARM_DESC(u14_34f, " equivalent to the \"u14-34f=...\" kernel boot " \
@@ -777,7 +778,7 @@ static int board_inquiry(unsigned int j)
 
    spin_unlock_irq(&driver_lock);
    time = jiffies;
-   while ((jiffies - time) < HZ && limit++ < 20000) udelay(100L);
+   while (time_before(jiffies, time + HZ) && limit++ < 20000) udelay(100L);
    spin_lock_irq(&driver_lock);
 
    if (cpp->adapter_status || HD(j)->cp_stat[0] != FREE) {
@@ -1478,7 +1479,8 @@ static int u14_34f_eh_host_reset(struct 
 
    spin_unlock_irq(sh[j]->host_lock);
    time = jiffies;
-   while ((jiffies - time) < (10 * HZ) && limit++ < 200000) udelay(100L);
+   while (time_before(jiffies, time + 10 * HZ) && limit++ < 200000)
+      udelay(100L);
    spin_lock_irq(sh[j]->host_lock);
 
    printk("%s: reset, interrupts disabled, loops %d.\n", BN(j), limit);
_

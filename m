From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi_set_device_offline lock fix
Date: Wed, 26 Feb 2003 15:28:31 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030226232830.GB1376@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e35.co.us.ibm.com (8.12.7/8.12.2) with ESMTP id h1QNQdOP020774
	for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2003 18:26:39 -0500
Received: from hmsbounty (sig-9-65-0-237.mts.ibm.com [9.65.0.237])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.5) with ESMTP id h1QNQcEw099176
	for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2003 16:26:39 -0700
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Patrick pointed out that I could get into a ABBA issue with holding
list_lock while calling scsi_eh_scmd_add which takes host_lock.
A call to scsi_prep_fn already holds the queue_lock and then makes a
call to scsi_get_command which takes list_lock.

-andmike
--
Michael Anderson
andmike@us.ibm.com

=====
name:		00_scsi_set_device_offline.diff
version:	2003-02-26.15:18:19-0800
against:	scsi-misc-2.5

 scsi.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

=====
--- 1.96/drivers/scsi/scsi.c	Fri Feb 21 13:46:58 2003
+++ edited/drivers/scsi/scsi.c	Wed Feb 26 08:00:06 2003
@@ -1308,7 +1308,8 @@
 void scsi_set_device_offline(struct scsi_device *sdev)
 {
 	struct scsi_cmnd *scmd;
-	int	cmds_active = 0;
+	LIST_HEAD(active_list);
+	struct list_head *lh, *lh_sf;
 	unsigned long flags;
 
 	sdev->online = FALSE;
@@ -1324,15 +1325,17 @@
 			if (!scsi_delete_timer(scmd)) {
 				continue;
 			}
-
-			++cmds_active;
-
-			scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD);
+			list_add_tail(&scmd->eh_entry, &active_list);
 		}
 	}
 	spin_unlock_irqrestore(&sdev->list_lock, flags);
 
-	if (!cmds_active) {
+	if (!list_empty(&active_list)) {
+		list_for_each_safe(lh, lh_sf, &active_list) {
+			scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
+			scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD);
+		}
+	} else {
 		/* FIXME: Send online state change hotplug event */
 	}
 }

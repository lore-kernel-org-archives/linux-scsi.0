From: priyankag@google.com (Priyanka Gupta)
Subject: [PATCH] scsi subsystem: Removing unused method scsi_device_cancel
Date: Tue, 19 Jun 2007 14:02:10 -0700 (PDT)
Message-ID: <20070619210210.CCD411B51C6@localhost>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:20401 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752405AbXFSVCf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jun 2007 17:02:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, priyankag@google.com

From: Priyanka Gupta <priyankag@google.com>

Removes an obsolete method scsi_device_cancel which isn't being used anywhere in the kernel. Applies to kernel version linux-2.6.21.5 onwards.

Signed-off-by: Priyanka Gupta <priyankag@google.com>
Acked-by: Grant Grundler <grundler@parisc-linux.org>
---

diff -uprN -X linux-2.6.21.5-vanilla/Documentation/dontdiff linux-2.6.21.5-vanilla/drivers/scsi/scsi.c /usr/local/work/upstream/linux-2.6.21.5/drivers/scsi/scsi.c
--- linux-2.6.21.5-vanilla/drivers/scsi/scsi.c	2007-06-11 11:37:06.000000000 -0700
+++ /usr/local/work/upstream/linux-2.6.21.5/drivers/scsi/scsi.c	2007-06-18 14:44:13.000000000 -0700
@@ -1029,52 +1029,6 @@ struct scsi_device *scsi_device_lookup(s
 }
 EXPORT_SYMBOL(scsi_device_lookup);
 
-/**
- * scsi_device_cancel - cancel outstanding IO to this device
- * @sdev:	Pointer to struct scsi_device
- * @recovery:	Boolean instructing function to recover device or not.
- *
- **/
-int scsi_device_cancel(struct scsi_device *sdev, int recovery)
-{
-	struct scsi_cmnd *scmd;
-	LIST_HEAD(active_list);
-	struct list_head *lh, *lh_sf;
-	unsigned long flags;
-
-	scsi_device_set_state(sdev, SDEV_CANCEL);
-
-	spin_lock_irqsave(&sdev->list_lock, flags);
-	list_for_each_entry(scmd, &sdev->cmd_list, list) {
-		if (scmd->request) {
-			/*
-			 * If we are unable to remove the timer, it means
-			 * that the command has already timed out or
-			 * finished.
-			 */
-			if (!scsi_delete_timer(scmd))
-				continue;
-			list_add_tail(&scmd->eh_entry, &active_list);
-		}
-	}
-	spin_unlock_irqrestore(&sdev->list_lock, flags);
-
-	if (!list_empty(&active_list)) {
-		list_for_each_safe(lh, lh_sf, &active_list) {
-			scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
-			list_del_init(lh);
-			if (recovery &&
-			    !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD)) {
-				scmd->result = (DID_ABORT << 16);
-				scsi_finish_command(scmd);
-			}
-		}
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL(scsi_device_cancel);
-
 MODULE_DESCRIPTION("SCSI core");
 MODULE_LICENSE("GPL");
 
diff -uprN -X linux-2.6.21.5-vanilla/Documentation/dontdiff linux-2.6.21.5-vanilla/include/scsi/scsi_device.h /usr/local/work/upstream/linux-2.6.21.5/include/scsi/scsi_device.h
--- linux-2.6.21.5-vanilla/include/scsi/scsi_device.h	2007-06-11 11:37:06.000000000 -0700
+++ /usr/local/work/upstream/linux-2.6.21.5/include/scsi/scsi_device.h	2007-06-18 14:44:50.000000000 -0700
@@ -204,7 +204,6 @@ extern struct scsi_device *__scsi_add_de
 extern int scsi_add_device(struct Scsi_Host *host, uint channel,
 			   uint target, uint lun);
 extern void scsi_remove_device(struct scsi_device *);
-extern int scsi_device_cancel(struct scsi_device *, int);
 
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);

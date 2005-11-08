From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] Fix refcount leak in scsi_report_lun_scan
Date: Tue, 8 Nov 2005 15:51:55 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0511081550190.4906-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:27346 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S965094AbVKHUwD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Nov 2005 15:52:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

This patch (as599) fixes a reference count leak in scsi_report_lun_scan.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -1071,6 +1071,7 @@ static int scsi_report_lun_scan(struct s
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	int ret = 0;
 
 	/*
 	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
@@ -1166,8 +1167,8 @@ static int scsi_report_lun_scan(struct s
 		/*
 		 * The device probably does not support a REPORT LUN command
 		 */
-		kfree(lun_data);
-		return 1;
+		ret = 1;
+		goto out_err;
 	}
 
 	/*
@@ -1235,6 +1236,7 @@ static int scsi_report_lun_scan(struct s
 		}
 	}
 
+ out_err:
 	kfree(lun_data);
  out:
 	scsi_device_put(sdev);
@@ -1243,7 +1245,7 @@ static int scsi_report_lun_scan(struct s
 		 * the sdev we used didn't appear in the report luns scan
 		 */
 		scsi_destroy_sdev(sdev);
-	return 0;
+	return ret;
 }
 
 struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,


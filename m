From: "Hironobu Ishii" <ishii.hironobu@jp.fujitsu.com>
Subject: [PATCH] message fix of scsi_mod.
Date: Wed, 31 Mar 2004 21:31:36 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <040a01c4171c$4ead2630$2987110a@lsd.css.fujitsu.com>
Reply-To: "Hironobu Ishii" <ishii.hironobu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:23207 "EHLO
	fgwmail6.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S261931AbUCaMdZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 07:33:25 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi James,

This patch:
    - fixes a message it does not tell us the error device.
    - fixes weird messages from scsi_sysfs.c

This is a patch for linux-2.6.5-rc3.

Please apply!

Thanks,
Hironobu Ishii.

diff -urN linux-2.6.5-rc3/drivers/scsi/scsi_scan.c linux-2.6.5-rc3-work/drivers/scsi/scsi_scan.c
--- linux-2.6.5-rc3/drivers/scsi/scsi_scan.c 2004-03-30 19:02:47.000000000 +0900
+++ linux-2.6.5-rc3-work/drivers/scsi/scsi_scan.c 2004-03-31 19:12:37.195529071 +0900
@@ -403,10 +403,12 @@
    /* if the longer inquiry has failed, flag the device
     * as only accepting 36 byte inquiries and retry the
     * 36 byte inquiry */
-   printk(KERN_INFO "scsi scan: %d byte inquiry failed"
-          " with code %d.  Consider BLIST_INQUIRY_36 for"
-          " this device\n", possible_inq_resp_len,
-          sreq->sr_result);
+   printk(KERN_INFO "scsi scan: <%d:%d:%d:%d>: "
+          "%d byte inquiry failed with code %d.  "
+          "Consider BLIST_INQUIRY_36 for this device\n",
+          sdev->host->host_no, sdev->channel,
+          sdev->id, sdev->lun,
+          possible_inq_resp_len, sreq->sr_result);
    *bflags = BLIST_INQUIRY_36;
    goto repeat_inquiry;
   }
diff -urN linux-2.6.5-rc3/drivers/scsi/scsi_sysfs.c linux-2.6.5-rc3-work/drivers/scsi/scsi_sysfs.c
--- linux-2.6.5-rc3/drivers/scsi/scsi_sysfs.c 2004-03-30 19:02:47.000000000 +0900
+++ linux-2.6.5-rc3-work/drivers/scsi/scsi_sysfs.c 2004-03-31 19:20:15.990455170 +0900
@@ -358,13 +358,15 @@
 
  error = device_add(&sdev->sdev_gendev);
  if (error) {
-  printk(KERN_INFO "error 1\n");
+  printk(KERN_INFO "scsi_sysfs: device_add() failed on <%d:%d:%d:%d>\n",
+   sdev->host->host_no, sdev->channel, sdev->id, sdev->lun );
   return error;
  }
 
  error = class_device_add(&sdev->sdev_classdev);
  if (error) {
-  printk(KERN_INFO "error 2\n");
+  printk(KERN_INFO "scsi_sysfs: class_device_add failed on <%d:%d:%d:%d>\n",
+   sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
   goto clean_device;
  }
  /* take a reference for the sdev_classdev; this is


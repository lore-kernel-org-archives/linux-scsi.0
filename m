From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Skip deleted devices in __scsi_device_lookup_by_target()
Date: Tue, 13 Jan 2009 16:50:37 +0100
Message-ID: <496CB84D.3090806@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000102000004040807050601"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:58447 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbZAMPuk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2009 10:50:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000102000004040807050601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi all,

this is a modified patch of my earlier patch
'Restart scsi_device_lookup_by_target'.
After discussions with Matthew Wilcox and James B. it
turned out that it's actually better to skip deleted
devices from __scsi_device_lookup_by_target(), leaving
scsi_device_lookup_by_target() untouched.

So here it goes.

James, please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------000102000004040807050601
Content-Type: text/plain;
 name="scsi-restart-lookup-by-target"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-restart-lookup-by-target"

Skip deleted devices in __scsi_device_lookup_by_target()

__scsi_device_lookup_by_target() will always return
the first sdev with a matching LUN, regardless of
the state. However, when this sdev is in SDEV_DEL
scsi_device_lookup_by_target() will ignore this
device and so any valid device on the list after
the deleted device will never be found.
So we have to modify __scsi_device_lookup_by_target()
to skip any device in SDEV_DEL.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index f8b79d4..537bb92 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1099,7 +1099,8 @@ EXPORT_SYMBOL(__starget_for_each_device);
  * Description: Looks up the scsi_device with the specified @lun for a given
  * @starget.  The returned scsi_device does not have an additional
  * reference.  You must hold the host's host_lock over this call and
- * any access to the returned scsi_device.
+ * any access to the returned scsi_device. A scsi_device in state
+ * SDEV_DEL is skipped.
  *
  * Note:  The only reason why drivers should use this is because
  * they need to access the device list in irq context.  Otherwise you
@@ -1111,6 +1112,8 @@ struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *starget,
 	struct scsi_device *sdev;
 
 	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {
+		if (sdev->sdev_state == SDEV_DEL)
+			continue;
 		if (sdev->lun ==lun)
 			return sdev;
 	}

--------------000102000004040807050601--

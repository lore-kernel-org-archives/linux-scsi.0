From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH v2 1/8] [SCSI] Generate uevent on sd capacity change
Date: Fri,  1 Feb 2013 12:53:08 -0500
Message-ID: <1359741195-2641-2-git-send-email-emilne@redhat.com>
References: <1359741195-2641-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757239Ab3BARxS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Feb 2013 12:53:18 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r11HrHod000885
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 1 Feb 2013 12:53:17 -0500
Received: from emilne.csb (dhcp-186-175.bos.redhat.com [10.16.186.175])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r11HrGRe011917
	for <linux-scsi@vger.kernel.org>; Fri, 1 Feb 2013 12:53:17 -0500
In-Reply-To: <1359741195-2641-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

In sd_read_capacity(), detect if the capacity is different from the
previously read value, and generate a uevent if this is the case.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_lib.c    | 5 ++++-
 drivers/scsi/scsi_sysfs.c  | 2 ++
 drivers/scsi/sd.c          | 9 +++++++++
 include/scsi/scsi_device.h | 3 ++-
 4 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6dfb978..eba68de 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2186,7 +2186,9 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 	case SDEV_EVT_MEDIA_CHANGE:
 		envp[idx++] = "SDEV_MEDIA_CHANGE=1";
 		break;
-
+	case SDEV_EVT_CAPACITY_CHANGE:
+		envp[idx++] = "SDEV_CAPACITY_CHANGE=1";
+		break;
 	default:
 		/* do nothing */
 		break;
@@ -2280,6 +2282,7 @@ struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
 	/* evt_type-specific initialization, if any */
 	switch (evt_type) {
 	case SDEV_EVT_MEDIA_CHANGE:
+	case SDEV_EVT_CAPACITY_CHANGE:
 	default:
 		/* do nothing */
 		break;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 04c2a27..ba7da3b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -712,6 +712,7 @@ sdev_store_evt_##name(struct device *dev, struct device_attribute *attr,\
 #define REF_EVT(name) &dev_attr_evt_##name.attr
 
 DECLARE_EVT(media_change, MEDIA_CHANGE)
+DECLARE_EVT(capacity_change, CAPACITY_CHANGE)
 
 /* Default template for device attributes.  May NOT be modified */
 static struct attribute *scsi_sdev_attrs[] = {
@@ -731,6 +732,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_ioerr_cnt.attr,
 	&dev_attr_modalias.attr,
 	REF_EVT(media_change),
+	REF_EVT(capacity_change),
 	NULL
 };
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6f0a4c6..9f2d00a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2017,6 +2017,15 @@ got_data:
 					  "%u-byte physical blocks\n",
 					  sdkp->physical_block_size);
 		}
+
+		/*
+		 * Don't report a capacity change event unless we have a
+		 * valid "old" value.
+		 */
+		if (!sdkp->first_scan && (old_capacity != 0) &&
+		    (old_capacity != sdkp->capacity))
+			sdev_evt_send_simple(sdp, SDEV_EVT_CAPACITY_CHANGE,
+					     GFP_KERNEL);
 	}
 
 	/* Rescale capacity to 512-byte units */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6efb2e1..e4c964e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -51,8 +51,9 @@ enum scsi_device_state {
 
 enum scsi_device_event {
 	SDEV_EVT_MEDIA_CHANGE	= 1,	/* media has changed */
+	SDEV_EVT_CAPACITY_CHANGE	= 2,	/* capacity has changed */
 
-	SDEV_EVT_LAST		= SDEV_EVT_MEDIA_CHANGE,
+	SDEV_EVT_LAST		= SDEV_EVT_CAPACITY_CHANGE,
 	SDEV_EVT_MAXBITS	= SDEV_EVT_LAST + 1
 };
 
-- 
1.7.11.7


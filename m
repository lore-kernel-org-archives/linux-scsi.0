From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5/6] [SCSI] Look up and store NAA if VPD page 0x83 is present
Date: Wed, 28 May 2014 23:52:44 -0400
Message-ID: <1401335565-29865-6-git-send-email-martin.petersen@oracle.com>
References: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32697 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbaE2Dwu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 23:52:50 -0400
In-Reply-To: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Copy offloading requires us to know the NAA descriptor for both source
target device. This descriptor is mandatory in the Device Identification
VPD page. Locate this descriptor in the returned VPD data so we don't
have to do lookups for every copy command.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi.c        | 57 ++++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  2 ++
 2 files changed, 59 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 88d46fe6bf98..7faea9987abf 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1024,6 +1024,62 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
 
 /**
+ * scsi_lookup_naa - Lookup NAA descriptor in VPD page 0x83
+ * @sdev: The device to ask
+ *
+ * Copy offloading requires us to know the NAA descriptor for both
+ * source and target device. This descriptor is mandatory in the Device
+ * Identification VPD page. Locate this descriptor in the returned VPD
+ * data so we don't have to do lookups for every copy command.
+ */
+static void scsi_lookup_naa(struct scsi_device *sdev)
+{
+	unsigned char *buf = sdev->vpd_pg83;
+	unsigned int len = sdev->vpd_pg83_len;
+
+	if (buf[1] != 0x83 || get_unaligned_be16(&buf[2]) == 0) {
+		sdev_printk(KERN_ERR, sdev,
+			    "%s: VPD page 0x83 contains no descriptors\n",
+			    __func__);
+		return;
+	}
+
+	buf += 4;
+	len -= 4;
+
+	do {
+		unsigned int desig_len = buf[3] + 4;
+
+		/* Binary code set */
+		if ((buf[0] & 0xf) != 1)
+			goto skip;
+
+		/* Target association */
+		if ((buf[1] >> 4) & 0x3)
+			goto skip;
+
+		/* NAA designator */
+		if ((buf[1] & 0xf) != 0x3)
+			goto skip;
+
+		sdev->naa = buf;
+		sdev->naa_len = desig_len;
+
+		return;
+
+skip:
+		buf += desig_len;
+		len -= desig_len;
+
+	} while (len > 0);
+
+	sdev_printk(KERN_ERR, sdev,
+		    "%s: VPD page 0x83 NAA descriptor not found\n", __func__);
+
+	return;
+}
+
+/**
  * scsi_attach_vpd - Attach Vital Product Data to a SCSI device structure
  * @sdev: The device to ask
  *
@@ -1107,6 +1163,7 @@ retry_pg83:
 		}
 		sdev->vpd_pg83_len = result;
 		sdev->vpd_pg83 = vpd_buf;
+		scsi_lookup_naa(sdev);
 	}
 }
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 5853c913d2b0..67bb70012802 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -119,6 +119,8 @@ struct scsi_device {
 	unsigned char *vpd_pg83;
 	int vpd_pg80_len;
 	unsigned char *vpd_pg80;
+	unsigned char naa_len;
+	unsigned char *naa;
 	unsigned char current_tag;	/* current tag */
 	struct scsi_target      *sdev_target;   /* used only for single_lun */
 
-- 
1.9.0


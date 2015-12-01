From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/18] scsi: Add scsi_vpd_lun_id()
Date: Tue,  1 Dec 2015 10:16:55 +0100
Message-ID: <1448961418-29013-16-git-send-email-hare@suse.de>
References: <1448961418-29013-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41598 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756052AbbLAJRK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 04:17:10 -0500
In-Reply-To: <1448961418-29013-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <jbottomley@odin.com>, Johannes Thumshirn <jthumshirn@suse.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Add a function scsi_vpd_lun_id() to return a unique device
identifcation based on the designation descriptors of
VPD page 0x83.

As devices might implement several descriptors the order
of preference is:
- NAA IEE Registered Extended
- EUI-64 based 16-byte
- EUI-64 based 12-byte
- NAA IEEE Registered
- NAA IEEE Extended
A SCSI name string descriptor is preferred to all of them
if the identification is longer than 16 bytes.

The returned unique device identification will be formatted
as a SCSI Name string to avoid clashes between different
designator types.

Reviewed-by: Ewan Milne <emilne@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c    | 140 +++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |   1 +
 2 files changed, 141 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index dd8ad2a..5bd8a19 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3154,3 +3154,143 @@ void sdev_enable_disk_events(struct scsi_device *sdev)
 	atomic_dec(&sdev->disk_events_disable_depth);
 }
 EXPORT_SYMBOL(sdev_enable_disk_events);
+
+/*
+ * scsi_vpd_lun_id - return a unique device identification
+ * @sdev: SCSI device
+ * @id:   buffer for the identification
+ * @id_len:  length of the buffer
+ *
+ * Copies a unique device identification into @id based
+ * on the information in the VPD page 0x83 of the device.
+ * The string will be formatted as a SCSI name string.
+ *
+ * Returns the length of the identification or error on failure.
+ * If the identifier is longer than the supplied buffer the actual
+ * identifier length is returned and the buffer is not zero-padded.
+ */
+int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
+{
+	u8 cur_id_type = 0xff;
+	u8 cur_id_size = 0;
+	unsigned char *d, *cur_id_str;
+	unsigned char __rcu *vpd_pg83;
+	int id_size = -EINVAL;
+
+	rcu_read_lock();
+	vpd_pg83 = rcu_dereference(sdev->vpd_pg83);
+	if (!vpd_pg83) {
+		rcu_read_unlock();
+		return -ENXIO;
+	}
+
+	/*
+	 * Look for the correct descriptor.
+	 * Order of preference for lun descriptor:
+	 * - SCSI name string
+	 * - NAA IEEE Registered Extended
+	 * - EUI-64 based 16-byte
+	 * - EUI-64 based 12-byte
+	 * - NAA IEEE Registered
+	 * - NAA IEEE Extended
+	 * as longer descriptors reduce the likelyhood
+	 * of identification clashes.
+	 */
+
+	/* The id string must be at least 20 bytes + terminating NULL byte */
+	if (id_len < 21) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+
+	memset(id, 0, id_len);
+	d = vpd_pg83 + 4;
+	while (d < vpd_pg83 + sdev->vpd_pg83_len) {
+		/* Skip designators not referring to the LUN */
+		if ((d[1] & 0x30) != 0x00)
+			goto next_desig;
+
+		switch (d[1] & 0xf) {
+		case 0x2:
+			/* EUI-64 */
+			if (cur_id_size > d[3])
+				break;
+			/* Prefer NAA IEEE Registered Extended */
+			if (cur_id_type == 0x3 &&
+			    cur_id_size == d[3])
+				break;
+			cur_id_size = d[3];
+			cur_id_str = d + 4;
+			cur_id_type = d[1] & 0xf;
+			switch (cur_id_size) {
+			case 8:
+				id_size = snprintf(id, id_len,
+						   "eui.%8phN",
+						   cur_id_str);
+				break;
+			case 12:
+				id_size = snprintf(id, id_len,
+						   "eui.%12phN",
+						   cur_id_str);
+				break;
+			case 16:
+				id_size = snprintf(id, id_len,
+						   "eui.%16phN",
+						   cur_id_str);
+				break;
+			default:
+				cur_id_size = 0;
+				break;
+			}
+			break;
+		case 0x3:
+			/* NAA */
+			if (cur_id_size > d[3])
+				break;
+			cur_id_size = d[3];
+			cur_id_str = d + 4;
+			cur_id_type = d[1] & 0xf;
+			switch (cur_id_size) {
+			case 8:
+				id_size = snprintf(id, id_len,
+						   "naa.%8phN",
+						   cur_id_str);
+				break;
+			case 16:
+				id_size = snprintf(id, id_len,
+						   "naa.%16phN",
+						   cur_id_str);
+				break;
+			default:
+				cur_id_size = 0;
+				break;
+			}
+			break;
+		case 0x8:
+			/* SCSI name string */
+			if (cur_id_size + 4 > d[3])
+				break;
+			/* Prefer others for truncated descriptor */
+			if (cur_id_size && d[3] > id_len)
+				break;
+			cur_id_size = id_size = d[3];
+			cur_id_str = d + 4;
+			cur_id_type = d[1] & 0xf;
+			if (cur_id_size >= id_len)
+				cur_id_size = id_len - 1;
+			memcpy(id, cur_id_str, cur_id_size);
+			/* Decrease priority for truncated descriptor */
+			if (cur_id_size != id_size)
+				cur_id_size = 6;
+			break;
+		default:
+			break;
+		}
+next_desig:
+		d += d[3] + 4;
+	}
+	rcu_read_unlock();
+
+	return id_size;
+}
+EXPORT_SYMBOL(scsi_vpd_lun_id);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index bde4077..4c49cfa 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -415,6 +415,7 @@ static inline int scsi_execute_req(struct scsi_device *sdev,
 }
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
+extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
 
 #ifdef CONFIG_PM
 extern int scsi_autopm_get_device(struct scsi_device *);
-- 
1.8.5.6


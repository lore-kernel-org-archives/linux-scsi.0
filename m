From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/17] scsi_dh_alua: parse target device id
Date: Mon,  4 May 2015 14:42:18 +0200
Message-ID: <1430743343-47174-13-git-send-email-hare@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbbEDMml (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 May 2015 08:42:41 -0400
In-Reply-To: <1430743343-47174-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Parse VPD descriptor to figure out the device identification.
As devices might implement several descriptors the order
of preference is:
- NAA IEE Registered Extended
- EUI-64 based 16-byte
- EUI-64 based 12-byte
- NAA IEEE Registered
- NAA IEEE Extended
A SCSI name string descriptor is preferred to all of them
if the identification is longer than 16 bytes.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 125 ++++++++++++++++++++++++++++-
 1 file changed, 121 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 98d4a22..2dd9578 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -70,6 +70,9 @@ static DEFINE_SPINLOCK(port_group_lock);
 struct alua_port_group {
 	struct kref		kref;
 	struct list_head	node;
+	unsigned char		device_id[256];
+	unsigned char		device_id_str[256];
+	int			device_id_size;
 	int			group_id;
 	int			tpgs;
 	int			state;
@@ -253,17 +256,84 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 {
 	unsigned char *d;
 	int group_id = -1;
-	struct alua_port_group *pg = NULL;
+	char device_id_str[256], *device_id = NULL;
+	int device_id_size, device_id_type = 0;
+	struct alua_port_group *tmp_pg, *pg = NULL;
 
 	if (!sdev->vpd_pg83)
 		return SCSI_DH_DEV_UNSUPP;
 
 	/*
 	 * Look for the correct descriptor.
+	 * Order of preference for lun descriptor:
+	 * - SCSI name string
+	 * - NAA IEEE Registered Extended
+	 * - EUI-64 based 16-byte
+	 * - EUI-64 based 12-byte
+	 * - NAA IEEE Registered
+	 * - NAA IEEE Extended
+	 * as longer descriptors reduce the likelyhood
+	 * of identification clashes.
 	 */
+	memset(device_id_str, 0, 256);
+	device_id_size = 0;
 	d = sdev->vpd_pg83 + 4;
 	while (d < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
 		switch (d[1] & 0xf) {
+		case 0x2:
+			/* EUI-64 */
+			if ((d[1] & 0x30) == 0x00) {
+				if (device_id_size > d[3])
+					break;
+				/* Prefer NAA IEEE Registered Extended */
+				if (device_id_type == 0x3 &&
+				    device_id_size == d[3])
+					break;
+				device_id_size = d[3];
+				device_id = d + 4;
+				device_id_type = d[1] & 0xf;
+				switch (device_id_size) {
+				case 8:
+					sprintf(device_id_str,
+						"eui.%8phN", d + 4);
+					break;
+				case 12:
+					sprintf(device_id_str,
+						"eui.%12phN", d + 4);
+					break;
+				case 16:
+					sprintf(device_id_str,
+						"eui.%16phN", d + 4);
+					break;
+				default:
+					device_id_size = 0;
+					break;
+				}
+			}
+			break;
+		case 0x3:
+			/* NAA */
+			if ((d[1] & 0x30) == 0x00) {
+				if (device_id_size > d[3])
+					break;
+				device_id_size = d[3];
+				device_id = d + 4;
+				device_id_type = d[1] & 0xf;
+				switch (device_id_size) {
+				case 8:
+					sprintf(device_id_str,
+						"naa.%8phN", d + 4);
+					break;
+				case 16:
+					sprintf(device_id_str,
+						"naa.%16phN", d + 4);
+					break;
+				default:
+					device_id_size = 0;
+					break;
+				}
+			}
+			break;
 		case 0x4:
 			/* Relative target port */
 			h->rel_port = (d[6] << 8) + d[7];
@@ -272,6 +342,21 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 			/* Target port group */
 			group_id = (d[6] << 8) + d[7];
 			break;
+		case 0x8:
+			/* SCSI name string */
+			if ((d[1] & 0x30) == 0x00) {
+				/* SCSI name */
+				if (device_id_size > d[3])
+					break;
+				device_id_size = d[3];
+				device_id = d + 4;
+				device_id_type = d[1] & 0xf;
+				strncpy(device_id_str, d + 4, 256);
+				if (device_id_size > 255)
+					device_id_size = 255;
+				device_id_str[device_id_size] = '\0';
+			}
+			break;
 		default:
 			break;
 		}
@@ -290,11 +375,35 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 		h->tpgs = TPGS_MODE_NONE;
 		return SCSI_DH_DEV_UNSUPP;
 	}
-	sdev_printk(KERN_INFO, sdev,
-		    "%s: port group %02x rel port %02x\n",
-		    ALUA_DH_NAME, group_id, h->rel_port);
 
 	spin_lock(&port_group_lock);
+	if (device_id_size) {
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: device %s port group %02x "
+			    "rel port %02x\n", ALUA_DH_NAME,
+			    device_id_str, group_id, h->rel_port);
+		list_for_each_entry(tmp_pg, &port_group_list, node) {
+			if (tmp_pg->group_id != group_id)
+				continue;
+			if (tmp_pg->device_id_size != device_id_size)
+				continue;
+			if (memcmp(tmp_pg->device_id, device_id,
+				   device_id_size))
+				continue;
+			pg = tmp_pg;
+			break;
+		}
+	} else {
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: port group %02x rel port %02x\n",
+			    ALUA_DH_NAME, group_id, h->rel_port);
+	}
+	if (pg) {
+		h->pg = pg;
+		kref_get(&pg->kref);
+		spin_unlock(&port_group_lock);
+		return SCSI_DH_OK;
+	}
 	pg = kzalloc(sizeof(struct alua_port_group), GFP_ATOMIC);
 	if (!pg) {
 		sdev_printk(KERN_WARNING, sdev,
@@ -304,6 +413,14 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 		spin_unlock(&port_group_lock);
 		return SCSI_DH_DEV_TEMP_BUSY;
 	}
+	if (device_id_size) {
+		memcpy(pg->device_id, device_id, device_id_size);
+		strncpy(pg->device_id_str, device_id_str, 256);
+	} else {
+		memset(pg->device_id, 0, 256);
+		pg->device_id_str[0] = '\0';
+	}
+	pg->device_id_size = device_id_size;
 	pg->group_id = group_id;
 	pg->buff = pg->inq;
 	pg->bufflen = ALUA_INQUIRY_SIZE;
-- 
1.8.5.2


From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/20] scsi_dh_alua: parse target device id
Date: Wed,  8 Jul 2015 11:06:12 +0200
Message-ID: <1436346378-96518-15-git-send-email-hare@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934510AbbGHJGd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 05:06:33 -0400
In-Reply-To: <1436346378-96518-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>

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
 drivers/scsi/device_handler/scsi_dh_alua.c | 152 ++++++++++++++++++++++++++++-
 1 file changed, 147 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index f4d851a..6991171 100644
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
@@ -227,17 +230,84 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
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
@@ -246,6 +316,21 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
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
@@ -264,9 +349,38 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 		h->tpgs = TPGS_MODE_NONE;
 		return SCSI_DH_DEV_UNSUPP;
 	}
+	if (!device_id_size) {
+		/*
+		 * Internal error: TPGS supported by no
+		 * device identifcation found.
+		 * Disable ALUA support.
+		 */
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: No device descriptors found\n",
+			    ALUA_DH_NAME);
+		h->tpgs = TPGS_MODE_NONE;
+		return SCSI_DH_DEV_UNSUPP;
+	}
 	sdev_printk(KERN_INFO, sdev,
-		    "%s: port group %02x rel port %02x\n",
-		    ALUA_DH_NAME, group_id, h->rel_port);
+		    "%s: device %s port group %02x "
+		    "rel port %02x\n", ALUA_DH_NAME,
+		    device_id_str, group_id, h->rel_port);
+	spin_lock(&port_group_lock);
+	list_for_each_entry(tmp_pg, &port_group_list, node) {
+		if (tmp_pg->group_id != group_id)
+			continue;
+		if (tmp_pg->device_id_size != device_id_size)
+			continue;
+		if (memcmp(tmp_pg->device_id, device_id,
+			   device_id_size))
+			continue;
+		h->pg = tmp_pg;
+		kref_get(&tmp_pg->kref);
+		break;
+	}
+	spin_unlock(&port_group_lock);
+	if (h->pg)
+		return SCSI_DH_OK;
 
 	pg = kzalloc(sizeof(struct alua_port_group), GFP_KERNEL);
 	if (!pg) {
@@ -276,13 +390,41 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 		/* Temporary failure, bypass */
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
 	pg->tpgs = h->tpgs;
 	pg->state = TPGS_STATE_OPTIMIZED;
 	kref_init(&pg->kref);
 	spin_lock(&port_group_lock);
-	list_add(&pg->node, &port_group_list);
-	h->pg = pg;
+	/*
+	 * Re-check list again to catch
+	 * concurrent updates
+	 */
+	list_for_each_entry(tmp_pg, &port_group_list, node) {
+		if (tmp_pg->group_id != pg->group_id)
+			continue;
+		if (tmp_pg->device_id_size != pg->device_id_size)
+			continue;
+		if (memcmp(tmp_pg->device_id, pg->device_id,
+			   device_id_size))
+			continue;
+		h->pg = tmp_pg;
+		kref_get(&tmp_pg->kref);
+		kfree(pg);
+		pg = NULL;
+		break;
+	}
+	if (pg) {
+		list_add(&pg->node, &port_group_list);
+		h->pg = pg;
+	}
 	spin_unlock(&port_group_lock);
 
 	return SCSI_DH_OK;
-- 
1.8.5.2


From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/16] scsi_dh_alua: parse target device id
Date: Fri, 31 Jan 2014 10:29:52 +0100
Message-ID: <1391160600-19652-9-git-send-email-hare@suse.de>
References: <1391160600-19652-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043AbaAaJaJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jan 2014 04:30:09 -0500
In-Reply-To: <1391160600-19652-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

VPD descriptor association 0x2 in VPD page 0x83 identification
descrioptors can be used to identify the array / target device.
Some tricks need to be taken for EMC and HP, which put the
array identification into the standard inquiry.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 123 ++++++++++++++++++++++++++++-
 1 file changed, 119 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 0af6866..857a999 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -69,6 +69,9 @@ static DEFINE_SPINLOCK(port_group_lock);
 struct alua_port_group {
 	struct kref		kref;
 	struct list_head	node;
+	unsigned char		target_id[256];
+	unsigned char		target_id_str[256];
+	int			target_id_size;
 	int			group_id;
 	int			tpgs;
 	int			state;
@@ -351,12 +354,14 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 	unsigned char bufflen = 36;
 	int len, timeout = ALUA_FAILOVER_TIMEOUT;
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
+	char target_id_str[256], *target_id = NULL;
+	int target_id_size;
 	struct scsi_sense_hdr sense_hdr;
 	unsigned retval, err;
 	int group_id = -1;
 	unsigned char *d;
 	unsigned long expiry;
-	struct alua_port_group *pg = NULL;
+	struct alua_port_group *tmp_pg, *pg = NULL;
 
 	expiry = round_jiffies_up(jiffies + timeout);
  retry:
@@ -409,9 +414,54 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 	/*
 	 * Now look for the correct descriptor.
 	 */
+	memset(target_id_str, 0, 256);
+	target_id_size = 0;
 	d = buff + 4;
 	while (d < buff + len) {
 		switch (d[1] & 0xf) {
+		case 0x2:
+			/* EUI-64 */
+			if ((d[1] & 0x30) == 0x20) {
+				target_id_size = d[3];
+				target_id = d + 4;
+				switch (target_id_size) {
+				case 8:
+					sprintf(target_id_str,
+						"eui.%8phN", d + 4);
+					break;
+				case 12:
+					sprintf(target_id_str,
+						"eui.%12phN", d + 4);
+					break;
+				case 16:
+					sprintf(target_id_str,
+						"eui.%16phN", d + 4);
+					break;
+				default:
+					target_id_size = 0;
+					break;
+				}
+			}
+			break;
+		case 0x3:
+			/* NAA */
+			if ((d[1] & 0x30) == 0x20) {
+				target_id_size = d[3];
+				target_id = d + 4;
+				switch (target_id_size) {
+				case 8:
+					sprintf(target_id_str,
+						"naa.%8phN", d + 4);
+					break;
+				case 16:
+					sprintf(target_id_str,
+						"naa.%16phN", d + 4);
+					break;
+				default:
+					target_id_size = 0;
+					break;
+				}
+			}
 		case 0x4:
 			/* Relative target port */
 			h->rel_port = (d[6] << 8) + d[7];
@@ -420,6 +470,18 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 			/* Target port group */
 			group_id = (d[6] << 8) + d[7];
 			break;
+		case 0x8:
+			/* SCSI name string */
+			if ((d[1] & 0x30) == 0x20) {
+				/* SCSI name */
+				target_id_size = d[3];
+				target_id = d + 4;
+				strncpy(target_id_str, d + 4, 256);
+				if (target_id_size > 255)
+					target_id_size = 255;
+				target_id_str[target_id_size] = '\0';
+			}
+			break;
 		default:
 			break;
 		}
@@ -439,11 +501,56 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 		err = SCSI_DH_DEV_UNSUPP;
 		goto out;
 	}
+	if (!target_id_size) {
+		/* Check for EMC Clariion extended inquiry */
+		if (!strncmp(sdev->vendor, "DGC     ", 8) &&
+		    sdev->inquiry_len > 160) {
+			target_id_size = sdev->inquiry[160];
+			target_id = sdev->inquiry + 161;
+			strcpy(target_id_str, "emc.");
+			memcpy(target_id_str + 4, target_id, target_id_size);
+		}
+		/* Check for HP EVA extended inquiry */
+		if (!strncmp(sdev->vendor, "HP      ", 8) &&
+		    !strncmp(sdev->model, "HSV", 3) &&
+		    sdev->inquiry_len > 170) {
+			target_id_size = 16;
+			target_id = sdev->inquiry + 154;
+			strcpy(target_id_str, "naa.");
+			memcpy(target_id_str + 4, target_id, target_id_size);
+		}
+	}
 
-	sdev_printk(KERN_INFO, sdev,
-		    "%s: port group %02x rel port %02x\n",
-		    ALUA_DH_NAME, group_id, h->rel_port);
 	spin_lock(&port_group_lock);
+	pg = NULL;
+	if (target_id_size) {
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: target %s port group %02x "
+			    "rel port %02x\n", ALUA_DH_NAME,
+			    target_id_str, group_id, h->rel_port);
+		list_for_each_entry(tmp_pg, &port_group_list, node) {
+			if (tmp_pg->group_id != group_id)
+				continue;
+			if (tmp_pg->target_id_size != target_id_size)
+				continue;
+			if (memcmp(tmp_pg->target_id, target_id,
+				   target_id_size))
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
+		err = SCSI_DH_OK;
+		goto out;
+	}
 	pg = kzalloc(sizeof(struct alua_port_group), GFP_KERNEL);
 	if (!pg) {
 		sdev_printk(KERN_WARNING, sdev,
@@ -454,6 +561,14 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 		err = SCSI_DH_DEV_TEMP_BUSY;
 		goto out;
 	}
+	if (target_id_size) {
+		memcpy(pg->target_id, target_id, target_id_size);
+		strncpy(pg->target_id_str, target_id_str, 256);
+	} else {
+		memset(pg->target_id, 0, 256);
+		pg->target_id_str[0] = '\0';
+	}
+	pg->target_id_size = target_id_size;
 	pg->group_id = group_id;
 	pg->buff = pg->inq;
 	pg->bufflen = ALUA_INQUIRY_SIZE;
-- 
1.7.12.4


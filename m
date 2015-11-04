From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 24/27] hpsa: enhance device messages
Date: Wed, 04 Nov 2015 15:52:22 -0600
Message-ID: <20151104215222.15472.2733.stgit@brunhilda>
References: <20151104214910.15472.23179.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:32962 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030199AbbKDV4O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:56:14 -0500
In-Reply-To: <20151104214910.15472.23179.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   45 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 91e7005..64638d5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -608,7 +608,7 @@ static inline int is_logical_dev_addr_mode(unsigned char scsi3addr[])
 }
 
 static const char * const raid_label[] = { "0", "4", "1(+0)", "5", "5+1", "6",
-	"1(+0)ADM", "UNKNOWN"
+	"1(+0)ADM", "UNKNOWN", "PHYS DRV"
 };
 #define HPSA_RAID_0	0
 #define HPSA_RAID_4	1
@@ -617,7 +617,8 @@ static const char * const raid_label[] = { "0", "4", "1(+0)", "5", "5+1", "6",
 #define HPSA_RAID_51	4
 #define HPSA_RAID_6	5	/* also used for RAID 60 */
 #define HPSA_RAID_ADM	6	/* also used for RAID 1+0 ADM */
-#define RAID_UNKNOWN (ARRAY_SIZE(raid_label) - 1)
+#define RAID_UNKNOWN (ARRAY_SIZE(raid_label) - 2)
+#define PHYSICAL_DRIVE (ARRAY_SIZE(raid_label) - 1)
 
 static inline bool is_logical_device(struct hpsa_scsi_dev_t *device)
 {
@@ -1143,18 +1144,52 @@ static int hpsa_find_target_lun(struct ctlr_info *h,
 static void hpsa_show_dev_msg(const char *level, struct ctlr_info *h,
 	struct hpsa_scsi_dev_t *dev, char *description)
 {
+#define LABEL_SIZE 25
+	char label[LABEL_SIZE];
+
 	if (h == NULL || h->pdev == NULL || h->scsi_host == NULL)
 		return;
 
+	switch (dev->devtype) {
+	case TYPE_RAID:
+		snprintf(label, LABEL_SIZE, "controller");
+		break;
+	case TYPE_ENCLOSURE:
+		snprintf(label, LABEL_SIZE, "enclosure");
+		break;
+	case TYPE_DISK:
+		if (dev->external)
+			snprintf(label, LABEL_SIZE, "external");
+		else if (!is_logical_dev_addr_mode(dev->scsi3addr))
+			snprintf(label, LABEL_SIZE, "%s",
+				raid_label[PHYSICAL_DRIVE]);
+		else
+			snprintf(label, LABEL_SIZE, "RAID-%s",
+				dev->raid_level > RAID_UNKNOWN ? "?" :
+				raid_label[dev->raid_level]);
+		break;
+	case TYPE_ROM:
+		snprintf(label, LABEL_SIZE, "rom");
+		break;
+	case TYPE_TAPE:
+		snprintf(label, LABEL_SIZE, "tape");
+		break;
+	case TYPE_MEDIUM_CHANGER:
+		snprintf(label, LABEL_SIZE, "changer");
+		break;
+	default:
+		snprintf(label, LABEL_SIZE, "UNKNOWN");
+		break;
+	}
+
 	dev_printk(level, &h->pdev->dev,
-			"scsi %d:%d:%d:%d: %s %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",
+			"scsi %d:%d:%d:%d: %s %s %.8s %.16s %s SSDSmartPathCap%c En%c Exp=%d\n",
 			h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
 			description,
 			scsi_device_type(dev->devtype),
 			dev->vendor,
 			dev->model,
-			dev->raid_level > RAID_UNKNOWN ?
-				"RAID-?" : raid_label[dev->raid_level],
+			label,
 			dev->offload_config ? '+' : '-',
 			dev->offload_enabled ? '+' : '-',
 			dev->expose_device);


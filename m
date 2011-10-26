From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 3/5] hpsa: rename HPSA_MAX_SCSI_DEVS_PER_HBA
Date: Wed, 26 Oct 2011 16:21:07 -0500
Message-ID: <20111026212107.15570.85375.stgit@beardog.cce.hp.com>
References: <20111026212006.15570.26229.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111026212006.15570.26229.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Scott Teel <scott.teel@hp.com>

Rename HPSA_MAX_SCSI_DEVS_PER_HBA to HPSA_MAX_DEVICES

Signed-off-by: Scott Teel <scott.teel@hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   23 ++++++++++-------------
 drivers/scsi/hpsa.h |    4 ++--
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index d59515d..d359186 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -567,16 +567,16 @@ static int hpsa_find_target_lun(struct ctlr_info *h,
 	 * assumes h->devlock is held
 	 */
 	int i, found = 0;
-	DECLARE_BITMAP(lun_taken, HPSA_MAX_SCSI_DEVS_PER_HBA);
+	DECLARE_BITMAP(lun_taken, HPSA_MAX_DEVICES);
 
-	memset(&lun_taken[0], 0, HPSA_MAX_SCSI_DEVS_PER_HBA >> 3);
+	memset(&lun_taken[0], 0, HPSA_MAX_DEVICES >> 3);
 
 	for (i = 0; i < h->ndevices; i++) {
 		if (h->dev[i]->bus == bus && h->dev[i]->target != -1)
 			set_bit(h->dev[i]->target, lun_taken);
 	}
 
-	for (i = 0; i < HPSA_MAX_SCSI_DEVS_PER_HBA; i++) {
+	for (i = 0; i < HPSA_MAX_DEVICES; i++) {
 		if (!test_bit(i, lun_taken)) {
 			/* *bus = 1; */
 			*target = i;
@@ -599,7 +599,7 @@ static int hpsa_scsi_add_entry(struct ctlr_info *h, int hostno,
 	unsigned char addr1[8], addr2[8];
 	struct hpsa_scsi_dev_t *sd;
 
-	if (n >= HPSA_MAX_SCSI_DEVS_PER_HBA) {
+	if (n >= HPSA_MAX_DEVICES) {
 		dev_err(&h->pdev->dev, "too many devices, some will be "
 			"inaccessible.\n");
 		return -1;
@@ -674,7 +674,7 @@ static void hpsa_scsi_replace_entry(struct ctlr_info *h, int hostno,
 	struct hpsa_scsi_dev_t *removed[], int *nremoved)
 {
 	/* assumes h->devlock is held */
-	BUG_ON(entry < 0 || entry >= HPSA_MAX_SCSI_DEVS_PER_HBA);
+	BUG_ON(entry < 0 || entry >= HPSA_MAX_DEVICES);
 	removed[*nremoved] = h->dev[entry];
 	(*nremoved)++;
 
@@ -703,7 +703,7 @@ static void hpsa_scsi_remove_entry(struct ctlr_info *h, int hostno, int entry,
 	int i;
 	struct hpsa_scsi_dev_t *sd;
 
-	BUG_ON(entry < 0 || entry >= HPSA_MAX_SCSI_DEVS_PER_HBA);
+	BUG_ON(entry < 0 || entry >= HPSA_MAX_DEVICES);
 
 	sd = h->dev[entry];
 	removed[*nremoved] = h->dev[entry];
@@ -815,10 +815,8 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 	int nadded, nremoved;
 	struct Scsi_Host *sh = NULL;
 
-	added = kzalloc(sizeof(*added) * HPSA_MAX_SCSI_DEVS_PER_HBA,
-		GFP_KERNEL);
-	removed = kzalloc(sizeof(*removed) * HPSA_MAX_SCSI_DEVS_PER_HBA,
-		GFP_KERNEL);
+	added = kzalloc(sizeof(*added) * HPSA_MAX_DEVICES, GFP_KERNEL);
+	removed = kzalloc(sizeof(*removed) * HPSA_MAX_DEVICES, GFP_KERNEL);
 
 	if (!added || !removed) {
 		dev_warn(&h->pdev->dev, "out of memory in "
@@ -1847,8 +1845,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 	int raid_ctlr_position;
 	DECLARE_BITMAP(lunzerobits, HPSA_MAX_TARGETS_PER_CTLR);
 
-	currentsd = kzalloc(sizeof(*currentsd) * HPSA_MAX_SCSI_DEVS_PER_HBA,
-		GFP_KERNEL);
+	currentsd = kzalloc(sizeof(*currentsd) * HPSA_MAX_DEVICES, GFP_KERNEL);
 	physdev_list = kzalloc(reportlunsize, GFP_KERNEL);
 	logdev_list = kzalloc(reportlunsize, GFP_KERNEL);
 	tmpdevice = kzalloc(sizeof(*tmpdevice), GFP_KERNEL);
@@ -1957,7 +1954,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		default:
 			break;
 		}
-		if (ncurrent >= HPSA_MAX_SCSI_DEVS_PER_HBA)
+		if (ncurrent >= HPSA_MAX_DEVICES)
 			break;
 	}
 	adjust_hpsa_scsi_table(h, hostno, currentsd, ncurrent);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 111b79e..4de9f71 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -102,8 +102,8 @@ struct ctlr_info {
 	struct Scsi_Host *scsi_host;
 	spinlock_t devlock; /* to protect hba[ctlr]->dev[];  */
 	int ndevices; /* number of used elements in .dev[] array. */
-#define HPSA_MAX_SCSI_DEVS_PER_HBA 256
-	struct hpsa_scsi_dev_t *dev[HPSA_MAX_SCSI_DEVS_PER_HBA];
+#define HPSA_MAX_DEVICES 256
+	struct hpsa_scsi_dev_t *dev[HPSA_MAX_DEVICES];
 	/*
 	 * Performant mode tables.
 	 */

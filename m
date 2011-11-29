From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] [SCSI] hpsa: Use kcalloc instead of kzalloc to allocate
 array
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.331.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c 2011-11-28 19:36:47.956780228 +0100
+++ b/drivers/scsi/hpsa.c 2011-11-28 20:04:07.554064368 +0100
@@ -821,8 +821,8 @@ static void adjust_hpsa_scsi_table(struc
 	int nadded, nremoved;
 	struct Scsi_Host *sh = NULL;
 
-	added = kzalloc(sizeof(*added) * HPSA_MAX_DEVICES, GFP_KERNEL);
-	removed = kzalloc(sizeof(*removed) * HPSA_MAX_DEVICES, GFP_KERNEL);
+	added = kcalloc(HPSA_MAX_DEVICES, sizeof(*added), GFP_KERNEL);
+	removed = kcalloc(HPSA_MAX_DEVICES, sizeof(*removed), GFP_KERNEL);
 
 	if (!added || !removed) {
 		dev_warn(&h->pdev->dev, "out of memory in "
@@ -994,8 +994,8 @@ static int hpsa_allocate_sg_chain_blocks
 	if (h->chainsize <= 0)
 		return 0;
 
-	h->cmd_sg_list = kzalloc(sizeof(*h->cmd_sg_list) * h->nr_cmds,
-				GFP_KERNEL);
+	h->cmd_sg_list = kcalloc(h->nr_cmds, sizeof(*h->cmd_sg_list),
+				 GFP_KERNEL);
 	if (!h->cmd_sg_list)
 		return -ENOMEM;
 	for (i = 0; i < h->nr_cmds; i++) {
@@ -1866,7 +1866,7 @@ static void hpsa_update_scsi_devices(str
 	int raid_ctlr_position;
 	DECLARE_BITMAP(lunzerobits, HPSA_MAX_TARGETS_PER_CTLR);
 
-	currentsd = kzalloc(sizeof(*currentsd) * HPSA_MAX_DEVICES, GFP_KERNEL);
+	currentsd = kcalloc(HPSA_MAX_DEVICES, sizeof(*currentsd), GFP_KERNEL);
 	physdev_list = kzalloc(reportlunsize, GFP_KERNEL);
 	logdev_list = kzalloc(reportlunsize, GFP_KERNEL);
 	tmpdevice = kzalloc(sizeof(*tmpdevice), GFP_KERNEL);

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A50F9C00140
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Aug 2022 04:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiHJEfI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Aug 2022 00:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiHJEfI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2022 00:35:08 -0400
X-Greylist: delayed 749 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 09 Aug 2022 21:35:07 PDT
Received: from mx5.cs.washington.edu (mx5.cs.washington.edu [IPv6:2607:4000:200:11::6a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7500082FAD
        for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2022 21:35:07 -0700 (PDT)
Received: from mx5.cs.washington.edu (localhost [IPv6:0:0:0:0:0:0:0:1])
        by mx5.cs.washington.edu (8.17.1/8.17.1/1.26) with ESMTP id 27A4MU9a210869;
        Tue, 9 Aug 2022 21:22:30 -0700
Received: from attu4.cs.washington.edu (attu4.cs.washington.edu [IPv6:2607:4000:200:10:0:0:0:8c])
        (authenticated bits=128)
        by mx5.cs.washington.edu (8.17.1/8.17.1/1.26) with ESMTPSA id 27A4MUnB210865
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Tue, 9 Aug 2022 21:22:30 -0700
Received: from attu4.cs.washington.edu (localhost [127.0.0.1])
        by attu4.cs.washington.edu (8.15.2/8.15.2/1.23) with ESMTP id 27A4MUEN2628183;
        Tue, 9 Aug 2022 21:22:30 -0700
Received: (from klee33@localhost)
        by attu4.cs.washington.edu (8.15.2/8.15.2/Submit/1.2) id 27A4MUDB2628182;
        Tue, 9 Aug 2022 21:22:30 -0700
From:   Kenneth Lee <klee33@uw.edu>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Kenneth Lee <klee33@uw.edu>
Subject: [PATCH] scsi: Use kzalloc for allocating only one element
Date:   Tue,  9 Aug 2022 21:22:17 -0700
Message-Id: <20220810042217.2628090-1-klee33@uw.edu>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use kzalloc(...) rather than kcalloc(1, ...) because the number of
elements we are specifying in this case is 1, so kzalloc would
accomplish the same thing and we can simplify.

Signed-off-by: Kenneth Lee <klee33@uw.edu>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 2 +-
 drivers/scsi/mvsas/mv_init.c     | 2 +-
 drivers/scsi/qedf/qedf_main.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 5037ea09a810..510bf3838b70 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -3031,7 +3031,7 @@ lpfc_debugfs_hdwqstat_open(struct inode *inode, struct file *file)
 		goto out;
 
 	 /* Round to page boundary */
-	debug->buffer = kcalloc(1, LPFC_SCSISTAT_SIZE, GFP_KERNEL);
+	debug->buffer = kzalloc(LPFC_SCSISTAT_SIZE, GFP_KERNEL);
 	if (!debug->buffer) {
 		kfree(debug);
 		goto out;
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 2fde496fff5f..47c13c4ccf53 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -521,7 +521,7 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	chip = &mvs_chips[ent->driver_data];
 	SHOST_TO_SAS_HA(shost) =
-		kcalloc(1, sizeof(struct sas_ha_struct), GFP_KERNEL);
+		kzalloc(sizeof(struct sas_ha_struct), GFP_KERNEL);
 	if (!SHOST_TO_SAS_HA(shost)) {
 		scsi_host_put(shost);
 		rc = -ENOMEM;
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 3d6b137314f3..103e278194f8 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2757,7 +2757,7 @@ static int qedf_prepare_sb(struct qedf_ctx *qedf)
 	for (id = 0; id < qedf->num_queues; id++) {
 		fp = &(qedf->fp_array[id]);
 		fp->sb_id = QEDF_SB_ID_NULL;
-		fp->sb_info = kcalloc(1, sizeof(*fp->sb_info), GFP_KERNEL);
+		fp->sb_info = kzalloc(sizeof(*fp->sb_info), GFP_KERNEL);
 		if (!fp->sb_info) {
 			QEDF_ERR(&(qedf->dbg_ctx), "SB info struct "
 				  "allocation failed.\n");
-- 
2.31.1


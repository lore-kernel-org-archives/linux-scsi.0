From: Firo Yang <firogm@gmail.com>
Subject: [PATCH] cciss: Clean up unnessary void pointer cast
Date: Thu, 23 Apr 2015 17:59:38 +0800
Message-ID: <1429783178-6948-1-git-send-email-firogm@gmail.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: don.brace@pmcs.com
Cc: kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, Firo Yang <firogm@gmail.com>
List-Id: linux-scsi@vger.kernel.org

There's no need to cast the, void *, return value of kmalloc() when
assigning to a pointer variable in drivers/block/cciss_scsi.c::
cciss_scsi_setup.

Signed-off-by: Firo Yang <firogm@gmail.com>
---
 drivers/block/cciss_scsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index ecd845c..6e17d47 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -704,8 +704,7 @@ cciss_scsi_setup(ctlr_info_t *h)
 	struct cciss_scsi_adapter_data_t * shba;
 
 	ccissscsi[h->ctlr].ndevices = 0;
-	shba = (struct cciss_scsi_adapter_data_t *)
-		kmalloc(sizeof(*shba), GFP_KERNEL);	
+	shba = kmalloc(sizeof(*shba), GFP_KERNEL);
 	if (shba == NULL)
 		return;
 	shba->scsi_host = NULL;
-- 
2.1.0


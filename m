From: "Thomas Meyer" <thomas@m3y3r.de>
Subject: [PATCH] scsi: pmcraid: Use *_pool_zalloc rather than *_pool_alloc
Date: Wed, 29 May 2019 22:21:40 +0200
Message-ID: <1559161113902-328168114-2-diffsplit-thomas@m3y3r.de>
References: <1559161113889-196429735-0-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1559161113889-196429735-0-diffsplit-thomas@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use *_pool_zalloc rather than *_pool_alloc followed by memset with 0.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4668,18 +4668,14 @@ static int pmcraid_allocate_control_bloc
 		return -ENOMEM;
 
 	for (i = 0; i < PMCRAID_MAX_CMD; i++) {
-		pinstance->cmd_list[i]->ioa_cb =
-			dma_pool_alloc(
-				pinstance->control_pool,
-				GFP_KERNEL,
-				&(pinstance->cmd_list[i]->ioa_cb_bus_addr));
+		pinstance->cmd_list[i]->ioa_cb = dma_pool_zalloc(pinstance->control_pool,
+								 GFP_KERNEL,
+								 &(pinstance->cmd_list[i]->ioa_cb_bus_addr));
 
 		if (!pinstance->cmd_list[i]->ioa_cb) {
 			pmcraid_release_control_blocks(pinstance, i);
 			return -ENOMEM;
 		}
-		memset(pinstance->cmd_list[i]->ioa_cb, 0,
-			sizeof(struct pmcraid_control_block));
 	}
 	return 0;
 }

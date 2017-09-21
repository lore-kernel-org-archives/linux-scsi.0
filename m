From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH 4/6] mvsas: Cocci spatch "pool_zalloc-simple"
Date: Thu, 21 Sep 2017 08:15:26 +0200
Message-ID: <1505974468535-1535923349-4-diffsplit-thomas@m3y3r.de>
References: <1505974468535-2047238743-0-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505974468535-2047238743-0-diffsplit-thomas@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use *_pool_zalloc rather than *_pool_alloc followed by memset with 0.
Found by coccinelle spatch "api/alloc/pool_zalloc-simple.cocci"

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -790,12 +790,11 @@ static int mvs_task_prep(struct sas_task
 	slot->n_elem = n_elem;
 	slot->slot_tag = tag;
 
-	slot->buf = dma_pool_alloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
+	slot->buf = dma_pool_zalloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
 	if (!slot->buf) {
 		rc = -ENOMEM;
 		goto err_out_tag;
 	}
-	memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
 
 	tei.task = task;
 	tei.hdr = &mvi->slot[tag];

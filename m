From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH 6/6] scsi: Cocci spatch "pool_zalloc-simple"
Date: Thu, 21 Sep 2017 08:15:26 +0200
Message-ID: <1505974468536-246250875-6-diffsplit-thomas@m3y3r.de>
References: <1505974468535-2047238743-0-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505974468535-2047238743-0-diffsplit-thomas@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use *_pool_zalloc rather than *_pool_alloc followed by memset with 0.
Found by coccinelle spatch "api/alloc/pool_zalloc-simple.cocci"

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1651,13 +1651,12 @@ int qla4xxx_set_chap(struct scsi_qla_hos
 	uint32_t chap_size = 0;
 	dma_addr_t chap_dma;
 
-	chap_table = dma_pool_alloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
+	chap_table = dma_pool_zalloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
 	if (chap_table == NULL) {
 		ret =  -ENOMEM;
 		goto exit_set_chap;
 	}
 
-	memset(chap_table, 0, sizeof(struct ql4_chap_table));
 	if (bidi)
 		chap_table->flags |= BIT_6; /* peer */
 	else
diff -u -p a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -825,12 +825,10 @@ static int qla4xxx_delete_chap(struct Sc
 	uint32_t chap_size;
 	int ret = 0;
 
-	chap_table = dma_pool_alloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
+	chap_table = dma_pool_zalloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
 	if (chap_table == NULL)
 		return -ENOMEM;
 
-	memset(chap_table, 0, sizeof(struct ql4_chap_table));
-
 	if (is_qla80XX(ha))
 		max_chap_entries = (ha->hw.flt_chap_size / 2) /
 				   sizeof(struct ql4_chap_table);

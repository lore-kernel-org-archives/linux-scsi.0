From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] qla4xxx: don't free pool that wasn't allocated
Date: Thu, 17 May 2012 10:11:20 +0300
Message-ID: <20120517071120.GG14660@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, iscsi-driver@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In the original code if dma_pool_alloc() fails then we call
dma_pool_free().  The problem is that "chap_table" is NULL and
"chap_dma" is uninitialized so it will cause an error.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 7ac21da..21dce92 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1329,10 +1329,8 @@ int qla4xxx_get_chap(struct scsi_qla_host *ha, char *username, char *password,
 	dma_addr_t chap_dma;
 
 	chap_table = dma_pool_alloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
-	if (chap_table == NULL) {
-		ret = -ENOMEM;
-		goto exit_get_chap;
-	}
+	if (chap_table == NULL)
+		return -ENOMEM;
 
 	chap_size = sizeof(struct ql4_chap_table);
 	memset(chap_table, 0, chap_size);

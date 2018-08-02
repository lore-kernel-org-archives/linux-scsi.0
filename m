From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH v2 3/4] drivers/scsi/snic/snic_trc: Use kvcalloc instead of vmalloc+memset
Date: Thu, 2 Aug 2018 19:28:33 +0800
Message-ID: <1533209314-1074-4-git-send-email-zhongjiang@huawei.com>
References: <1533209314-1074-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533209314-1074-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, aacraid@microsemi.com
Cc: andy.shevchenko@gmail.com, joe@perches.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The kvcalloc is better than vmalloc() + memset() , So replace them.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/scsi/snic/snic_trc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/snic/snic_trc.c b/drivers/scsi/snic/snic_trc.c
index fc60c93..e766fa2 100644
--- a/drivers/scsi/snic/snic_trc.c
+++ b/drivers/scsi/snic/snic_trc.c
@@ -125,8 +125,8 @@ struct snic_trc_data *
 	void *tbuf = NULL;
 	int tbuf_sz = 0, ret;
 
-	tbuf_sz = (snic_trace_max_pages * PAGE_SIZE);
-	tbuf = vmalloc(tbuf_sz);
+	tbuf_sz = snic_trace_max_pages * PAGE_SIZE;
+	tbuf = kvcalloc(snic_trace_max_pages, PAGE_SIZE, GFP_KERNEL);
 	if (!tbuf) {
 		SNIC_ERR("Failed to Allocate Trace Buffer Size. %d\n", tbuf_sz);
 		SNIC_ERR("Trace Facility not enabled.\n");
@@ -135,7 +135,6 @@ struct snic_trc_data *
 		return ret;
 	}
 
-	memset(tbuf, 0, tbuf_sz);
 	trc->buf = (struct snic_trc_data *) tbuf;
 	spin_lock_init(&trc->lock);
 
@@ -173,7 +172,7 @@ struct snic_trc_data *
 	snic_trc_debugfs_term();
 
 	if (trc->buf) {
-		vfree(trc->buf);
+		kvfree(trc->buf);
 		trc->buf = NULL;
 	}
 
-- 
1.7.12.4

From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH] scsi: sr: fix oob access in get_capabilities
Date: Fri, 3 Mar 2017 18:17:52 +0800
Message-ID: <1488536272-10509-1-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>
List-Id: linux-scsi@vger.kernel.org

'n = header_length + block_descriptor_length' could be greater than 512,
and will lead to oob access, so enlarge transfer buffer to fix it.

===
BUG: KASAN: slab-out-of-bounds in sr_probe+0x570/0xcc0 at addr ffff88000009020e
Read of size 1 by task kworker/u48:2/188

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 drivers/scsi/sr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 0b29b93..5a80aa6 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -852,7 +852,7 @@ static void get_capabilities(struct scsi_cd *cd)
 
 
 	/* allocate transfer buffer */
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(1024, GFP_KERNEL | GFP_DMA);
 	if (!buffer) {
 		sr_printk(KERN_ERR, cd, "out of memory.\n");
 		return;
-- 
1.7.12.4

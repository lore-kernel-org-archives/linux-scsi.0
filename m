From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] qla2xxx: use sg_virt()
Date: Thu, 23 Mar 2017 21:16:33 +0800
Message-ID: <6441bf33ffc2cd73fdd44671030c8a72e7a81403.1490258759.git.geliangtang@gmail.com>
References: <a41fae798473b657f09859ae113403655b1717f9.1490258141.git.geliangtang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a41fae798473b657f09859ae113403655b1717f9.1490258141.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use sg_virt() instead of open-coding it.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 3203367..9610d85 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1991,7 +1991,7 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 				return 1;
 			}
 
-			spt = page_address(sg_page(sg)) + sg->offset;
+			spt = sg_virt(sg);
 			spt += j;
 
 			spt->app_tag = 0xffff;
-- 
2.9.3

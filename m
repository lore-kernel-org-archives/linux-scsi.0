From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] scsi: csiostor: Fix a possible null-pointer dereference in csio_eh_lun_reset_handler()
Date: Mon, 29 Jul 2019 16:51:35 +0800
Message-ID: <20190729085135.29403-1-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.ibm.com, martin.petersen@oracle.com, varun@chelsio.com, hare@suse.com, osandov@fb.com, jthumshirn@suse.de, axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-scsi@vger.kernel.org

In csio_eh_lun_reset_handler(), there is an if statement on line 2072 to
check whether rn is NULL:
    if (!rn)

When rn is NULL, it is used on line 2217:
    CSIO_INC_STATS(rn, n_lun_rst_fail);

Thus, a possible null-pointer dereference may occur.

To fix this bug, csio_eh_lun_reset_handler() directly returns FAILED
when rn is NULL.

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/csiostor/csio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 469d0bc9f5fe..c81d743d3544 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2070,7 +2070,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	struct csio_scsi_level_data sld;
 
 	if (!rn)
-		goto fail;
+		return FAILED;
 
 	csio_dbg(hw, "Request to reset LUN:%llu (ssni:0x%x tgtid:%d)\n",
 		      cmnd->device->lun, rn->flowid, rn->scsi_id);
-- 
2.17.0

From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2] scsi: return correct blkprep status code in case scsi_init_io() fails.
Date: Wed, 12 Apr 2017 09:21:19 +0200
Message-ID: <20170412072119.7529-1-jthumshirn@suse.de>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When instrumenting the SCSI layer to run into the
!blk_rq_nr_phys_segments(rq) case the following  warning emitted from the
block layer:

blk_peek_request: bad return=-22

This happens because since commit fd3fc0b4d730 ('scsi: don't BUG_ON()
empty DMA transfers') we return the wrong error value from scsi_prep_fn()
back to the block layer.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Fixes: fd3fc0b4d730 scsi: don't BUG_ON() empty DMA transfers
Cc: <stable@vger.kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
Changes to v1:
* s/iscsi_prep_fn()/scsi_prep_fn()
* Add Cc stable

 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 19125d72f322..5558e212368b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1061,10 +1061,10 @@ int scsi_init_io(struct scsi_cmnd *cmd)
 	struct scsi_device *sdev = cmd->device;
 	struct request *rq = cmd->request;
 	bool is_mq = (rq->mq_ctx != NULL);
-	int error;
+	int error = BLKPREP_KILL;
 
 	if (WARN_ON_ONCE(!blk_rq_nr_phys_segments(rq)))
-		return -EINVAL;
+		goto err_exit;
 
 	error = scsi_init_sgtable(rq, &cmd->sdb);
 	if (error)
-- 
2.12.0

From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] sd_zbc: Write unlock zone from sd_uninit_cmnd()
Date: Tue,  8 Aug 2017 13:17:46 +0900
Message-ID: <20170808041746.31341-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:23397 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbdHHESd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2017 00:18:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, Christoph Hellwig <hch@lst.de>

Releasing the write lock of a zone when the write commnand that
acquired the lock completes can cause deadlocks with scsi-mq due to
potential queue reordering if the lock owning request is requeued and
not executed.

Since sd_uninit_cmnd() is always called when a request is requeued,
call sd_zbc_write_unlock_zone() from that function for write requests
that acquired a zone lock. Acquisition of a zone lock by a write command
is indicated using the new command flag SCMD_ZONE_WRITE_LOCK.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c        | 3 +++
 drivers/scsi/sd_zbc.c    | 9 +++++----
 include/scsi/scsi_cmnd.h | 1 +
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bea36adeee17..e2647f2d4430 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1277,6 +1277,9 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
 	struct request *rq = SCpnt->request;
 
+	if (SCpnt->flags & SCMD_ZONE_WRITE_LOCK)
+		sd_zbc_write_unlock_zone(SCpnt);
+
 	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
 		__free_page(rq->special_vec.bv_page);
 
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 96855df9f49d..8aa54779aac1 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -294,6 +294,9 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 	    test_and_set_bit(zno, sdkp->zones_wlock))
 		return BLKPREP_DEFER;
 
+	WARN_ON_ONCE(cmd->flags & SCMD_ZONE_WRITE_LOCK);
+	cmd->flags |= SCMD_ZONE_WRITE_LOCK;
+
 	return BLKPREP_OK;
 }
 
@@ -302,9 +305,10 @@ void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd)
 	struct request *rq = cmd->request;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 
-	if (sdkp->zones_wlock) {
+	if (sdkp->zones_wlock && cmd->flags & SCMD_ZONE_WRITE_LOCK) {
 		unsigned int zno = sd_zbc_zone_no(sdkp, blk_rq_pos(rq));
 		WARN_ON_ONCE(!test_bit(zno, sdkp->zones_wlock));
+		cmd->flags &= ~SCMD_ZONE_WRITE_LOCK;
 		clear_bit_unlock(zno, sdkp->zones_wlock);
 		smp_mb__after_atomic();
 	}
@@ -335,9 +339,6 @@ void sd_zbc_complete(struct scsi_cmnd *cmd,
 	case REQ_OP_WRITE_ZEROES:
 	case REQ_OP_WRITE_SAME:
 
-		/* Unlock the zone */
-		sd_zbc_write_unlock_zone(cmd);
-
 		if (result &&
 		    sshdr->sense_key == ILLEGAL_REQUEST &&
 		    sshdr->asc == 0x21)
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a1266d318c85..6af198d8120b 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -57,6 +57,7 @@ struct scsi_pointer {
 /* for scmd->flags */
 #define SCMD_TAGGED		(1 << 0)
 #define SCMD_UNCHECKED_ISA_DMA	(1 << 1)
+#define SCMD_ZONE_WRITE_LOCK	(1 << 2)
 
 struct scsi_cmnd {
 	struct scsi_request req;
-- 
2.13.3

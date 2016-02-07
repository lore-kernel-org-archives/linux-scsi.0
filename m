From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] target/iblock: Use -EAGAIN/-ENOMEM to propigate SAM BUSY/TASK_SET_FULL
Date: Sun,  7 Feb 2016 06:22:37 +0000
Message-ID: <1454826157-20877-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates target/iblock backend driver code to
check for bio completion status of -EAGAIN / -ENOMEM
provided by raw block drivers and scsi devices, in order
to generate the following SCSI status to initiators:

  - SAM_STAT_BUSY
  - SAM_STAT_TASK_SET_FULL

Note these two SAM status codes are useful to signal to
Linux SCSI host side that se_cmd should be retried
again, or with TASK_SET_FULL case to attempt to lower
our internal host LLD queue_depth and scsi_cmnd retry.

It also updates target_complete_cmd() to parse status
when signalling success to target_completion_wq.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Andy Grover <agrover@redhat.com>
Cc: Mike Christie <mchristi@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c    | 38 +++++++++++++++++++++++++++-------
 drivers/target/target_core_iblock.h    |  1 +
 drivers/target/target_core_transport.c | 13 ++++++++++--
 3 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 5a2899f..77d0381 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -300,11 +300,28 @@ static void iblock_complete_cmd(struct se_cmd *cmd)
 
 	if (!atomic_dec_and_test(&ibr->pending))
 		return;
-
-	if (atomic_read(&ibr->ib_bio_err_cnt))
-		status = SAM_STAT_CHECK_CONDITION;
-	else
+	/*
+	 * Propigate use these two bio completion values from raw block
+	 * drivers to signal up BUSY and TASK_SET_FULL status to the
+	 * host side initiator.  The latter for Linux/iSCSI initiators
+	 * means the Linux/SCSI LLD will begin to reduce it's internal
+	 * per session queue_depth.
+	 */
+	if (atomic_read(&ibr->ib_bio_err_cnt)) {
+		switch (ibr->ib_bio_retry) {
+		case -EAGAIN:
+			status = SAM_STAT_BUSY;
+			break;
+		case -ENOMEM:
+			status = SAM_STAT_TASK_SET_FULL;
+			break;
+		default:
+			status = SAM_STAT_CHECK_CONDITION;
+			break;
+		}
+	} else {
 		status = SAM_STAT_GOOD;
+	}
 
 	target_complete_cmd(cmd, status);
 	kfree(ibr);
@@ -316,7 +333,15 @@ static void iblock_bio_done(struct bio *bio)
 	struct iblock_req *ibr = cmd->priv;
 
 	if (bio->bi_error) {
-		pr_err("bio error: %p,  err: %d\n", bio, bio->bi_error);
+		pr_debug_ratelimited("test_bit(BIO_UPTODATE) failed for bio: %p,"
+			" err: %d\n", bio, bio->bi_error);
+		/*
+		 * Save the retryable status provided and translate into
+		 * SAM status in iblock_complete_cmd().
+		 */
+		if (bio->bi_error == -EAGAIN || bio->bi_error == -ENOMEM) {
+			ibr->ib_bio_retry = bio->bi_error;
+		}
 		/*
 		 * Bump the ib_bio_err_cnt and release bio.
 		 */
@@ -655,8 +680,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	u32 sg_num = sgl_nents;
 	sector_t block_lba;
 	unsigned bio_cnt;
-	int rw = 0;
-	int i;
+	int i, rw = 0;
 
 	if (data_direction == DMA_TO_DEVICE) {
 		struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index 01c2afd..ff3cfdd 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -9,6 +9,7 @@
 struct iblock_req {
 	atomic_t pending;
 	atomic_t ib_bio_err_cnt;
+	int ib_bio_retry;
 } ____cacheline_aligned;
 
 #define IBDF_HAS_UDEV_PATH		0x01
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 6becc94..eb12ae2 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -732,11 +732,20 @@ static unsigned char *transport_get_sense_buffer(struct se_cmd *cmd)
 void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 {
 	struct se_device *dev = cmd->se_dev;
-	int success = scsi_status == GOOD;
+	int success;
 	unsigned long flags;
 
 	cmd->scsi_status = scsi_status;
-
+	switch (cmd->scsi_status) {
+	case SAM_STAT_GOOD:
+	case SAM_STAT_BUSY:
+	case SAM_STAT_TASK_SET_FULL:
+		success = 1;
+		break;
+	default:
+		success = 0;
+		break;
+	}
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	cmd->transport_state &= ~CMD_T_BUSY;
-- 
1.9.1

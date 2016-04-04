From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/14] libata: sanitize ata_tf_read_block()
Date: Mon,  4 Apr 2016 11:43:57 +0200
Message-ID: <1459763047-125551-5-git-send-email-hare@suse.de>
References: <1459763047-125551-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039AbcDDJoY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 05:44:24 -0400
In-Reply-To: <1459763047-125551-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Return (u64)-1 if ata_tf_read_block() could not decode the LBA
address, and do not set the information sense descriptor in
ata_gen_ata_sense() in these cases.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/ata/libata-core.c | 4 ++--
 drivers/ata/libata-scsi.c | 2 ++
 drivers/ata/libata.h      | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f991f78..a8d6336 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -695,7 +695,7 @@ static int ata_rwcmd_protocol(struct ata_taskfile *tf, struct ata_device *dev)
  *	RETURNS:
  *	Block address read from @tf.
  */
-u64 ata_tf_read_block(struct ata_taskfile *tf, struct ata_device *dev)
+u64 ata_tf_read_block(const struct ata_taskfile *tf, struct ata_device *dev)
 {
 	u64 block = 0;
 
@@ -720,7 +720,7 @@ u64 ata_tf_read_block(struct ata_taskfile *tf, struct ata_device *dev)
 		if (!sect) {
 			ata_dev_warn(dev,
 				     "device reported invalid CHS sector 0\n");
-			sect = 1; /* oh well */
+			return (u64)-1;
 		}
 
 		block = (cyl * dev->heads + head) * dev->sectors + sect - 1;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e331077..410ce14 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1083,6 +1083,8 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 	}
 
 	block = ata_tf_read_block(&qc->result_tf, dev);
+	if (block == (u64)-1)
+		return;
 
 	/* information sense data descriptor */
 	sb[7] = 12;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 8cfdd96..507c22f 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -67,7 +67,8 @@ extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev, int tag);
 extern int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 			   u64 block, u32 n_block, unsigned int tf_flags,
 			   unsigned int tag);
-extern u64 ata_tf_read_block(struct ata_taskfile *tf, struct ata_device *dev);
+extern u64 ata_tf_read_block(const struct ata_taskfile *tf,
+			     struct ata_device *dev);
 extern unsigned ata_exec_internal(struct ata_device *dev,
 				  struct ata_taskfile *tf, const u8 *cdb,
 				  int dma_dir, void *buf, unsigned int buflen,
-- 
1.8.5.6


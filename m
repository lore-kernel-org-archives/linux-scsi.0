From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi: fix scsi_get_lba helper function for pc command
Date: Wed, 2 Jun 2010 16:33:53 +0900
Message-ID: <20100602163313S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:38266 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab0FBHeH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jun 2010 03:34:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, jaxboe@fusionio.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com

This fixes scsi_get_lba() helper function for PC commands.

Only the block layer is supposed to touch rq->__sector. We could
create a new accessor for it. But it seems overdoing a bit? Jens?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi: fix scsi_get_lba helper function for pc command

scsi_get_lba() can be used to get the lba info from
scsi_cmnd. scsi_get_lba() gets the lba info from rq->__sector so
scsi_get_lba() returns a bogus value for PC commands (we don't use
rq->__sector for PC commands).

This patch sets rq->__sector in scsi_setup_blk_pc_cmnd() so that
scsi_get_lba() works with PC commands.

scsi_get_data_transfer_info() is taken from
scsi_debug. scsi_get_data_transfer_info() looks useful for some
(scsi_debug, scsi_trace, libata, etc). So I export it. I'll convert
them to use scsi_get_data_transfer_info().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_lib.c  |   54 +++++++++++++++++++++++++++++++++++++++++++++-
 include/scsi/scsi_cmnd.h |    4 +++
 2 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1646fe7..b9b7f40 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -19,6 +19,7 @@
 #include <linux/delay.h>
 #include <linux/hardirq.h>
 #include <linux/scatterlist.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -69,6 +70,52 @@ struct kmem_cache *scsi_sdb_cache;
 
 static void scsi_run_queue(struct request_queue *q);
 
+int scsi_get_data_transfer_info(unsigned char *cmd, unsigned long long *lba,
+				unsigned int *num, unsigned int *ei_lba)
+{
+	int ret = 0;
+
+	switch (*cmd) {
+	case VARIABLE_LENGTH_CMD:
+		*lba = get_unaligned_be64(&cmd[12]);
+		*num = get_unaligned_be32(&cmd[28]);
+		*ei_lba = get_unaligned_be32(&cmd[20]);
+		break;
+	case WRITE_16:
+	case READ_16:
+	case VERIFY_16:
+	case WRITE_SAME_16:
+		*lba = get_unaligned_be64(&cmd[2]);
+		*num = get_unaligned_be32(&cmd[10]);
+		break;
+	case WRITE_12:
+	case READ_12:
+	case VERIFY_12:
+		*lba = get_unaligned_be32(&cmd[2]);
+		*num = get_unaligned_be32(&cmd[6]);
+		break;
+	case WRITE_10:
+	case READ_10:
+	case XDWRITEREAD_10:
+	case VERIFY:
+	case WRITE_SAME:
+		*lba = get_unaligned_be32(&cmd[2]);
+		*num = get_unaligned_be16(&cmd[7]);
+		break;
+	case WRITE_6:
+	case READ_6:
+		*lba = (u32)cmd[3] | (u32)cmd[2] << 8 |
+			(u32)(cmd[1] & 0x1f) << 16;
+		*num = (0 == cmd[4]) ? 256 : cmd[4];
+		break;
+	default:
+		ret = -1;
+		break;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(scsi_get_data_transfer_info);
+
 /*
  * Function:	scsi_unprep_request()
  *
@@ -1046,6 +1093,8 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 {
 	struct scsi_cmnd *cmd;
 	int ret = scsi_prep_state_check(sdev, req);
+	unsigned int num, ei_lba;
+	unsigned long long lba;
 
 	if (ret != BLKPREP_OK)
 		return ret;
@@ -1082,7 +1131,10 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 		cmd->sc_data_direction = DMA_TO_DEVICE;
 	else
 		cmd->sc_data_direction = DMA_FROM_DEVICE;
-	
+
+	scsi_get_data_transfer_info(cmd->cmnd, &lba, &num, &ei_lba);
+	req->__sector = lba;
+
 	cmd->transfersize = blk_rq_bytes(req);
 	cmd->allowed = req->retries;
 	return BLKPREP_OK;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a5e885a..be3c785 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -151,6 +151,10 @@ extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
 struct scsi_cmnd *scsi_allocate_command(gfp_t gfp_mask);
 void scsi_free_command(gfp_t gfp_mask, struct scsi_cmnd *cmd);
 
+extern int scsi_get_data_transfer_info(unsigned char *cmd,
+				       unsigned long long *lba,
+				       unsigned int *num, unsigned int *ei_lba);
+
 static inline unsigned scsi_sg_count(struct scsi_cmnd *cmd)
 {
 	return cmd->sdb.table.nents;
-- 
1.6.5


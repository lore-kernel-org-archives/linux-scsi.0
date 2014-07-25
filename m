From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] [SCSI] Make scsi_transfer_length take a scsi_data_buffer argument
Date: Fri, 25 Jul 2014 16:00:19 -0400
Message-ID: <1406318419-7273-1-git-send-email-martin.petersen@oracle.com>
References: <20140713113715.GA26031@infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23853 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbaGYT7p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jul 2014 15:59:45 -0400
In-Reply-To: <20140713113715.GA26031@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@infradead.org>

For bidirectional commands we need to be able to distinguish between the
in and out scsi_data_buffers when calculating the wire transfer length.
Make scsi_transfer_length() take a scsi_data_buffer argument so the
caller can choose which I/O direction the calculation should apply to.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 drivers/scsi/libiscsi.c            | 2 +-
 drivers/target/loopback/tcm_loop.c | 2 +-
 include/scsi/scsi_cmnd.h           | 5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f2db82beb646..fdea8c1527d4 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -391,7 +391,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	if (scsi_get_prot_op(sc) != SCSI_PROT_NORMAL)
 		task->protected = true;
 
-	transfer_length = scsi_transfer_length(sc);
+	transfer_length = scsi_transfer_length(sc, scsi_out(sc));
 	hdr->data_length = cpu_to_be32(transfer_length);
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
 		struct iscsi_r2t_info *r2t = &task->unsol_r2t;
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 340de9d92b15..c50453df555a 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -213,7 +213,7 @@ static void tcm_loop_submission_work(struct work_struct *work)
 
 	}
 
-	transfer_length = scsi_transfer_length(sc);
+	transfer_length = scsi_transfer_length(sc, scsi_out(sc));
 	if (!scsi_prot_sg_count(sc) &&
 	    scsi_get_prot_op(sc) != SCSI_PROT_NORMAL) {
 		se_cmd->prot_pto = true;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 73f349044941..42e62cfff515 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -313,9 +313,10 @@ static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
 	cmd->result = (cmd->result & 0x00ffffff) | (status << 24);
 }
 
-static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
+static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd,
+					    struct scsi_data_buffer *sdb)
 {
-	unsigned int xfer_len = scsi_out(scmd)->length;
+	unsigned int xfer_len = sdb->length;
 	unsigned int prot_op = scsi_get_prot_op(scmd);
 	unsigned int sector_size = scmd->device->sector_size;
 
-- 
1.9.3


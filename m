From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.2-rc4
Date: Sun, 02 Aug 2015 09:17:53 -0700
Message-ID: <1438532273.2182.28.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

A set of three fixes for the ipr driver and one fairly major one for
memory leaks in the mq path of SCSI.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Brian King (3):
      ipr: Fix invalid array indexing for HRRQ
      ipr: Fix incorrect trace indexing
      ipr: Fix locking for unit attention handling

Tony Battersby (1):
      scsi: fix memory leak with scsi-mq

And the diffstat:

 drivers/scsi/ipr.c        | 28 ++++++++++++++++++----------
 drivers/scsi/ipr.h        |  1 +
 drivers/scsi/scsi_error.c |  2 +-
 drivers/scsi/scsi_lib.c   |  6 +++---
 4 files changed, 23 insertions(+), 14 deletions(-)

With full diff below

James

---

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 8827448..a9aa389 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -599,9 +599,10 @@ static void ipr_trc_hook(struct ipr_cmnd *ipr_cmd,
 {
 	struct ipr_trace_entry *trace_entry;
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+	unsigned int trace_index;
 
-	trace_entry = &ioa_cfg->trace[atomic_add_return
-			(1, &ioa_cfg->trace_index)%IPR_NUM_TRACE_ENTRIES];
+	trace_index = atomic_add_return(1, &ioa_cfg->trace_index) & IPR_TRACE_INDEX_MASK;
+	trace_entry = &ioa_cfg->trace[trace_index];
 	trace_entry->time = jiffies;
 	trace_entry->op_code = ipr_cmd->ioarcb.cmd_pkt.cdb[0];
 	trace_entry->type = type;
@@ -1051,10 +1052,15 @@ static void ipr_send_blocking_cmd(struct ipr_cmnd *ipr_cmd,
 
 static int ipr_get_hrrq_index(struct ipr_ioa_cfg *ioa_cfg)
 {
+	unsigned int hrrq;
+
 	if (ioa_cfg->hrrq_num == 1)
-		return 0;
-	else
-		return (atomic_add_return(1, &ioa_cfg->hrrq_index) % (ioa_cfg->hrrq_num - 1)) + 1;
+		hrrq = 0;
+	else {
+		hrrq = atomic_add_return(1, &ioa_cfg->hrrq_index);
+		hrrq = (hrrq % (ioa_cfg->hrrq_num - 1)) + 1;
+	}
+	return hrrq;
 }
 
 /**
@@ -6263,21 +6269,23 @@ static void ipr_scsi_done(struct ipr_cmnd *ipr_cmd)
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	struct scsi_cmnd *scsi_cmd = ipr_cmd->scsi_cmd;
 	u32 ioasc = be32_to_cpu(ipr_cmd->s.ioasa.hdr.ioasc);
-	unsigned long hrrq_flags;
+	unsigned long lock_flags;
 
 	scsi_set_resid(scsi_cmd, be32_to_cpu(ipr_cmd->s.ioasa.hdr.residual_data_len));
 
 	if (likely(IPR_IOASC_SENSE_KEY(ioasc) == 0)) {
 		scsi_dma_unmap(scsi_cmd);
 
-		spin_lock_irqsave(ipr_cmd->hrrq->lock, hrrq_flags);
+		spin_lock_irqsave(ipr_cmd->hrrq->lock, lock_flags);
 		list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
 		scsi_cmd->scsi_done(scsi_cmd);
-		spin_unlock_irqrestore(ipr_cmd->hrrq->lock, hrrq_flags);
+		spin_unlock_irqrestore(ipr_cmd->hrrq->lock, lock_flags);
 	} else {
-		spin_lock_irqsave(ipr_cmd->hrrq->lock, hrrq_flags);
+		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+		spin_lock(&ipr_cmd->hrrq->_lock);
 		ipr_erp_start(ioa_cfg, ipr_cmd);
-		spin_unlock_irqrestore(ipr_cmd->hrrq->lock, hrrq_flags);
+		spin_unlock(&ipr_cmd->hrrq->_lock);
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	}
 }
 
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index 73790a1..6b97ee4 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1486,6 +1486,7 @@ struct ipr_ioa_cfg {
 
 #define IPR_NUM_TRACE_INDEX_BITS	8
 #define IPR_NUM_TRACE_ENTRIES		(1 << IPR_NUM_TRACE_INDEX_BITS)
+#define IPR_TRACE_INDEX_MASK		(IPR_NUM_TRACE_ENTRIES - 1)
 #define IPR_TRACE_SIZE	(sizeof(struct ipr_trace_entry) * IPR_NUM_TRACE_ENTRIES)
 	char trace_start[8];
 #define IPR_TRACE_START_LABEL			"trace"
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 106884a..cfadcce 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -944,7 +944,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 			    scmd->sdb.length);
 		scmd->sdb.table.sgl = &ses->sense_sgl;
 		scmd->sc_data_direction = DMA_FROM_DEVICE;
-		scmd->sdb.table.nents = 1;
+		scmd->sdb.table.nents = scmd->sdb.table.orig_nents = 1;
 		scmd->cmnd[0] = REQUEST_SENSE;
 		scmd->cmnd[4] = scmd->sdb.length;
 		scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b1a2631..448ebda 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -583,7 +583,7 @@ static struct scatterlist *scsi_sg_alloc(unsigned int nents, gfp_t gfp_mask)
 
 static void scsi_free_sgtable(struct scsi_data_buffer *sdb, bool mq)
 {
-	if (mq && sdb->table.nents <= SCSI_MAX_SG_SEGMENTS)
+	if (mq && sdb->table.orig_nents <= SCSI_MAX_SG_SEGMENTS)
 		return;
 	__sg_free_table(&sdb->table, SCSI_MAX_SG_SEGMENTS, mq, scsi_sg_free);
 }
@@ -597,8 +597,8 @@ static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents, bool mq)
 
 	if (mq) {
 		if (nents <= SCSI_MAX_SG_SEGMENTS) {
-			sdb->table.nents = nents;
-			sg_init_table(sdb->table.sgl, sdb->table.nents);
+			sdb->table.nents = sdb->table.orig_nents = nents;
+			sg_init_table(sdb->table.sgl, nents);
 			return 0;
 		}
 		first_chunk = sdb->table.sgl;

From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/3] block: set rq->resid_len to blk_rq_bytes() on issue
Date: Tue, 19 May 2009 18:33:05 +0900
Message-ID: <1242725586-13142-3-git-send-email-tj@kernel.org>
References: <1242725586-13142-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1242725586-13142-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, zaitcev@
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

In commit c3a4d78c580de4edc9ef0f7c59812fb02ceb037f, while introducing
rq->resid_len, the default value of residue count was changed from
full count to zero.  The conversion was done under the assumption that
when a request fails residue count wasn't defined.  However, Boaz and
James pointed out that this wasn't true and the residue count should
be preserved for failed requests too.

This patchset restores the original behavior by setting rq->resid_len
to blk_rq_bytes(rq) on request start and restoring explicit clearing
in affected drivers.  While at it, take advantage of the fact that
rq->resid_len is set to full count where applicable.

* ide-cd: rq->resid_len cleared on pc success

* mptsas: req->resid_len cleared on success

* sas_expander: rsp/req->resid_len cleared on success

* mpt2sas_transport: req->resid_len cleared on success

* ide-cd, ide-tape, mptsas, sas_host_smp, mpt2sas_transport, ub: take
  advantage of initial full count to simplify code

Boaz Harrosh spotted bug in resid_len initialization.  Fixed as
suggested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Borislav Petkov <petkovbb@googlemail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Eric Moore <Eric.Moore@lsi.com>
Cc: Darrick J. Wong <djwong@us.ibm.com>
---
 block/blk-core.c                         |    5 +++--
 drivers/block/ub.c                       |    6 ++++--
 drivers/ide/ide-cd.c                     |    4 ++--
 drivers/ide/ide-tape.c                   |    2 +-
 drivers/message/fusion/mptsas.c          |    3 ++-
 drivers/scsi/libsas/sas_expander.c       |    4 ++++
 drivers/scsi/libsas/sas_host_smp.c       |    3 ---
 drivers/scsi/mpt2sas/mpt2sas_transport.c |    4 ++--
 8 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a2d97de..e3f7e6a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1783,9 +1783,10 @@ void blk_start_request(struct request *req)
 	blk_dequeue_request(req);
 
 	/*
-	 * We are now handing the request to the hardware, add the
-	 * timeout handler.
+	 * We are now handing the request to the hardware, initialize
+	 * resid_len to full count and add the timeout handler.
 	 */
+	req->resid_len = blk_rq_bytes(req);
 	blk_add_timer(req);
 }
 EXPORT_SYMBOL(blk_start_request);
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index f32781c..e67bbae 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -781,8 +781,10 @@ static void ub_rw_cmd_done(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
 
 	if (cmd->error == 0) {
 		if (blk_pc_request(rq)) {
-			if (cmd->act_len < blk_rq_bytes(rq))
-				rq->resid_len = blk_rq_bytes(rq) - cmd->act_len;
+			if (cmd->act_len >= rq->resid_len)
+				rq->resid_len = 0;
+			else
+				rq->resid_len -= cmd->act_len;
 			scsi_status = 0;
 		} else {
 			if (cmd->act_len != cmd->len) {
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 4c7792f..081aed6 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -699,6 +699,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 
 out_end:
 	if (blk_pc_request(rq) && rc == 0) {
+		rq->resid_len = 0;
 		blk_end_request_all(rq, 0);
 		hwif->rq = NULL;
 	} else {
@@ -718,8 +719,7 @@ out_end:
 
 		/* make sure it's fully ended */
 		if (blk_fs_request(rq) == 0) {
-			rq->resid_len = blk_rq_bytes(rq) -
-				(cmd->nbytes - cmd->nleft);
+			rq->resid_len -= cmd->nbytes - cmd->nleft;
 			if (uptodate == 0 && (cmd->tf_flags & IDE_TFLAG_WRITE))
 				rq->resid_len += cmd->last_xfer_len;
 		}
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index e166045..683ff37 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -380,7 +380,7 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 		}
 
 		tape->first_frame += blocks;
-		rq->resid_len = blk_rq_bytes(rq) - blocks * tape->blk_size;
+		rq->resid_len -= blocks * tape->blk_size;
 
 		if (pc->error) {
 			uptodate = 0;
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 4e6fcf0..79f5433 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1357,7 +1357,8 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
 		memcpy(req->sense, smprep, sizeof(*smprep));
 		req->sense_len = sizeof(*smprep);
-		rsp->resid_len = blk_rq_bytes(rsp) - smprep->ResponseDataLength;
+		req->resid_len = 0;
+		rsp->resid_len -= smprep->ResponseDataLength;
 	} else {
 		printk(MYIOC_s_ERR_FMT "%s: smp passthru reply failed to be returned\n",
 		    ioc->name, __func__);
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 531af9e..54fa1e4 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1937,7 +1937,11 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	if (ret > 0) {
 		/* positive number is the untransferred residual */
 		rsp->resid_len = ret;
+		req->resid_len = 0;
 		ret = 0;
+	} else if (ret == 0) {
+		rsp->resid_len = 0;
+		req->resid_len = 0;
 	}
 
 	return ret;
diff --git a/drivers/scsi/libsas/sas_host_smp.c b/drivers/scsi/libsas/sas_host_smp.c
index be9a951..1bc3b75 100644
--- a/drivers/scsi/libsas/sas_host_smp.c
+++ b/drivers/scsi/libsas/sas_host_smp.c
@@ -176,9 +176,6 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 	resp_data[1] = req_data[1];
 	resp_data[2] = SMP_RESP_FUNC_UNK;
 
-	req->resid_len = blk_rq_bytes(req);
-	rsp->resid_len = blk_rq_bytes(rsp);
-
 	switch (req_data[1]) {
 	case SMP_REPORT_GENERAL:
 		req->resid_len -= 8;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index af95a44..5c65da5 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -1170,8 +1170,8 @@ transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 		memcpy(req->sense, mpi_reply, sizeof(*mpi_reply));
 		req->sense_len = sizeof(*mpi_reply);
-		rsp->resid_len = blk_rq_bytes(rsp) -
-				 mpi_reply->ResponseDataLength;
+		req->resid_len = 0;
+		rsp->resid_len -= mpi_reply->ResponseDataLength;
 	} else {
 		dtransportprintk(ioc, printk(MPT2SAS_DEBUG_FMT
 		    "%s - no reply\n", ioc->name, __func__));
-- 
1.6.0.2


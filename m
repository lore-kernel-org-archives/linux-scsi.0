From: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/3] BNX2FC: Fixed the handling for the SCSI
	retry delay
Date: Wed, 11 Dec 2013 15:30:22 -0800
Message-ID: <1386804623-22376-2-git-send-email-eddie.wai@broadcom.com>
References: <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: fcoe-devel <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

SCSI retry delay upon SAM_STAT_BUSY/_SET_FULL was not being handled
in bnx2fc.  This patch adds such handling by returning TARGET_BUSY
to the SCSI ML for the corresponding LUN until the retry timer expires.

Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/bnx2fc/bnx2fc.h     |    1 +
 drivers/scsi/bnx2fc/bnx2fc_io.c  |   19 ++++++++++++++++++-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c |    1 +
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 1ebf3fb..2e984e3 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -367,6 +367,7 @@ struct bnx2fc_rport {
 	atomic_t num_active_ios;
 	u32 flush_in_prog;
 	unsigned long timestamp;
+	unsigned long retry_delay_timestamp;
 	struct list_head free_task_list;
 	struct bnx2fc_cmd *pending_queue[BNX2FC_SQ_WQES_MAX+1];
 	struct list_head active_cmd_queue;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index ed88089..d2cabc9 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1871,7 +1871,15 @@ int bnx2fc_queuecommand(struct Scsi_Host *host,
 		rc = SCSI_MLQUEUE_TARGET_BUSY;
 		goto exit_qcmd;
 	}
-
+	if (tgt->retry_delay_timestamp) {
+		if (time_after(jiffies, tgt->retry_delay_timestamp)) {
+			tgt->retry_delay_timestamp = 0;
+		} else {
+			/* If retry_delay timer is active, flow off the ML */
+			rc = SCSI_MLQUEUE_TARGET_BUSY;
+			goto exit_qcmd;
+		}
+	}
 	io_req = bnx2fc_cmd_alloc(tgt);
 	if (!io_req) {
 		rc = SCSI_MLQUEUE_HOST_BUSY;
@@ -1961,6 +1969,15 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 				 " fcp_resid = 0x%x\n",
 				io_req->cdb_status, io_req->fcp_resid);
 			sc_cmd->result = (DID_OK << 16) | io_req->cdb_status;
+
+			if (io_req->cdb_status == SAM_STAT_TASK_SET_FULL ||
+			    io_req->cdb_status == SAM_STAT_BUSY) {
+				/* Set the jiffies + retry_delay_timer * 100ms
+				   for the rport/tgt */
+				tgt->retry_delay_timestamp = jiffies +
+					fcp_rsp->retry_delay_timer * HZ / 10;
+			}
+
 		}
 		if (io_req->fcp_resid)
 			scsi_set_resid(sc_cmd, io_req->fcp_resid);
diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index 4d93177..68948b7 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -386,6 +386,7 @@ static int bnx2fc_init_tgt(struct bnx2fc_rport *tgt,
 	tgt->rq_prod_idx = 0x8000;
 	tgt->rq_cons_idx = 0;
 	atomic_set(&tgt->num_active_ios, 0);
+	tgt->retry_delay_timestamp = 0;
 
 	if (rdata->flags & FC_RP_FLAGS_RETRY &&
 	    rdata->ids.roles & FC_RPORT_ROLE_FCP_TARGET &&
-- 
1.7.1

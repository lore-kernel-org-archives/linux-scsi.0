From: "Bhanu Prakash Gollapudi" <bprakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 11/12] bnx2fc: Tx BDs cache in write tasks
Date: Mon, 27 Jun 2011 23:31:03 -0700
Message-ID: <1309242664-27252-12-git-send-email-bprakash@broadcom.com>
References: <1309242664-27252-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1309242664-27252-1-git-send-email-bprakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.open-fcoe.org/mailman/options/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

When there is a single BD for the entire data to be transmitted, use the BD
inside the SGL context and set the cached SGE indication in the task context

Signed-off-by: Bhanu Prakash Gollapudi <bprakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c |   29 ++++++++++++++++++++++-------
 1 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 357a63d..ec89359 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -1711,18 +1711,33 @@ void bnx2fc_init_task(struct bnx2fc_cmd *io_req,
 		task_type = FCOE_TASK_TYPE_READ;
 
 	/* Tx only */
+	bd_count = bd_tbl->bd_valid;
 	if (task_type == FCOE_TASK_TYPE_WRITE) {
-		task->txwr_only.sgl_ctx.sgl.mul_sgl.cur_sge_addr.lo =
-				(u32)bd_tbl->bd_tbl_dma;
-		task->txwr_only.sgl_ctx.sgl.mul_sgl.cur_sge_addr.hi =
-				(u32)((u64)bd_tbl->bd_tbl_dma >> 32);
-		task->txwr_only.sgl_ctx.sgl.mul_sgl.sgl_size =
-				bd_tbl->bd_valid;
+		if ((dev_type == TYPE_DISK) && (bd_count == 1)) {
+			struct fcoe_bd_ctx *fcoe_bd_tbl = bd_tbl->bd_tbl;
+
+			task->txwr_only.sgl_ctx.cached_sge.cur_buf_addr.lo =
+					fcoe_bd_tbl->buf_addr_lo;
+			task->txwr_only.sgl_ctx.cached_sge.cur_buf_addr.hi =
+					fcoe_bd_tbl->buf_addr_hi;
+			task->txwr_only.sgl_ctx.cached_sge.cur_buf_rem =
+					fcoe_bd_tbl->buf_len;
+
+			task->txwr_rxrd.const_ctx.init_flags |= 1 <<
+				FCOE_TCE_TX_WR_RX_RD_CONST_CACHED_SGE_SHIFT;
+		} else {
+			task->txwr_only.sgl_ctx.sgl.mul_sgl.cur_sge_addr.lo =
+					(u32)bd_tbl->bd_tbl_dma;
+			task->txwr_only.sgl_ctx.sgl.mul_sgl.cur_sge_addr.hi =
+					(u32)((u64)bd_tbl->bd_tbl_dma >> 32);
+			task->txwr_only.sgl_ctx.sgl.mul_sgl.sgl_size =
+					bd_tbl->bd_valid;
+		}
 	}
 
 	/*Tx Write Rx Read */
 	/* Init state to NORMAL */
-	task->txwr_rxrd.const_ctx.init_flags = task_type <<
+	task->txwr_rxrd.const_ctx.init_flags |= task_type <<
 				FCOE_TCE_TX_WR_RX_RD_CONST_TASK_TYPE_SHIFT;
 	if (dev_type == TYPE_TAPE)
 		task->txwr_rxrd.const_ctx.init_flags |=
-- 
1.7.0.6

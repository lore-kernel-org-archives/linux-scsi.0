From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] qla2xxx: remove stub qlt_check_srr_debug()
Date: Sat, 24 May 2014 16:03:12 +0200
Message-ID: <1400940192.22523.59.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

qlt_check_srr_debug() was added in v3.5. It is a stub function unless
CONFIG_QLA_TGT_DEBUG_SRR is defined. But CONFIG_QLA_TGT_DEBUG_SRR will
never be defined, because the Kconfig symbol QLA_TGT_DEBUG_SRR was never
added to the tree.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested.

Or was it intended for this to set it by hand? In that case: please drop
the CONFIG_ prefix, and, perhaps add a comment about its purpose.

 drivers/scsi/qla2xxx/qla_target.c | 90 ---------------------------------------
 1 file changed, 90 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 0cb73074c199..9729411faf45 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1747,95 +1747,6 @@ static inline int qlt_need_explicit_conf(struct qla_hw_data *ha,
 		    cmd->conf_compl_supported;
 }
 
-#ifdef CONFIG_QLA_TGT_DEBUG_SRR
-/*
- *  Original taken from the XFS code
- */
-static unsigned long qlt_srr_random(void)
-{
-	static int Inited;
-	static unsigned long RandomValue;
-	static DEFINE_SPINLOCK(lock);
-	/* cycles pseudo-randomly through all values between 1 and 2^31 - 2 */
-	register long rv;
-	register long lo;
-	register long hi;
-	unsigned long flags;
-
-	spin_lock_irqsave(&lock, flags);
-	if (!Inited) {
-		RandomValue = jiffies;
-		Inited = 1;
-	}
-	rv = RandomValue;
-	hi = rv / 127773;
-	lo = rv % 127773;
-	rv = 16807 * lo - 2836 * hi;
-	if (rv <= 0)
-		rv += 2147483647;
-	RandomValue = rv;
-	spin_unlock_irqrestore(&lock, flags);
-	return rv;
-}
-
-static void qlt_check_srr_debug(struct qla_tgt_cmd *cmd, int *xmit_type)
-{
-#if 0 /* This is not a real status packets lost, so it won't lead to SRR */
-	if ((*xmit_type & QLA_TGT_XMIT_STATUS) && (qlt_srr_random() % 200)
-	    == 50) {
-		*xmit_type &= ~QLA_TGT_XMIT_STATUS;
-		ql_dbg(ql_dbg_tgt_mgt, cmd->vha, 0xf015,
-		    "Dropping cmd %p (tag %d) status", cmd, cmd->tag);
-	}
-#endif
-	/*
-	 * It's currently not possible to simulate SRRs for FCP_WRITE without
-	 * a physical link layer failure, so don't even try here..
-	 */
-	if (cmd->dma_data_direction != DMA_FROM_DEVICE)
-		return;
-
-	if (qlt_has_data(cmd) && (cmd->sg_cnt > 1) &&
-	    ((qlt_srr_random() % 100) == 20)) {
-		int i, leave = 0;
-		unsigned int tot_len = 0;
-
-		while (leave == 0)
-			leave = qlt_srr_random() % cmd->sg_cnt;
-
-		for (i = 0; i < leave; i++)
-			tot_len += cmd->sg[i].length;
-
-		ql_dbg(ql_dbg_tgt_mgt, cmd->vha, 0xf016,
-		    "Cutting cmd %p (tag %d) buffer"
-		    " tail to len %d, sg_cnt %d (cmd->bufflen %d,"
-		    " cmd->sg_cnt %d)", cmd, cmd->tag, tot_len, leave,
-		    cmd->bufflen, cmd->sg_cnt);
-
-		cmd->bufflen = tot_len;
-		cmd->sg_cnt = leave;
-	}
-
-	if (qlt_has_data(cmd) && ((qlt_srr_random() % 100) == 70)) {
-		unsigned int offset = qlt_srr_random() % cmd->bufflen;
-
-		ql_dbg(ql_dbg_tgt_mgt, cmd->vha, 0xf017,
-		    "Cutting cmd %p (tag %d) buffer head "
-		    "to offset %d (cmd->bufflen %d)", cmd, cmd->tag, offset,
-		    cmd->bufflen);
-		if (offset == 0)
-			*xmit_type &= ~QLA_TGT_XMIT_DATA;
-		else if (qlt_set_data_offset(cmd, offset)) {
-			ql_dbg(ql_dbg_tgt_mgt, cmd->vha, 0xf018,
-			    "qlt_set_data_offset() failed (tag %d)", cmd->tag);
-		}
-	}
-}
-#else
-static inline void qlt_check_srr_debug(struct qla_tgt_cmd *cmd, int *xmit_type)
-{}
-#endif
-
 static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	struct qla_tgt_prm *prm)
 {
@@ -1918,7 +1829,6 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	int res;
 
 	memset(&prm, 0, sizeof(prm));
-	qlt_check_srr_debug(cmd, &xmit_type);
 
 	ql_dbg(ql_dbg_tgt, cmd->vha, 0xe018,
 	    "is_send_status=%d, cmd->bufflen=%d, cmd->sg_cnt=%d, "
-- 
1.9.0

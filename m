From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] tcm_fc: move the dereference below the NULL test
Date: Fri, 7 Sep 2012 14:55:32 +0800
Message-ID: <CAPgLHd88a_SPmNfjC=kWAwgC29XdbafzumA1iBQ7aYsGs+tnMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/target/tcm_fc/tfc_io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index ad36ede1..1b367a9 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -328,11 +328,12 @@ drop:
  */
 void ft_invl_hw_context(struct ft_cmd *cmd)
 {
-	struct fc_seq *seq = cmd->seq;
+	struct fc_seq *seq;
 	struct fc_exch *ep = NULL;
 	struct fc_lport *lport = NULL;
 
 	BUG_ON(!cmd);
+	seq = cmd->seq;
 
 	/* Cleanup the DDP context in HW if DDP was setup */
 	if (cmd->was_ddp_setup && seq) {

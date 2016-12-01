From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH scsi 1/3] scsi: cxgb4i: use cxgb4_tp_smt_idx() to get smt_idx
Date: Thu,  1 Dec 2016 20:28:27 +0530
Message-ID: <1b69fea63b061d81ee1687a8e238f206ebbf3661.1480603332.git.varun@chelsio.com>
References: <cover.1480603332.git.varun@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1480603332.git.varun@chelsio.com>
In-Reply-To: <cover.1480603332.git.varun@chelsio.com>
References: <cover.1480603332.git.varun@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net, indranil@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

cxgb4_tp_smt_idx() is defined in cxgb4 driver, it returns
smt_idx for T4,T5,T6 adapters.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 0039beb..90522d4 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1451,8 +1451,8 @@ static int init_act_open(struct cxgbi_sock *csk)
 		csk->mtu = dst_mtu(csk->dst);
 	cxgb4_best_mtu(lldi->mtus, csk->mtu, &csk->mss_idx);
 	csk->tx_chan = cxgb4_port_chan(ndev);
-	/* SMT two entries per row */
-	csk->smac_idx = ((cxgb4_port_viid(ndev) & 0x7F)) << 1;
+	csk->smac_idx = cxgb4_tp_smt_idx(lldi->adapter_type,
+					 cxgb4_port_viid(ndev));
 	step = lldi->ntxq / lldi->nchan;
 	csk->txq_idx = cxgb4_port_idx(ndev) * step;
 	step = lldi->nrxq / lldi->nchan;
-- 
2.0.2

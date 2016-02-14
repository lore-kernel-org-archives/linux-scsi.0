From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 08/34] cxgb4: update struct cxgb4_lld_info definition
Date: Sun, 14 Feb 2016 23:07:39 +0530
Message-ID: <ac838ef86255b93074334a6b5af25f1dbd87b8be.1455467089.git.varun@chelsio.com>
References: <2e4101f9c306049896ffff513b575e3ba61f93d9.1455467089.git.varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:53024 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751680AbcBNRiH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Feb 2016 12:38:07 -0500
In-Reply-To: <2e4101f9c306049896ffff513b575e3ba61f93d9.1455467089.git.varun@chelsio.com>
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, davem@davemloft.net, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com

add members for iSCSI DDP.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h      | 2 ++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 4 ++++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h  | 4 ++++
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 92086a0..646076e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -759,6 +759,8 @@ struct adapter {
 	struct list_head list_node;
 	struct list_head rcu_node;
 
+	void *iscsi_ppm;
+
 	struct tid_info tids;
 	void **tid_release_head;
 	spinlock_t tid_release_lock;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 050f215..1a1f1c8 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -2457,6 +2457,10 @@ static void uld_attach(struct adapter *adap, unsigned int uld)
 	lli.wr_cred = adap->params.ofldq_wr_cred;
 	lli.adapter_type = adap->params.chip;
 	lli.iscsi_iolen = MAXRXDATA_G(t4_read_reg(adap, TP_PARA_REG2_A));
+	lli.iscsi_tagmask = t4_read_reg(adap, ULP_RX_ISCSI_TAGMASK_A);
+	lli.iscsi_pgsz_order = t4_read_reg(adap, ULP_RX_ISCSI_PSZ_A);
+	lli.iscsi_llimit = t4_read_reg(adap, ULP_RX_ISCSI_LLIMIT_A);
+	lli.iscsi_ppm = &adap->iscsi_ppm;
 	lli.cclk_ps = 1000000000 / adap->params.vpd.cclk;
 	lli.udb_density = 1 << adap->params.sge.eq_qpp;
 	lli.ucq_density = 1 << adap->params.sge.iq_qpp;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index d97a81f..f3c58aa 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -275,6 +275,10 @@ struct cxgb4_lld_info {
 	unsigned int max_ordird_qp;          /* Max ORD/IRD depth per RDMA QP */
 	unsigned int max_ird_adapter;        /* Max IRD memory per adapter */
 	bool ulptx_memwrite_dsgl;            /* use of T5 DSGL allowed */
+	unsigned int iscsi_tagmask;	     /* iscsi ddp tag mask */
+	unsigned int iscsi_pgsz_order;	     /* iscsi ddp page size orders */
+	unsigned int iscsi_llimit;	     /* chip's iscsi region llimit */
+	void **iscsi_ppm;		     /* iscsi page pod manager */
 	int nodeid;			     /* device numa node id */
 };
 
-- 
2.0.2


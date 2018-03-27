From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] qed*: qed_cm_init_pf() can be static
Date: Tue, 27 Mar 2018 12:48:14 +0800
Message-ID: <20180327044814.GA75596@lkp-sb-ep06>
References: <1522083732-26560-1-git-send-email-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1522083732-26560-1-git-send-email-Michal.Kalderon@cavium.com>
Sender: netdev-owner@vger.kernel.org
To: Michal Kalderon <Michal.Kalderon@cavium.com>
Cc: kbuild-all@01.org, michal.kalderon@cavium.com, davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Tomer Tayar <Tomer.Tayar@cavium.com>, Manish Rangankar <Manish.Rangankar@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>
List-Id: linux-scsi@vger.kernel.org


Fixes: cda33d25b808 ("qed*: Utilize FW 8.33.11.0")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 qed_cxt.c           |    2 +-
 qed_dcbx.c          |    2 +-
 qed_dev.c           |   12 ++++++------
 qed_init_fw_funcs.c |    2 +-
 qed_iscsi.c         |    4 ++--
 qed_iwarp.c         |   18 +++++++++---------
 qed_ll2.c           |    4 ++--
 qed_mcp.c           |    2 +-
 qed_rdma.c          |    4 ++--
 qed_roce.c          |    2 +-
 qed_sriov.c         |    8 ++++----
 qed_vf.c            |    2 +-
 12 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index 00f41c1..1695c90 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -1531,7 +1531,7 @@ void qed_qm_init_pf(struct qed_hwfn *p_hwfn,
 }
 
 /* CM PF */
-void qed_cm_init_pf(struct qed_hwfn *p_hwfn)
+static void qed_cm_init_pf(struct qed_hwfn *p_hwfn)
 {
 	/* XCM pure-LB queue */
 	STORE_RT_REG(p_hwfn, XCM_REG_CON_PHY_Q3_RT_OFFSET,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c b/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
index 449777f..456b8d1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
@@ -860,7 +860,7 @@ static int qed_dcbx_read_mib(struct qed_hwfn *p_hwfn,
 	return rc;
 }
 
-void qed_dcbx_aen(struct qed_hwfn *hwfn, u32 mib_type)
+static void qed_dcbx_aen(struct qed_hwfn *hwfn, u32 mib_type)
 {
 	struct qed_common_cb_ops *op = hwfn->cdev->protocol_ops.common;
 	void *cookie = hwfn->cdev->ops_cookie;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index de5527c..0daef44 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -230,12 +230,12 @@ static u32 qed_get_pq_flags(struct qed_hwfn *p_hwfn)
 }
 
 /* Getters for resource amounts necessary for qm initialization */
-u8 qed_init_qm_get_num_tcs(struct qed_hwfn *p_hwfn)
+static u8 qed_init_qm_get_num_tcs(struct qed_hwfn *p_hwfn)
 {
 	return p_hwfn->hw_info.num_hw_tc;
 }
 
-u16 qed_init_qm_get_num_vfs(struct qed_hwfn *p_hwfn)
+static u16 qed_init_qm_get_num_vfs(struct qed_hwfn *p_hwfn)
 {
 	return IS_QED_SRIOV(p_hwfn->cdev) ?
 	       p_hwfn->cdev->p_iov_info->total_vfs : 0;
@@ -243,7 +243,7 @@ u16 qed_init_qm_get_num_vfs(struct qed_hwfn *p_hwfn)
 
 #define NUM_DEFAULT_RLS 1
 
-u16 qed_init_qm_get_num_pf_rls(struct qed_hwfn *p_hwfn)
+static u16 qed_init_qm_get_num_pf_rls(struct qed_hwfn *p_hwfn)
 {
 	u16 num_pf_rls, num_vfs = qed_init_qm_get_num_vfs(p_hwfn);
 
@@ -261,7 +261,7 @@ u16 qed_init_qm_get_num_pf_rls(struct qed_hwfn *p_hwfn)
 	return num_pf_rls;
 }
 
-u16 qed_init_qm_get_num_vports(struct qed_hwfn *p_hwfn)
+static u16 qed_init_qm_get_num_vports(struct qed_hwfn *p_hwfn)
 {
 	u32 pq_flags = qed_get_pq_flags(p_hwfn);
 
@@ -273,7 +273,7 @@ u16 qed_init_qm_get_num_vports(struct qed_hwfn *p_hwfn)
 }
 
 /* calc amount of PQs according to the requested flags */
-u16 qed_init_qm_get_num_pqs(struct qed_hwfn *p_hwfn)
+static u16 qed_init_qm_get_num_pqs(struct qed_hwfn *p_hwfn)
 {
 	u32 pq_flags = qed_get_pq_flags(p_hwfn);
 
@@ -507,7 +507,7 @@ u16 qed_get_cm_pq_idx_vf(struct qed_hwfn *p_hwfn, u16 vf)
 	return qed_get_cm_pq_idx(p_hwfn, PQ_FLAGS_VFS) + vf;
 }
 
-u16 qed_get_cm_pq_idx_rl(struct qed_hwfn *p_hwfn, u8 rl)
+static u16 qed_get_cm_pq_idx_rl(struct qed_hwfn *p_hwfn, u8 rl)
 {
 	u16 max_rl = qed_init_qm_get_num_pf_rls(p_hwfn);
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
index 1365da7..b296b78 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
@@ -1225,7 +1225,7 @@ void qed_gft_disable(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt, u16 pf_id)
 	       0);
 }
 
-void qed_set_gft_event_id_cm_hdr(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
+static void qed_set_gft_event_id_cm_hdr(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 {
 	u32 rfs_cm_hdr_event_id;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
index c0d4a54..1135387 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
@@ -873,8 +873,8 @@ static void qed_iscsi_release_connection(struct qed_hwfn *p_hwfn,
 	spin_unlock_bh(&p_hwfn->p_iscsi_info->lock);
 }
 
-void qed_iscsi_free_connection(struct qed_hwfn *p_hwfn,
-			       struct qed_iscsi_conn *p_conn)
+static void qed_iscsi_free_connection(struct qed_hwfn *p_hwfn,
+				      struct qed_iscsi_conn *p_conn)
 {
 	qed_chain_free(p_hwfn->cdev, &p_conn->xhq);
 	qed_chain_free(p_hwfn->cdev, &p_conn->uhq);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index 2a2b101..7b292ec 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -375,7 +375,7 @@ qed_iwarp2roce_state(enum qed_iwarp_qp_state state)
 	}
 }
 
-const char *iwarp_state_names[] = {
+static const char *iwarp_state_names[] = {
 	"IDLE",
 	"RTS",
 	"TERMINATE",
@@ -940,7 +940,7 @@ qed_iwarp_return_ep(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 	spin_unlock_bh(&p_hwfn->p_rdma_info->iwarp.iw_lock);
 }
 
-void
+static void
 qed_iwarp_parse_private_data(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 {
 	struct mpa_v2_hdr *mpa_v2_params;
@@ -965,7 +965,7 @@ qed_iwarp_parse_private_data(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 				       mpa_data_size;
 }
 
-void
+static void
 qed_iwarp_mpa_reply_arrived(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 {
 	struct qed_iwarp_cm_event_params params;
@@ -2507,7 +2507,7 @@ static void qed_iwarp_ll2_rel_tx_pkt(void *cxt, u8 connection_handle,
 /* The only slowpath for iwarp ll2 is unalign flush. When this completion
  * is received, need to reset the FPDU.
  */
-void
+static void
 qed_iwarp_ll2_slowpath(void *cxt,
 		       u8 connection_handle,
 		       u32 opaque_data_0, u32 opaque_data_1)
@@ -2810,8 +2810,8 @@ int qed_iwarp_stop(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	return qed_iwarp_ll2_stop(p_hwfn, p_ptt);
 }
 
-void qed_iwarp_qp_in_error(struct qed_hwfn *p_hwfn,
-			   struct qed_iwarp_ep *ep, u8 fw_return_code)
+static void qed_iwarp_qp_in_error(struct qed_hwfn *p_hwfn,
+				  struct qed_iwarp_ep *ep, u8 fw_return_code)
 {
 	struct qed_iwarp_cm_event_params params;
 
@@ -2831,8 +2831,8 @@ void qed_iwarp_qp_in_error(struct qed_hwfn *p_hwfn,
 	ep->event_cb(ep->cb_context, &params);
 }
 
-void qed_iwarp_exception_received(struct qed_hwfn *p_hwfn,
-				  struct qed_iwarp_ep *ep, int fw_ret_code)
+static void qed_iwarp_exception_received(struct qed_hwfn *p_hwfn,
+					 struct qed_iwarp_ep *ep, int fw_ret_code)
 {
 	struct qed_iwarp_cm_event_params params;
 	bool event_cb = false;
@@ -2961,7 +2961,7 @@ qed_iwarp_tcp_connect_unsuccessful(struct qed_hwfn *p_hwfn,
 	}
 }
 
-void
+static void
 qed_iwarp_connect_complete(struct qed_hwfn *p_hwfn,
 			   struct qed_iwarp_ep *ep, u8 fw_return_code)
 {
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 74fc626..ff0556e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -158,7 +158,7 @@ static void qed_ll2_kill_buffers(struct qed_dev *cdev)
 		qed_ll2_dealloc_buffer(cdev, buffer);
 }
 
-void qed_ll2b_complete_rx_packet(void *cxt, struct qed_ll2_comp_rx_data *data)
+static void qed_ll2b_complete_rx_packet(void *cxt, struct qed_ll2_comp_rx_data *data)
 {
 	struct qed_hwfn *p_hwfn = cxt;
 	struct qed_ll2_buffer *buffer = data->cookie;
@@ -2123,7 +2123,7 @@ static void qed_ll2_register_cb_ops(struct qed_dev *cdev,
 	cdev->ll2->cb_cookie = cookie;
 }
 
-struct qed_ll2_cbs ll2_cbs = {
+static struct qed_ll2_cbs ll2_cbs = {
 	.rx_comp_cb = &qed_ll2b_complete_rx_packet,
 	.rx_release_cb = &qed_ll2b_release_rx_packet,
 	.tx_comp_cb = &qed_ll2b_complete_tx_packet,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 6f46cb1..a4141fa 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -2687,7 +2687,7 @@ static int qed_mcp_resource_cmd(struct qed_hwfn *p_hwfn,
 	return rc;
 }
 
-int
+static int
 __qed_mcp_resc_lock(struct qed_hwfn *p_hwfn,
 		    struct qed_ptt *p_ptt,
 		    struct qed_resc_lock_params *p_params)
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index a411f9c..a47cf6f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -134,7 +134,7 @@ static bool qed_bmap_is_empty(struct qed_bmap *bmap)
 	return bmap->max_count == find_first_bit(bmap->bitmap, bmap->max_count);
 }
 
-u32 qed_rdma_get_sb_id(void *p_hwfn, u32 rel_sb_id)
+static u32 qed_rdma_get_sb_id(void *p_hwfn, u32 rel_sb_id)
 {
 	/* First sb id for RoCE is after all the l2 sb */
 	return FEAT_NUM((struct qed_hwfn *)p_hwfn, QED_PF_L2_QUE) + rel_sb_id;
@@ -682,7 +682,7 @@ static int qed_rdma_setup(struct qed_hwfn *p_hwfn,
 	return qed_rdma_start_fw(p_hwfn, params, p_ptt);
 }
 
-int qed_rdma_stop(void *rdma_cxt)
+static int qed_rdma_stop(void *rdma_cxt)
 {
 	struct qed_hwfn *p_hwfn = (struct qed_hwfn *)rdma_cxt;
 	struct rdma_close_func_ramrod_data *p_ramrod;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
index fb7c2d1..db36e3b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -148,7 +148,7 @@ static enum roce_flavor qed_roce_mode_to_flavor(enum roce_mode roce_mode)
 	return flavor;
 }
 
-void qed_roce_free_cid_pair(struct qed_hwfn *p_hwfn, u16 cid)
+static void qed_roce_free_cid_pair(struct qed_hwfn *p_hwfn, u16 cid)
 {
 	spin_lock_bh(&p_hwfn->p_rdma_info->lock);
 	qed_bmap_release_id(p_hwfn, &p_hwfn->p_rdma_info->cid_map, cid);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index 5acb91b..8bab9af 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -672,8 +672,8 @@ int qed_iov_hw_info(struct qed_hwfn *p_hwfn)
 	return 0;
 }
 
-bool _qed_iov_pf_sanity_check(struct qed_hwfn *p_hwfn,
-			      int vfid, bool b_fail_malicious)
+static bool _qed_iov_pf_sanity_check(struct qed_hwfn *p_hwfn,
+				     int vfid, bool b_fail_malicious)
 {
 	/* Check PF supports sriov */
 	if (IS_VF(p_hwfn->cdev) || !IS_QED_SRIOV(p_hwfn->cdev) ||
@@ -687,7 +687,7 @@ bool _qed_iov_pf_sanity_check(struct qed_hwfn *p_hwfn,
 	return true;
 }
 
-bool qed_iov_pf_sanity_check(struct qed_hwfn *p_hwfn, int vfid)
+static bool qed_iov_pf_sanity_check(struct qed_hwfn *p_hwfn, int vfid)
 {
 	return _qed_iov_pf_sanity_check(p_hwfn, vfid, true);
 }
@@ -3925,7 +3925,7 @@ static void qed_iov_process_mbx_req(struct qed_hwfn *p_hwfn,
 	}
 }
 
-void qed_iov_pf_get_pending_events(struct qed_hwfn *p_hwfn, u64 *events)
+static void qed_iov_pf_get_pending_events(struct qed_hwfn *p_hwfn, u64 *events)
 {
 	int i;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_vf.c b/drivers/net/ethernet/qlogic/qed/qed_vf.c
index 91b5e9f..d83e38f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_vf.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_vf.c
@@ -169,7 +169,7 @@ static void qed_vf_pf_add_qid(struct qed_hwfn *p_hwfn,
 	p_qid_tlv->qid = p_cid->qid_usage_idx;
 }
 
-int _qed_vf_pf_release(struct qed_hwfn *p_hwfn, bool b_final)
+static int _qed_vf_pf_release(struct qed_hwfn *p_hwfn, bool b_final)
 {
 	struct qed_vf_iov *p_iov = p_hwfn->vf_iov_info;
 	struct pfvf_def_resp_tlv *resp;

From: michaelc@cs.wisc.edu
Subject: [PATCH 3/3] iscsi drivers: use libiscsi get stats fn
Date: Thu, 14 Jun 2012 23:15:47 -0500
Message-ID: <1339733747-14731-4-git-send-email-michaelc@cs.wisc.edu>
References: <1339733747-14731-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab2FOFFj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jun 2012 01:05:39 -0400
In-Reply-To: <1339733747-14731-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This moves the libiscsi_tcp stats function to libiscsi
and has the iscsi drivers use it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   17 +++------------
 drivers/scsi/be2iscsi/be_iscsi.c         |   29 ----------------------------
 drivers/scsi/be2iscsi/be_iscsi.h         |    3 --
 drivers/scsi/be2iscsi/be_main.c          |    2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c         |   31 +-----------------------------
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c       |    2 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c       |    2 +-
 drivers/scsi/cxgbi/libcxgbi.c            |   22 ---------------------
 drivers/scsi/cxgbi/libcxgbi.h            |    1 -
 drivers/scsi/iscsi_tcp.c                 |    2 +-
 drivers/scsi/libiscsi.c                  |   26 +++++++++++++++++++++++++
 drivers/scsi/libiscsi_tcp.c              |   17 ----------------
 include/scsi/libiscsi.h                  |    2 +
 include/scsi/libiscsi_tcp.h              |    2 -
 14 files changed, 37 insertions(+), 121 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 0ab8c9c..f490c21 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -512,24 +512,15 @@ iscsi_iser_conn_get_stats(struct iscsi_cls_conn *cls_conn, struct iscsi_stats *s
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 
-	stats->txdata_octets = conn->txdata_octets;
-	stats->rxdata_octets = conn->rxdata_octets;
-	stats->scsicmd_pdus = conn->scsicmd_pdus_cnt;
-	stats->dataout_pdus = conn->dataout_pdus_cnt;
-	stats->scsirsp_pdus = conn->scsirsp_pdus_cnt;
-	stats->datain_pdus = conn->datain_pdus_cnt; /* always 0 */
-	stats->r2t_pdus = conn->r2t_pdus_cnt; /* always 0 */
-	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
-	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
 	stats->custom_length = 4;
 	strcpy(stats->custom[0].desc, "qp_tx_queue_full");
 	stats->custom[0].value = 0; /* TB iser_conn->qp_tx_queue_full; */
 	strcpy(stats->custom[1].desc, "fmr_map_not_avail");
 	stats->custom[1].value = 0; /* TB iser_conn->fmr_map_not_avail */;
-	strcpy(stats->custom[2].desc, "eh_abort_cnt");
-	stats->custom[2].value = conn->eh_abort_cnt;
-	strcpy(stats->custom[3].desc, "fmr_unalign_cnt");
-	stats->custom[3].value = conn->fmr_unalign_cnt;
+	strcpy(stats->custom[2].desc, "fmr_unalign_cnt");
+	stats->custom[2].value = conn->fmr_unalign_cnt;
+
+	iscsi_conn_get_stats(cls_conn, stats);
 }
 
 static int iscsi_iser_get_ep_param(struct iscsi_endpoint *ep,
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 43f3503..85a7453 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -758,35 +758,6 @@ int beiscsi_get_macaddr(char *buf, struct beiscsi_hba *phba)
 }
 
 /**
- * beiscsi_conn_get_stats - get the iscsi stats
- * @cls_conn: pointer to iscsi cls conn
- * @stats: pointer to iscsi_stats structure
- *
- * returns iscsi stats
- */
-void beiscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn,
-			    struct iscsi_stats *stats)
-{
-	struct iscsi_conn *conn = cls_conn->dd_data;
-
-	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_get_stats\n");
-	stats->txdata_octets = conn->txdata_octets;
-	stats->rxdata_octets = conn->rxdata_octets;
-	stats->dataout_pdus = conn->dataout_pdus_cnt;
-	stats->scsirsp_pdus = conn->scsirsp_pdus_cnt;
-	stats->scsicmd_pdus = conn->scsicmd_pdus_cnt;
-	stats->datain_pdus = conn->datain_pdus_cnt;
-	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
-	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
-	stats->r2t_pdus = conn->r2t_pdus_cnt;
-	stats->digest_err = 0;
-	stats->timeout_err = 0;
-	stats->custom_length = 0;
-	strcpy(stats->custom[0].desc, "eh_abort_cnt");
-	stats->custom[0].value = conn->eh_abort_cnt;
-}
-
-/**
  * beiscsi_set_params_for_offld - get the parameters for offload
  * @beiscsi_conn: pointer to beiscsi_conn
  * @params: pointer to offload_params structure
diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
index 8b826fc..dd98606 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.h
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -85,7 +85,4 @@ int beiscsi_ep_poll(struct iscsi_endpoint *ep, int timeout_ms);
 
 void beiscsi_ep_disconnect(struct iscsi_endpoint *ep);
 
-void beiscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn,
-			    struct iscsi_stats *stats);
-
 #endif
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 0b1d99c..e67496c 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4517,7 +4517,7 @@ struct iscsi_transport beiscsi_iscsi_transport = {
 	.cleanup_task = beiscsi_cleanup_task,
 	.alloc_pdu = beiscsi_alloc_pdu,
 	.parse_pdu_itt = beiscsi_parse_pdu,
-	.get_stats = beiscsi_conn_get_stats,
+	.get_stats = iscsi_conn_get_stats,
 	.get_ep_param = beiscsi_ep_get_param,
 	.ep_connect = beiscsi_ep_connect,
 	.ep_poll = beiscsi_ep_poll,
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index f8d516b..e4add3b 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1611,35 +1611,6 @@ static int bnx2i_conn_start(struct iscsi_cls_conn *cls_conn)
 	return 0;
 }
 
-
-/**
- * bnx2i_conn_get_stats - returns iSCSI stats
- * @cls_conn:	pointer to iscsi cls conn
- * @stats:	pointer to iscsi statistic struct
- */
-static void bnx2i_conn_get_stats(struct iscsi_cls_conn *cls_conn,
-				 struct iscsi_stats *stats)
-{
-	struct iscsi_conn *conn = cls_conn->dd_data;
-
-	stats->txdata_octets = conn->txdata_octets;
-	stats->rxdata_octets = conn->rxdata_octets;
-	stats->scsicmd_pdus = conn->scsicmd_pdus_cnt;
-	stats->dataout_pdus = conn->dataout_pdus_cnt;
-	stats->scsirsp_pdus = conn->scsirsp_pdus_cnt;
-	stats->datain_pdus = conn->datain_pdus_cnt;
-	stats->r2t_pdus = conn->r2t_pdus_cnt;
-	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
-	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
-	stats->custom_length = 3;
-	strcpy(stats->custom[2].desc, "eh_abort_cnt");
-	stats->custom[2].value = conn->eh_abort_cnt;
-	stats->digest_err = 0;
-	stats->timeout_err = 0;
-	stats->custom_length = 0;
-}
-
-
 /**
  * bnx2i_check_route - checks if target IP route belongs to one of NX2 devices
  * @dst_addr:	target IP address
@@ -2275,7 +2246,7 @@ struct iscsi_transport bnx2i_iscsi_transport = {
 	.stop_conn		= iscsi_conn_stop,
 	.send_pdu		= iscsi_conn_send_pdu,
 	.xmit_task		= bnx2i_task_xmit,
-	.get_stats		= bnx2i_conn_get_stats,
+	.get_stats		= iscsi_conn_get_stats,
 	/* TCP connect - disconnect - option-2 interface calls */
 	.get_ep_param		= bnx2i_ep_get_param,
 	.ep_connect		= bnx2i_ep_connect,
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 36739da..52f9e9b 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -120,7 +120,7 @@ static struct iscsi_transport cxgb3i_iscsi_transport = {
 	.stop_conn	= iscsi_conn_stop,
 	.get_conn_param	= iscsi_conn_get_param,
 	.set_param	= cxgbi_set_conn_param,
-	.get_stats	= cxgbi_get_conn_stats,
+	.get_stats	= iscsi_conn_get_stats,
 	/* pdu xmit req from user space */
 	.send_pdu	= iscsi_conn_send_pdu,
 	/* task */
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 5a4a3bf..0f01665 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -121,7 +121,7 @@ static struct iscsi_transport cxgb4i_iscsi_transport = {
 	.stop_conn		= iscsi_conn_stop,
 	.get_conn_param	= iscsi_conn_get_param,
 	.set_param	= cxgbi_set_conn_param,
-	.get_stats	= cxgbi_get_conn_stats,
+	.get_stats	= iscsi_conn_get_stats,
 	/* pdu xmit req from user space */
 	.send_pdu	= iscsi_conn_send_pdu,
 	/* task */
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index d9253db..3be62c5 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2080,28 +2080,6 @@ void cxgbi_cleanup_task(struct iscsi_task *task)
 }
 EXPORT_SYMBOL_GPL(cxgbi_cleanup_task);
 
-void cxgbi_get_conn_stats(struct iscsi_cls_conn *cls_conn,
-				struct iscsi_stats *stats)
-{
-	struct iscsi_conn *conn = cls_conn->dd_data;
-
-	stats->txdata_octets = conn->txdata_octets;
-	stats->rxdata_octets = conn->rxdata_octets;
-	stats->scsicmd_pdus = conn->scsicmd_pdus_cnt;
-	stats->dataout_pdus = conn->dataout_pdus_cnt;
-	stats->scsirsp_pdus = conn->scsirsp_pdus_cnt;
-	stats->datain_pdus = conn->datain_pdus_cnt;
-	stats->r2t_pdus = conn->r2t_pdus_cnt;
-	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
-	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
-	stats->digest_err = 0;
-	stats->timeout_err = 0;
-	stats->custom_length = 1;
-	strcpy(stats->custom[0].desc, "eh_abort_cnt");
-	stats->custom[0].value = conn->eh_abort_cnt;
-}
-EXPORT_SYMBOL_GPL(cxgbi_get_conn_stats);
-
 static int cxgbi_conn_max_xmit_dlength(struct iscsi_conn *conn)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 80fa99b..ebcb75e 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -710,7 +710,6 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *);
 void cxgbi_cleanup_task(struct iscsi_task *task);
 
 umode_t cxgbi_attr_is_visible(int param_type, int param);
-void cxgbi_get_conn_stats(struct iscsi_cls_conn *, struct iscsi_stats *);
 int cxgbi_set_conn_param(struct iscsi_cls_conn *,
 			enum iscsi_param, char *, int);
 int cxgbi_get_ep_param(struct iscsi_endpoint *ep, enum iscsi_param, char *);
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 9220861..1eed3bc 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -795,7 +795,7 @@ iscsi_sw_tcp_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 	strcpy(stats->custom[2].desc, "eh_abort_cnt");
 	stats->custom[2].value = conn->eh_abort_cnt;
 
-	iscsi_tcp_conn_get_stats(cls_conn, stats);
+	iscsi_conn_get_stats(cls_conn, stats);
 }
 
 static struct iscsi_cls_session *
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index d134b40..f348478 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3494,6 +3494,32 @@ int iscsi_host_set_param(struct Scsi_Host *shost, enum iscsi_host_param param,
 }
 EXPORT_SYMBOL_GPL(iscsi_host_set_param);
 
+void iscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn,
+			  struct iscsi_stats *stats)
+{
+	struct iscsi_conn *conn = cls_conn->dd_data;
+	int next_custom = stats->custom_length + 1;
+
+	stats->digest_err = 0;
+	stats->timeout_err = 0;
+
+	stats->txdata_octets = conn->txdata_octets;
+	stats->rxdata_octets = conn->rxdata_octets;
+	stats->scsicmd_pdus = conn->scsicmd_pdus_cnt;
+	stats->scsirsp_pdus = conn->scsirsp_pdus_cnt;
+	stats->dataout_pdus = conn->dataout_pdus_cnt;
+	stats->datain_pdus = conn->datain_pdus_cnt;
+	stats->r2t_pdus = conn->r2t_pdus_cnt;
+	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
+	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
+	stats->noptx_pdus = conn->noptx_pdus;
+	stats->noprx_pdus = conn->noprx_pdus;
+
+	strcpy(stats->custom[next_custom].desc, "eh_abort_cnt");
+	stats->custom[next_custom].value = conn->eh_abort_cnt;
+}
+EXPORT_SYMBOL_GPL(iscsi_conn_get_stats);
+
 MODULE_AUTHOR("Mike Christie");
 MODULE_DESCRIPTION("iSCSI library functions");
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 552e8a2..ae15daf 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -1187,20 +1187,3 @@ int iscsi_tcp_set_max_r2t(struct iscsi_conn *conn, char *buf)
 	return iscsi_tcp_r2tpool_alloc(session);
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_set_max_r2t);
-
-void iscsi_tcp_conn_get_stats(struct iscsi_cls_conn *cls_conn,
-			      struct iscsi_stats *stats)
-{
-	struct iscsi_conn *conn = cls_conn->dd_data;
-
-	stats->txdata_octets = conn->txdata_octets;
-	stats->rxdata_octets = conn->rxdata_octets;
-	stats->scsicmd_pdus = conn->scsicmd_pdus_cnt;
-	stats->dataout_pdus = conn->dataout_pdus_cnt;
-	stats->scsirsp_pdus = conn->scsirsp_pdus_cnt;
-	stats->datain_pdus = conn->datain_pdus_cnt;
-	stats->r2t_pdus = conn->r2t_pdus_cnt;
-	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
-	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
-}
-EXPORT_SYMBOL_GPL(iscsi_tcp_conn_get_stats);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index b9ffcc5..dbf82f4 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -423,6 +423,8 @@ extern void __iscsi_put_task(struct iscsi_task *task);
 extern void __iscsi_get_task(struct iscsi_task *task);
 extern void iscsi_complete_scsi_task(struct iscsi_task *task,
 				     uint32_t exp_cmdsn, uint32_t max_cmdsn);
+extern void iscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn,
+				 struct iscsi_stats *stats);
 
 /*
  * generic helpers
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index 215469a..f128fb7 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -129,6 +129,4 @@ extern void iscsi_tcp_conn_teardown(struct iscsi_cls_conn *cls_conn);
 extern int iscsi_tcp_r2tpool_alloc(struct iscsi_session *session);
 extern void iscsi_tcp_r2tpool_free(struct iscsi_session *session);
 extern int iscsi_tcp_set_max_r2t(struct iscsi_conn *conn, char *buf);
-extern void iscsi_tcp_conn_get_stats(struct iscsi_cls_conn *cls_conn,
-				     struct iscsi_stats *stats);
 #endif /* LIBISCSI_TCP_H */
-- 
1.7.7.6


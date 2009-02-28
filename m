From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 2.6.29-rc6
Date: Sat, 28 Feb 2009 07:44:00 -0800
Message-ID: <1235835840.3468.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38821 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934AbZB1PoH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Feb 2009 10:44:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

We've got two serious bug fixes (abort command looping and missing sd
index lock), a small one (make mpt msi disable correct) a driver
enhancement (additional PCI ID for hptiop) and a slew of bug fix updates
for the chelsio iSCSI driver.

The patch is here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

HighPoint Linux Team (1):
      hptiop: Add new PCI device ID

James Bottomley (1):
      fix ABORTED_COMMAND looping forever problem

Karen Xie (6):
      cxgb3i: update the driver version to 1.0.1
      cxgb3i: Fix spelling errors in documentation
      cxgb3i: added missing include in cxgb3i_ddp.h
      cxgb3i: Outgoing pdus need to observe skb's MAX_SKB_FRAGS
      cxgb3i: added per-task data to track transmit progress
      cxgb3i: transmit work-request fixes

Tejun Heo (1):
      sd: revive sd_index_lock

Yinghai Lu (1):
      mpt: fix disable lsi sas to use msi as default

The diffstat:

 drivers/message/fusion/mptbase.c     |    4 
 drivers/scsi/cxgb3i/cxgb3i.h         |   21 ++
 drivers/scsi/cxgb3i/cxgb3i_ddp.c     |   19 +-
 drivers/scsi/cxgb3i/cxgb3i_ddp.h     |    5 
 drivers/scsi/cxgb3i/cxgb3i_init.c    |    4 
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c   |   22 +-
 drivers/scsi/cxgb3i/cxgb3i_offload.c |  146 +++++++++++++-----
 drivers/scsi/cxgb3i/cxgb3i_offload.h |   29 ++-
 drivers/scsi/cxgb3i/cxgb3i_pdu.c     |  275 +++++++++++++++++++++++------------
 drivers/scsi/cxgb3i/cxgb3i_pdu.h     |    2 
 drivers/scsi/hptiop.c                |    1 
 drivers/scsi/scsi_lib.c              |    5 
 drivers/scsi/sd.c                    |    7 
 14 files changed, 371 insertions(+), 180 deletions(-)

The full diff is below

James

---

diff --git a/Documentation/scsi/cxgb3i.txt b/Documentation/scsi/cxgb3i.txt
index 8141fa0..7ac8032 100644
--- a/Documentation/scsi/cxgb3i.txt
+++ b/Documentation/scsi/cxgb3i.txt
@@ -4,7 +4,7 @@ Introduction
 ============
 
 The Chelsio T3 ASIC based Adapters (S310, S320, S302, S304, Mezz cards, etc.
-series of products) supports iSCSI acceleration and iSCSI Direct Data Placement
+series of products) support iSCSI acceleration and iSCSI Direct Data Placement
 (DDP) where the hardware handles the expensive byte touching operations, such
 as CRC computation and verification, and direct DMA to the final host memory
 destination:
@@ -31,9 +31,9 @@ destination:
 	  the TCP segments onto the wire. It handles TCP retransmission if
 	  needed.
 
-	  On receving, S3 h/w recovers the iSCSI PDU by reassembling TCP
+	  On receiving, S3 h/w recovers the iSCSI PDU by reassembling TCP
 	  segments, separating the header and data, calculating and verifying
-	  the digests, then forwards the header to the host. The payload data,
+	  the digests, then forwarding the header to the host. The payload data,
 	  if possible, will be directly placed into the pre-posted host DDP
 	  buffer. Otherwise, the payload data will be sent to the host too.
 
@@ -68,9 +68,8 @@ The following steps need to be taken to accelerates the open-iscsi initiator:
 	sure the ip address is unique in the network.
 
 3. edit /etc/iscsi/iscsid.conf
-   The default setting for MaxRecvDataSegmentLength (131072) is too big,
-   replace "node.conn[0].iscsi.MaxRecvDataSegmentLength" to be a value no
-   bigger than 15360 (for example 8192):
+   The default setting for MaxRecvDataSegmentLength (131072) is too big;
+   replace with a value no bigger than 15360 (for example 8192):
 
 	node.conn[0].iscsi.MaxRecvDataSegmentLength = 8192
 
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 96ac883..ea3aafb 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -91,9 +91,9 @@ MODULE_PARM_DESC(mpt_msi_enable_fc, " Enable MSI Support for FC \
 		controllers (default=0)");
 
 static int mpt_msi_enable_sas;
-module_param(mpt_msi_enable_sas, int, 1);
+module_param(mpt_msi_enable_sas, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable_sas, " Enable MSI Support for SAS \
-		controllers (default=1)");
+		controllers (default=0)");
 
 
 static int mpt_channel_mapping;
diff --git a/drivers/scsi/cxgb3i/cxgb3i.h b/drivers/scsi/cxgb3i/cxgb3i.h
index fde6e4c..a7cf550 100644
--- a/drivers/scsi/cxgb3i/cxgb3i.h
+++ b/drivers/scsi/cxgb3i/cxgb3i.h
@@ -20,6 +20,7 @@
 #include <linux/list.h>
 #include <linux/netdevice.h>
 #include <linux/scatterlist.h>
+#include <linux/skbuff.h>
 #include <scsi/libiscsi_tcp.h>
 
 /* from cxgb3 LLD */
@@ -113,6 +114,26 @@ struct cxgb3i_endpoint {
 	struct cxgb3i_conn *cconn;
 };
 
+/**
+ * struct cxgb3i_task_data - private iscsi task data
+ *
+ * @nr_frags:	# of coalesced page frags (from scsi sgl)
+ * @frags:	coalesced page frags (from scsi sgl)
+ * @skb:	tx pdu skb
+ * @offset:	data offset for the next pdu
+ * @count:	max. possible pdu payload
+ * @sgoffset:	offset to the first sg entry for a given offset
+ */
+#define MAX_PDU_FRAGS	((ULP2_MAX_PDU_PAYLOAD + 512 - 1) / 512)
+struct cxgb3i_task_data {
+	unsigned short nr_frags;
+	skb_frag_t frags[MAX_PDU_FRAGS];
+	struct sk_buff *skb;
+	unsigned int offset;
+	unsigned int count;
+	unsigned int sgoffset;
+};
+
 int cxgb3i_iscsi_init(void);
 void cxgb3i_iscsi_cleanup(void);
 
diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
index 08f3a09..a83d36e 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
@@ -639,10 +639,11 @@ static int ddp_init(struct t3cdev *tdev)
 	write_unlock(&cxgb3i_ddp_rwlock);
 
 	ddp_log_info("nppods %u (0x%x ~ 0x%x), bits %u, mask 0x%x,0x%x "
-			"pkt %u,%u.\n",
+			"pkt %u/%u, %u/%u.\n",
 			ppmax, ddp->llimit, ddp->ulimit, ddp->idx_bits,
 			ddp->idx_mask, ddp->rsvd_tag_mask,
-			ddp->max_txsz, ddp->max_rxsz);
+			ddp->max_txsz, uinfo.max_txsz,
+			ddp->max_rxsz, uinfo.max_rxsz);
 	return 0;
 
 free_ddp_map:
@@ -654,8 +655,8 @@ free_ddp_map:
  * cxgb3i_adapter_ddp_init - initialize the adapter's ddp resource
  * @tdev: t3cdev adapter
  * @tformat: tag format
- * @txsz: max tx pkt size, filled in by this func.
- * @rxsz: max rx pkt size, filled in by this func.
+ * @txsz: max tx pdu payload size, filled in by this func.
+ * @rxsz: max rx pdu payload size, filled in by this func.
  * initialize the ddp pagepod manager for a given adapter if needed and
  * setup the tag format for a given iscsi entity
  */
@@ -685,10 +686,12 @@ int cxgb3i_adapter_ddp_init(struct t3cdev *tdev,
 		      tformat->sw_bits, tformat->rsvd_bits,
 		      tformat->rsvd_shift, tformat->rsvd_mask);
 
-	*txsz = ddp->max_txsz;
-	*rxsz = ddp->max_rxsz;
-	ddp_log_info("ddp max pkt size: %u, %u.\n",
-		     ddp->max_txsz, ddp->max_rxsz);
+	*txsz = min_t(unsigned int, ULP2_MAX_PDU_PAYLOAD,
+			ddp->max_txsz - ISCSI_PDU_NONPAYLOAD_LEN);
+	*rxsz = min_t(unsigned int, ULP2_MAX_PDU_PAYLOAD,
+			ddp->max_rxsz - ISCSI_PDU_NONPAYLOAD_LEN);
+	ddp_log_info("max payload size: %u/%u, %u/%u.\n",
+		     *txsz, ddp->max_txsz, *rxsz, ddp->max_rxsz);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(cxgb3i_adapter_ddp_init);
diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.h b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
index 5c7c4d9..3faae78 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
@@ -13,6 +13,8 @@
 #ifndef __CXGB3I_ULP2_DDP_H__
 #define __CXGB3I_ULP2_DDP_H__
 
+#include <linux/vmalloc.h>
+
 /**
  * struct cxgb3i_tag_format - cxgb3i ulp tag format for an iscsi entity
  *
@@ -85,8 +87,9 @@ struct cxgb3i_ddp_info {
 	struct sk_buff **gl_skb;
 };
 
+#define ISCSI_PDU_NONPAYLOAD_LEN	312 /* bhs(48) + ahs(256) + digest(8) */
 #define ULP2_MAX_PKT_SIZE	16224
-#define ULP2_MAX_PDU_PAYLOAD	(ULP2_MAX_PKT_SIZE - ISCSI_PDU_NONPAYLOAD_MAX)
+#define ULP2_MAX_PDU_PAYLOAD	(ULP2_MAX_PKT_SIZE - ISCSI_PDU_NONPAYLOAD_LEN)
 #define PPOD_PAGES_MAX		4
 #define PPOD_PAGES_SHIFT	2	/* 4 pages per pod */
 
diff --git a/drivers/scsi/cxgb3i/cxgb3i_init.c b/drivers/scsi/cxgb3i/cxgb3i_init.c
index 091ecb4..1ce9f24 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_init.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_init.c
@@ -12,8 +12,8 @@
 #include "cxgb3i.h"
 
 #define DRV_MODULE_NAME         "cxgb3i"
-#define DRV_MODULE_VERSION	"1.0.0"
-#define DRV_MODULE_RELDATE	"Jun. 1, 2008"
+#define DRV_MODULE_VERSION	"1.0.1"
+#define DRV_MODULE_RELDATE	"Jan. 2009"
 
 static char version[] =
 	"Chelsio S3xx iSCSI Driver " DRV_MODULE_NAME
diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index d83464b..fa2a44f 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -364,7 +364,8 @@ cxgb3i_session_create(struct iscsi_endpoint *ep, u16 cmds_max, u16 qdepth,
 
 	cls_session = iscsi_session_setup(&cxgb3i_iscsi_transport, shost,
 					  cmds_max,
-					  sizeof(struct iscsi_tcp_task),
+					  sizeof(struct iscsi_tcp_task) +
+					  sizeof(struct cxgb3i_task_data),
 					  initial_cmdsn, ISCSI_MAX_TARGET);
 	if (!cls_session)
 		return NULL;
@@ -402,17 +403,15 @@ static inline int cxgb3i_conn_max_xmit_dlength(struct iscsi_conn *conn)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
-	unsigned int max = min_t(unsigned int, ULP2_MAX_PDU_PAYLOAD,
-				 cconn->hba->snic->tx_max_size -
-				 ISCSI_PDU_NONPAYLOAD_MAX);
+	unsigned int max = max(512 * MAX_SKB_FRAGS, SKB_TX_HEADROOM);
 
+	max = min(cconn->hba->snic->tx_max_size, max);
 	if (conn->max_xmit_dlength)
-		conn->max_xmit_dlength = min_t(unsigned int,
-						conn->max_xmit_dlength, max);
+		conn->max_xmit_dlength = min(conn->max_xmit_dlength, max);
 	else
 		conn->max_xmit_dlength = max;
 	align_pdu_size(conn->max_xmit_dlength);
-	cxgb3i_log_info("conn 0x%p, max xmit %u.\n",
+	cxgb3i_api_debug("conn 0x%p, max xmit %u.\n",
 			 conn, conn->max_xmit_dlength);
 	return 0;
 }
@@ -427,9 +426,7 @@ static inline int cxgb3i_conn_max_recv_dlength(struct iscsi_conn *conn)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
-	unsigned int max = min_t(unsigned int, ULP2_MAX_PDU_PAYLOAD,
-				 cconn->hba->snic->rx_max_size -
-				 ISCSI_PDU_NONPAYLOAD_MAX);
+	unsigned int max = cconn->hba->snic->rx_max_size;
 
 	align_pdu_size(max);
 	if (conn->max_recv_dlength) {
@@ -439,8 +436,7 @@ static inline int cxgb3i_conn_max_recv_dlength(struct iscsi_conn *conn)
 					 conn->max_recv_dlength, max);
 			return -EINVAL;
 		}
-		conn->max_recv_dlength = min_t(unsigned int,
-						conn->max_recv_dlength, max);
+		conn->max_recv_dlength = min(conn->max_recv_dlength, max);
 		align_pdu_size(conn->max_recv_dlength);
 	} else
 		conn->max_recv_dlength = max;
@@ -844,7 +840,7 @@ static struct scsi_host_template cxgb3i_host_template = {
 	.proc_name		= "cxgb3i",
 	.queuecommand		= iscsi_queuecommand,
 	.change_queue_depth	= iscsi_change_queue_depth,
-	.can_queue		= 128 * (ISCSI_DEF_XMIT_CMDS_MAX - 1),
+	.can_queue		= CXGB3I_SCSI_QDEPTH_DFLT - 1,
 	.sg_tablesize		= SG_ALL,
 	.max_sectors		= 0xFFFF,
 	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index a865f1f..de3b3b6 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -23,19 +23,19 @@
 #include "cxgb3i_ddp.h"
 
 #ifdef __DEBUG_C3CN_CONN__
-#define c3cn_conn_debug         cxgb3i_log_info
+#define c3cn_conn_debug		cxgb3i_log_debug
 #else
 #define c3cn_conn_debug(fmt...)
 #endif
 
 #ifdef __DEBUG_C3CN_TX__
-#define c3cn_tx_debug         cxgb3i_log_debug
+#define c3cn_tx_debug		cxgb3i_log_debug
 #else
 #define c3cn_tx_debug(fmt...)
 #endif
 
 #ifdef __DEBUG_C3CN_RX__
-#define c3cn_rx_debug         cxgb3i_log_debug
+#define c3cn_rx_debug		cxgb3i_log_debug
 #else
 #define c3cn_rx_debug(fmt...)
 #endif
@@ -47,9 +47,9 @@ static int cxgb3_rcv_win = 256 * 1024;
 module_param(cxgb3_rcv_win, int, 0644);
 MODULE_PARM_DESC(cxgb3_rcv_win, "TCP receive window in bytes (default=256KB)");
 
-static int cxgb3_snd_win = 64 * 1024;
+static int cxgb3_snd_win = 128 * 1024;
 module_param(cxgb3_snd_win, int, 0644);
-MODULE_PARM_DESC(cxgb3_snd_win, "TCP send window in bytes (default=64KB)");
+MODULE_PARM_DESC(cxgb3_snd_win, "TCP send window in bytes (default=128KB)");
 
 static int cxgb3_rx_credit_thres = 10 * 1024;
 module_param(cxgb3_rx_credit_thres, int, 0644);
@@ -301,8 +301,8 @@ static void act_open_req_arp_failure(struct t3cdev *dev, struct sk_buff *skb)
 static void skb_entail(struct s3_conn *c3cn, struct sk_buff *skb,
 		       int flags)
 {
-	CXGB3_SKB_CB(skb)->seq = c3cn->write_seq;
-	CXGB3_SKB_CB(skb)->flags = flags;
+	skb_tcp_seq(skb) = c3cn->write_seq;
+	skb_flags(skb) = flags;
 	__skb_queue_tail(&c3cn->write_queue, skb);
 }
 
@@ -457,12 +457,9 @@ static unsigned int wrlen __read_mostly;
  * The number of WRs needed for an skb depends on the number of fragments
  * in the skb and whether it has any payload in its main body.  This maps the
  * length of the gather list represented by an skb into the # of necessary WRs.
- *
- * The max. length of an skb is controlled by the max pdu size which is ~16K.
- * Also, assume the min. fragment length is the sector size (512), then add
- * extra fragment counts for iscsi bhs and payload padding.
+ * The extra two fragments are for iscsi bhs and payload padding.
  */
-#define SKB_WR_LIST_SIZE	(16384/512 + 3)
+#define SKB_WR_LIST_SIZE	(MAX_SKB_FRAGS + 2)
 static unsigned int skb_wrs[SKB_WR_LIST_SIZE] __read_mostly;
 
 static void s3_init_wr_tab(unsigned int wr_len)
@@ -485,7 +482,7 @@ static void s3_init_wr_tab(unsigned int wr_len)
 
 static inline void reset_wr_list(struct s3_conn *c3cn)
 {
-	c3cn->wr_pending_head = NULL;
+	c3cn->wr_pending_head = c3cn->wr_pending_tail = NULL;
 }
 
 /*
@@ -496,7 +493,7 @@ static inline void reset_wr_list(struct s3_conn *c3cn)
 static inline void enqueue_wr(struct s3_conn *c3cn,
 			      struct sk_buff *skb)
 {
-	skb_wr_data(skb) = NULL;
+	skb_tx_wr_next(skb) = NULL;
 
 	/*
 	 * We want to take an extra reference since both us and the driver
@@ -509,10 +506,22 @@ static inline void enqueue_wr(struct s3_conn *c3cn,
 	if (!c3cn->wr_pending_head)
 		c3cn->wr_pending_head = skb;
 	else
-		skb_wr_data(skb) = skb;
+		skb_tx_wr_next(c3cn->wr_pending_tail) = skb;
 	c3cn->wr_pending_tail = skb;
 }
 
+static int count_pending_wrs(struct s3_conn *c3cn)
+{
+	int n = 0;
+	const struct sk_buff *skb = c3cn->wr_pending_head;
+
+	while (skb) {
+		n += skb->csum;
+		skb = skb_tx_wr_next(skb);
+	}
+	return n;
+}
+
 static inline struct sk_buff *peek_wr(const struct s3_conn *c3cn)
 {
 	return c3cn->wr_pending_head;
@@ -529,8 +538,8 @@ static inline struct sk_buff *dequeue_wr(struct s3_conn *c3cn)
 
 	if (likely(skb)) {
 		/* Don't bother clearing the tail */
-		c3cn->wr_pending_head = skb_wr_data(skb);
-		skb_wr_data(skb) = NULL;
+		c3cn->wr_pending_head = skb_tx_wr_next(skb);
+		skb_tx_wr_next(skb) = NULL;
 	}
 	return skb;
 }
@@ -543,13 +552,14 @@ static void purge_wr_queue(struct s3_conn *c3cn)
 }
 
 static inline void make_tx_data_wr(struct s3_conn *c3cn, struct sk_buff *skb,
-				   int len)
+				   int len, int req_completion)
 {
 	struct tx_data_wr *req;
 
 	skb_reset_transport_header(skb);
 	req = (struct tx_data_wr *)__skb_push(skb, sizeof(*req));
-	req->wr_hi = htonl(V_WR_OP(FW_WROPCODE_OFLD_TX_DATA));
+	req->wr_hi = htonl(V_WR_OP(FW_WROPCODE_OFLD_TX_DATA) |
+			(req_completion ? F_WR_COMPL : 0));
 	req->wr_lo = htonl(V_WR_TID(c3cn->tid));
 	req->sndseq = htonl(c3cn->snd_nxt);
 	/* len includes the length of any HW ULP additions */
@@ -592,7 +602,7 @@ static int c3cn_push_tx_frames(struct s3_conn *c3cn, int req_completion)
 
 	if (unlikely(c3cn->state == C3CN_STATE_CONNECTING ||
 		     c3cn->state == C3CN_STATE_CLOSE_WAIT_1 ||
-		     c3cn->state == C3CN_STATE_ABORTING)) {
+		     c3cn->state >= C3CN_STATE_ABORTING)) {
 		c3cn_tx_debug("c3cn 0x%p, in closing state %u.\n",
 			      c3cn, c3cn->state);
 		return 0;
@@ -615,7 +625,7 @@ static int c3cn_push_tx_frames(struct s3_conn *c3cn, int req_completion)
 		if (c3cn->wr_avail < wrs_needed) {
 			c3cn_tx_debug("c3cn 0x%p, skb len %u/%u, frag %u, "
 				      "wr %d < %u.\n",
-				      c3cn, skb->len, skb->datalen, frags,
+				      c3cn, skb->len, skb->data_len, frags,
 				      wrs_needed, c3cn->wr_avail);
 			break;
 		}
@@ -627,20 +637,24 @@ static int c3cn_push_tx_frames(struct s3_conn *c3cn, int req_completion)
 		c3cn->wr_unacked += wrs_needed;
 		enqueue_wr(c3cn, skb);
 
-		if (likely(CXGB3_SKB_CB(skb)->flags & C3CB_FLAG_NEED_HDR)) {
-			len += ulp_extra_len(skb);
-			make_tx_data_wr(c3cn, skb, len);
-			c3cn->snd_nxt += len;
-			if ((req_completion
-			     && c3cn->wr_unacked == wrs_needed)
-			    || (CXGB3_SKB_CB(skb)->flags & C3CB_FLAG_COMPL)
-			    || c3cn->wr_unacked >= c3cn->wr_max / 2) {
-				struct work_request_hdr *wr = cplhdr(skb);
+		c3cn_tx_debug("c3cn 0x%p, enqueue, skb len %u/%u, frag %u, "
+				"wr %d, left %u, unack %u.\n",
+				c3cn, skb->len, skb->data_len, frags,
+				wrs_needed, c3cn->wr_avail, c3cn->wr_unacked);
+
 
-				wr->wr_hi |= htonl(F_WR_COMPL);
+		if (likely(skb_flags(skb) & C3CB_FLAG_NEED_HDR)) {
+			if ((req_completion &&
+				c3cn->wr_unacked == wrs_needed) ||
+			    (skb_flags(skb) & C3CB_FLAG_COMPL) ||
+			    c3cn->wr_unacked >= c3cn->wr_max / 2) {
+				req_completion = 1;
 				c3cn->wr_unacked = 0;
 			}
-			CXGB3_SKB_CB(skb)->flags &= ~C3CB_FLAG_NEED_HDR;
+			len += ulp_extra_len(skb);
+			make_tx_data_wr(c3cn, skb, len, req_completion);
+			c3cn->snd_nxt += len;
+			skb_flags(skb) &= ~C3CB_FLAG_NEED_HDR;
 		}
 
 		total_size += skb->truesize;
@@ -735,8 +749,11 @@ static void process_act_establish(struct s3_conn *c3cn, struct sk_buff *skb)
 	if (unlikely(c3cn_flag(c3cn, C3CN_ACTIVE_CLOSE_NEEDED)))
 		/* upper layer has requested closing */
 		send_abort_req(c3cn);
-	else if (c3cn_push_tx_frames(c3cn, 1))
+	else {
+		if (skb_queue_len(&c3cn->write_queue))
+			c3cn_push_tx_frames(c3cn, 1);
 		cxgb3i_conn_tx_open(c3cn);
+	}
 }
 
 static int do_act_establish(struct t3cdev *cdev, struct sk_buff *skb,
@@ -1082,8 +1099,8 @@ static void process_rx_iscsi_hdr(struct s3_conn *c3cn, struct sk_buff *skb)
 		return;
 	}
 
-	CXGB3_SKB_CB(skb)->seq = ntohl(hdr_cpl->seq);
-	CXGB3_SKB_CB(skb)->flags = 0;
+	skb_tcp_seq(skb) = ntohl(hdr_cpl->seq);
+	skb_flags(skb) = 0;
 
 	skb_reset_transport_header(skb);
 	__skb_pull(skb, sizeof(struct cpl_iscsi_hdr));
@@ -1103,12 +1120,12 @@ static void process_rx_iscsi_hdr(struct s3_conn *c3cn, struct sk_buff *skb)
 		goto abort_conn;
 
 	skb_ulp_mode(skb) = ULP2_FLAG_DATA_READY;
-	skb_ulp_pdulen(skb) = ntohs(ddp_cpl.len);
-	skb_ulp_ddigest(skb) = ntohl(ddp_cpl.ulp_crc);
+	skb_rx_pdulen(skb) = ntohs(ddp_cpl.len);
+	skb_rx_ddigest(skb) = ntohl(ddp_cpl.ulp_crc);
 	status = ntohl(ddp_cpl.ddp_status);
 
 	c3cn_rx_debug("rx skb 0x%p, len %u, pdulen %u, ddp status 0x%x.\n",
-		      skb, skb->len, skb_ulp_pdulen(skb), status);
+		      skb, skb->len, skb_rx_pdulen(skb), status);
 
 	if (status & (1 << RX_DDP_STATUS_HCRC_SHIFT))
 		skb_ulp_mode(skb) |= ULP2_FLAG_HCRC_ERROR;
@@ -1126,7 +1143,7 @@ static void process_rx_iscsi_hdr(struct s3_conn *c3cn, struct sk_buff *skb)
 	} else if (status & (1 << RX_DDP_STATUS_DDP_SHIFT))
 		skb_ulp_mode(skb) |= ULP2_FLAG_DATA_DDPED;
 
-	c3cn->rcv_nxt = ntohl(ddp_cpl.seq) + skb_ulp_pdulen(skb);
+	c3cn->rcv_nxt = ntohl(ddp_cpl.seq) + skb_rx_pdulen(skb);
 	__pskb_trim(skb, len);
 	__skb_queue_tail(&c3cn->receive_queue, skb);
 	cxgb3i_conn_pdu_ready(c3cn);
@@ -1151,12 +1168,27 @@ static int do_iscsi_hdr(struct t3cdev *t3dev, struct sk_buff *skb, void *ctx)
  * Process an acknowledgment of WR completion.  Advance snd_una and send the
  * next batch of work requests from the write queue.
  */
+static void check_wr_invariants(struct s3_conn *c3cn)
+{
+	int pending = count_pending_wrs(c3cn);
+
+	if (unlikely(c3cn->wr_avail + pending != c3cn->wr_max))
+		cxgb3i_log_error("TID %u: credit imbalance: avail %u, "
+				"pending %u, total should be %u\n",
+				c3cn->tid, c3cn->wr_avail, pending,
+				c3cn->wr_max);
+}
+
 static void process_wr_ack(struct s3_conn *c3cn, struct sk_buff *skb)
 {
 	struct cpl_wr_ack *hdr = cplhdr(skb);
 	unsigned int credits = ntohs(hdr->credits);
 	u32 snd_una = ntohl(hdr->snd_una);
 
+	c3cn_tx_debug("%u WR credits, avail %u, unack %u, TID %u, state %u.\n",
+			credits, c3cn->wr_avail, c3cn->wr_unacked,
+			c3cn->tid, c3cn->state);
+
 	c3cn->wr_avail += credits;
 	if (c3cn->wr_unacked > c3cn->wr_max - c3cn->wr_avail)
 		c3cn->wr_unacked = c3cn->wr_max - c3cn->wr_avail;
@@ -1171,6 +1203,17 @@ static void process_wr_ack(struct s3_conn *c3cn, struct sk_buff *skb)
 			break;
 		}
 		if (unlikely(credits < p->csum)) {
+			struct tx_data_wr *w = cplhdr(p);
+			cxgb3i_log_error("TID %u got %u WR credits need %u, "
+					 "len %u, main body %u, frags %u, "
+					 "seq # %u, ACK una %u, ACK nxt %u, "
+					 "WR_AVAIL %u, WRs pending %u\n",
+					 c3cn->tid, credits, p->csum, p->len,
+					 p->len - p->data_len,
+					 skb_shinfo(p)->nr_frags,
+					 ntohl(w->sndseq), snd_una,
+					 ntohl(hdr->snd_nxt), c3cn->wr_avail,
+					 count_pending_wrs(c3cn) - credits);
 			p->csum -= credits;
 			break;
 		} else {
@@ -1180,15 +1223,24 @@ static void process_wr_ack(struct s3_conn *c3cn, struct sk_buff *skb)
 		}
 	}
 
-	if (unlikely(before(snd_una, c3cn->snd_una)))
+	check_wr_invariants(c3cn);
+
+	if (unlikely(before(snd_una, c3cn->snd_una))) {
+		cxgb3i_log_error("TID %u, unexpected sequence # %u in WR_ACK "
+				 "snd_una %u\n",
+				 c3cn->tid, snd_una, c3cn->snd_una);
 		goto out_free;
+	}
 
 	if (c3cn->snd_una != snd_una) {
 		c3cn->snd_una = snd_una;
 		dst_confirm(c3cn->dst_cache);
 	}
 
-	if (skb_queue_len(&c3cn->write_queue) && c3cn_push_tx_frames(c3cn, 0))
+	if (skb_queue_len(&c3cn->write_queue)) {
+		if (c3cn_push_tx_frames(c3cn, 0))
+			cxgb3i_conn_tx_open(c3cn);
+	} else
 		cxgb3i_conn_tx_open(c3cn);
 out_free:
 	__kfree_skb(skb);
@@ -1452,7 +1504,7 @@ static void init_offload_conn(struct s3_conn *c3cn,
 			      struct dst_entry *dst)
 {
 	BUG_ON(c3cn->cdev != cdev);
-	c3cn->wr_max = c3cn->wr_avail = T3C_DATA(cdev)->max_wrs;
+	c3cn->wr_max = c3cn->wr_avail = T3C_DATA(cdev)->max_wrs - 1;
 	c3cn->wr_unacked = 0;
 	c3cn->mss_idx = select_mss(c3cn, dst_mtu(dst));
 
@@ -1671,9 +1723,17 @@ int cxgb3i_c3cn_send_pdus(struct s3_conn *c3cn, struct sk_buff *skb)
 		goto out_err;
 	}
 
-	err = -EPIPE;
 	if (c3cn->err) {
 		c3cn_tx_debug("c3cn 0x%p, err %d.\n", c3cn, c3cn->err);
+		err = -EPIPE;
+		goto out_err;
+	}
+
+	if (c3cn->write_seq - c3cn->snd_una >= cxgb3_snd_win) {
+		c3cn_tx_debug("c3cn 0x%p, snd %u - %u > %u.\n",
+				c3cn, c3cn->write_seq, c3cn->snd_una,
+				cxgb3_snd_win);
+		err = -EAGAIN;
 		goto out_err;
 	}
 
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.h b/drivers/scsi/cxgb3i/cxgb3i_offload.h
index d231569..6344b9e 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.h
@@ -178,25 +178,33 @@ void cxgb3i_c3cn_release(struct s3_conn *);
  * @flag:	see C3CB_FLAG_* below
  * @ulp_mode:	ULP mode/submode of sk_buff
  * @seq:	tcp sequence number
- * @ddigest:	pdu data digest
- * @pdulen:	recovered pdu length
- * @wr_data:	scratch area for tx wr
  */
+struct cxgb3_skb_rx_cb {
+	__u32 ddigest;			/* data digest */
+	__u32 pdulen;			/* recovered pdu length */
+};
+
+struct cxgb3_skb_tx_cb {
+	struct sk_buff *wr_next;	/* next wr */
+};
+
 struct cxgb3_skb_cb {
 	__u8 flags;
 	__u8 ulp_mode;
 	__u32 seq;
-	__u32 ddigest;
-	__u32 pdulen;
-	struct sk_buff *wr_data;
+	union {
+		struct cxgb3_skb_rx_cb rx;
+		struct cxgb3_skb_tx_cb tx;
+	};
 };
 
 #define CXGB3_SKB_CB(skb)	((struct cxgb3_skb_cb *)&((skb)->cb[0]))
-
+#define skb_flags(skb)		(CXGB3_SKB_CB(skb)->flags)
 #define skb_ulp_mode(skb)	(CXGB3_SKB_CB(skb)->ulp_mode)
-#define skb_ulp_ddigest(skb)	(CXGB3_SKB_CB(skb)->ddigest)
-#define skb_ulp_pdulen(skb)	(CXGB3_SKB_CB(skb)->pdulen)
-#define skb_wr_data(skb)	(CXGB3_SKB_CB(skb)->wr_data)
+#define skb_tcp_seq(skb)	(CXGB3_SKB_CB(skb)->seq)
+#define skb_rx_ddigest(skb)	(CXGB3_SKB_CB(skb)->rx.ddigest)
+#define skb_rx_pdulen(skb)	(CXGB3_SKB_CB(skb)->rx.pdulen)
+#define skb_tx_wr_next(skb)	(CXGB3_SKB_CB(skb)->tx.wr_next)
 
 enum c3cb_flags {
 	C3CB_FLAG_NEED_HDR = 1 << 0,	/* packet needs a TX_DATA_WR header */
@@ -217,6 +225,7 @@ struct sge_opaque_hdr {
 /* for TX: a skb must have a headroom of at least TX_HEADER_LEN bytes */
 #define TX_HEADER_LEN \
 		(sizeof(struct tx_data_wr) + sizeof(struct sge_opaque_hdr))
+#define SKB_TX_HEADROOM		SKB_MAX_HEAD(TX_HEADER_LEN)
 
 /*
  * get and set private ip for iscsi traffic
diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.c b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
index ce7ce8c..17115c2 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
@@ -32,6 +32,10 @@
 #define cxgb3i_tx_debug(fmt...)
 #endif
 
+/* always allocate rooms for AHS */
+#define SKB_TX_PDU_HEADER_LEN	\
+	(sizeof(struct iscsi_hdr) + ISCSI_MAX_AHS_SIZE)
+static unsigned int skb_extra_headroom;
 static struct page *pad_page;
 
 /*
@@ -146,12 +150,13 @@ static inline void tx_skb_setmode(struct sk_buff *skb, int hcrc, int dcrc)
 
 void cxgb3i_conn_cleanup_task(struct iscsi_task *task)
 {
-	struct iscsi_tcp_task *tcp_task = task->dd_data;
+	struct cxgb3i_task_data *tdata = task->dd_data +
+					sizeof(struct iscsi_tcp_task);
 
 	/* never reached the xmit task callout */
-	if (tcp_task->dd_data)
-		kfree_skb(tcp_task->dd_data);
-	tcp_task->dd_data = NULL;
+	if (tdata->skb)
+		__kfree_skb(tdata->skb);
+	memset(tdata, 0, sizeof(struct cxgb3i_task_data));
 
 	/* MNC - Do we need a check in case this is called but
 	 * cxgb3i_conn_alloc_pdu has never been called on the task */
@@ -159,28 +164,102 @@ void cxgb3i_conn_cleanup_task(struct iscsi_task *task)
 	iscsi_tcp_cleanup_task(task);
 }
 
-/*
- * We do not support ahs yet
- */
+static int sgl_seek_offset(struct scatterlist *sgl, unsigned int sgcnt,
+				unsigned int offset, unsigned int *off,
+				struct scatterlist **sgp)
+{
+	int i;
+	struct scatterlist *sg;
+
+	for_each_sg(sgl, sg, sgcnt, i) {
+		if (offset < sg->length) {
+			*off = offset;
+			*sgp = sg;
+			return 0;
+		}
+		offset -= sg->length;
+	}
+	return -EFAULT;
+}
+
+static int sgl_read_to_frags(struct scatterlist *sg, unsigned int sgoffset,
+				unsigned int dlen, skb_frag_t *frags,
+				int frag_max)
+{
+	unsigned int datalen = dlen;
+	unsigned int sglen = sg->length - sgoffset;
+	struct page *page = sg_page(sg);
+	int i;
+
+	i = 0;
+	do {
+		unsigned int copy;
+
+		if (!sglen) {
+			sg = sg_next(sg);
+			if (!sg) {
+				cxgb3i_log_error("%s, sg NULL, len %u/%u.\n",
+						 __func__, datalen, dlen);
+				return -EINVAL;
+			}
+			sgoffset = 0;
+			sglen = sg->length;
+			page = sg_page(sg);
+
+		}
+		copy = min(datalen, sglen);
+		if (i && page == frags[i - 1].page &&
+		    sgoffset + sg->offset ==
+			frags[i - 1].page_offset + frags[i - 1].size) {
+			frags[i - 1].size += copy;
+		} else {
+			if (i >= frag_max) {
+				cxgb3i_log_error("%s, too many pages %u, "
+						 "dlen %u.\n", __func__,
+						 frag_max, dlen);
+				return -EINVAL;
+			}
+
+			frags[i].page = page;
+			frags[i].page_offset = sg->offset + sgoffset;
+			frags[i].size = copy;
+			i++;
+		}
+		datalen -= copy;
+		sgoffset += copy;
+		sglen -= copy;
+	} while (datalen);
+
+	return i;
+}
+
 int cxgb3i_conn_alloc_pdu(struct iscsi_task *task, u8 opcode)
 {
+	struct iscsi_conn *conn = task->conn;
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
-	struct sk_buff *skb;
+	struct cxgb3i_task_data *tdata = task->dd_data + sizeof(*tcp_task);
+	struct scsi_cmnd *sc = task->sc;
+	int headroom = SKB_TX_PDU_HEADER_LEN;
 
+	tcp_task->dd_data = tdata;
 	task->hdr = NULL;
-	/* always allocate rooms for AHS */
-	skb = alloc_skb(sizeof(struct iscsi_hdr) + ISCSI_MAX_AHS_SIZE +
-			TX_HEADER_LEN,  GFP_ATOMIC);
-	if (!skb)
+
+	/* write command, need to send data pdus */
+	if (skb_extra_headroom && (opcode == ISCSI_OP_SCSI_DATA_OUT ||
+	    (opcode == ISCSI_OP_SCSI_CMD &&
+	    (scsi_bidi_cmnd(sc) || sc->sc_data_direction == DMA_TO_DEVICE))))
+		headroom += min(skb_extra_headroom, conn->max_xmit_dlength);
+
+	tdata->skb = alloc_skb(TX_HEADER_LEN + headroom, GFP_ATOMIC);
+	if (!tdata->skb)
 		return -ENOMEM;
+	skb_reserve(tdata->skb, TX_HEADER_LEN);
 
 	cxgb3i_tx_debug("task 0x%p, opcode 0x%x, skb 0x%p.\n",
-			task, opcode, skb);
+			task, opcode, tdata->skb);
 
-	tcp_task->dd_data = skb;
-	skb_reserve(skb, TX_HEADER_LEN);
-	task->hdr = (struct iscsi_hdr *)skb->data;
-	task->hdr_max = sizeof(struct iscsi_hdr);
+	task->hdr = (struct iscsi_hdr *)tdata->skb->data;
+	task->hdr_max = SKB_TX_PDU_HEADER_LEN;
 
 	/* data_out uses scsi_cmd's itt */
 	if (opcode != ISCSI_OP_SCSI_DATA_OUT)
@@ -192,13 +271,13 @@ int cxgb3i_conn_alloc_pdu(struct iscsi_task *task, u8 opcode)
 int cxgb3i_conn_init_pdu(struct iscsi_task *task, unsigned int offset,
 			      unsigned int count)
 {
-	struct iscsi_tcp_task *tcp_task = task->dd_data;
-	struct sk_buff *skb = tcp_task->dd_data;
 	struct iscsi_conn *conn = task->conn;
-	struct page *pg;
+	struct iscsi_tcp_task *tcp_task = task->dd_data;
+	struct cxgb3i_task_data *tdata = tcp_task->dd_data;
+	struct sk_buff *skb = tdata->skb;
 	unsigned int datalen = count;
 	int i, padlen = iscsi_padding(count);
-	skb_frag_t *frag;
+	struct page *pg;
 
 	cxgb3i_tx_debug("task 0x%p,0x%p, offset %u, count %u, skb 0x%p.\n",
 			task, task->sc, offset, count, skb);
@@ -209,90 +288,94 @@ int cxgb3i_conn_init_pdu(struct iscsi_task *task, unsigned int offset,
 		return 0;
 
 	if (task->sc) {
-		struct scatterlist *sg;
-		struct scsi_data_buffer *sdb;
-		unsigned int sgoffset = offset;
-		struct page *sgpg;
-		unsigned int sglen;
-
-		sdb = scsi_out(task->sc);
-		sg = sdb->table.sgl;
-
-		for_each_sg(sdb->table.sgl, sg, sdb->table.nents, i) {
-			cxgb3i_tx_debug("sg %d, page 0x%p, len %u offset %u\n",
-					i, sg_page(sg), sg->length, sg->offset);
-
-			if (sgoffset < sg->length)
-				break;
-			sgoffset -= sg->length;
+		struct scsi_data_buffer *sdb = scsi_out(task->sc);
+		struct scatterlist *sg = NULL;
+		int err;
+
+		tdata->offset = offset;
+		tdata->count = count;
+		err = sgl_seek_offset(sdb->table.sgl, sdb->table.nents,
+					tdata->offset, &tdata->sgoffset, &sg);
+		if (err < 0) {
+			cxgb3i_log_warn("tpdu, sgl %u, bad offset %u/%u.\n",
+					sdb->table.nents, tdata->offset,
+					sdb->length);
+			return err;
 		}
-		sgpg = sg_page(sg);
-		sglen = sg->length - sgoffset;
-
-		do {
-			int j = skb_shinfo(skb)->nr_frags;
-			unsigned int copy;
-
-			if (!sglen) {
-				sg = sg_next(sg);
-				sgpg = sg_page(sg);
-				sgoffset = 0;
-				sglen = sg->length;
-				++i;
+		err = sgl_read_to_frags(sg, tdata->sgoffset, tdata->count,
+					tdata->frags, MAX_PDU_FRAGS);
+		if (err < 0) {
+			cxgb3i_log_warn("tpdu, sgl %u, bad offset %u + %u.\n",
+					sdb->table.nents, tdata->offset,
+					tdata->count);
+			return err;
+		}
+		tdata->nr_frags = err;
+
+		if (tdata->nr_frags > MAX_SKB_FRAGS ||
+		    (padlen && tdata->nr_frags == MAX_SKB_FRAGS)) {
+			char *dst = skb->data + task->hdr_len;
+			skb_frag_t *frag = tdata->frags;
+
+			/* data fits in the skb's headroom */
+			for (i = 0; i < tdata->nr_frags; i++, frag++) {
+				char *src = kmap_atomic(frag->page,
+							KM_SOFTIRQ0);
+
+				memcpy(dst, src+frag->page_offset, frag->size);
+				dst += frag->size;
+				kunmap_atomic(src, KM_SOFTIRQ0);
 			}
-			copy = min(sglen, datalen);
-			if (j && skb_can_coalesce(skb, j, sgpg,
-						  sg->offset + sgoffset)) {
-				skb_shinfo(skb)->frags[j - 1].size += copy;
-			} else {
-				get_page(sgpg);
-				skb_fill_page_desc(skb, j, sgpg,
-						   sg->offset + sgoffset, copy);
+			if (padlen) {
+				memset(dst, 0, padlen);
+				padlen = 0;
 			}
-			sgoffset += copy;
-			sglen -= copy;
-			datalen -= copy;
-		} while (datalen);
+			skb_put(skb, count + padlen);
+		} else {
+			/* data fit into frag_list */
+			for (i = 0; i < tdata->nr_frags; i++)
+				get_page(tdata->frags[i].page);
+
+			memcpy(skb_shinfo(skb)->frags, tdata->frags,
+				sizeof(skb_frag_t) * tdata->nr_frags);
+			skb_shinfo(skb)->nr_frags = tdata->nr_frags;
+			skb->len += count;
+			skb->data_len += count;
+			skb->truesize += count;
+		}
+
 	} else {
 		pg = virt_to_page(task->data);
 
-		while (datalen) {
-			i = skb_shinfo(skb)->nr_frags;
-			frag = &skb_shinfo(skb)->frags[i];
-
-			get_page(pg);
-			frag->page = pg;
-			frag->page_offset = 0;
-			frag->size = min((unsigned int)PAGE_SIZE, datalen);
-
-			skb_shinfo(skb)->nr_frags++;
-			datalen -= frag->size;
-			pg++;
-		}
+		get_page(pg);
+		skb_fill_page_desc(skb, 0, pg, offset_in_page(task->data),
+					count);
+		skb->len += count;
+		skb->data_len += count;
+		skb->truesize += count;
 	}
 
 	if (padlen) {
 		i = skb_shinfo(skb)->nr_frags;
-		frag = &skb_shinfo(skb)->frags[i];
-		frag->page = pad_page;
-		frag->page_offset = 0;
-		frag->size = padlen;
-		skb_shinfo(skb)->nr_frags++;
+		get_page(pad_page);
+		skb_fill_page_desc(skb, skb_shinfo(skb)->nr_frags, pad_page, 0,
+				 padlen);
+
+		skb->data_len += padlen;
+		skb->truesize += padlen;
+		skb->len += padlen;
 	}
 
-	datalen = count + padlen;
-	skb->data_len += datalen;
-	skb->truesize += datalen;
-	skb->len += datalen;
 	return 0;
 }
 
 int cxgb3i_conn_xmit_pdu(struct iscsi_task *task)
 {
-	struct iscsi_tcp_task *tcp_task = task->dd_data;
-	struct sk_buff *skb = tcp_task->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = task->conn->dd_data;
 	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
+	struct iscsi_tcp_task *tcp_task = task->dd_data;
+	struct cxgb3i_task_data *tdata = tcp_task->dd_data;
+	struct sk_buff *skb = tdata->skb;
 	unsigned int datalen;
 	int err;
 
@@ -300,13 +383,14 @@ int cxgb3i_conn_xmit_pdu(struct iscsi_task *task)
 		return 0;
 
 	datalen = skb->data_len;
-	tcp_task->dd_data = NULL;
+	tdata->skb = NULL;
 	err = cxgb3i_c3cn_send_pdus(cconn->cep->c3cn, skb);
-	cxgb3i_tx_debug("task 0x%p, skb 0x%p, len %u/%u, rv %d.\n",
-			task, skb, skb->len, skb->data_len, err);
 	if (err > 0) {
 		int pdulen = err;
 
+	cxgb3i_tx_debug("task 0x%p, skb 0x%p, len %u/%u, rv %d.\n",
+			task, skb, skb->len, skb->data_len, err);
+
 		if (task->conn->hdrdgst_en)
 			pdulen += ISCSI_DIGEST_SIZE;
 		if (datalen && task->conn->datadgst_en)
@@ -325,12 +409,14 @@ int cxgb3i_conn_xmit_pdu(struct iscsi_task *task)
 		return err;
 	}
 	/* reset skb to send when we are called again */
-	tcp_task->dd_data = skb;
+	tdata->skb = skb;
 	return -EAGAIN;
 }
 
 int cxgb3i_pdu_init(void)
 {
+	if (SKB_TX_HEADROOM > (512 * MAX_SKB_FRAGS))
+		skb_extra_headroom = SKB_TX_HEADROOM;
 	pad_page = alloc_page(GFP_KERNEL);
 	if (!pad_page)
 		return -ENOMEM;
@@ -366,7 +452,9 @@ void cxgb3i_conn_pdu_ready(struct s3_conn *c3cn)
 	skb = skb_peek(&c3cn->receive_queue);
 	while (!err && skb) {
 		__skb_unlink(skb, &c3cn->receive_queue);
-		read += skb_ulp_pdulen(skb);
+		read += skb_rx_pdulen(skb);
+		cxgb3i_rx_debug("conn 0x%p, cn 0x%p, rx skb 0x%p, pdulen %u.\n",
+				conn, c3cn, skb, skb_rx_pdulen(skb));
 		err = cxgb3i_conn_read_pdu_skb(conn, skb);
 		__kfree_skb(skb);
 		skb = skb_peek(&c3cn->receive_queue);
@@ -377,6 +465,11 @@ void cxgb3i_conn_pdu_ready(struct s3_conn *c3cn)
 		cxgb3i_c3cn_rx_credits(c3cn, read);
 	}
 	conn->rxdata_octets += read;
+
+	if (err) {
+		cxgb3i_log_info("conn 0x%p rx failed err %d.\n", conn, err);
+		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+	}
 }
 
 void cxgb3i_conn_tx_open(struct s3_conn *c3cn)
diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.h b/drivers/scsi/cxgb3i/cxgb3i_pdu.h
index a3f685c..0770b23 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_pdu.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.h
@@ -53,7 +53,7 @@ struct cpl_rx_data_ddp_norss {
 #define ULP2_FLAG_DCRC_ERROR		0x20
 #define ULP2_FLAG_PAD_ERROR		0x40
 
-void cxgb3i_conn_closing(struct s3_conn *);
+void cxgb3i_conn_closing(struct s3_conn *c3cn);
 void cxgb3i_conn_pdu_ready(struct s3_conn *c3cn);
 void cxgb3i_conn_tx_open(struct s3_conn *c3cn);
 #endif
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index a48e499..34be88d 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1251,6 +1251,7 @@ static struct pci_device_id hptiop_id_table[] = {
 	{ PCI_VDEVICE(TTI, 0x3530), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3560), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4322), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4321), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4210), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4211), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4310), (kernel_ulong_t)&hptiop_itl_ops },
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 940dc32..b82ffd9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1040,12 +1040,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				action = ACTION_FAIL;
 			break;
 		case ABORTED_COMMAND:
+			action = ACTION_FAIL;
 			if (sshdr.asc == 0x10) { /* DIF */
 				description = "Target Data Integrity Failure";
-				action = ACTION_FAIL;
 				error = -EILSEQ;
-			} else
-				action = ACTION_RETRY;
+			}
 			break;
 		case NOT_READY:
 			/* If the device is in the process of becoming
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d57566b..55310db 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -107,6 +107,7 @@ static void scsi_disk_release(struct device *cdev);
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
 static void sd_print_result(struct scsi_disk *, int);
 
+static DEFINE_SPINLOCK(sd_index_lock);
 static DEFINE_IDA(sd_index_ida);
 
 /* This semaphore is used to mediate the 0->1 reference get in the
@@ -1914,7 +1915,9 @@ static int sd_probe(struct device *dev)
 		if (!ida_pre_get(&sd_index_ida, GFP_KERNEL))
 			goto out_put;
 
+		spin_lock(&sd_index_lock);
 		error = ida_get_new(&sd_index_ida, &index);
+		spin_unlock(&sd_index_lock);
 	} while (error == -EAGAIN);
 
 	if (error)
@@ -1936,7 +1939,9 @@ static int sd_probe(struct device *dev)
 	return 0;
 
  out_free_index:
+	spin_lock(&sd_index_lock);
 	ida_remove(&sd_index_ida, index);
+	spin_unlock(&sd_index_lock);
  out_put:
 	put_disk(gd);
  out_free:
@@ -1986,7 +1991,9 @@ static void scsi_disk_release(struct device *dev)
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct gendisk *disk = sdkp->disk;
 	
+	spin_lock(&sd_index_lock);
 	ida_remove(&sd_index_ida, sdkp->index);
+	spin_unlock(&sd_index_lock);
 
 	disk->private_data = NULL;
 	put_disk(disk);



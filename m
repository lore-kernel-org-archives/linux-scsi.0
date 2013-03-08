From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC 08/11] iser-target: Add base + proto includes
Date: Fri,  8 Mar 2013 01:45:13 +0000
Message-ID: <1362707116-31406-9-git-send-email-nab@linux-iscsi.org>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/isert/isert_base.h  |  123 ++++++++++++++++++++++++++++
 drivers/infiniband/ulp/isert/isert_proto.h |   47 +++++++++++
 2 files changed, 170 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/ulp/isert/isert_base.h
 create mode 100644 drivers/infiniband/ulp/isert/isert_proto.h

diff --git a/drivers/infiniband/ulp/isert/isert_base.h b/drivers/infiniband/ulp/isert/isert_base.h
new file mode 100644
index 0000000..a7c8bc9
--- /dev/null
+++ b/drivers/infiniband/ulp/isert/isert_base.h
@@ -0,0 +1,123 @@
+#include <linux/socket.h>
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_fmr_pool.h>
+#include <rdma/rdma_cm.h>
+
+#define ISERT_RDMA_LISTEN_BACKLOG	10
+
+enum isert_desc_type {
+	ISCSI_TX_CONTROL,
+	ISCSI_TX_DATAIN
+};
+
+enum iser_ib_op_code {
+	ISER_IB_RECV,
+	ISER_IB_SEND,
+	ISER_IB_RDMA_WRITE,
+	ISER_IB_RDMA_READ,
+};
+
+enum iser_conn_state {
+	ISER_CONN_INIT,
+	ISER_CONN_UP,
+	ISER_CONN_TERMINATING,
+	ISER_CONN_DOWN,
+};
+
+struct iser_rx_desc {
+	struct iser_hdr iser_header;
+	struct iscsi_hdr iscsi_header;
+	char		data[ISER_RECV_DATA_SEG_LEN];
+	u64		dma_addr;
+	struct ib_sge	rx_sg;
+	char		pad[ISER_RX_PAD_SIZE];
+} __attribute__((packed));
+
+struct isert_rx_desc {
+	struct isert_conn	*desc_conn;
+	struct work_struct	desc_work;
+	struct iser_rx_desc	desc;
+}  __attribute__((packed));
+
+struct iser_tx_desc {
+        struct iser_hdr iser_header;
+        struct iscsi_hdr iscsi_header;
+        enum isert_desc_type type;
+        u64             dma_addr;
+        struct ib_sge   tx_sg[2];
+        int             num_sge;
+	struct isert_cmd *isert_cmd;
+	struct ib_send_wr send_wr;
+} __attribute__((packed));
+
+struct isert_rdma_wr {
+	struct list_head	wr_list;
+	struct isert_cmd	*isert_cmd;
+	enum iser_ib_op_code	iser_ib_op;
+	struct ib_sge		*ib_sge;
+	int			num_sge;
+	struct scatterlist	*sge;
+	int 			send_wr_num;
+	struct ib_send_wr	*send_wr;
+};
+
+struct isert_cmd {
+	uint32_t		read_stag;
+	uint32_t		write_stag;
+	uint64_t		read_va;
+	uint64_t		write_va;
+	u64			sense_buf_dma;
+	u32			sense_buf_len;
+	u32			read_va_off;
+	u32			write_va_off;
+	u32			rdma_wr_num;
+	struct isert_conn	*conn;
+	struct iscsi_cmd	iscsi_cmd;
+	struct ib_sge		*ib_sge;
+	struct iser_tx_desc	tx_desc;
+	struct isert_rdma_wr	rdma_wr;
+	struct work_struct	comp_work;
+	struct kref		cmd_kref;
+};
+
+struct isert_conn {
+	enum iser_conn_state	state;
+	int			post_recv_buf_count;
+	atomic_t		post_send_buf_count;
+	u32			responder_resources;
+	u32			initiator_depth;
+	u32			max_sge;
+	char			*login_buf;
+	char			*login_req_buf;
+	char			*login_rsp_buf;
+	u64			login_req_dma;
+	u64			login_rsp_dma;
+	unsigned int		conn_rx_desc_head;
+	struct isert_rx_desc	*conn_rx_descs;
+	struct ib_recv_wr	conn_rx_wr[ISERT_MIN_POSTED_RX];
+	struct iscsi_conn	*conn;
+	struct list_head	conn_accept_node;
+	struct completion	conn_login_comp;
+	struct iser_tx_desc	conn_login_tx_desc;
+	struct rdma_cm_id	*conn_cm_id;
+	struct ib_pd		*conn_pd;
+	struct ib_cq		*conn_rx_cq;
+	struct ib_cq		*conn_tx_cq;
+	struct ib_mr		*conn_mr;
+	struct ib_qp		*conn_qp;
+	struct tasklet_struct	conn_rx_tasklet;
+	struct tasklet_struct	conn_tx_tasklet;
+	struct work_struct	conn_logout_work;
+	wait_queue_head_t	conn_wait;
+	struct kref		conn_kref;
+};
+
+struct isert_np {
+	wait_queue_head_t	np_accept_wq;
+	struct rdma_cm_id	*np_cm_id;
+	struct mutex		np_accept_mutex;
+	struct list_head	np_accept_list;
+	struct completion	np_login_comp;
+};
diff --git a/drivers/infiniband/ulp/isert/isert_proto.h b/drivers/infiniband/ulp/isert/isert_proto.h
new file mode 100644
index 0000000..ae38b92
--- /dev/null
+++ b/drivers/infiniband/ulp/isert/isert_proto.h
@@ -0,0 +1,47 @@
+/* From iscsi_iser.h */
+
+struct iser_hdr {
+	u8	flags;
+	u8	rsvd[3];
+	__be32	write_stag; /* write rkey */
+	__be64	write_va;
+	__be32	read_stag;  /* read rkey */
+	__be64	read_va;
+} __attribute__((packed));
+
+/*Constant PDU lengths calculations */
+#define ISER_HEADERS_LEN  (sizeof(struct iser_hdr) + sizeof(struct iscsi_hdr))
+
+#define ISER_RECV_DATA_SEG_LEN  8192
+#define ISER_RX_PAYLOAD_SIZE    (ISER_HEADERS_LEN + ISER_RECV_DATA_SEG_LEN)
+#define ISER_RX_LOGIN_SIZE      (ISER_HEADERS_LEN + ISCSI_DEF_MAX_RECV_SEG_LEN)
+
+/* QP settings */
+/* Maximal bounds on received asynchronous PDUs */
+#define ISERT_MAX_TX_MISC_PDUS	4 /* NOOP_IN(2) , ASYNC_EVENT(2)   */
+
+#define ISERT_MAX_RX_MISC_PDUS	6 /* NOOP_OUT(2), TEXT(1),         *
+                                           * SCSI_TMFUNC(2), LOGOUT(1) */
+
+#define ISCSI_DEF_XMIT_CMDS_MAX 128	/* from libiscsi.h, must be power of 2 */
+
+#define ISERT_QP_MAX_RECV_DTOS	(ISCSI_DEF_XMIT_CMDS_MAX)
+
+#define ISERT_MIN_POSTED_RX	(ISCSI_DEF_XMIT_CMDS_MAX >> 2)
+
+#define ISERT_INFLIGHT_DATAOUTS	8
+
+#define ISERT_QP_MAX_REQ_DTOS	(ISCSI_DEF_XMIT_CMDS_MAX *    \
+				(1 + ISERT_INFLIGHT_DATAOUTS) + \
+				ISERT_MAX_TX_MISC_PDUS	+ \
+				ISERT_MAX_RX_MISC_PDUS)
+
+#define ISER_RX_PAD_SIZE	(16384 - (ISER_RX_PAYLOAD_SIZE + \
+					sizeof(u64) + sizeof(struct ib_sge)))
+
+#define ISER_VER	0x10
+#define ISER_WSV	0x08
+#define ISER_RSV	0x04
+#define ISCSI_CTRL	0x10
+#define ISER_HELLO	0x20
+#define ISER_HELLORPLY	0x30
-- 
1.7.2.5

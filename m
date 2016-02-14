From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 28/34] cxgbit: add cxgbit_lro.h
Date: Sun, 14 Feb 2016 23:15:35 +0530
Message-ID: <69025e48524c849494e081b3b9313dfe7f4d68d0.1455467089.git.varun@chelsio.com>
References: <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

This file contains data structure
definitions for LRO support.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/cxgbit/cxgbit_lro.h | 70 ++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)
 create mode 100644 drivers/target/iscsi/cxgbit/cxgbit_lro.h

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_lro.h b/drivers/target/iscsi/cxgbit/cxgbit_lro.h
new file mode 100644
index 0000000..74c840d
--- /dev/null
+++ b/drivers/target/iscsi/cxgbit/cxgbit_lro.h
@@ -0,0 +1,70 @@
+/*
+ * Copyright (c) 2016 Chelsio Communications, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ *
+ */
+
+#ifndef	__CXGBIT_LRO_H__
+#define	__CXGBIT_LRO_H__
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/skbuff.h>
+
+#define LRO_FLUSH_TOTALLEN_MAX	65535
+
+struct cxgbit_lro_cb {
+	struct cxgbit_sock *csk;
+	u32 pdu_totallen;
+	u32 offset;
+	u8 pdu_cnt;
+	bool release;
+};
+
+enum cxgbit_pducb_flags {
+	PDUCBF_RX_HDR		= (1 << 0), /* received pdu header */
+	PDUCBF_RX_DATA		= (1 << 1), /* received pdu payload */
+	PDUCBF_RX_STATUS	= (1 << 2), /* received ddp status */
+	PDUCBF_RX_DATA_DDPD	= (1 << 3), /* pdu payload ddp'd */
+	PDUCBF_RX_HCRC_ERR	= (1 << 4), /* header digest error */
+	PDUCBF_RX_DCRC_ERR	= (1 << 5), /* data digest error */
+};
+
+struct cxgbit_lro_pdu_cb {
+	u8 flags;
+	u8 frags;
+	u8 nr_dfrags;
+	u8 dfrag_index;
+	u32 seq;
+	u32 pdulen;
+	u32 hlen;
+	u32 dlen;
+	u32 doffset;
+	u32 ddigest;
+	void *hdr;
+};
+
+#define LRO_SKB_MAX_HEADROOM  \
+		(sizeof(struct cxgbit_lro_cb) + \
+		 MAX_SKB_FRAGS * sizeof(struct cxgbit_lro_pdu_cb))
+
+#define LRO_SKB_MIN_HEADROOM  \
+		(sizeof(struct cxgbit_lro_cb) + \
+		 sizeof(struct cxgbit_lro_pdu_cb))
+
+#define cxgbit_skb_lro_cb(skb)	((struct cxgbit_lro_cb *)skb->data)
+#define cxgbit_skb_lro_pdu_cb(skb, i)	\
+	((struct cxgbit_lro_pdu_cb *)(skb->data + sizeof(struct cxgbit_lro_cb) \
+					+ i * sizeof(struct cxgbit_lro_pdu_cb)))
+
+#define CPL_RX_ISCSI_DDP_STATUS_DDP_SHIFT	16 /* ddp'able */
+#define CPL_RX_ISCSI_DDP_STATUS_PAD_SHIFT	19 /* pad error */
+#define CPL_RX_ISCSI_DDP_STATUS_HCRC_SHIFT	20 /* hcrc error */
+#define CPL_RX_ISCSI_DDP_STATUS_DCRC_SHIFT	21 /* dcrc error */
+
+#endif	/*__CXGBIT_LRO_H_*/
-- 
2.0.2

Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B873A946C;
	Tue, 17 Mar 2026 07:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773732343; cv=none; b=pRQ5XYbRkUVTywUZDHyGDjM7brmEMNa5hgY5/L/lSKRJN4zmbf64xjKUO9b7mG3OHplmiNKRdNkrml+uBdonx3qUTmiQAFMRwr5ue9/mkcVpJb664e/QtcALTs131XrtNLxLINn3o8cpA05vFictAvWIhaix8U7BwvaJ4GtDi7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773732343; c=relaxed/simple;
	bh=RYu/Hlzy4M1NMLc3Xhe8UGrQf4l5omMwfSrz1Eps63w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=upjxlRVVaXmWkB3STpf19lsFSOsNoDLIJodBoHyA0xJ55MbZzjsloMIBuRhxaP7BqITfG+J5JaOCnmfICmJx/Y06pWaCO2EZXyKTP/ERE7WeLn7kgNJqAaISxv/zqHf+/PG+6bCG0+EzQcI9nf+sWYaQkhCEUYXecQ3DQH8K02o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=B2/B/tRX; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="B2/B/tRX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=VV
	Awc+xdn6yxKxTFGsxyf3leIZLjYYGFor99fkx3VcY=; b=B2/B/tRXLqRU3I6JI1
	nHtyO0tNTNiJHdb/Q/jSIbQFETEb1gblYnPNEhAb7NgqSA/g1wijUDUwe4Ee8vmt
	3I1jLZhztTaNOmUmMaa9jZ/xTepvKI4dsDiD10xOt/3iqlCPjHbkaimvlzZwQ1UQ
	l05QyjVVHFaqbF36Um1GCaeCk=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgCnhdw1AblpkrBDWA--.58229S3;
	Tue, 17 Mar 2026 15:22:33 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk,
	fujita.tomonori@lab.ntt.co.jp,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	bvanassche@acm.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v8 1/3] bsg: add bsg_uring_cmd uapi structure
Date: Tue, 17 Mar 2026 15:22:24 +0800
Message-Id: <20260317072226.2598233-2-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260317072226.2598233-1-yangxiuwei@kylinos.cn>
References: <20260317072226.2598233-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgCnhdw1AblpkrBDWA--.58229S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxCr4xGry7Zw43Kw17tF1fWFg_yoW5ZFWxpF
	Z8Kw43JFWUWw1fZrW3Ja4UCFW5Zr18Ja47Kay7Wwnak3W5tryrA3WjkryjqF48X39Yy34a
	v3W7trW5C3yktw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jexRDUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwhkXp2m5ATmARwAA3E

Add the bsg_uring_cmd structure to the BSG UAPI header to support
io_uring-based SCSI passthrough operations via IORING_OP_URING_CMD.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 include/uapi/linux/bsg.h | 75 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/include/uapi/linux/bsg.h b/include/uapi/linux/bsg.h
index cd6302def5ed..6cff77f5b857 100644
--- a/include/uapi/linux/bsg.h
+++ b/include/uapi/linux/bsg.h
@@ -2,6 +2,9 @@
 #ifndef _UAPIBSG_H
 #define _UAPIBSG_H
 
+#ifdef __KERNEL__
+#include <linux/build_bug.h>
+#endif /* __KERNEL__ */
 #include <linux/types.h>
 
 #define BSG_PROTOCOL_SCSI		0
@@ -63,5 +66,77 @@ struct sg_io_v4 {
 	__u32 padding;
 };
 
+struct bsg_uring_cmd {
+	__u64 request;		/* [i], [*i] command descriptor address */
+	__u32 request_len;	/* [i] command descriptor length in bytes */
+	__u32 protocol;		/* [i] protocol type (BSG_PROTOCOL_*) */
+	__u32 subprotocol;	/* [i] subprotocol type (BSG_SUB_PROTOCOL_*) */
+	__u32 max_response_len;	/* [i] response buffer size in bytes */
+
+	__u64 response;		/* [i], [*o] response data address */
+	__u64 dout_xferp;	/* [i], [*i] */
+	__u32 dout_xfer_len;	/* [i] bytes to be transferred to device */
+	__u32 dout_iovec_count;	/* [i] 0 -> "flat" dout transfer else
+				 * dout_xferp points to array of iovec
+				 */
+	__u64 din_xferp;	/* [i], [*o] */
+	__u32 din_xfer_len;	/* [i] bytes to be transferred from device */
+	__u32 din_iovec_count;	/* [i] 0 -> "flat" din transfer */
+
+	__u32 timeout_ms;	/* [i] timeout in milliseconds */
+	__u8  reserved[12];	/* reserved for future extension */
+};
+
+#ifdef __KERNEL__
+/* Must match IORING_OP_URING_CMD payload size (e.g. SQE128). */
+static_assert(sizeof(struct bsg_uring_cmd) == 80);
+#endif /* __KERNEL__ */
+
+
+/*
+ * SCSI BSG io_uring completion (res2, 64-bit)
+ *
+ * When using BSG_PROTOCOL_SCSI + BSG_SUB_PROTOCOL_SCSI_CMD with
+ * IORING_OP_URING_CMD, the completion queue entry (CQE) contains:
+ *   - result: errno (0 on success)
+ *   - res2: packed SCSI status
+ *
+ * res2 bit layout:
+ *   [0..7]   device_status  (SCSI status byte, e.g. CHECK_CONDITION)
+ *   [8..15]  driver_status  (e.g. DRIVER_SENSE when sense data is valid)
+ *   [16..23] host_status    (e.g. DID_OK, DID_TIME_OUT)
+ *   [24..31] sense_len_wr   (bytes of sense data written to response buffer)
+ *   [32..63] resid_len      (residual transfer length)
+ */
+static inline __u8 bsg_scsi_res2_device_status(__u64 res2)
+{
+	return res2 & 0xff;
+}
+static inline __u8 bsg_scsi_res2_driver_status(__u64 res2)
+{
+	return res2 >> 8;
+}
+static inline __u8 bsg_scsi_res2_host_status(__u64 res2)
+{
+	return res2 >> 16;
+}
+static inline __u8 bsg_scsi_res2_sense_len(__u64 res2)
+{
+	return res2 >> 24;
+}
+static inline __u32 bsg_scsi_res2_resid_len(__u64 res2)
+{
+	return res2 >> 32;
+}
+static inline __u64 bsg_scsi_res2_build(__u8 device_status, __u8 driver_status,
+					__u8 host_status, __u8 sense_len_wr,
+					__u32 resid_len)
+{
+	return ((__u64)(__u32)(resid_len) << 32) |
+		((__u64)sense_len_wr << 24) |
+		((__u64)host_status << 16) |
+		((__u64)driver_status << 8) |
+		(__u64)device_status;
+}
 
 #endif /* _UAPIBSG_H */
-- 
2.25.1


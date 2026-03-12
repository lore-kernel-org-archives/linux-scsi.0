Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E837337648D;
	Thu, 12 Mar 2026 09:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773307438; cv=none; b=A1dV+RvUQ5JcWBsS3EWPKrS3bWcafRTVcfVTTDt1ZJ5L1tGs1Ygyr3c430d11ywB/hMPKY3eiMmOEYAHKmCdsr10eALxX0hrcIHIgbAUkyC1s7a+KmUq40Jvi7/dsmX1t4WXuhNWf1yibKdymYlgl1FQ6BR1gZBXswVFYR9o/bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773307438; c=relaxed/simple;
	bh=T01e8uCCN0bl8hso7tWF+T2tLzx+D/e6Am6ptrAUPMU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=raoy7H0ZfMMyZxv5I4W3wv19NzW/3Dh7wuLbHFikoPSf3mh5O4/l/KlQ8ZJuRnmEtkKqcF03udSSovB1xGziAE1Xml7dt91Njx/Muu4VNV+15ZNaOZM1kWPBtMGGg/vqgFwG7oojfE8hKlWiRTZ88deFveaVU5aemZdAmFEA8JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ocuH0/dN; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ocuH0/dN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=j+
	aGSEZZtgdvqbWm66L5+yY/BK2NFwjcYx9a6LJE9RI=; b=ocuH0/dN4k85Ux1Oi+
	5h28RqvGiQLZmmiXC1+Vnxlp0KnoyAsASivitbICPH/T+/RwOv5uw9q7wdjMP9IS
	Ck2VaFe3LrB94ZKiSPy28H1a/EtCnuCdHdeocwgNtCcSxq1r2p8HlHPdrDNOBOkI
	8m/lU4oKrrWtUTQwrJFc/Ot2A=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDn0tbfhbJpu7uqAQ--.55S3;
	Thu, 12 Mar 2026 17:22:50 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk,
	fujita.tomonori@lab.ntt.co.jp,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	bvanassche@acm.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v7 1/3] bsg: add bsg_uring_cmd uapi structure
Date: Thu, 12 Mar 2026 17:22:35 +0800
Message-Id: <20260312092237.2464560-2-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260312092237.2464560-1-yangxiuwei@kylinos.cn>
References: <20260312092237.2464560-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDn0tbfhbJpu7uqAQ--.55S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxCr4xGryrJr4fCw4Uury5CFg_yoW5WF4kpF
	90kw4ayrW5Wr42krW3Xa4UCay5Zr48t342g39rAw1a9w1YqF18uF1j93WSqa1Iqw4kt34Y
	vrnFqryDCwn2yaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jexRDUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwgqiM2myheqg7AAA3h

Add the bsg_uring_cmd structure to the BSG UAPI header to support
io_uring-based SCSI passthrough operations via IORING_OP_URING_CMD.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 include/uapi/linux/bsg.h | 49 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/include/uapi/linux/bsg.h b/include/uapi/linux/bsg.h
index cd6302def5ed..757118660d86 100644
--- a/include/uapi/linux/bsg.h
+++ b/include/uapi/linux/bsg.h
@@ -63,5 +63,54 @@ struct sg_io_v4 {
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
+/*
+ * SCSI BSG io_uring completion (res2, 64-bit)
+ *
+ * When using BSG_PROTOCOL_SCSI + BSG_SUB_PROTOCOL_SCSI_CMD with
+ * IORING_OP_URING_CMD, the completion queue entry (CQE) contains:
+ *   - result: errno (0 on success)
+ *   - res2: packed SCSI status; see macros below to decode.
+ *
+ * res2 bit layout:
+ *   [0..7]   device_status  (SCSI status byte, e.g. CHECK_CONDITION)
+ *   [8..15]  driver_status  (e.g. DRIVER_SENSE when sense data is valid)
+ *   [16..23] host_status    (e.g. DID_OK, DID_TIME_OUT)
+ *   [24..31] sense_len_wr   (bytes of sense data written to response buffer)
+ *   [32..63] resid_len      (residual transfer length)
+ */
+#define BSG_SCSI_RES2_DEVICE_STATUS(res2)   ((__u8)((__u64)(res2) & 0xff))
+#define BSG_SCSI_RES2_DRIVER_STATUS(res2)   ((__u8)((__u64)(res2) >> 8))
+#define BSG_SCSI_RES2_HOST_STATUS(res2)     ((__u8)((__u64)(res2) >> 16))
+#define BSG_SCSI_RES2_SENSE_LEN(res2)       ((__u8)((__u64)(res2) >> 24))
+#define BSG_SCSI_RES2_RESID_LEN(res2)       ((__u32)((__u64)(res2) >> 32))
+
+#define BSG_SCSI_RES2_BUILD(device_status, driver_status, host_status,   \
+			    sense_len_wr, resid_len)			\
+	(((__u64)(__u32)(resid_len) << 32) |				\
+	 ((__u64)(__u8)(sense_len_wr) << 24) |				\
+	 ((__u64)(__u8)(host_status) << 16) |				\
+	 ((__u64)(__u8)(driver_status) << 8) |				\
+	 ((__u64)(__u8)(device_status)))
 
 #endif /* _UAPIBSG_H */
-- 
2.25.1


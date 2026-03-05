Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C79323EAAB;
	Thu,  5 Mar 2026 01:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772674191; cv=none; b=NrfZG9IY77Lj2EyrbyBhBdgkse9Q/Ps0YIV7R6tNT246tA/rPPlvdxCvGQn/gSs4WCAa+rqjeZ36VKjPkPjnt7wsAN2pAM8CrQRXT2yc/if63AHkrVwiEzPlO5LXyDBLZrNNzBbkHGzYgvtboSbXFy1C/iD5rlxvjyqRadR0DiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772674191; c=relaxed/simple;
	bh=4nhnK/caT+5lVyHZhvTwEdE//w0eYhU8dWxnE45mTEY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PPQd0nY5t8+BmnFsevukEWwaYxCiza7QiGB61Bykv8g6MoBAnFKOgd46fNTbsH3knFOeQihH5WakNT+84YTkSJdypY+V97DM0w9i1Tb6WSdagaGA7yJqCZk/JPI9/8b3rSS9AcvrzCzZ3Nwq3+Nf3trQHvjAJmke4uMzns8lLmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=HAzPNtBp; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="HAzPNtBp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=1Y
	BNzXxLpA3HY1a54/AnAdwwruJdKBfVzW9rKDno53k=; b=HAzPNtBpghsoi0cjHd
	clSRJTLKmnMAHejPqdkV3jlsx+IuqRuJNd/NF+lFzVpeZsDL0eCUeAiIVzrfzq8Z
	IpUAuQRUWW9YgHvkpIFlzm4p8plQEX6LSXQBI48tgMAjTIc/gM+i2tkZzBVpeDU8
	YG1ovE4kQpWeOD3keajdMReUI=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wBXMO9b3Khp6W63OA--.24976S3;
	Thu, 05 Mar 2026 09:29:05 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v6 1/3] bsg: add bsg_uring_cmd uapi structure
Date: Thu,  5 Mar 2026 09:28:55 +0800
Message-Id: <20260305012857.2136525-2-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260305012857.2136525-1-yangxiuwei@kylinos.cn>
References: <20260304080313.675768-1-yangxiuwei@kylinos.cn>
 <20260305012857.2136525-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXMO9b3Khp6W63OA--.24976S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF1xJF4fWFWfXF4xJFWUurg_yoW8XrWfpF
	s8Kw4fXFWUWw4I9r43Wa4jka4YqF40y3W7G3y7Zrn093Z0qFy8Ar4UCF4UK3Wjq39rAry0
	9r17trZ8Cw4jvw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jUzV8UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QHTZGmo3GGYEwAA3o

Add the bsg_uring_cmd structure to the BSG UAPI header to support
io_uring-based SCSI passthrough operations via IORING_OP_URING_CMD.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 include/uapi/linux/bsg.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/uapi/linux/bsg.h b/include/uapi/linux/bsg.h
index cd6302def5ed..983c6e2b6871 100644
--- a/include/uapi/linux/bsg.h
+++ b/include/uapi/linux/bsg.h
@@ -63,5 +63,26 @@ struct sg_io_v4 {
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
+	__u32 flags;		/* [i] bit mask */
+	__u8  reserved[8];	/* reserved for future extension */
+};
 
 #endif /* _UAPIBSG_H */
-- 
2.25.1


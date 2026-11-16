Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.193
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788381;
	b=LXmZoJL9XmA6IB7/BpFTowl0n4IQ22ovXWfNI5N9PIk3BzhSxx6w0EBPa3TjEomzuhbj
	 wrL8luSZ8TWjL0miRJnRRLXW+1aBSMqmiSX5NdKQ2Dx2xoz5AAHVQfsdRWMISwzRM8Gnz
	 gTM49k6kq8laK0yPKi1msO3SkykLOPdA/CjKraUcrjphcqy3p5hZ2p13TcsiB8G/4/Ihk
	 ICXhwzFFoNACyEVuQEO59sIo233wV50tuTkBvS8iYRMcbTKTI89NS1Eg8OeQmZF/t3bT5
	 yAZqg0WwTBIWbt9VSc0cFDg28VaAapDWnrRuCFnZ39C8ub7W0C9nYxPd7qbckEvjcSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788381;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=YWNWzU+sAi4YSRb/iVqUcJ9Q9hOUWI/RmfSUeN1egCY=;
	b=UMLgoRoY78kry2UIochN5Lf+ZQ84wxRXvDSZoZvxGIKt+GWFqyhBtUszZ4ApCbI1em/U
	 T0EvgJc19rbpep8kbdq6iRz+SCpSAryintoQCxoNbVt6ZrTrbUiy9CSaQcoj0ympsmvVO
	 vmwfI0Cq+LgP1VbDe3bdJ7knLO2y1gMkFxR6XrAfAZFtGhzskrMcFPG+pEmPeBJFBpcgz
	 jX6CScJesfFOIXmcSDJajKQPelT7kNgrxnhzan5whbAWGpy2x607o4+rTgfjZHki/rqey
	 yy4gYc+wPpCUPzXtL2n+R/CXiL0jVVwG2Rm8iqAORyV8r4EEKI0lXSJ3h2Hf1cWwWuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=F49pYo7g;
	arc=none smtp.remote-ip=95.215.58.193
Received: from mta1.migadu.com (out-193.mta1.migadu.com [95.215.58.193])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693BA606A882
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 00:19:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 693BA606A882
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=F49pYo7g
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0FWeIS8U8U2Ah43sIfGLQVftVHXgr5aFNYqRFVAa/bc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794788378; v=1; x=1795393178;
 b=F49pYo7g9XflLiD2uRIc7vPKmHg6r8bOlVnUy+Pj0jI3Ru3rggZU3A0VIu6mdOozLcI7j7HT
 7/gmh3oJAtdXMtSQRMSZns3n6aZELw2pWE8cj4YS04KZWy8Q4ogj7w8Y+z/G9uYE+6Cn+tf4i0x
 9i0uxMlE1Wk33Nys9eMvREiI=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1cce60d9ce0f2eee;
	Mon, 16 Nov 2026 00:19:38 +0000
X-Mizu-Trace-ID: 1cce60d9ce0f2eee
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Sun, 15 Nov 2026 19:18:05 -0500
Subject: [PATCH RFC 12/18] scsi: target: uring: Support SYNCHRONIZE CACHE
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-feat-target-core-uring-v1-12-28cdc137eac6@linux.dev>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
In-Reply-To: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
To: "Martin K. Petersen" <mkp@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, Mike Christie <michael.christie@oracle.com>, 
 Bodo Stroesser <bostroesser@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0

target_core_uring only passes reads and writes to the server.

A server that caches writes has no way to learn that the initiator
wants them on stable storage.

Add TCMUR_OP_FLUSH and send it for SYNCHRONIZE CACHE. The descriptor
carries the range to flush; a zero length means up to the end of the
device.

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/target/target_core_uring.c     | 14 +++++++++++++-
 include/uapi/linux/target_core_uring.h |  1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_core_uring.c
index 629419a4c8f46..f39bf7bf36d0f 100644
--- a/drivers/target/target_core_uring.c
+++ b/drivers/target/target_core_uring.c
@@ -237,7 +237,8 @@ static sense_reason_t tcmur_submit(struct se_cmd *se_cmd, u32 op, u64 offset,
 	tcmd->desc.op = op;
 	tcmd->desc.offset = offset;
 	tcmd->desc.len = len;
-	tcmd->desc.data_len = se_cmd->data_length;
+	if (sgl)
+		tcmd->desc.data_len = se_cmd->data_length;
 	if (op == TCMUR_OP_WRITE && (se_cmd->se_cmd_flags & SCF_FUA))
 		tcmd->desc.flags |= TCMUR_IO_F_FUA;
 
@@ -257,6 +258,16 @@ static sense_reason_t tcmur_execute_rw(struct se_cmd *se_cmd,
 			    se_cmd->data_length, sgl, sgl_nents);
 }
 
+static sense_reason_t tcmur_execute_sync_cache(struct se_cmd *se_cmd)
+{
+	u32 block_size = se_cmd->se_dev->dev_attrib.block_size;
+
+	/* Pass a zero length to flush up to the end of the device */
+	return tcmur_submit(se_cmd, TCMUR_OP_FLUSH,
+			    se_cmd->t_task_lba * block_size,
+			    se_cmd->data_length, NULL, 0);
+}
+
 static void tcmur_tmr_notify(struct se_device *dev, enum tcm_tmreq_table tmf,
 			     struct list_head *aborted_cmds)
 {
@@ -929,6 +940,7 @@ static sector_t tcmur_get_blocks(struct se_device *dev)
 
 static struct exec_cmd_ops tcmur_exec_cmd_ops = {
 	.execute_rw		= tcmur_execute_rw,
+	.execute_sync_cache	= tcmur_execute_sync_cache,
 };
 
 static sense_reason_t tcmur_parse_cdb(struct se_cmd *se_cmd)
diff --git a/include/uapi/linux/target_core_uring.h b/include/uapi/linux/target_core_uring.h
index 8b95be853753c..a1d8ae47ebf7d 100644
--- a/include/uapi/linux/target_core_uring.h
+++ b/include/uapi/linux/target_core_uring.h
@@ -67,6 +67,7 @@ struct tcmur_io_cmd {
 enum tcmur_io_op {
 	TCMUR_OP_READ,
 	TCMUR_OP_WRITE,
+	TCMUR_OP_FLUSH,
 };
 
 /* Put the write on stable storage before completing it */

-- 
2.43.0


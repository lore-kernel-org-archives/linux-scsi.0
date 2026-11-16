Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.202
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788393;
	b=e8+h+z5aUFqmJolFu3r4fWajYPxOY0qo44x2pUeiCb0mbonTavkFQ735Zn05/Soy9sVZ
	 q5STOelLtfae32sZkJIGrTOU4Pw5H0FtLrt9PCHNUPlzN/CIk0KVQryqc5TgYktoGo9kU
	 XzJ+iEnsPgFSgiLRCQnsaipJq0Ls0OijogQl5JiQfQ6LmD1izU46dl930oc4swrzcH+PY
	 HquVmPIbL9ZqLnndupAcQ97FLj7L69K8Kdr+Pn6aOhpRkyGoTT6AL2qXHvnu5cIomUfKw
	 Tvof9xhquk2uq0RpnJViQ3DY/5MPmZ88c3Kw++pOMn6u7xgsccYlDJMwVEN8+TdMhgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788393;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=/DvcrPnmu92vL1+Z1FDAy2MlBQdn5ri0ucAIPhPkLJ0=;
	b=rvEh0Uszizx64mC+5eL/6DHmuliP7hUUQ4+JPEqonNABWe1m7z21aIuzI4+NM7uHbPEk
	 potYpSKrm1PS2XjFS4/HVW25ene+00q3CbKUM/8jhfr/Fs4P486c58Tf9JJzAORwwLGVO
	 V52gMNwHFuCNmINtCp+fs8aqc7Nf99dy8P0XVuqu5UUHN3YqISPu1JGo2PhVSiNe3/4cV
	 b3+nNAtPT4RS6C9B89mIelC8woG6YsgSILWcTrC9IHdbh65o0nOZGZluTCsAEllTgqYOJ
	 fZUKS6CTQi11MTUDWGx6y6R8LNKnH2r4KdPXM5nu4jGUYqND6HG/jPKGSAWuA4pSyCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nOdJc61A;
	arc=none smtp.remote-ip=95.215.58.202
Received: from mta1.migadu.com (out-202.mta1.migadu.com [95.215.58.202])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3079F606A330
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 00:19:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3079F606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nOdJc61A
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GpehgTaud2Pfhp2jXZFOd3rjXU3YNVsMj+zIz7rtWoU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794788391; v=1; x=1795393191;
 b=nOdJc61Aq6Ywg+LHRI0H78YKoO49t1BBGOYCqFhfz/6EaNOyCzJxYP+y+tPGf3QGQKYlZjhm
 HADmuEaujI/mRBPqlwtxFqkueRDeQZ0D/+jjJB74uqs311Iam8Avb5jTqJd4gHLDDlqARFKZzs/
 W8PRUn9Q0fLnswSH1lPgFw3I=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0cc090cd4e7b3a72;
	Mon, 16 Nov 2026 00:19:51 +0000
X-Mizu-Trace-ID: 0cc090cd4e7b3a72
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Sun, 15 Nov 2026 19:18:07 -0500
Subject: [PATCH RFC 14/18] scsi: target: uring: Handle WRITE SAME
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
Message-Id: <20261115-feat-target-core-uring-v1-14-28cdc137eac6@linux.dev>
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

target_core_uring does not set execute_write_same(), so the core rejects
WRITE SAME without the UNMAP bit.

Initiators use it to zero or initialize ranges without sending the data
for every block.

Add TCMUR_OP_WRITE_SAME. The descriptor carries the range to fill, and
the data of the command is the one block to repeat. Accept up to 65536
blocks per command.

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/target/target_core_uring.c     | 14 ++++++++++++++
 include/uapi/linux/target_core_uring.h |  9 +++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_core_uring.c
index 366c5e9820956..42283a1ae1512 100644
--- a/drivers/target/target_core_uring.c
+++ b/drivers/target/target_core_uring.c
@@ -30,6 +30,8 @@
 #define TCMUR_VERSION		"1.0"
 #define TCMUR_MINORS		(1U << MINORBITS)
 #define TCMUR_MAX_IO_SIZE	(4U << 20)
+/* Limit one WRITE SAME to this many blocks */
+#define TCMUR_MAX_WRITE_SAME_LEN	0x10000
 #define TCMUR_DEF_QUEUE_DEPTH	128
 #define TCMUR_DEF_BLOCK_SIZE	512
 #define TCMUR_DEF_CMD_TIMEOUT	30
@@ -295,6 +297,16 @@ static sense_reason_t tcmur_execute_unmap(struct se_cmd *se_cmd, sector_t lba,
 	return tcmd.status ? TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE : 0;
 }
 
+static sense_reason_t tcmur_execute_write_same(struct se_cmd *se_cmd)
+{
+	u32 block_size = se_cmd->se_dev->dev_attrib.block_size;
+
+	return tcmur_submit(se_cmd, TCMUR_OP_WRITE_SAME,
+			    se_cmd->t_task_lba * block_size,
+			    (u64)sbc_get_write_same_sectors(se_cmd) * block_size,
+			    se_cmd->t_data_sg, se_cmd->t_data_nents);
+}
+
 static bool tcmur_configure_unmap(struct se_device *dev)
 {
 	dev->dev_attrib.max_unmap_lba_count = UINT_MAX /
@@ -813,6 +825,7 @@ static int tcmur_configure_device(struct se_device *dev)
 	dev->dev_attrib.hw_block_size = udev->block_size;
 	dev->dev_attrib.hw_max_sectors = TCMUR_MAX_IO_SIZE / udev->block_size;
 	dev->dev_attrib.hw_queue_depth = udev->nr_queues * udev->queue_depth;
+	dev->dev_attrib.max_write_same_len = TCMUR_MAX_WRITE_SAME_LEN;
 	dev->dev_attrib.is_nonrot = 1;
 
 	udev->cdev_dev.devt = MKDEV(MAJOR(tcmur_devt), udev->dev_id);
@@ -979,6 +992,7 @@ static struct exec_cmd_ops tcmur_exec_cmd_ops = {
 	.execute_rw		= tcmur_execute_rw,
 	.execute_sync_cache	= tcmur_execute_sync_cache,
 	.execute_unmap		= tcmur_execute_unmap,
+	.execute_write_same	= tcmur_execute_write_same,
 };
 
 static sense_reason_t tcmur_parse_cdb(struct se_cmd *se_cmd)
diff --git a/include/uapi/linux/target_core_uring.h b/include/uapi/linux/target_core_uring.h
index 9df10558cfa9e..469340b152f15 100644
--- a/include/uapi/linux/target_core_uring.h
+++ b/include/uapi/linux/target_core_uring.h
@@ -69,6 +69,7 @@ enum tcmur_io_op {
 	TCMUR_OP_WRITE,
 	TCMUR_OP_FLUSH,
 	TCMUR_OP_UNMAP,
+	TCMUR_OP_WRITE_SAME,
 };
 
 /* Put the write on stable storage before completing it */
@@ -80,7 +81,7 @@ enum tcmur_io_op {
  * @flags:	TCMUR_IO_F_*
  * @offset:	Start of the range in bytes
  * @len:	Length of the range in bytes
- * @data_len:	Bytes of data to transfer
+ * @data_len:	Bytes of data to transfer; one block for TCMUR_OP_WRITE_SAME
  * @reserved:	Zero
  *
  * The descriptors of a queue form an array indexed by tag, which the server
@@ -99,9 +100,9 @@ struct tcmur_io_desc {
 	(TCMUR_MAX_QUEUE_DEPTH * sizeof(struct tcmur_io_desc))
 
 /*
- * The data of a command is read (TCMUR_OP_WRITE) or written
- * (TCMUR_OP_READ) with pread()/pwrite() on the file, at the position
- * returned by tcmur_buf_pos().
+ * The data of a command is read (TCMUR_OP_WRITE, TCMUR_OP_WRITE_SAME) or
+ * written (TCMUR_OP_READ) with pread()/pwrite() on the file, at the
+ * position returned by tcmur_buf_pos().
  */
 #define TCMUR_BUF_TAG_SHIFT	32
 #define TCMUR_BUF_QID_SHIFT	48

-- 
2.43.0


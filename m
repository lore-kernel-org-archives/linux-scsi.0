Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.57
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788400;
	b=FlwG1vrUitnH3q3jIhJdoC2RnxM0kJOztnMfutTFS1UGK4WEO8IEY9ld6cMz96tfbVyJ
	 ba2ltx0INzppDClpHucaZAnZslBmqUBrJT8fv2PjiWI26hs3vfvJIWgyj7Hg8oLU6VDjj
	 gLsE80zKg1LflNIsgZPsW67c7FsyqjwrIyv3gZRqCAK6XxgF5mn4+sqcfGu1MrR+HkrOS
	 OEZB1Gbu84DkaguauJvvV+fN97M6XgDaST4DcJf9M8mxq9i7xyVdcFaRSevmubl31CV2/
	 52v1dmUrXsqgCcvJwuRy7WMAkD6j1vBXHEarHuT+crNJzl77jR44AazjLxoGtTBIxxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788400;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=Fey+fb0AyjftoFZmQ0EK4zMD6FbYtb7HncNqSOZbYz8=;
	b=sLdP5A3ttRBh2oLoe4DcyVz0+tPSjz8uzEtuqSQjdvOVsLtIC7QsZR3kvIxF9mJ+JZo/
	 NXbbaASjVoAnsIBKcVMfhl0+FRi3oTRWFg8o2YAmdnIlksslEq2bcsT6SN4o4bs+JdN25
	 BNYFHoLecDdTnw4eBHth5yZPr49H8FVZJ2+MMLfuBwwXW61CZdjYtApUnppLoNqV5TKOH
	 t51XilX/EmA7ztGPUp8asFi6M2DkdJ3dd5x648dXwUfumqO3cbl44oFaZBSEPWGoj8U+1
	 sFvtC+X7ivgZ5umGnq09p4WfTK/f1zh7Cy10Wzl8s++XfH0vg4ly+j6N4gco7qqpUaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TPalJ9d4;
	arc=none smtp.remote-ip=91.218.175.57
Received: from mta0.migadu.com (out-57.mta0.migadu.com [91.218.175.57])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43274606A31F
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 00:19:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43274606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TPalJ9d4
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FXepQQOyT3/mJZXQ4rFqUNCryuyhgeXz7UIdUhuHmkM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794788397; v=1; x=1795393197;
 b=TPalJ9d4rVw9E1YTfh6nzNNk7R5A99c/V8ITqknyvhiT5kfGhwXoAlAxHRofSnsuN8vwlDJP
 p0ZnQE2vKiIMMhk7FxhjdW5RSB3ByefMjoRzOuQquRuSRBy6pWSOaNMQXTJ2bS2mAwGY00QEyL6
 knyXCUgHLGWp7fOQHLlZlOJE=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1e3934d81e5fd725;
	Mon, 16 Nov 2026 00:19:57 +0000
X-Mizu-Trace-ID: 1e3934d81e5fd725
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Sun, 15 Nov 2026 19:18:08 -0500
Subject: [PATCH RFC 15/18] scsi: target: uring: Register command data as
 io_uring fixed buffers
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
Message-Id: <20261115-feat-target-core-uring-v1-15-28cdc137eac6@linux.dev>
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

The server of a target_core_uring device copies the data of each command
with pread() or pwrite().

For large commands that copy dominates, although the server often only
passes the data on to a file, a block device or a socket.

Add TCMUR_IO_REGISTER_BUF, which registers the pages of a command as a
fixed buffer of the server's io_uring, and TCMUR_IO_UNREGISTER_BUF. The
server then uses the buffer in fixed read and write requests on its
backing store. Let the buffer hold a reference on the command, so that
the command completes only after the buffer is released.

Exporting a 2 GiB device through tcm_loop to fio (io_uring, direct I/O,
iodepth 32 for 4k and 8 for 1M, 6 seconds per job) on a 32 CPU VM, with
32 queues and a server that keeps the data in a tmpfs file, copying
through a bounce buffer or using fixed buffers. Small commands are
slower with fixed buffers, as each one takes two more io_uring requests;
the server can choose per command. Three alternating runs (median,
min-max in parentheses):

  workload               copy (MB/s)         fixed buffer (MB/s)   change
  4k randread, 16 jobs    5808 (5463-5944)    5217 (5090-5463)       -10%
  4k randwrite, 16 jobs   2023 (1831-2101)    1845 (1571-1850)        -9%
  1M read, 4 jobs        21516 (10137-22138) 44973 (31086-45013)    +109%
  1M write, 4 jobs        5997 (5669-7364)    7430 (5970-8002)       +24%

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/target/target_core_uring.c     | 60 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/target_core_uring.h | 13 ++++++--
 2 files changed, 69 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_core_uring.c
index 42283a1ae1512..4f5cf18b1ec07 100644
--- a/drivers/target/target_core_uring.c
+++ b/drivers/target/target_core_uring.c
@@ -48,8 +48,8 @@ struct tcmur_dev;
  * @sgl:	Data pages of the command
  * @sgl_nents:	Number of entries in @sgl
  * @desc:	What the server is asked to do
- * @ref:	Held by the tag or the pending list and by data copies in
- *		progress
+ * @ref:	Held by the tag or the pending list, by data copies in
+ *		progress and by registered buffers
  * @deadline:	When to give up waiting for the server
  * @done:	Complete this instead of @se_cmd when the last reference goes
  * @status:	SAM status to complete @se_cmd with
@@ -489,6 +489,56 @@ static int tcmur_commit(struct tcmur_queue *q, struct tcmur_io *io, int result)
 	return 0;
 }
 
+static void tcmur_buf_release(void *priv)
+{
+	tcmur_cmd_put(priv);
+}
+
+static int tcmur_register_buf(struct tcmur_dev *udev, u16 q_id, u16 tag,
+			      struct io_uring_cmd *ucmd, unsigned int index,
+			      unsigned int issue_flags)
+{
+	struct tcmur_cmd *tcmd = tcmur_get_cmd(udev, q_id, tag);
+	unsigned int len, n = 0;
+	struct scatterlist *sg;
+	struct bio_vec *bvs;
+	int ret = -EINVAL;
+	u32 left;
+	int i;
+
+	if (!tcmd)
+		return -EINVAL;
+	if (!tcmd->desc.data_len)
+		goto put_cmd;
+
+	bvs = kmalloc_array(tcmd->sgl_nents, sizeof(*bvs), GFP_KERNEL);
+	if (!bvs) {
+		ret = -ENOMEM;
+		goto put_cmd;
+	}
+
+	left = tcmd->desc.data_len;
+	for_each_sg(tcmd->sgl, sg, tcmd->sgl_nents, i) {
+		len = min(sg->length, left);
+		bvec_set_page(&bvs[n++], sg_page(sg), len, sg->offset);
+		left -= len;
+		if (!left)
+			break;
+	}
+
+	/* Keep the command reference until the buffer is released */
+	ret = io_buffer_register_bvec(ucmd, bvs, n, tcmur_buf_release, tcmd,
+				      tcmd->desc.op == TCMUR_OP_READ ?
+				      IO_BUF_DEST : IO_BUF_SOURCE,
+				      index, issue_flags);
+	kfree(bvs);
+	if (!ret)
+		return 0;
+put_cmd:
+	tcmur_cmd_put(tcmd);
+	return ret;
+}
+
 static int tcmur_ch_uring_cmd_local(struct io_uring_cmd *ucmd,
 				    unsigned int issue_flags)
 {
@@ -515,6 +565,12 @@ static int tcmur_ch_uring_cmd_local(struct io_uring_cmd *ucmd,
 		if (ret)
 			return ret;
 		return tcmur_fetch(q, io, ucmd, issue_flags);
+	case TCMUR_IO_REGISTER_BUF:
+		return tcmur_register_buf(udev, q_id, tag, ucmd,
+					  READ_ONCE(ioc->addr), issue_flags);
+	case TCMUR_IO_UNREGISTER_BUF:
+		return io_buffer_unregister(ucmd, READ_ONCE(ioc->addr),
+					    issue_flags);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/include/uapi/linux/target_core_uring.h b/include/uapi/linux/target_core_uring.h
index 469340b152f15..92d3d2fc9c25e 100644
--- a/include/uapi/linux/target_core_uring.h
+++ b/include/uapi/linux/target_core_uring.h
@@ -45,13 +45,14 @@ struct tcmur_dev_info {
  * @tag:	Tag the command is for
  * @result:	TCMUR_IO_COMMIT_AND_FETCH: 0, or a negative errno if the
  *		command failed
- * @reserved1:	Zero
+ * @addr:	TCMUR_IO_REGISTER_BUF and TCMUR_IO_UNREGISTER_BUF: index in the
+ *		buffer table of the ring
  */
 struct tcmur_io_cmd {
 	__u16	q_id;
 	__u16	tag;
 	__s32	result;
-	__u64	reserved1;
+	__u64	addr;
 };
 
 /*
@@ -64,6 +65,14 @@ struct tcmur_io_cmd {
 #define TCMUR_IO_FETCH			_IOWR(0xBB, 0x08, struct tcmur_io_cmd)
 #define TCMUR_IO_COMMIT_AND_FETCH	_IOWR(0xBB, 0x09, struct tcmur_io_cmd)
 
+/*
+ * TCMUR_IO_REGISTER_BUF: register the data pages of the command of
+ * (q_id, tag) as fixed buffer @addr of the ring, so that the server can
+ * do I/O on them without copying. TCMUR_IO_UNREGISTER_BUF removes it.
+ */
+#define TCMUR_IO_REGISTER_BUF		_IOWR(0xBB, 0x0a, struct tcmur_io_cmd)
+#define TCMUR_IO_UNREGISTER_BUF		_IOWR(0xBB, 0x0b, struct tcmur_io_cmd)
+
 enum tcmur_io_op {
 	TCMUR_OP_READ,
 	TCMUR_OP_WRITE,

-- 
2.43.0


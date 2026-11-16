Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788352;
	b=XbJeZ4j3p1kvogmfpVnwJJF8lpShHODRig7PWZR+d2uFo3nzf/hQz4wEToLiOvGiGYLl
	 855i0Ya9ViEfFXxVva98sP2ySP/s88J31PVgu1JCmwYdvRYmFQbFtCrq7bZiCALgbXFp1
	 mUJPKIZcbONxZ+gVmjLJd+ILdKZ40J+ml5cWJyC4cOipT+7+ZdIh+9XAGANXlORFVWPqd
	 ur7lWbXZjiIZaW0h4PjpUY/pqTLGuZR+MBguMMgf0X7thp9ALaQ5opDU1LM00g8jRi58p
	 NWDDAsVrUO435iGX1SVCQW9PpACh+ru4dWxax+l+dw3V4Ew1Zsc6h/bzkbzv1vtJGwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788352;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=qJUANPBrcmUXZH9q6jSZaPiBplp1K6wLWEwNFELnjHc=;
	b=Xf76+ap3ZAWwXGw4G1kc0GrHGa34Z7CLnsuF1MhNVkLJvvpJuPT0F+/PYXJi0vh/ewnp
	 I0Bidiod7IBXgPqy6RRLvnikdxUz8jjZmQMGA3mznw3lI1b00WNKhqjc0Dh9oE7D1LjVF
	 eWNEkUWQgzNS8FlWVLW0wOWPUo70FbOpYye/AQuPCZHbfJeapE/zT4XmkxvzgprqoFZhy
	 PzA2X1a7jOS7xYGwpesBCEYCNtlZBFRaJAnlPGi874upIGpp7ScRLx+wcelmIj/XQuQQl
	 ADLM29N75yODsQQUItgv6f0LfYyD6bbkVjIlMhuIqq7i2hE3TB8+DcS9l7GnqA/7YkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IPf8vUhi;
	arc=none smtp.remote-ip=95.215.58.172
Received: from mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E1D606A32F
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 00:19:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64E1D606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IPf8vUhi
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=rM6vS4HAjcmUGcm6Libw2HvbeosH2oHmDxlTZorpgpA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794788349; v=1; x=1795393149;
 b=IPf8vUhi4/FBP7UUxW0m2AntbR2pvza2o00XTjEwRgG+X5+LECVZ3NXEZwyRElbxBd8v8UZ2
 pIrCcffnsO4xLZPlzOiZwPF9umBW+eHjhph/dRkOQs5bV1YFeYYD7p6FKbHhNQDnwsvv3YasNLB
 0pAPWosra1k8gtOJ+Reg9Y+c=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ba3022391c40b343;
	Mon, 16 Nov 2026 00:19:09 +0000
X-Mizu-Trace-ID: ba3022391c40b343
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Sun, 15 Nov 2026 19:18:01 -0500
Subject: [PATCH RFC 08/18] scsi: target: uring: Copy command data with
 pread() and pwrite()
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
Message-Id: <20261115-feat-target-core-uring-v1-8-28cdc137eac6@linux.dev>
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

The server of a target_core_uring device fetches commands and commits
their results.

It has no access to the data of reads and writes.

Let the server pwrite() the data of a read command and pread() the data
of a write command on the character device, at a position that encodes
the queue, the tag and the offset in the command. Copy straight between
the pages of the command and the buffer of the server, so that the data
is copied once. Hold a reference on the command during the copy, so
that it does not complete underneath.

Exporting a 2 GiB device through tcm_loop to fio (io_uring, direct I/O,
iodepth 32 for 4k and 8 for 1M, 6 seconds per job) on a 32 CPU VM, with
TCM/USER and a single-threaded handler, then with this backstore, 32
queues and one server thread per queue. Both servers keep the data in
memory. A single job is slower; the gain comes with concurrency and with
large I/O. Three alternating runs (median, min-max in parentheses):

  workload               TCM/USER (MB/s)   uring (MB/s)          change
  4k randread, 1 job      426 (409-463)      354 (348-378)         -17%
  4k randread, 4 jobs    1165 (1072-1253)   1466 (1451-1518)       +26%
  4k randread, 16 jobs    920 (916-1162)    6500 (6173-6769)      +607%
  4k randwrite, 16 jobs   793 (711-886)     6070 (5966-6216)      +665%
  1M read, 4 jobs        6019 (5857-6047)  47687 (32175-49464)    +692%
  1M write, 4 jobs       2791 (2649-2907)  28295 (27152-29050)    +914%

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/target/target_core_uring.c     | 89 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/target_core_uring.h | 15 ++++++
 2 files changed, 103 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_core_uring.c
index 770bb665fbe00..3a6f8d25d28e5 100644
--- a/drivers/target/target_core_uring.c
+++ b/drivers/target/target_core_uring.c
@@ -19,6 +19,7 @@
 #include <linux/parser.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
+#include <linux/uio.h>
 #include <linux/vmalloc.h>
 #include <scsi/scsi_proto.h>
 #include <target/target_core_base.h>
@@ -43,7 +44,8 @@ struct tcmur_dev;
  * @sgl:	Data pages of the command
  * @sgl_nents:	Number of entries in @sgl
  * @desc:	What the server is asked to do
- * @ref:	Held by the tag or the pending list
+ * @ref:	Held by the tag or the pending list and by data copies in
+ *		progress
  * @status:	SAM status to complete @se_cmd with
  */
 struct tcmur_cmd {
@@ -232,6 +234,26 @@ static sense_reason_t tcmur_execute_rw(struct se_cmd *se_cmd,
 			    se_cmd->data_length, sgl, sgl_nents);
 }
 
+/* Take a reference on the command the server works on in (@q_id, @tag) */
+static struct tcmur_cmd *tcmur_get_cmd(struct tcmur_dev *udev, u16 q_id,
+				       u16 tag)
+{
+	struct tcmur_cmd *tcmd;
+	struct tcmur_queue *q;
+
+	if (q_id >= udev->nr_queues || tag >= udev->queue_depth)
+		return NULL;
+
+	q = &udev->queues[q_id];
+	spin_lock(&q->lock);
+	tcmd = q->ios[tag].cmd;
+	if (tcmd)
+		refcount_inc(&tcmd->ref);
+	spin_unlock(&q->lock);
+
+	return tcmd;
+}
+
 static void tcmur_cancel_fetch(struct io_uring_cmd *ucmd,
 			       unsigned int issue_flags)
 {
@@ -363,6 +385,69 @@ static int tcmur_ch_uring_cmd(struct io_uring_cmd *ucmd,
 	return tcmur_ch_uring_cmd_local(ucmd, issue_flags);
 }
 
+/* Copy between the data pages of a command and the buffer of the server */
+static ssize_t tcmur_ch_copy(struct kiocb *iocb, struct iov_iter *iter,
+			     bool to_cmd)
+{
+	struct tcmur_dev *udev = iocb->ki_filp->private_data;
+	u32 off = iocb->ki_pos & TCMUR_BUF_OFF_MASK;
+	u16 tag = iocb->ki_pos >> TCMUR_BUF_TAG_SHIFT;
+	u16 q_id = iocb->ki_pos >> TCMUR_BUF_QID_SHIFT;
+	size_t count, n, copied;
+	struct tcmur_cmd *tcmd;
+	struct scatterlist *sg;
+	ssize_t done = 0;
+	int i;
+
+	tcmd = tcmur_get_cmd(udev, q_id, tag);
+	if (!tcmd)
+		return -EINVAL;
+
+	if (to_cmd != (tcmd->desc.op == TCMUR_OP_READ) ||
+	    off > tcmd->desc.data_len) {
+		done = -EINVAL;
+		goto put_cmd;
+	}
+
+	count = min(iov_iter_count(iter), tcmd->desc.data_len - off);
+	for_each_sg(tcmd->sgl, sg, tcmd->sgl_nents, i) {
+		if (!count)
+			break;
+		if (off >= sg->length) {
+			off -= sg->length;
+			continue;
+		}
+
+		n = min(sg->length - off, count);
+		if (to_cmd)
+			copied = copy_page_from_iter(sg_page(sg),
+						     sg->offset + off, n, iter);
+		else
+			copied = copy_page_to_iter(sg_page(sg),
+						   sg->offset + off, n, iter);
+		done += copied;
+		count -= copied;
+		if (copied != n)
+			break;
+		off = 0;
+	}
+	if (!done && count)
+		done = -EFAULT;
+put_cmd:
+	tcmur_cmd_put(tcmd);
+	return done;
+}
+
+static ssize_t tcmur_ch_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	return tcmur_ch_copy(iocb, to, false);
+}
+
+static ssize_t tcmur_ch_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	return tcmur_ch_copy(iocb, from, true);
+}
+
 static size_t tcmur_desc_area_size(struct tcmur_dev *udev)
 {
 	return PAGE_ALIGN(udev->queue_depth * sizeof(struct tcmur_io_desc));
@@ -433,6 +518,8 @@ static const struct file_operations tcmur_ch_fops = {
 	.owner		= THIS_MODULE,
 	.open		= tcmur_ch_open,
 	.release	= tcmur_ch_release,
+	.read_iter	= tcmur_ch_read_iter,
+	.write_iter	= tcmur_ch_write_iter,
 	.uring_cmd	= tcmur_ch_uring_cmd,
 	.mmap		= tcmur_ch_mmap,
 	.unlocked_ioctl	= tcmur_ch_ioctl,
diff --git a/include/uapi/linux/target_core_uring.h b/include/uapi/linux/target_core_uring.h
index a662a23fca9ab..8b95be853753c 100644
--- a/include/uapi/linux/target_core_uring.h
+++ b/include/uapi/linux/target_core_uring.h
@@ -96,4 +96,19 @@ struct tcmur_io_desc {
 #define TCMUR_DESC_AREA_SIZE \
 	(TCMUR_MAX_QUEUE_DEPTH * sizeof(struct tcmur_io_desc))
 
+/*
+ * The data of a command is read (TCMUR_OP_WRITE) or written
+ * (TCMUR_OP_READ) with pread()/pwrite() on the file, at the position
+ * returned by tcmur_buf_pos().
+ */
+#define TCMUR_BUF_TAG_SHIFT	32
+#define TCMUR_BUF_QID_SHIFT	48
+#define TCMUR_BUF_OFF_MASK	((1ULL << TCMUR_BUF_TAG_SHIFT) - 1)
+
+static inline __u64 tcmur_buf_pos(__u16 q_id, __u16 tag, __u32 off)
+{
+	return ((__u64)q_id << TCMUR_BUF_QID_SHIFT) |
+	       ((__u64)tag << TCMUR_BUF_TAG_SHIFT) | off;
+}
+
 #endif /* _UAPI_LINUX_TARGET_CORE_URING_H */

-- 
2.43.0


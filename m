Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.29
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788364;
	b=OXEpTDinjn0XW/uL4bY8s1tTfVlBKOy3dh+Kh6kmGxqBYQz2wbKeCg2GkreMPhj4xybG
	 +kswGmViRUcZhnHQQ59xuseqtdJ9eGqFb5GjLewNIJDb9m4bHthqmmBUqLeWvImFNeTU5
	 qFdab6Z6ivzQY0/tQRtIn2e7u7WJ7ptxfAifjpR3EonVV+k/wozEqptsX0GiygHIKRGA9
	 +lw8DIwY5G/J3JE0Jv1I7CmnKeZKZ3owt5w/ZpJ1IbsKB5ia/6YMxUsiQiiYoO3OOkV2y
	 QxiKhes7OiLs0CxqsY4m+B7Se+TZ4K2r7ee4nHnlPSOee3LZOlWbsv/R2hzprcgUP/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788364;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=qu6DBgMxRkupt4HnGpADZC2d8uM7xTpXMjch9KCI1b0=;
	b=FhJgDWPw6sXnw/pRp3gqWQA0QvYNBNTQchIpA6wyn8XQNdbiWv76fvHLH5xjeA0VyrfJ
	 sGIkkPCg21DCCDK3NpOrL+fYYvkSFV/NPMLy0lfycF/ncANnPaSiJoDJ7JOOz5FDV8fRF
	 cjUiU0PCOrPwgJJAfRScvR31A78MYaq076DJtOKM42bC0UJHOJgWI4n8YRVQcqGTr8lrm
	 CfSbpkCr9x0ByF8CAH2PMa/ZD3PhEjpfnqYoehrlz48RQ1B4gQ4My5qSkXH0K3DeVOTAj
	 ryIACb8EFxqY0M9bIcFJyly91goJTB8pJuUO6g+Mi7+XtY2+W/xrNB3pSyMFnFo5aZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CIL+vkSm;
	arc=none smtp.remote-ip=91.218.175.29
Received: from mta0.migadu.com (out-29.mta0.migadu.com [91.218.175.29])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29D1606A33A
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 00:19:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F29D1606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CIL+vkSm
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=x2PPpgQO2VQnEUdFymh0p2TYLS7IgGWyu3wj9qKiZds=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794788362; v=1; x=1795393162;
 b=CIL+vkSmH5XJbor5YoJnIOT1uF6HwPiH1RBiKwyoUwz9A1GGIZm7yUj9miUKovHulYn3ThYG
 R9p6FxTQZ4BhnX/8pgNq5UhO0CYMJP8yx6fzg/D+1qqnLoLpMH5xIe7Fa+4XtN2pNor8IKO6YPi
 51MyVvw/bb8LSFOLGpXretqs=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f350d4b32e6c5b5a;
	Mon, 16 Nov 2026 00:19:22 +0000
X-Mizu-Trace-ID: f350d4b32e6c5b5a
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Sun, 15 Nov 2026 19:18:03 -0500
Subject: [PATCH RFC 10/18] scsi: target: uring: Time out commands the
 server does not complete
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
Message-Id: <20261115-feat-target-core-uring-v1-10-28cdc137eac6@linux.dev>
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

Commands of a target_core_uring device wait on a pending list until a
server fetches them, and then for the server to commit them.

Without a server, or with one that hangs, they wait forever, and so
does everything that waits for them, such as removing the LUN.

Add the cmd_time_out parameter, 30 seconds by default, and fail the
commands that are older. A delayed work scans the queues when the oldest
command is due. A timed out command that the server works on is
completed, but the server keeps the tag until it commits it.

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/target/target_core_uring.c | 80 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_core_uring.c
index 2978dd08c99cf..0f83bdc55e06a 100644
--- a/drivers/target/target_core_uring.c
+++ b/drivers/target/target_core_uring.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/uio.h>
 #include <linux/vmalloc.h>
+#include <linux/workqueue.h>
 #include <scsi/scsi_proto.h>
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
@@ -31,6 +32,7 @@
 #define TCMUR_MAX_IO_SIZE	(4U << 20)
 #define TCMUR_DEF_QUEUE_DEPTH	128
 #define TCMUR_DEF_BLOCK_SIZE	512
+#define TCMUR_DEF_CMD_TIMEOUT	30
 
 /* Set while the file is open, to allow one server at a time */
 #define TCMUR_DEV_OPEN		0
@@ -46,6 +48,7 @@ struct tcmur_dev;
  * @desc:	What the server is asked to do
  * @ref:	Held by the tag or the pending list and by data copies in
  *		progress
+ * @deadline:	When to give up waiting for the server
  * @status:	SAM status to complete @se_cmd with
  */
 struct tcmur_cmd {
@@ -55,6 +58,7 @@ struct tcmur_cmd {
 	u32			sgl_nents;
 	struct tcmur_io_desc	desc;
 	refcount_t		ref;
+	unsigned long		deadline;
 	u8			status;
 };
 
@@ -102,8 +106,10 @@ struct tcmur_dev {
 	u32			block_size;
 	u16			nr_queues;
 	u16			queue_depth;
+	unsigned int		cmd_timeout;
 
 	struct tcmur_queue	*queues;
+	struct delayed_work	timeout_work;
 };
 
 /**
@@ -190,6 +196,8 @@ static void tcmur_queue_cmd(struct tcmur_dev *udev, struct tcmur_cmd *tcmd)
 	struct tcmur_io *io;
 
 	refcount_set(&tcmd->ref, 1);
+	if (udev->cmd_timeout)
+		tcmd->deadline = jiffies + udev->cmd_timeout * HZ;
 
 	spin_lock(&q->lock);
 	io = list_first_entry_or_null(&q->idle, struct tcmur_io, node);
@@ -205,6 +213,9 @@ static void tcmur_queue_cmd(struct tcmur_dev *udev, struct tcmur_cmd *tcmd)
 
 	if (ucmd)
 		io_uring_cmd_complete_in_task(ucmd, tcmur_fetch_tw_cb);
+	if (udev->cmd_timeout)
+		schedule_delayed_work(&udev->timeout_work,
+				      udev->cmd_timeout * HZ);
 }
 
 static sense_reason_t tcmur_submit(struct se_cmd *se_cmd, u32 op, u64 offset,
@@ -244,6 +255,58 @@ static sense_reason_t tcmur_execute_rw(struct se_cmd *se_cmd,
 			    se_cmd->data_length, sgl, sgl_nents);
 }
 
+static void tcmur_timeout_work(struct work_struct *work)
+{
+	struct tcmur_dev *udev = container_of(work, struct tcmur_dev,
+					      timeout_work.work);
+	unsigned long now = jiffies, next = 0;
+	struct tcmur_cmd *tcmd, *tmp;
+	struct tcmur_queue *q;
+	struct tcmur_io *io;
+	bool rearm = false;
+	LIST_HEAD(expired);
+	unsigned int i, j;
+
+	for (i = 0; i < udev->nr_queues; i++) {
+		q = &udev->queues[i];
+
+		spin_lock(&q->lock);
+		list_for_each_entry_safe(tcmd, tmp, &q->pending, node) {
+			if (time_after(tcmd->deadline, now)) {
+				if (!rearm || time_before(tcmd->deadline, next))
+					next = tcmd->deadline;
+				rearm = true;
+				break;
+			}
+			list_move_tail(&tcmd->node, &expired);
+		}
+		for (j = 0; j < udev->queue_depth; j++) {
+			io = &q->ios[j];
+			tcmd = io->cmd;
+			if (!tcmd)
+				continue;
+			if (time_after(tcmd->deadline, now)) {
+				if (!rearm || time_before(tcmd->deadline, next))
+					next = tcmd->deadline;
+				rearm = true;
+				continue;
+			}
+			/* Leave the tag to the server until it commits it */
+			io->cmd = NULL;
+			list_add_tail(&tcmd->node, &expired);
+		}
+		spin_unlock(&q->lock);
+	}
+
+	if (!list_empty(&expired))
+		pr_warn_ratelimited("tcmur%d: command timed out\n",
+				    udev->dev_id);
+	tcmur_end_cmds(&expired, SAM_STAT_CHECK_CONDITION);
+
+	if (rearm)
+		schedule_delayed_work(&udev->timeout_work, next - now);
+}
+
 /* Take a reference on the command the server works on in (@q_id, @tag) */
 static struct tcmur_cmd *tcmur_get_cmd(struct tcmur_dev *udev, u16 q_id,
 				       u16 tag)
@@ -331,7 +394,10 @@ static int tcmur_commit(struct tcmur_queue *q, struct tcmur_io *io, int result)
 	io->owned = false;
 	spin_unlock(&q->lock);
 
-	tcmur_cmd_end(tcmd, result ? SAM_STAT_CHECK_CONDITION : SAM_STAT_GOOD);
+	/* Skip a command that timed out already */
+	if (tcmd)
+		tcmur_cmd_end(tcmd, result ? SAM_STAT_CHECK_CONDITION :
+					     SAM_STAT_GOOD);
 	return 0;
 }
 
@@ -639,6 +705,8 @@ static struct se_device *tcmur_alloc_device(struct se_hba *hba,
 	udev->nr_queues = 1;
 	udev->queue_depth = TCMUR_DEF_QUEUE_DEPTH;
 	udev->block_size = TCMUR_DEF_BLOCK_SIZE;
+	udev->cmd_timeout = TCMUR_DEF_CMD_TIMEOUT;
+	INIT_DELAYED_WORK(&udev->timeout_work, tcmur_timeout_work);
 
 	device_initialize(&udev->cdev_dev);
 	udev->cdev_dev.class = &tcmur_class;
@@ -723,6 +791,8 @@ static void tcmur_destroy_device(struct se_device *dev)
 		}
 		spin_unlock(&q->lock);
 	}
+
+	cancel_delayed_work_sync(&udev->timeout_work);
 }
 
 static void tcmur_free_device(struct se_device *dev)
@@ -731,7 +801,8 @@ static void tcmur_free_device(struct se_device *dev)
 }
 
 enum {
-	Opt_dev_size, Opt_block_size, Opt_nr_queues, Opt_queue_depth, Opt_err,
+	Opt_dev_size, Opt_block_size, Opt_nr_queues, Opt_queue_depth,
+	Opt_cmd_time_out, Opt_err,
 };
 
 static const match_table_t tcmur_tokens = {
@@ -739,6 +810,7 @@ static const match_table_t tcmur_tokens = {
 	{ Opt_block_size,	"block_size=%u" },
 	{ Opt_nr_queues,	"nr_queues=%u" },
 	{ Opt_queue_depth,	"queue_depth=%u" },
+	{ Opt_cmd_time_out,	"cmd_time_out=%u" },
 	{ Opt_err,		NULL }
 };
 
@@ -794,6 +866,9 @@ static ssize_t tcmur_set_configfs_dev_params(struct se_device *dev,
 			else
 				udev->queue_depth = val;
 			break;
+		case Opt_cmd_time_out:
+			udev->cmd_timeout = val;
+			break;
 		}
 	}
 
@@ -812,6 +887,7 @@ static ssize_t tcmur_show_configfs_dev_params(struct se_device *dev, char *b)
 		      udev->block_size);
 	bl += sprintf(b + bl, " Queues: %u Queue depth: %u", udev->nr_queues,
 		      udev->queue_depth);
+	bl += sprintf(b + bl, " Command timeout: %u", udev->cmd_timeout);
 	bl += sprintf(b + bl, "\n");
 	return bl;
 }

-- 
2.43.0


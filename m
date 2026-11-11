Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.129
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794408672;
	b=KTp+Rxu/N6wE+tBUyx4kS3IQP6Vwod22yNQBVpPD5twIDk7Ha06DS2fX8OdI6R2BE3nx
	 DfGTl6v2AJpVt30GRlqG3h3LyL7I/aOG8JQr7zvPwpqf4FtvWq24kayMjxoO7Dql1czjn
	 9WsNuUKLoXa9O05Y+Ai+1farUYWZ+PDcCWpei0iIMcfw3fT3uU7TZZl2tWvWQI5Zrn2/J
	 VR4nqYy/OkRYvX5afK5s60mB2rOqRT59UuSeeRh07iwroteHZKD6KAo1M0XiFC9Y+jZfe
	 dum1o9RGnX3uZr2L9aqGjTLLEWohQRcm5IUK7bKanghcoqOp++7vnsM/07nbln8AbHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794408672;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=g+jv8AtfpGafUC5wBdSfIamvnfKnHxDWwY7oWhWrKE0=;
	b=pKyuqSFNmbGjY5N0kxjK4Jgb+/B4ywEGEJp2bW/Zve61JXC1zosfbIXW2csDo5nIixIL
	 qNquCvVm/mk1DJmeHliALf7qfVHt3NVv7H4+ZA2NY2Z9BepB+/Z0in+GepbWGWNVboTlU
	 fDaGZUvefB/Rc6PfkgX75jHfh+GQUWYtoda+f0WnjU2u8XtSdYhkj6phnDblNrUiLi+zc
	 DuhBQABOeUk/MsE7Z/X2+yGeQ60eVx4pj6Tad4nHrpyoBw3h+deTxtzpzT4PN8Zh9jJ2/
	 BzyYMK+Ml/lunY4xPRI2TrA8UKKgmg/9LS8UolTT65V8G0AbD61isRafJ3aW/hvl4Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Po9Gdm7o;
	arc=none smtp.remote-ip=95.215.58.129
Received: from mta1.migadu.com (out-129.mta1.migadu.com [95.215.58.129])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9666F606A8A8
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 14:51:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9666F606A8A8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Po9Gdm7o
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xy5K9Cw6RLs5ZIVIwHbgzwEDhJquIkV4vlOTki38lhQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794408669; v=1; x=1795013469;
 b=Po9Gdm7oiVslmglM7cR6dHG8MZzP0QUgzefHoPf2YJ9YcvzjIfCAyeaf6lnYj9vp+yWVYGj2
 3xjTci7xJQGJx5jQIIQXWkCBYqRrzUjqJZfo6zFZ7vPF9iw4okDAbDcpUvhImliv7s/m/obG0JE
 L3LQET57+mehEjqh++d6BuPE=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fa600de2af1b08c0;
	Wed, 11 Nov 2026 14:51:09 +0000
X-Mizu-Trace-ID: fa600de2af1b08c0
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: axboe@kernel.dk,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	dgilbert@interlog.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mathieu.desnoyers@efficios.com,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH v2 2/2] scsi: sg: Require CAP_SYS_ADMIN for BLKTRACE passthrough ioctls
Date: Wed, 11 Nov 2026 22:50:34 +0800
Message-ID: <20261111145034.248717-3-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261111145034.248717-1-cui.tao@linux.dev>
References: <20261111145034.248717-1-cui.tao@linux.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

sg_ioctl_common() calls blk_trace_setup(), blk_trace_startstop()
and blk_trace_remove() directly instead of going through
blk_trace_ioctl(), so gating the block side does not close the sg
passthrough: an unprivileged process with access to an /dev/sg node
could still allocate relay buffers and control tracing state on the
underlying request queue.

Require CAP_SYS_ADMIN for the four passthrough commands.  The check
sits after the command log line so the new rejections stay visible
in the ioctl trace, and it is qualified with
IS_ENABLED(CONFIG_BLK_DEV_IO_TRACE) so kernels without blktrace
keep returning -ENOTTY for these commands instead of a new -EPERM.

BLKTRACE ioctls through sg now get the same answer they would get
through the block device node: -EPERM for unprivileged callers,
regardless of the trace or queue state behind the node.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 drivers/scsi/sg.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 6551f1284d44..f863979604ef 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -911,6 +911,13 @@ static int put_compat_request_table(struct compat_sg_req_info __user *o,
 }
 #endif
 
+/* keep in sync with the commands blk_trace_ioctl() gates */
+static bool sg_is_blktrace_cmd(unsigned int cmd)
+{
+	return cmd == BLKTRACESETUP || cmd == BLKTRACESTART ||
+	       cmd == BLKTRACESTOP || cmd == BLKTRACETEARDOWN;
+}
+
 static long
 sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
 		unsigned int cmd_in, void __user *p)
@@ -922,6 +929,9 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
 
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
 				   "sg_ioctl: cmd=0x%x\n", (int) cmd_in));
+	if (IS_ENABLED(CONFIG_BLK_DEV_IO_TRACE) &&
+	    sg_is_blktrace_cmd(cmd_in) && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
 	read_only = (O_RDWR != (filp->f_flags & O_ACCMODE));
 
 	switch (cmd_in) {
-- 
2.53.0


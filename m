Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.115
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794408662;
	b=eUfMFzllAHs46sVbvckut8pNjltXgNrPmQOmSe5/r1yw7X6nwhxj71SlwYxfPm6iLMnh
	 ULLUohefmQp8rBTwUpRgSf6K7R8a5qTCOEbQi1ExwwkIT8Vg1NBmbInbTPUMiqLvrpISk
	 imUBINTSgJGMP+CU2uWbFIhxauDQqjxik10/4RvYCq3G67MNrXlRpm1HnJXPCGPla2E8a
	 4IUmEm3sv7wyRnLjonJ4I8/tCOMQOvZ1UKgbe84cmUuJYCfHCKS0FWszgMArFq5SH57/5
	 L219PEew1gTIc0eqPZgmqnoOYSNkfo8kISBHzYPHK79TxLisEE2R0vMq4draYF4O6ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794408662;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=EJoVaWGGDNW1Id/n/9brJAEB3fKM8Jou3zLTRrF1e7U=;
	b=LxdQcw0QGrvNPRF9/hsquKbefG/jZX4uEy16YAqdw+I9F4AaS57j7LPyDCdEzV+nnKb+
	 xZ7J8jhdhjygfj267zFDwfDcOum0s6M5yLJyzkJAV3KsvPAWs1Mga2dRMVAaQIegWwZ2G
	 YlOuSmzmi4MuhDMbtvS18seiYrX/KKTjNWpxY8wSp5dfdRV/YyR1oHscLyJWr1jewz72b
	 ptelVBWuF1Dk0fsja4+LZUxx817KqhhCwHcGeSi19uJYJdbMNzUVY5m3LwjM4sb0gtFVj
	 d1pyCAz1j4inUdUc+ilNHkPfpLegvINxa9gZ0cyrx36jzMe6XWPQAHkHHtemkaZEy5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VO5lBtoU;
	arc=none smtp.remote-ip=95.215.58.115
Received: from mta1.migadu.com (out-115.mta1.migadu.com [95.215.58.115])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD8C606A889
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 14:51:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CD8C606A889
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VO5lBtoU
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6BTSDkaYo+GkLYc1VRePzbZVpQvqYtmjYkbAZjXokg8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794408660; v=1; x=1795013460;
 b=VO5lBtoUEtVoeus0nYjvQfEZJgP5hfM+BiUlYoKSpEDMIeVtuq7aJ6raxAVT+jwAJnfHnOaO
 juz/m1mHxUcW1glOPSJRgesgBV7GZQ9hhQKQkxW8CimUk02p6qI3/vkSlcV2N0qq7B4kqBGg6co
 jmTBlL875ihc8ZZkXitc23oA=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9da4ac12eb974c88;
	Wed, 11 Nov 2026 14:51:00 +0000
X-Mizu-Trace-ID: 9da4ac12eb974c88
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
Subject: [PATCH v2 1/2] blktrace: require CAP_SYS_ADMIN for the blktrace interface
Date: Wed, 11 Nov 2026 22:50:33 +0800
Message-ID: <20261111145034.248717-2-cui.tao@linux.dev>
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

BLKTRACESETUP allocates user-sized relay buffers and sets up a trace
that outlives the creating fd.  Every command of the interface,
BLKTRACESETUP, BLKTRACESETUP2, BLKTRACESTART, BLKTRACESTOP,
BLKTRACETEARDOWN and, on x86_64 with CONFIG_COMPAT, the 32-bit
variant can be issued by anyone who can open the block device node,
and the sysfs trace attribute group reaches the same tracing state
without any check.  A container that is handed the node can hold
trace state and relay memory on a shared queue; the relay files
themselves stay root-only (0400).

Gate blk_trace_ioctl() and sysfs_blk_trace_attr_store() with
CAP_SYS_ADMIN.  The ioctls return -EPERM, the sysfs store -EACCES
like the md store callbacks it resembles.  Unprivileged callers now
get one answer that depends only on their credentials, instead of
values that revealed whether a trace existed and was running.

Traces survive the creating fd by design, so a creator that drops
its privileges can no longer tear down its own trace.  Such traces
wait for a privileged teardown or for the queue to go away;
blk_trace_remove() from sg_device_destroy() and
blk_trace_shutdown() from blk_unregister_queue() bound that wait for
unplugged devices.
Document the sysfs attributes in Documentation/ABI, where the group
has been missing since it was added.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 Documentation/ABI/stable/sysfs-block | 18 ++++++++++++++++++
 kernel/trace/blktrace.c              |  6 ++++++
 2 files changed, 24 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
index 900b3fc4c72d..177c4b95a47d 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -939,3 +939,21 @@ Description:
 		==  ==============================================
 
 		For more details refer Documentation/admin-guide/iostats.rst
+
+
+What:		/sys/block/<disk>/trace/{enable,act_mask,pid,start_lba,end_lba}
+		/sys/block/<disk>/<partition>/trace/{enable,act_mask,pid,start_lba,end_lba}
+Date:		January 2009
+Contact:	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>
+Description:
+		Configure blktrace for this device's request queue.
+		"enable" creates (1) or removes (0) the per-queue trace
+		bookkeeping; "act_mask" selects the traced action
+		categories, either as a number or as a list of category
+		names; "pid" restricts tracing to one process;
+		"start_lba" and "end_lba" bound the traced sector range.
+		Reading an attribute shows the current setting and needs
+		no privilege; writing any attribute requires
+		CAP_SYS_ADMIN.  Enabling from sysfs does not set up
+		relay buffers; full tracing is armed through the
+		BLKTRACESETUP ioctl.
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 8cd2520b4c99..f56d57a924bf 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -927,6 +927,9 @@ int blk_trace_ioctl(struct block_device *bdev, unsigned cmd, char __user *arg)
 	int ret, start = 0;
 	char b[BDEVNAME_SIZE];
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	switch (cmd) {
 	case BLKTRACESETUP2:
 		snprintf(b, sizeof(b), "%pg", bdev);
@@ -2079,6 +2082,9 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 	u64 value;
 	ssize_t ret = -EINVAL;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
 	if (count == 0)
 		goto out;
 
-- 
2.53.0


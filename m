Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.250.124.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793266096;
	b=Q3qbcSTSIW0EGTbFLdjsKmHR8BZzWpP7Q4klXgBjAfCIs4bbraSTQtsuwVNOMzol9hB3
	 Yf9Vqhs03DuHhHW+QVFN2tUnCw+wL4czbxtjo0byRY/aPubtFFEvK0fZrpQ+++A8/hUW4
	 PwPelsiLN/2aFkRPeA10RNH/EQSarE5zYPsyqxcrfYRSgLx5zpmphaJdYnzEt2O1USnxS
	 lkIrGvdQJvgF068HHt08hF/LOWE/cVueDx+glCE2EGviUypIoESlYZhet8uqXa355fYTR
	 7kfaf7n02rjGWHCmzAFT2pJGGNF4B9PPHWSskV9guD6xHAEGSxQJXMW3XStakJKn82g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793266096;
	h=DMARC-Filter:Received:Received:X-Yandex-Fwd:DKIM-Signature:From:To:
	 Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ucJClS3C52+tN9fgpmASAGYwr5TrUblvC/hnqIUBTG0=;
	b=p99AHLn7xHYo0Bgx5cASFlsM8RhSC5dWFHzVkVQlKhzPzZy3C5r//NGLvg6wYiuXnLyg
	 yVjFI9SXQ3FSddSDbcMqprbxPMcZw5qQYURV0tfKeKk/vVYS7Q42MPy/qSuf9rZfHcFkQ
	 qcdTiJhk9MVG1UDrpRc1OPD39mAHELaqHLthZJVg13+w6doZbVS2hURc25E9givoG/x2r
	 tbvJtm00ArwT4kLruzmD9OY6lEoIRuwQwgGpqMRoM9JymtKaWi/Osux/S8NoZfqLI9IiD
	 InYMoPvjxxNaBwqzgAdvIQ5vDluaGGwqr1HCeX0JSrzr4M9K50amtA9W/N+Ni+U5vTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yandex.ru;
	spf=pass smtp.mailfrom=yandex.ru;
	dkim=pass header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=tEWvMa08;
	arc=none smtp.remote-ip=51.250.124.100
Received: from forward104a.mail.yandex.net (forward104a.mail.yandex.net [51.250.124.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0FA606A31C;
	Thu, 29 Oct 2026 09:28:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB0FA606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=tEWvMa08
Received: from mail-nwsmtp-smtp-production-main-62 (mail-nwsmtp-smtp-production-main-62.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:5724:0:640:b7ee:0])
	by forward104a.mail.yandex.net (postfix) with ESMTPS id 3407010003A;
	Thu, 29 Oct 2026 12:28:07 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-62 with ESMTPSA id 1SfdjsOiIiE0-pzJcvn9f;
	Thu, 29 Oct 2026 12:28:06 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1793266086; bh=ucJClS3C52+tN9fgpmASAGYwr5TrUblvC/hnqIUBTG0=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=tEWvMa08wWHLuX1dHNmCdAZLKGbZXIGgg8nxJ0Fljluo/r8jUAq51uzrLhfnKXdrF
	 OgCT1XAnG5Pdpyt3v4PsuCioXjUEGegs+ROO3AFv5ElCUIimCck/ejJEB4ylqNUq7T
	 xsgQwxuY3YC+8eVtzb12s1EgZ73BOtlAIjR9hhhw=
Authentication-Results: mail-nwsmtp-smtp-production-main-62; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Jens Axboe <axboe@kernel.dk>,
	Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Martin Petersen <mkp@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH 2/2] scsi: add basic CDB check to bsg_sg_io()
Date: Thu, 29 Oct 2026 12:26:24 +0300
Message-ID: <20261029092624.579887-2-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029092624.579887-1-dmantipov@yandex.ru>
References: <20261029092624.579887-1-dmantipov@yandex.ru>
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

Local fuzzing of 6.12.113 has reported the following crash:

[ T6325] KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
[ T6325] CPU: 1 UID: 0 PID: 6325 Comm: syz.0.17 Tainted: G W 6.12.113 #2
...
[  123.544088][ T6325] RIP: 0010:ufs_bsg_request+0x244/0x11f0
...
[  123.550658][ T6325] Call Trace:
[  123.550918][ T6325]  <TASK>
[  123.551154][ T6325]  ? __pfx_ufs_bsg_request+0x10/0x10
[  123.551599][ T6325]  bsg_queue_rq+0x4e2/0x780
[  123.551991][ T6325]  ? __pfx_bsg_queue_rq+0x10/0x10
[  123.552526][ T6325]  ? lockdep_unlock+0x5c/0xd0
[  123.553098][ T6325]  blk_mq_dispatch_rq_list+0x499/0x1990
[  123.553819][ T6325]  ? do_raw_spin_lock+0x12b/0x2f0
[  123.554458][ T6325]  ? __pfx_blk_mq_dispatch_rq_list+0x10/0x10
[  123.555332][ T6325]  ? do_raw_spin_unlock+0xf5/0x200
[  123.556247][ T6325]  __blk_mq_sched_dispatch_requests+0x355/0x1580
[  123.557644][ T6325]  ? __lock_acquire+0x761/0x2e30
[  123.559226][ T6325]  ? do_raw_spin_lock+0x12b/0x2f0
[  123.562128][ T6325]  ? __pfx___blk_mq_sched_dispatch_requests+0x10/0x10
[  123.565938][ T6325]  ? lock_acquire+0x115/0x350
[  123.568870][ T6325]  ? lock_acquire+0x115/0x350
[  123.571884][ T6325]  blk_mq_sched_dispatch_requests+0xd7/0x180
[  123.574304][ T6325]  ? blk_mq_run_hw_queue+0x317/0x4e0
[  123.575617][ T6325]  blk_mq_run_hw_queue+0x340/0x4e0
[  123.576586][ T6325]  blk_execute_rq+0x1e0/0x4c0
[  123.577254][ T6325]  ? import_ubuf+0xfb/0x1d0
[  123.577847][ T6325]  ? blk_rq_map_user+0x11b/0x1a0
[  123.578440][ T6325]  ? __pfx_blk_execute_rq+0x10/0x10
[  123.579013][ T6325]  ? _copy_from_user+0x94/0xb0
[  123.579509][ T6325]  bsg_transport_sg_io_fn+0x5ff/0xef0
[  123.580093][ T6325]  bsg_ioctl+0x7ec/0xa10
[  123.580603][ T6325]  ? __pfx_bsg_transport_sg_io_fn+0x10/0x10
[  123.581248][ T6325]  ? __pfx_bsg_ioctl+0x10/0x10
[  123.581695][ T6325]  ? __fget_files+0x2a/0x420
[  123.582057][ T6325]  ? bpf_lsm_file_ioctl+0x9/0x20
[  123.582437][ T6325]  ? __pfx_bsg_ioctl+0x10/0x10
[  123.582789][ T6325]  __se_sys_ioctl+0xfc/0x170
[  123.583123][ T6325]  do_syscall_64+0x166/0x520
[  123.583470][ T6325]  ? trace_irq_disable+0x3b/0x140
[  123.583904][ T6325]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  123.584412][ T6325]  entry_SYSCALL_64_after_hwframe+0x77/0x7f

This is caused by ioctl(..., SG_IO, {struct sg_io_v4 hdr = {
.subprotocol = BSG_SUB_PROTOCOL_SCSI_TRANSPORT, .request = NULL,
.request_len = 0 }}). So if 'hdr' is not a task management
function, perform basic 'request' and 'request_len' check
assuming that there should be a valid fixed length CDB at least.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 block/bsg-lib.c         | 2 --
 block/bsg.c             | 9 +++++++++
 include/linux/bsg-lib.h | 2 ++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 536cee4430a7..e7ae60f73870 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -16,8 +16,6 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/sg.h>
 
-#define uptr64(val) ((void __user *)(uintptr_t)(val))
-
 struct bsg_set {
 	struct blk_mq_tag_set	tag_set;
 	struct bsg_device	*bd;
diff --git a/block/bsg.c b/block/bsg.c
index 82aaf3cee582..80f367ae7d24 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -11,6 +11,7 @@
 #include <linux/percpu.h>
 #include <linux/idr.h>
 #include <linux/bsg.h>
+#include <linux/bsg-lib.h>
 #include <linux/slab.h>
 #include <linux/io_uring/cmd.h>
 
@@ -66,6 +67,14 @@ static int bsg_sg_io(struct bsg_device *bd, bool open_for_write,
 		return -EFAULT;
 	if (hdr.guard != 'Q')
 		return -EINVAL;
+
+	if (hdr.subprotocol != BSG_SUB_PROTOCOL_SCSI_TMF) {
+		if (hdr.request_len < SCSI_MIN_CDB_SIZE)
+			return -EINVAL;
+		if (!access_ok(uptr64(hdr.request), hdr.request_len))
+			return -EFAULT;
+	}
+
 	ret = bd->sg_io_fn(bd->queue, &hdr, open_for_write,
 			   bsg_timeout(bd, &hdr));
 	if (!ret && copy_to_user(uarg, &hdr, sizeof(hdr)))
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index a697246feeac..fac7c89516ca 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -17,6 +17,8 @@ struct device;
 struct scatterlist;
 struct request_queue;
 
+#define uptr64(val) ((void __user *)(uintptr_t)(val))
+
 typedef int (bsg_job_fn) (struct bsg_job *);
 typedef enum blk_eh_timer_return (bsg_timeout_fn)(struct request *);
 
-- 
2.56.0


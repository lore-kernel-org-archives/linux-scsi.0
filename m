Received: from iad-out-001.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-001.esa.us-east-1.outbound.mail-perimeter.amazon.com [107.22.191.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9CF3EAC7D;
	Thu,  2 Apr 2026 13:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=107.22.191.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775138246; cv=none; b=l8L7+Mh1LLrLOBnr3vb3CfB8QYkCjWPaBNoZu6V4uX7T+7YK93F0dCoiFFlhGRPJbmPaLbpUFf06qDWQgx9krFpVdqLsEEsJ6uL3smn0Ccz+VhzCEjDiiVIkgQdD4ZRfrbj6lBo/9qWBmp978m7bdguU7mFBKQApQNVYQ59R9mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775138246; c=relaxed/simple;
	bh=JG2Mv9KfI7xkq43R9tTrX6gyZeNUTJ68NxGSnZETtNU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P08VRjxl6lHJhyA0wVhmqkXUEtdcTTIeES54Yc+NnkPkvXUW9xBdkPY/ivOzkefgBNQRNnD/eMROn1pZva5BZU8mz/tFZl/5pq8/A9gHeCih3tsffgnuzlItIahImFpp11EdIwb2i2WlNsABcgyI80Fyvew52X4LsgqBBrk3DIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=tlghinag; arc=none smtp.client-ip=107.22.191.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="tlghinag"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1775138245; x=1806674245;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=uP5c6JzjwZwnGCsqflyTr1RQBZf98/zHqoDjD1LVIe8=;
  b=tlghinagVkaxpxVfZfAxysM9soN/XJ5BPs+HhdvtQM1zd9O65z+5bYki
   0nWPnNYPBoupnADfdJ8AkGHMN4cvdtEGHiL9Otst9UM0YeLot7Lh01wSC
   0bntyFUvbmSQblrs9USBk1DFRBC8ImWJf4Dyj0EbHGL4GwvQx+yZycgca
   7L0R1YTjB+AfCxfrWPXYvoGuVmUokD+sAAyKIfOZ09rQwm2bU+uoNwOzC
   SkFWyYg1qx/nkaMTSyLnlBACcH5eaBTko75NDyvimaeMGOei+7eS7mvPN
   fF8Mw8HKvfOLWhBOQBfqUa6dWZaS6fxdcaBbrljNTqTyBS7ivNQMJFVGP
   w==;
X-CSE-ConnectionGUID: NdtHOC2/QUC71siKA+aOaw==
X-CSE-MsgGUID: rByC0p3/S0qrlGbYKmvOyw==
X-IronPort-AV: E=Sophos;i="6.23,155,1770595200"; 
   d="scan'208";a="14926256"
Received: from ip-10-4-22-235.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.22.235])
  by internal-iad-out-001.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2026 13:57:20 +0000
Received: from EX19MTAUEB002.ant.amazon.com [52.94.133.143:22502]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.17.255:2525] with esmtp (Farcaster)
 id 31a3c434-4697-4e89-8051-95e7f182a31b; Thu, 2 Apr 2026 13:57:20 +0000 (UTC)
X-Farcaster-Flow-ID: 31a3c434-4697-4e89-8051-95e7f182a31b
Received: from EX19D012UEC004.ant.amazon.com (10.252.135.219) by
 EX19MTAUEB002.ant.amazon.com (10.252.135.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 2 Apr 2026 13:57:20 +0000
Received: from EX19D012UEC003.ant.amazon.com (10.252.135.160) by
 EX19D012UEC004.ant.amazon.com (10.252.135.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 2 Apr 2026 13:57:20 +0000
Received: from EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9]) by
 EX19D012UEC003.ant.amazon.com ([fe80::67ea:859:1e17:25a9%3]) with mapi id
 15.02.2562.037; Thu, 2 Apr 2026 13:57:20 +0000
From: "Heyne, Maximilian" <mheyne@amazon.de>
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "Heyne, Maximilian" <mheyne@amazon.de>, Keith Busch <kbusch@kernel.org>,
	Casey Chen <cachen@purestorage.com>, Christoph Hellwig <hch@lst.de>, "Hannes
 Reinecke" <hare@suse.de>, Ming Lei <ming.lei@redhat.com>, Chaitanya Kulkarni
	<kch@nvidia.com>, Jens Axboe <axboe@kernel.dk>, Hector Martin
	<marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>, Alyssa Rosenzweig
	<alyssa@rosenzweig.io>, Sagi Grimberg <sagi@grimberg.me>, "James E.J.
 Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>, "Avri
 Altman" <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, "Sasha
 Levin" <sashal@kernel.org>, Peter Wang <peter.wang@mediatek.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Thomas Yen
	<thomasyen@google.com>, Bean Huo <beanhuo@micron.com>, Seunghwan Baek
	<sh8267.baek@samsung.com>, Brian Kao <powenkao@google.com>, Seunghui Lee
	<sh043.lee@samsung.com>, Sanjeev Yadav <sanjeev.y@mediatek.com>, Wonkon Kim
	<wkon.kim@samsung.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "asahi@lists.linux.dev"
	<asahi@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: [PATCH 6.1.y v2 5/6] nvme: fix admin request_queue lifetime
Thread-Topic: [PATCH 6.1.y v2 5/6] nvme: fix admin request_queue lifetime
Thread-Index: AQHcwqifs3Nc8vl5p0q1jggWcESD2A==
Date: Thu, 2 Apr 2026 13:57:19 +0000
Message-ID: <20260402-sloth-visible-3c249ba7@mheyne-amazon>
References: <20260402-moral-jockey-f072379b@mheyne-amazon>
In-Reply-To: <20260402-moral-jockey-f072379b@mheyne-amazon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 03b3bcd319b3ab5182bc9aaa0421351572c78ac0]

The namespaces can access the controller's admin request_queue, and
stale references on the namespaces may exist after tearing down the
controller. Ensure the admin request_queue is active by moving the
controller's 'put' to after all controller references have been released
to ensure no one is can access the request_queue. This fixes a reported
use-after-free bug:

  BUG: KASAN: slab-use-after-free in blk_queue_enter+0x41c/0x4a0
  Read of size 8 at addr ffff88c0a53819f8 by task nvme/3287
  CPU: 67 UID: 0 PID: 3287 Comm: nvme Tainted: G            E       6.13.2-=
ga1582f1a031e #15
  Tainted: [E]=3DUNSIGNED_MODULE
  Hardware name: Jabil /EGS 2S MB1, BIOS 1.00 06/18/2025
  Call Trace:
   <TASK>
   dump_stack_lvl+0x4f/0x60
   print_report+0xc4/0x620
   ? _raw_spin_lock_irqsave+0x70/0xb0
   ? _raw_read_unlock_irqrestore+0x30/0x30
   ? blk_queue_enter+0x41c/0x4a0
   kasan_report+0xab/0xe0
   ? blk_queue_enter+0x41c/0x4a0
   blk_queue_enter+0x41c/0x4a0
   ? __irq_work_queue_local+0x75/0x1d0
   ? blk_queue_start_drain+0x70/0x70
   ? irq_work_queue+0x18/0x20
   ? vprintk_emit.part.0+0x1cc/0x350
   ? wake_up_klogd_work_func+0x60/0x60
   blk_mq_alloc_request+0x2b7/0x6b0
   ? __blk_mq_alloc_requests+0x1060/0x1060
   ? __switch_to+0x5b7/0x1060
   nvme_submit_user_cmd+0xa9/0x330
   nvme_user_cmd.isra.0+0x240/0x3f0
   ? force_sigsegv+0xe0/0xe0
   ? nvme_user_cmd64+0x400/0x400
   ? vfs_fileattr_set+0x9b0/0x9b0
   ? cgroup_update_frozen_flag+0x24/0x1c0
   ? cgroup_leave_frozen+0x204/0x330
   ? nvme_ioctl+0x7c/0x2c0
   blkdev_ioctl+0x1a8/0x4d0
   ? blkdev_common_ioctl+0x1930/0x1930
   ? fdget+0x54/0x380
   __x64_sys_ioctl+0x129/0x190
   do_syscall_64+0x5b/0x160
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x7f765f703b0b
  Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 6=
6 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 8b 0d dd 52 0f 00 f7 d8 64 89 01 48
  RSP: 002b:00007ffe2cefe808 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
  RAX: ffffffffffffffda RBX: 00007ffe2cefe860 RCX: 00007f765f703b0b
  RDX: 00007ffe2cefe860 RSI: 00000000c0484e41 RDI: 0000000000000003
  RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000000
  R10: 00007f765f611d50 R11: 0000000000000202 R12: 0000000000000003
  R13: 00000000c0484e41 R14: 0000000000000001 R15: 00007ffe2cefea60
   </TASK>

Reported-by: Casey Chen <cachen@purestorage.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[ Because we're missing commit 0da7feaa5913 ("nvme-pci: use the tagset
  alloc/free helpers") we need to additionally remove the blk_put_queue
  from nvme_dev_remove_admin in pci.c to properly fix the UAF ]
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
---
 drivers/nvme/host/core.c | 3 ++-
 drivers/nvme/host/pci.c  | 1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 044e1a9c099b3..f17318f6c82b0 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -5043,7 +5043,6 @@ EXPORT_SYMBOL_GPL(nvme_alloc_admin_tag_set);
 void nvme_remove_admin_tag_set(struct nvme_ctrl *ctrl)
 {
 	blk_mq_destroy_queue(ctrl->admin_q);
-	blk_put_queue(ctrl->admin_q);
 	if (ctrl->ops->flags & NVME_F_FABRICS) {
 		blk_mq_destroy_queue(ctrl->fabrics_q);
 		blk_put_queue(ctrl->fabrics_q);
@@ -5186,6 +5185,8 @@ static void nvme_free_ctrl(struct device *dev)
 		container_of(dev, struct nvme_ctrl, ctrl_device);
 	struct nvme_subsystem *subsys =3D ctrl->subsys;
 =

+	if (ctrl->admin_q)
+		blk_put_queue(ctrl->admin_q);
 	if (!subsys || ctrl->instance !=3D subsys->instance)
 		ida_free(&nvme_instance_ida, ctrl->instance);
 =

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 38732c0c28bbb..e8b7b0004086c 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1782,7 +1782,6 @@ static void nvme_dev_remove_admin(struct nvme_dev *de=
v)
 		 */
 		nvme_start_admin_queue(&dev->ctrl);
 		blk_mq_destroy_queue(dev->ctrl.admin_q);
-		blk_put_queue(dev->ctrl.admin_q);
 		blk_mq_free_tag_set(&dev->admin_tagset);
 	}
 }
-- =

2.50.1




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


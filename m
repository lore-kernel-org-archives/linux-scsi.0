Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52741149DF0
	for <linux-scsi@vger.kernel.org>; Mon, 26 May 2025 11:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748258552; cv=none; b=dpXqCGbEt66tbHEurHnj2GEn40+OkQqtPv4i2CgpvAFODUyM6onYCiqHC8nQ8IvDCv7kKOSmG/1R8YsVZ6hatNqJqr5DgrutihYC3NONragSqXQxX8RrjQNsUgpmPJf2EVFoKw9iwEc1VImh8dXjCcog4oIKSiD/zvwXbcwW2lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748258552; c=relaxed/simple;
	bh=uZg+yGU8pcYVGCGpREQbW4pNJhNNqPZ0ncc3jIscy9I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iNqP4V2OKGjHu3ZDynTRuwcQzvmpieYPXASfXr/yL3Dn1+Iz2UQVfIT91R7bpgrB24MiZq2n22CDsJ3l1gpahA5+7lrAhqbOZqknEYODRe1m4fyMpM0YsDqRC2my+LYU/6NtQNtV5qIQwexh+pw/PW1o895vY4MkRe/JpFgZ+ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=S1gUsoI2; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="S1gUsoI2"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-742c73f82dfso1481307b3a.2
        for <linux-scsi@vger.kernel.org>; Mon, 26 May 2025 04:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1748258549; x=1748863349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a8Rvy2VEG9VG9RMZUpG3xMh8xiC1n34E/d/WF9I9ENI=;
        b=S1gUsoI2ZN0rMc4WboznUler+ktlEKJxIVoojvtT4+hIJGXPg/AKvTpDeSu+lE1vUU
         AA0QXulB8T9/PA1BHSl2y7iL5feNmsJ22+OvhsGNdrZA29X3IsR2Xk1HWuRWZ3PBd/na
         +DrCR1SJ83k35Jooja9JBzzHhi+wISIroPjTabXwyM4sA31jWCx+Rci83BsZyPogG5Cu
         BeIfNtSoLGoFMYh6BtfP2VUzNqVbj2gZqPE0Kwy030YYrMY5aywelcBFdc5wpZY4W016
         +FuOBkPzx/JFUgDiJHkHaxJOqyDD1UK7PNJ46tokHWMMzyVA4Dm+EVXLC84U+ln72SeH
         18bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748258549; x=1748863349;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a8Rvy2VEG9VG9RMZUpG3xMh8xiC1n34E/d/WF9I9ENI=;
        b=mq4UBt/PM9oqZ/bPmxpzwwiPN/N29pcCZ77DvXvt+MvS9XB0cREOl2BR6xRAUFSMcq
         TtFoht/f1rZddHb9CEO2PtW5jjZEzRZsGR8nB9ylSBMXd5mMQJwW0kbnWbeEvlH3zseB
         vDlUHRBDSf4B9Owqu9J27LEWq7FYlNB57kRNtNpVApxec30UIMKpK3w4NwQkbZ6HKRZ1
         cUmH9PebXqXboDxDoYfQQ027B8aSZZ6xJhKYAXYZbzn7L3EhiSTy3dBA1VyOr0/mrX1z
         YBp1Df4Z1qXZIfqtR70vj+vJKipLH6RDzPWYiLQ16AkYb4DO+rKf36sn+mtWlcwwJt+s
         eHJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpR1yLA+nMh0Ma/dAg9UQJ58EIqdg3SjBAZmpTIkisP8N/TBjthrNx1HyhvZ67JWkJcj2ceCVi6Yb6@vger.kernel.org
X-Gm-Message-State: AOJu0YxstznqUAq77PeW+kWkGtvd77R3WNCezqSYoxula+5AQ+FPuOxm
	YLYv97TGhjSd+JHLvElijAGDFA1gj4AvkLlfGuxfPTCE8o/bTVexvryvlRlHF9Vagxk=
X-Gm-Gg: ASbGnctlUcmP2/OcLAwpvk+O8iqyvNKG7+c004GepCeNp8Yqjb0baI3DInYYzpanPQ8
	Y8jBFk+6tUkZfoNXjdcROlFv/cI+CzyPnYKll4uzrjyllrq0TT0/VHvQXea03mcS6GANnsGjmXd
	u+mZXTJGysPRckcNQ4dwnVUpTn2ZOlDzH8VGaNq5T9buAWSGYPuQey2lBuEWt4oWY7FIncz02NX
	FP0wWNSXL+tV8Vw9WxGCfL5yAAYNIJ+Af+rwgTd45UQ+Kp0Qut6GZpsfRM+o2cBrOUg27o2Rs/7
	3ffF7gnmcULw20p/whL1KAs0K4n1JDCGDkih9tI6zkrRRmipQT4lKlGwyMYMAQzIVTIKoeVFGt4
	i3X4BzFGzeM2P
X-Google-Smtp-Source: AGHT+IH+Q6ClUM8l/8JlwPA1KiluhWdLOAM6JflGiIQL19LY3/p+yQQpueI30OaAvJ6tLNRsg0h7Mw==
X-Received: by 2002:a05:6a00:3d15:b0:742:b3a6:db10 with SMTP id d2e1a72fcca58-745fe083538mr14760068b3a.18.1748258549404;
        Mon, 26 May 2025 04:22:29 -0700 (PDT)
Received: from HTW5T2C6VL.bytedance.net ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a982b80asm16927532b3a.116.2025.05.26.04.22.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 26 May 2025 04:22:29 -0700 (PDT)
From: Fengnan Chang <changfengnan@bytedance.com>
To: sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	Fengnan Chang <changfengnan@bytedance.com>
Subject: [RFC PATCH] scsi: mpi3mr: add remove host in mpi3mr_shutdown
Date: Mon, 26 May 2025 19:22:03 +0800
Message-Id: <20250526112203.75874-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When we do reboot test, we found the following issue:
[ 1524.234267] sd 0:0:2:0: [sdc] Synchronizing SCSI cache
[ 1524.234491] sd 0:0:1:0: [sdb] Synchronizing SCSI cache
[ 1524.234726] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 1524.235568] mpi3mr0: issuing message unit reset(MUR)
[ 1524.545409] mpi3mr0: ioc_status/ioc_config after successful message unit reset is (0x10)/(0x470000)
[ 1524.753407] mpi3mr0: ioc_status/ioc_config after successful shutdown is (0x8)/(0x472000)
[ 1526.002436] BUG: unable to handle page fault for address: 0000000000001090
[ 1526.002454] #PF: supervisor write access in kernel mode
[ 1526.002463] #PF: error_code(0x0002) - not-present page
[ 1526.002470] PGD 0 P4D 0
[ 1526.002476] Oops: 0002 [#1] SMP NOPTI
[ 1526.002483] CPU: 17 PID: 2800 Comm: kworker/17:1H Kdump: loaded Tainted: G S         OE     5.15.152-amd64 #5.15.152
[ 1526.002497] Hardware name: ByteDance ByteDance System/ByteDance System
[ 1526.002507] Workqueue: kblockd blk_mq_requeue_work
[ 1526.002517] RIP: 0010:mpi3mr_op_request_post+0x1bf/0x290 [mpi3mr]
[ 1526.002531] Code: ca f0 0f c1 42 2c 83 c0 01 83 f8 08 7f 3d f0 41 ff 86 dc 1e 00 00 49 8b 86 80 00 00 00 48 8d 94 d8 08 10 00 00 41 0f b7 47 02 <89> 02 31 db 48 8b 34 24 4c 89 e7 e8 51 85 8e c5 48 83 c4 18 89 d8
[ 1526.002551] RSP: 0018:ffff9a6244083bd8 EFLAGS: 00010003
[ 1526.002558] RAX: 0000000000000168 RBX: 0000000000000011 RCX: 0000000000000440
[ 1526.002567] RDX: 0000000000001090 RSI: 0000000000000000 RDI: ffff8af528c4e400
[ 1526.002576] RBP: 0000000000000080 R08: 000000000000001b R09: ffff8af528c4e380
[ 1526.002584] R10: 0000000000000000 R11: 0000000000000168 R12: ffff8af5431c6560
[ 1526.002593] R13: 0000000000000167 R14: ffff8af51aed87f0 R15: ffff8af5431c6550
[ 1526.002602] FS:  0000000000000000(0000) GS:ffff8b726fe40000(0000) knlGS:0000000000000000
[ 1526.002611] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1526.002619] CR2: 0000000000001090 CR3: 0000000255a04006 CR4: 0000000000770ee0
[ 1526.002628] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1526.002637] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
[ 1526.002646] PKRU: 55555554
[ 1526.002650] Call Trace:
[ 1526.002655]  <TASK>
[ 1526.002660]  ? __die_body+0x1a/0x60
[ 1526.002668]  ? page_fault_oops+0x131/0x270
[ 1526.002675]  ? update_group_capacity+0x25/0x1b0
[ 1526.002684]  ? exc_page_fault+0x79/0x160
[ 1526.002692]  ? asm_exc_page_fault+0x22/0x30
[ 1526.002700]  ? mpi3mr_op_request_post+0x1bf/0x290 [mpi3mr]
[ 1526.002711]  ? mpi3mr_op_request_post+0xe2/0x290 [mpi3mr]
[ 1526.002721]  mpi3mr_qcmd+0x43b/0xc10 [mpi3mr]
[ 1526.002730]  ? scsi_init_command+0x102/0x160 [scsi_mod]
[ 1526.002746]  ? ktime_get+0x3b/0xa0
[ 1526.002753]  scsi_queue_rq+0x375/0xa60 [scsi_mod]
[ 1526.002765]  blk_mq_dispatch_rq_list+0x13f/0x810
[ 1526.002774]  __blk_mq_sched_dispatch_requests+0xb4/0x140
[ 1526.002782]  blk_mq_sched_dispatch_requests+0x30/0x60
[ 1526.002790]  __blk_mq_run_hw_queue+0x2b/0x60
[ 1526.002798]  __blk_mq_delay_run_hw_queue+0x13a/0x160
[ 1526.002806]  blk_mq_run_hw_queues+0x45/0xc0
[ 1526.002813]  blk_mq_requeue_work+0x159/0x180
[ 1526.002819]  process_one_work+0x1ce/0x370
[ 1526.003004]  ? process_one_work+0x370/0x370
[ 1526.003183]  worker_thread+0x30/0x380
[ 1526.003359]  ? process_one_work+0x370/0x370
[ 1526.003573]  kthread+0xc0/0xe0
[ 1526.003794]  ? __kthread_cancel_work+0x40/0x40
[ 1526.004015]  ret_from_fork+0x1f/0x30

After my analysis, I think it is like this:
When the machine reboots, the shutdown function of all devices will
be called.
In mpi3mr_shutdown, the mpi3mr driver releases related resources when
shutting down the device, but does not quiesce or destroy the request_queue
in block layer, which leads to the possibility that io may still be issued
to mpi3mr driver, and when the mpi3mr driver try to processes io, it's
possible to access the released resources.
So add remove scsi&sas host in mpi3mr_shutdown to destroy request_queue.

BTW, the above call trace log is reproduced on Debian+ 5.15.152 kernel
using the mpi3mr 8.12 driver version, but this issue still exist in the
upstream version.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index c186b892150f..443430d51603 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5603,6 +5603,11 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
 	if (wq)
 		destroy_workqueue(wq);
 
+	if (mrioc->sas_transport_enabled)
+		sas_remove_host(shost);
+	else
+		scsi_remove_host(shost);
+
 	mpi3mr_stop_watchdog(mrioc);
 	mpi3mr_cleanup_ioc(mrioc);
 	mpi3mr_cleanup_resources(mrioc);
-- 
2.39.2 (Apple Git-143)


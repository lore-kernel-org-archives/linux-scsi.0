Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818F1823AF
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 07:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720595218; cv=none; b=QiLTl5hR1EpOaFicZnPab1c4DK5JprgZCegJh4kgYknxYPj/LZ9gvsqQEZtKZhvgxUZW/mSqGI6m7ht3pXKbLMslSQjrqQIiXYj8jaxtNfjgsjqqGtYHAxKWFK3jvO0BMhE4vgNdFjcUtZIkTa1WTm+zKA+/P43sbHG489ksn6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720595218; c=relaxed/simple;
	bh=zsLNcCb20Ccps4H8+mYPt2OXdBGILVgPEGqJ6O7g1L0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=nS3/di/r0pZfzeWluxQS/esR1YrRj40fiptoeiutI2GD7foGP7om6WuHsS9HL85FkobpP8ZCCOo0mznanTWAkRKjNHs9VZf172WBUHMFaBa4m8JfyMWMjuaiUasiXXX2qj0eHxMKYRYsEblOoZ5QRpmUnHDUCS8XUtpP+BkixVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lSKqL//h; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lSKqL//h"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-4f2f39829a9so2013647e0c.2
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 00:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720595214; x=1721200014; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IOCPHr7p6x9hJpFOYS5ad7rsTTZbDEcjyEiFb6iO8Rk=;
        b=lSKqL//hEC5RdASc+jfJKFshXHMhtjshThJNzip4I6S2G4g2ZZWznmaJtB5ZuBY2JU
         NtNN3Kv4+aDkB1Wq4XURwNnnu3vL81q7DC5kTaYi1T4ifGyG15IfCF/ZO6WPczE7SCy+
         ML3WmFwikvVUmpGB4sxEH3ZNkzpNm135gTtHVd90LxewqLm66xAqzsTaKtlE6rcfcp4o
         GgynZQKRzU2QPf/yqMBmtF0er/phMRm7nFHojp+D6kS93xJd8EFRyuj2hSBi3FzKK8zD
         bKX6zcNf+wK2I1y6dnBMP23sGIbhSyNSFvtsShzvpe8RmyTgEcBdWaDlGaa3QU1xRc4i
         9ONQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720595214; x=1721200014;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IOCPHr7p6x9hJpFOYS5ad7rsTTZbDEcjyEiFb6iO8Rk=;
        b=o5MNDarGecgRx/xLjn7rv0qgF+yqcJ38zt97q8eU+9Q8j6bnMEqdba0x32Cjo+eOsU
         L77Bvs9HkomiOcER7LYXknszyGGviaw5UAMsUUx115wn5u7bEF3dDSOeZjdMCCF2RzR3
         EAA6yz/QuKPJAcVZMjIH70suI2HgENeDqwkHR7JefcOYkzWb2643tyjct9JqyPZt3Xum
         BEUi1Rc1nkEsQD08tYcekskc1t5vIbMnUwYsTd2K5yGW4QySq2wIb7yOePE/8JxtEtgM
         g9/ZSWjkbL51PaqL1iA2SCL7WYYy+dEAhdivJvjx8hXNcBxsB/uT8I2OXwP0aljdXLIm
         qCjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVv0dw53tAyqybRE00hneaXKITMzBrJU0jJ5olISiq9qhTLQKahlg7d0J1g3h3PI6KGvR30ubHDBSIZlHuzmZOlaV9fFDDtIH4BsQ==
X-Gm-Message-State: AOJu0YxDWw5PElFzqZB2FcPwVXQQ7VIAIcfSlu83/c8jAz8pOy1uOB+D
	3vEG0f2q3GIv5LNeucnKlSOfR5Jf9K5o52eChfWtjuHDXxiF2hExj6XUS3gbB8/G+Lv78u0o7yc
	ejmy1P1D3q/o+gvk8s4m92lj4T+57CkEQITjTxA==
X-Google-Smtp-Source: AGHT+IGlfU91hkSyX6VrmE5WOY7XcciMtki2fwsUMZ64RffWUc3H0Z99rBV67A3Nb7LXhvvtGT0k10N7XPo1KA+lVys=
X-Received: by 2002:a05:6122:4d84:b0:4ef:6870:ff5 with SMTP id
 71dfb90a1353d-4f33f1db5famr5896471e0c.5.1720595213772; Wed, 10 Jul 2024
 00:06:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 10 Jul 2024 12:36:42 +0530
Message-ID: <CA+G9fYuSAE=WjPBDQ=rTLdVit2A6aay_cQHKreJ02FFGFU+vSQ@mail.gmail.com>
Subject: next-20240709: kernel BUG at drivers/scsi/scsi_lib.c:1160! - WARNING:
 block/blk-merge.c:607 __blk_rq_map_sg
To: linux-block <linux-block@vger.kernel.org>, linux-scsi@vger.kernel.org, 
	open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Chaitanya Kulkarni <chaitanyak@nvidia.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Anders Roxell <anders.roxell@linaro.org>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

The arm64 Juno-r2 boot failed due to boot BUG and Warnings [1] while booting
Linux next-20240709 tag kernel.

The arm64 juno-r2 device is configured to boot via NFS and also has an attached
SATA drive for running mount tests.

Always reproducible: Yes.

Following are the list of kernel warnings and BUG,
  WARNING: CPU: 2 PID: 236 at block/blk-merge.c:607 __blk_rq_map_sg
(block/blk-merge.c:607 (discriminator 1))
  kernel BUG at drivers/scsi/scsi_lib.c:1160!
  WARNING: CPU: 0 PID: 236 at kernel/exit.c:829 do_exit
(kernel/exit.c:829 (discriminator 1))
  WARNING: CPU: 2 PID: 0 at kernel/context_tracking.c:128
ct_kernel_exit.constprop.0 (kernel/context_tracking.c:128
(discriminator 1))

This is started from Linux next-20240709.
  GOOD: next-20240703
  BAD: next-20240709

Build details,
-------
kernel: 6.10.0-rc7
git_repo: https://gitlab.com/Linaro/lkft/mirrors/next/linux-next
git_ref: master
git_sha: 82d01fe6ee52086035b201cfa1410a3b04384257
git_describe: next-20240709
Test details: https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20240709

Regressions (compared to build next-20240703)
------------------------------------------------------------------------

juno-r2:
  boot:
    * gcc-13-lkftconfig
    * gcc-13-lkftconfig-debug
    * gcc-13-lkftconfig-rcutorture
    * gcc-13-lkftconfig-debug-kmemleak
    * clang-nightly-lkftconfig
    * clang-18-lkftconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Crash log [1]:
------
[   34.473953] sky2 0000:08:00.0 enp8s0: renamed from eth0
[   34.748839] ------------[ cut here ]------------
[   34.748856] usbcore: registered new device driver onboard-usb-dev
[   34.753472] WARNING: CPU: 2 PID: 236 at block/blk-merge.c:607
__blk_rq_map_sg (block/blk-merge.c:607 (discriminator 1))
[   34.753497] Modules linked in: onboard_usb_dev(+) hdlcd cec
crct10dif_ce gpu_sched drm_dma_helper drm_kms_helper fuse drm
backlight dm_mod ip_tables x_tables
[   34.753528] CPU: 2 UID: 0 PID: 236 Comm: (udev-worker) Not tainted
6.10.0-rc7-next-20240709 #1
[   34.753537] Hardware name: ARM Juno development board (r2) (DT)
[   34.753540] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   34.753548] pc : __blk_rq_map_sg (block/blk-merge.c:607 (discriminator 1))
[   34.753557] lr : __blk_rq_map_sg (block/blk-merge.c:482
block/blk-merge.c:509 block/blk-merge.c:573 block/blk-merge.c:598)
[   34.753565] sp : ffff8000846c3420
[   34.753568] x29: ffff8000846c3490 x28: 0000000000000000 x27: ffff8000846c3500
[   34.753578] x26: 0000000000000000 x25: ffff0008225495a0 x24: 0000000000000000
[   34.753587] x23: ffff000822549540 x22: ffff000800c9b000 x21: 0000000000000008
[   34.753595] x20: ffff000822549380 x19: 0000000000002000 x18: 0000000000000000
[   34.753604] x17: 000000000000ffff x16: 0000000000002000 x15: ffff00082180d000
[   34.753612] x14: ffff80008224c118 x13: 0000000000000000 x12: 0000000000000004
[   34.753620] x11: ffff00082204da80 x10: 0000000000000000 x9 : ffff800080b912c8
[   34.753629] x8 : 0000000000014000 x7 : 0000000000000000 x6 : 0000000000000000
[   34.753637] x5 : 0000000000000001 x4 : 0000000000014000 x3 : ffff8000846c3500
[   34.753645] x2 : 0000000000000000 x1 : 000000000000000a x0 : 0000000000000008
[   34.753653] Call trace:
[   34.753655] __blk_rq_map_sg (block/blk-merge.c:607 (discriminator 1))
[   34.753665] scsi_alloc_sgtables (drivers/scsi/scsi_lib.c:1140)
[   34.753674] sd_init_command (drivers/scsi/sd.c:1337 drivers/scsi/sd.c:1458)
[   34.753681] scsi_queue_rq (drivers/scsi/scsi_lib.c:1832)
[   34.753688] blk_mq_dispatch_rq_list (block/blk-mq.c:2032)
[   34.753695] __blk_mq_sched_dispatch_requests
(block/blk-mq-sched.c:170 block/blk-mq-sched.c:184
block/blk-mq-sched.c:309)
[   34.753703] blk_mq_sched_dispatch_requests
(block/blk-mq-sched.c:331 (discriminator 1))
[   34.753711] blk_mq_run_hw_queue (include/linux/rcupdate.h:871
block/blk-mq.c:2245)
[   34.753717] blk_mq_flush_plug_list.part.0 (block/blk-mq.c:2750
block/blk-mq.c:2794)
[   34.753723] blk_mq_flush_plug_list (block/blk-mq.c:2796)
[   34.753730] __blk_flush_plug (block/blk-core.c:1202 (discriminator 1))
[   34.753736] blk_finish_plug (block/blk-core.c:1223 (discriminator
1) block/blk-core.c:1219 (discriminator 1))
[   34.753743] read_pages (mm/readahead.c:188 (discriminator 2))
[   34.753751] page_cache_ra_unbounded (mm/readahead.c:258)
[   34.753759] force_page_cache_ra (mm/readahead.c:327)
[   34.753767] page_cache_sync_ra (mm/readahead.c:577)
[   34.753775] filemap_get_pages (mm/filemap.c:2531)
[   34.753784] filemap_read (mm/filemap.c:2625)
[   34.753793] blkdev_read_iter (block/fops.c:764)
[   34.753801] vfs_read (fs/read_write.c:395 fs/read_write.c:476)
[   34.753808] ksys_read (fs/read_write.c:619)
[   34.753814] __arm64_sys_read (fs/read_write.c:627)
[   34.753821] invoke_syscall (arch/arm64/include/asm/current.h:19
arch/arm64/kernel/syscall.c:54)
[   34.753831] el0_svc_common.constprop.0 (arch/arm64/kernel/syscall.c:139)
[   34.753840] do_el0_svc (arch/arm64/kernel/syscall.c:152)
[   34.753848] el0_svc (arch/arm64/include/asm/irqflags.h:82
(discriminator 1) arch/arm64/include/asm/irqflags.h:123 (discriminator
1) arch/arm64/include/asm/irqflags.h:136 (discriminator 1)
arch/arm64/kernel/entry-common.c:165 (discriminator 1)
arch/arm64/kernel/entry-common.c:178 (discriminator 1)
arch/arm64/kernel/entry-common.c:713 (discriminator 1))
[   34.753857] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:731)
[   34.753864] el0t_64_sync (arch/arm64/kernel/entry.S:598)
[   34.753870] ---[ end trace 0000000000000000 ]---
[   34.767944] ------------[ cut here ]------------
[   35.011822] kernel BUG at drivers/scsi/scsi_lib.c:1160!
[   35.017056] Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
[   35.017063] Modules linked in: drm_shmem_helper onboard_usb_dev
hdlcd cec crct10dif_ce gpu_sched drm_dma_helper drm_kms_helper fuse
drm backlight dm_mod ip_tables x_tables
[   35.017097] CPU: 2 UID: 0 PID: 236 Comm: (udev-worker) Tainted: G
     W          6.10.0-rc7-next-20240709 #1
[   35.017107] Tainted: [W]=WARN
[   35.017109] Hardware name: ARM Juno development board (r2) (DT)
[   35.017113] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   35.017120] pc : scsi_alloc_sgtables (drivers/scsi/scsi_lib.c:1160
(discriminator 1))
[   35.017132] lr : scsi_alloc_sgtables (drivers/scsi/scsi_lib.c:1140)
[   35.017139] sp : ffff8000846c34f0
[   35.017141] x29: ffff8000846c3510 x28: 0000000000000003 x27: 00000000000000d0
[   35.017151] x26: ffff000800c9b000 x25: 0000000000000000 x24: 0000000000000000
[   35.017159] x23: ffff000822549540 x22: ffff000800c9b000 x21: 000000000000000a
[   35.017167] x20: ffff000822549380 x19: ffff000822549478 x18: 0000000000000000
[   35.017175] x17: 000000000000ffff x16: 0000000000002000 x15: ffff00082180d000
[   35.017184] x14: ffff80008224c118 x13: 0000000000000000 x12: 0000000000000004
[   35.017192] x11: ffff00082204da80 x10: 0000000000000000 x9 : ffff800080b912c8
[   35.017200] x8 : 0000000000014000 x7 : 0000000000000000 x6 : 0000000000000000
[   35.017208] x5 : 0000000000000001 x4 : 0000000000014000 x3 : ffff8000846c3500
[   35.017216] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000008
[   35.017225] Call trace:
[   35.017227] scsi_alloc_sgtables (drivers/scsi/scsi_lib.c:1160
(discriminator 1))
[   35.017234] sd_init_command (drivers/scsi/sd.c:1337 drivers/scsi/sd.c:1458)
[   35.017242] scsi_queue_rq (drivers/scsi/scsi_lib.c:1832)
[   35.017248] blk_mq_dispatch_rq_list (block/blk-mq.c:2032)
[   35.017257] __blk_mq_sched_dispatch_requests
(block/blk-mq-sched.c:170 block/blk-mq-sched.c:184
block/blk-mq-sched.c:309)
[   35.017265] blk_mq_sched_dispatch_requests
(block/blk-mq-sched.c:331 (discriminator 1))
[   35.017273] blk_mq_run_hw_queue (include/linux/rcupdate.h:871
block/blk-mq.c:2245)
[   35.017279] blk_mq_flush_plug_list.part.0 (block/blk-mq.c:2750
block/blk-mq.c:2794)
[   35.017285] blk_mq_flush_plug_list (block/blk-mq.c:2796)
[   35.017292] __blk_flush_plug (block/blk-core.c:1202 (discriminator 1))
[   35.017299] blk_finish_plug (block/blk-core.c:1223 (discriminator
1) block/blk-core.c:1219 (discriminator 1))
[   35.017306] read_pages (mm/readahead.c:188 (discriminator 2))
[   35.017315] page_cache_ra_unbounded (mm/readahead.c:258)
[   35.017323] force_page_cache_ra (mm/readahead.c:327)
[   35.017330] page_cache_sync_ra (mm/readahead.c:577)
[   35.017338] filemap_get_pages (mm/filemap.c:2531)
[   35.017347] filemap_read (mm/filemap.c:2625)
[   35.017355] blkdev_read_iter (block/fops.c:764)
[   35.017364] vfs_read (fs/read_write.c:395 fs/read_write.c:476)
[   35.017371] ksys_read (fs/read_write.c:619)
[   35.017377] __arm64_sys_read (fs/read_write.c:627)
[   35.017384] invoke_syscall (arch/arm64/include/asm/current.h:19
arch/arm64/kernel/syscall.c:54)
[   35.017395] el0_svc_common.constprop.0 (arch/arm64/kernel/syscall.c:139)
[   35.017404] do_el0_svc (arch/arm64/kernel/syscall.c:152)
[   35.017412] el0_svc (arch/arm64/include/asm/irqflags.h:82
(discriminator 1) arch/arm64/include/asm/irqflags.h:123 (discriminator
1) arch/arm64/include/asm/irqflags.h:136 (discriminator 1)
arch/arm64/kernel/entry-common.c:165 (discriminator 1)
arch/arm64/kernel/entry-common.c:178 (discriminator 1)
arch/arm64/kernel/entry-common.c:713 (discriminator 1))
[   35.017420] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:731)
[   35.017428] el0t_64_sync (arch/arm64/kernel/entry.S:598)
[ 35.017437] Code: 52800155 17ffff7a 52800135 17ffff78 (d4210000)
All code
========
   0: 52800155 mov w21, #0xa                    // #10
   4: 17ffff7a b 0xfffffffffffffdec
   8: 52800135 mov w21, #0x9                    // #9
   c: 17ffff78 b 0xfffffffffffffdec
  10:* d4210000 brk #0x800 <-- trapping instruction

Code starting with the faulting instruction
===========================================
   0: d4210000 brk #0x800
[   35.017441] ---[ end trace 0000000000000000 ]---
[   35.272094] note: (udev-worker)[236] exited with irqs disabled
[   35.272149] note: (udev-worker)[236] exited with preempt_count 1
[[0;32m  OK  [0m] Finished [0;[   35.285437] ------------[ cut here
]------------
[   35.286047] ------------[ cut here ]------------
1;39msystemd-tmpfiles-setup.se35.291955] WARNING: CPU: 0 PID: 236 at
kernel/exit.c:829 do_exit (kernel/exit.c:829 (discriminator 1))
0mate Volatile Files and Dire[   35.291982] Modules linked in:
panfrost tda998x(+) drm_shmem_helper onboard_usb_dev hdlcd cec
crct10dif_ce gpu_sched drm_dma_helper drm_kms_helper fuse drm
backlight dm_mod ip_tables x_tables
ctories.
[   35.292046] CPU: 0 UID: 0 PID: 236 Comm: (udev-worker) Tainted: G
   D W          6.10.0-rc7-next-20240709 #1
[   35.292061] Tainted: [D]=DIE, [W]=WARN
[   35.292065] Hardware name: ARM Juno development board (r2) (DT)
[   35.292071] pstate: 40000005 (nZcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   35.292081] pc : do_exit (kernel/exit.c:829 (discriminator 1))
[   35.292094] lr : do_exit (kernel/exit.c:829 (discriminator 1))
[   35.292105] sp : ffff8000846c3150
[   35.292109] x29: ffff8000846c3180 x28: ffff000821fab900 x27: 00000000000000d0
[   35.292125] x26: ffff800081fe0f38 x25: 00000000000003c0 x24: 0000000000000000
[   35.292139] x23: ffff800081fe0fa0 x22: 000000000000000b x21: ffff000800f7e300
[   35.292154] x20: ffff000800f66300 x19: ffff000821fab900 x18: 0000000000000042
[   35.292168] x17: 0000000000000000 x16: 0030342e36312e36 x15: 362e30310b000000
[   35.292183] x14: 0000000020000000 x13: 70c83fcb00000000 x12: 0000000000000001
[   35.292197] x11: 0000000000000040 x10: 0000000000000c70 x9 : ffff80008154fdd0
[   35.292211] x8 : ffff8000846c3048 x7 : 0000000000000000 x6 : 0000000000000001
[   35.292225] x5 : ffff8000831af000 x4 : ffff8000831af5a8 x3 : 0000000000000000
[   35.292239] x2 : ffff000821fab900 x1 : ffff8000800b4f38 x0 : ffff8000846c3908
[   35.292254] Call trace:
[   35.292258] do_exit (kernel/exit.c:829 (discriminator 1))
[   35.292271] make_task_dead
(arch/arm64/include/asm/atomic_ll_sc.h:95 (discriminator 2)
arch/arm64/include/asm/atomic.h:52 (discriminator 2)
include/linux/atomic/atomic-arch-fallback.h:564 (discriminator 2)
include/linux/atomic/atomic-arch-fallback.h:1020 (discriminator 2)
include/linux/atomic/atomic-instrumented.h:454 (discriminator 2)
kernel/exit.c:978 (discriminator 2))
[   35.292283] die (arch/arm64/kernel/traps.c:239)
[   35.292293] bug_handler (arch/arm64/kernel/traps.c:992)
[   35.292303] call_break_hook (arch/arm64/kernel/debug-monitors.c:320)
[   35.292314] brk_handler (arch/arm64/kernel/debug-monitors.c:326
(discriminator 1))
[   35.292324] do_debug_exception (arch/arm64/mm/fault.c:909 (discriminator 1))
[   35.292339] el1_dbg (arch/arm64/kernel/entry-common.c:473)
[   35.292352] el1h_64_sync_handler (arch/arm64/kernel/entry-common.c:520)
[   35.292365] el1h_64_sync (arch/arm64/kernel/entry.S:593)
[   35.292374] scsi_alloc_sgtables (drivers/scsi/scsi_lib.c:1160
(discriminator 1))
[   35.292387] sd_init_command (drivers/scsi/sd.c:1337 drivers/scsi/sd.c:1458)
[   35.292399] scsi_queue_rq (drivers/scsi/scsi_lib.c:1832)
[   35.292410] blk_mq_dispatch_rq_list (block/blk-mq.c:2032)
[   35.292423] __blk_mq_sched_dispatch_requests
(block/blk-mq-sched.c:170 block/blk-mq-sched.c:184
block/blk-mq-sched.c:309)
[   35.292437] blk_mq_sched_dispatch_requests
(block/blk-mq-sched.c:331 (discriminator 1))
[   35.292450] blk_mq_run_hw_queue (include/linux/rcupdate.h:871
block/blk-mq.c:2245)
[   35.292461] blk_mq_flush_plug_list.part.0 (block/blk-mq.c:2750
block/blk-mq.c:2794)
[   35.292473] blk_mq_flush_plug_list (block/blk-mq.c:2796)
[   35.292484] __blk_flush_plug (block/blk-core.c:1202 (discriminator 1))
[   35.292496] blk_finish_plug (block/blk-core.c:1223 (discriminator
1) block/blk-core.c:1219 (discriminator 1))
[   35.292507] read_pages (mm/readahead.c:188 (discriminator 2))
[   35.292521] page_cache_ra_unbounded (mm/readahead.c:258)
[   35.292534] force_page_cache_ra (mm/readahead.c:327)
[   35.292547] page_cache_sync_ra (mm/readahead.c:577)
[   35.292560] filemap_get_pages (mm/filemap.c:2531)
[   35.292575] filemap_read (mm/filemap.c:2625)
[   35.292588] blkdev_read_iter (block/fops.c:764)
[   35.292602] vfs_read (fs/read_write.c:395 fs/read_write.c:476)
[   35.292614] ksys_read (fs/read_write.c:619)
[   35.292624] __arm64_sys_read (fs/read_write.c:627)
[   35.292635] invoke_syscall (arch/arm64/include/asm/current.h:19
arch/arm64/kernel/syscall.c:54)
[   35.292650] el0_svc_common.constprop.0 (arch/arm64/kernel/syscall.c:139)
[   35.292665] do_el0_svc (arch/arm64/kernel/syscall.c:152)
[   35.292679] el0_svc (arch/arm64/include/asm/irqflags.h:82
(discriminator 1) arch/arm64/include/asm/irqflags.h:123 (discriminator
1) arch/arm64/include/asm/irqflags.h:136 (discriminator 1)
arch/arm64/kernel/entry-common.c:165 (discriminator 1)
arch/arm64/kernel/entry-common.c:178 (discriminator 1)
arch/arm64/kernel/entry-common.c:713 (discriminator 1))
[   35.292691] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:731)
[   35.292703] el0t_64_sync (arch/arm64/kernel/entry.S:598)
[   35.292713] ---[ end trace 0000000000000000 ]---
[   35.296623] ------------[ cut here ]------------
[   35.306500] WARNING: CPU: 2 PID: 0 at kernel/context_tracking.c:128
ct_kernel_exit.constprop.0 (kernel/context_tracking.c:128
(discriminator 1))
[   35.306521] Modules linked in: panfrost tda998x(+) drm_shmem_helper
onboard_usb_dev hdlcd cec crct10dif_ce gpu_sched drm_dma_helper
drm_kms_helper fuse drm backlight dm_mod ip_tables x_tables
[   35.306559] CPU: 2 UID: 0 PID: 0 Comm: swapper/2 Tainted: G      D
W          6.10.0-rc7-next-20240709 #1
[   35.306569] Tainted: [D]=DIE, [W]=WARN
[   35.306571] Hardware name: ARM Juno development board (r2) (DT)
[   35.306575] pstate: 200000c5 (nzCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   35.306581] pc : ct_kernel_exit.constprop.0
(kernel/context_tracking.c:128 (discriminator 1))
[   35.306590] lr : ct_idle_enter (kernel/context_tracking.c:321)
[   35.306598] sp : ffff800083acbd60
[   35.306601] x29: ffff800083acbd60 x28: 0000000000000000 x27: 0000000000000000
[   35.306610] x26: 0000000000000000 x25: 0000000000000000 x24: 00000008373621a0
[   35.306618] x23: ffff000822011080 x22: ffff000822011080 x21: ffff00097ec61d38
[   35.306627] x20: ffff000822011098 x19: ffff00097ec5f038 x18: ffff80008470bc28
[   35.306635] x17: 0000000000000000 x16: ffff800081bb82f8 x15: 0000ffffaa241000
[   35.306643] x14: 0000000000000001 x13: ffff0008226d6708 x12: 0000000000000001
[   35.306651] x11: 071c71c71c71c71c x10: ffff00097ec620a4 x9 : ffff8000815409f8
[   35.306660] x8 : ffff800083acbc98 x7 : 0000000000000001 x6 : ffff8000831af000
[   35.306668] x5 : 4000000000000002 x4 : ffff8008fc677000 x3 : ffff800083acbd60
[   35.306676] x2 : ffff8000825e8038 x1 : ffff8000825e8038 x0 : 4000000000000000
[   35.306684] Call trace:
[   35.306687] ct_kernel_exit.constprop.0
(kernel/context_tracking.c:128 (discriminator 1))
[   35.306696] ct_idle_enter (kernel/context_tracking.c:321)
[   35.306704] cpuidle_enter_state (include/linux/cpuidle.h:136
drivers/cpuidle/cpuidle.c:250)
[   35.306712] cpuidle_enter (drivers/cpuidle/cpuidle.c:390 (discriminator 2))
[   35.306718] do_idle (kernel/sched/idle.c:155
kernel/sched/idle.c:230 kernel/sched/idle.c:326)
[   35.306728] cpu_startup_entry (kernel/sched/idle.c:423)
[   35.306736] secondary_start_kernel
(arch/arm64/include/asm/atomic_ll_sc.h:95 (discriminator 2)
arch/arm64/include/asm/atomic.h:28 (discriminator 2)
include/linux/atomic/atomic-arch-fallback.h:546 (discriminator 2)
include/linux/atomic/atomic-arch-fallback.h:994 (discriminator 2)
include/linux/atomic/atomic-instrumented.h:436 (discriminator 2)
include/linux/sched/mm.h:37 (discriminator 2)
arch/arm64/kernel/smp.c:212 (discriminator 2))
[   35.306745] __secondary_switched (arch/arm64/kernel/head.S:418)
[   35.306754] ---[ end trace 0000000000000000 ]---
[   35.429740] tda998x 0-0070: found TDA19988
[   35.435881] Voluntary context switch within RCU read-side critical section!
[   35.435910] WARNING: CPU: 5 PID: 236 at
kernel/rcu/tree_plugin.h:330 rcu_note_context_switch
(kernel/rcu/tree_plugin.h:330 (discriminator 1))
[   35.435941] Modules linked in: panfrost tda998x(+) drm_shmem_helper
onboard_usb_dev hdlcd cec crct10dif_ce gpu_sched drm_dma_helper
drm_kms_helper fuse drm backlight dm_mod ip_tables x_tables
[   35.436009] CPU: 5 UID: 0 PID: 236 Comm: (udev-worker) Tainted: G
   D W          6.10.0-rc7-next-20240709 #1
[   35.436025] Tainted: [D]=DIE, [W]=WARN
[   35.436029] Hardware name: ARM Juno development board (r2) (DT)
[   35.436034] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   35.436045] pc : rcu_note_context_switch
(kernel/rcu/tree_plugin.h:330 (discriminator 1))
[   35.436058] lr : rcu_note_context_switch
(kernel/rcu/tree_plugin.h:330 (discriminator 1))
[   35.436070] sp : ffff8000846c2bb0
[   35.436074] x29: ffff8000846c2bb0 x28: 0000000000000000 x27: ffff8000846c2d08
[   35.436089] x26: 0000000000000000 x25: ffff000821fab900 x24: ffff800081547ae8
[   35.436104] x23: 0000000000000000 x22: ffff000821fab900 x21: ffff800083808220
[   35.436118] x20: 0000000000000000 x19: ffff00097ecca8c0 x18: 0000000000000006
[   35.436133] x17: 3039336336343830 x16: 3030386666666620 x15: 3a20307820383366
[   35.436147] x14: 3462303038303030 x13: 216e6f6974636573 x12: 206c616369746972
[   35.436162] x11: 6320656469732d64 x10: 6165722055435220 x9 : ffff800080142ae8
[   35.436176] x8 : 6863746977732074 x7 : 7865746e6f632079 x6 : 7261746e756c6f56
[   35.436190] x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000027
[   35.436204] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff000821fab900
[   35.436219] Call trace:
[   35.436222] rcu_note_context_switch (kernel/rcu/tree_plugin.h:330
(discriminator 1))
[   35.436236] __schedule (kernel/sched/core.c:566
kernel/sched/sched.h:1476 kernel/sched/sched.h:1775
kernel/sched/core.c:6510)
[   35.436247] schedule (kernel/sched/core.c:6681 kernel/sched/core.c:6695)
[   35.436257] io_schedule (arch/arm64/include/asm/current.h:19
kernel/sched/core.c:7455 kernel/sched/core.c:7481)
[   35.436267] folio_wait_bit_common (mm/filemap.c:1299 (discriminator 1))
[   35.436282] __folio_lock (mm/filemap.c:1647)
[   35.436295] truncate_inode_pages_range
(include/linux/pagemap.h:1050 mm/truncate.c:413)
[   35.436311] truncate_inode_pages (mm/truncate.c:441)
[   35.436326] blkdev_flush_mapping (block/bdev.c:48 block/bdev.c:65
block/bdev.c:665)
[   35.436339] blkdev_put_whole (block/bdev.c:671)
[   35.436350] bdev_release (block/bdev.c:1097)
[   35.436362] blkdev_release (block/fops.c:640)
[   35.436373] __fput (fs/file_table.c:423 (discriminator 1))
[   35.436387] ____fput (fs/file_table.c:451)
[   35.436398] task_work_run (kernel/task_work.c:207 (discriminator 1))
[   35.436409] do_exit (kernel/exit.c:891)
[   35.436422] make_task_dead
(arch/arm64/include/asm/atomic_ll_sc.h:95 (discriminator 2)
arch/arm64/include/asm/atomic.h:52 (discriminator 2)
include/linux/atomic/atomic-arch-fallback.h:564 (discriminator 2)
include/linux/atomic/atomic-arch-fallback.h:1020 (discriminator 2)
include/linux/atomic/atomic-instrumented.h:454 (discriminator 2)
kernel/exit.c:978 (discriminator 2))
[   35.436435] die (arch/arm64/kernel/traps.c:239)
[   35.436445] bug_handler (arch/arm64/kernel/traps.c:992)
[   35.436455] call_break_hook (arch/arm64/kernel/debug-monitors.c:320)
[   35.436466] brk_handler (arch/arm64/kernel/debug-monitors.c:326
(discriminator 1))
[   35.436475] do_debug_exception (arch/arm64/mm/fault.c:909 (discriminator 1))
[   35.436490] el1_dbg (arch/arm64/kernel/entry-common.c:473)
[   35.436503] el1h_64_sync_handler (arch/arm64/kernel/entry-common.c:520)
[   35.436516] el1h_64_sync (arch/arm64/kernel/entry.S:593)
[   35.436525] scsi_alloc_sgtables (drivers/scsi/scsi_lib.c:1160
(discriminator 1))
[   35.436538] sd_init_command (drivers/scsi/sd.c:1337 drivers/scsi/sd.c:1458)
[   35.436550] scsi_queue_rq (drivers/scsi/scsi_lib.c:1832)
[   35.436561] blk_mq_dispatch_rq_list (block/blk-mq.c:2032)
[   35.436573] __blk_mq_sched_dispatch_requests
(block/blk-mq-sched.c:170 block/blk-mq-sched.c:184
block/blk-mq-sched.c:309)
[   35.436588] blk_mq_sched_dispatch_requests
(block/blk-mq-sched.c:331 (discriminator 1))
[   35.436601] blk_mq_run_hw_queue (include/linux/rcupdate.h:871
block/blk-mq.c:2245)
[   35.436612] blk_mq_flush_plug_list.part.0 (block/blk-mq.c:2750
block/blk-mq.c:2794)
[   35.436624] blk_mq_flush_plug_list (block/blk-mq.c:2796)
[   35.436635] __blk_flush_plug (block/blk-core.c:1202 (discriminator 1))
[   35.436647] blk_finish_plug (block/blk-core.c:1223 (discriminator
1) block/blk-core.c:1219 (discriminator 1))
[   35.436659] read_pages (mm/readahead.c:188 (discriminator 2))
[   35.436672] page_cache_ra_unbounded (mm/readahead.c:258)
[   35.436686] force_page_cache_ra (mm/readahead.c:327)
[   35.436699] page_cache_sync_ra (mm/readahead.c:577)
[   35.436712] filemap_get_pages (mm/filemap.c:2531)
[   35.436726] filemap_read (mm/filemap.c:2625)
[   35.436739] blkdev_read_iter (block/fops.c:764)
[   35.436751] vfs_read (fs/read_write.c:395 fs/read_write.c:476)
[   35.436763] ksys_read (fs/read_write.c:619)
[   35.436774] __arm64_sys_read (fs/read_write.c:627)
[   35.436785] invoke_syscall (arch/arm64/include/asm/current.h:19
arch/arm64/kernel/syscall.c:54)
[   35.436801] el0_svc_common.constprop.0 (arch/arm64/kernel/syscall.c:139)
[   35.436815] do_el0_svc (arch/arm64/kernel/syscall.c:152)
[   35.436829] el0_svc (arch/arm64/include/asm/irqflags.h:82
(discriminator 1) arch/arm64/include/asm/irqflags.h:123 (discriminator
1) arch/arm64/include/asm/irqflags.h:136 (discriminator 1)
arch/arm64/kernel/entry-common.c:165 (discriminator 1)
arch/arm64/kernel/entry-common.c:178 (discriminator 1)
arch/arm64/kernel/entry-common.c:713 (discriminator 1))
[   35.436841] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:731)
[   35.436854] el0t_64_sync (arch/arm64/kernel/entry.S:598)
[   35.436863] ---[ end trace 0000000000000000 ]---

Build link [2] and config [3] provided.
Please let me know if you need more information.

Links:
----
[1] https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20240709/testrun/24547087/suite/boot/test/gcc-13-lkftconfig/log
[2] https://storage.tuxsuite.com/public/linaro/lkft/builds/2j0OwvzyH9AnnxOg1WtJSM69SIV/
[3] https://storage.tuxsuite.com/public/linaro/lkft/builds/2j0OwvzyH9AnnxOg1WtJSM69SIV/config

--
Linaro LKFT
https://lkft.linaro.org

From: Willem Riede <wrlk@riede.org>
Subject: Badness in scsi_single_lun_run at /root/scsi/scsi_lib.c:344
Date: Mon, 26 Jan 2004 19:32:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040127003244.GM23308@serve.riede.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:18338 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S265528AbUA0Act (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2004 19:32:49 -0500
Received: from serve.riede.org (localhost.localdomain [127.0.0.1])
	by serve.riede.org (8.12.10/8.12.10) with ESMTP id i0R0Wilu025173
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2004 19:32:46 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

For additional fun shaking bugs out of ide-scsi, I dusted of my old
PD/CD drive (retired years ago in favor of a CD Writer).

Besides having to set   host->max_lun = 2;  in  idescsi_attach() to
have both luns of this device detected:

Jan 26 17:13:23 fallguy kernel: scsi6 : SCSI host adapter emulation for IDE ATAPI devices
Jan 26 17:13:23 fallguy kernel:   Vendor: NEC       Model: PD-1 ODX654P      Rev: A111
Jan 26 17:13:23 fallguy kernel:   Type:   CD-ROM                             ANSI SCSI revision: 02
Jan 26 17:13:23 fallguy kernel: sr1: scsi3-mmc drive: 6x/6x xa/form2 cdda tray
Jan 26 17:13:23 fallguy kernel:   Vendor: NEC       Model: PD-1 ODX654P      Rev: A111
Jan 26 17:13:23 fallguy kernel:   Type:   Optical Device                     ANSI SCSI revision: 02
Jan 26 17:13:23 fallguy kernel: SCSI device sdc: 1298496 512-byte hdwr sectors (665 MB)
Jan 26 17:13:23 fallguy kernel: sdc: Write Protect is off
Jan 26 17:13:23 fallguy kernel: SCSI device sdc: drive cache: write back

I get a bunch of the following warning:

Jan 26 17:13:23 fallguy kernel: Badness in scsi_single_lun_run at /root/scsi/scsi_lib.c:344
Jan 26 17:13:23 fallguy kernel: Call Trace:
Jan 26 17:13:23 fallguy kernel:  [<e0850192>] scsi_single_lun_run+0x202/0x230 [scsi_mod]
Jan 26 17:13:23 fallguy kernel:  [<e084a33d>] scsi_put_command+0xbd/0x160 [scsi_mod]
Jan 26 17:13:23 fallguy kernel:  [<e0850347>] scsi_run_queue+0x187/0x190 [scsi_mod]
Jan 26 17:13:23 fallguy kernel:  [<e0850524>] scsi_end_request+0xf4/0x150 [scsi_mod]
Jan 26 17:13:23 fallguy kernel:  [<e08508f7>] scsi_io_completion+0x1c7/0x4b0 [scsi_mod]
Jan 26 17:13:23 fallguy kernel:  [<e0829a32>] sd_rw_intr+0x82/0x260 [sd_mod]
Jan 26 17:13:24 fallguy kernel:  [<e084aed1>] scsi_finish_command+0x81/0xe0 [scsi_mod]
Jan 26 17:13:24 fallguy kernel:  [<e084ade8>] scsi_softirq+0xc8/0xf0 [scsi_mod]
Jan 26 17:13:24 fallguy kernel:  [<c012d6a7>] do_softirq+0xc7/0xd0
Jan 26 17:13:24 fallguy kernel:  [<c010e395>] do_IRQ+0x165/0x220
Jan 26 17:13:24 fallguy kernel:  [<c011c04d>] smp_apic_timer_interrupt+0xdd/0x150
Jan 26 17:13:24 fallguy kernel:  [<c010c21c>] common_interrupt+0x18/0x20
Jan 26 17:13:24 fallguy kernel:  [<c01089f0>] default_idle+0x0/0x40
Jan 26 17:13:24 fallguy kernel:  [<c0108a19>] default_idle+0x29/0x40
Jan 26 17:13:24 fallguy kernel:  [<c0108aab>] cpu_idle+0x3b/0x50
Jan 26 17:13:24 fallguy kernel:  [<c0128f80>] printk+0x180/0x260
Jan 26 17:13:24 fallguy kernel:

Most are similar from do_IRQ up, io_completion called from sd_rw_intr or (sr) rw_intr,
which make its way to scsi_single_lun_run. (I don't understand why scsi_put_command
shows up, I believe it should be scsi_end_request -> scsi_next_request -> scsi_run_queue
-> scsi_single_lun_run.

One is different, don't know if that's a fluke (kernel log buffer overrun?) or evidence
of a rogue path...

Jan 26 17:14:12 fallguy kernel: Badness in scsi_single_lun_run at /root/scsi/scsi_lib.c:344
Jan 26 17:14:12 fallguy kernel: Call Trace:
Jan 26 17:14:12 fallguy kernel:  [<e0850192>] scsi_single_lun_run+0x202/0x230 [scsi_mod]
Jan 26 17:14:12 fallguy kernel:  [<e084a33d>] scsi_put_command+0xbd/0x160 [scsi_mod]
Jan 26 17:14:12 fallguy kernel:  [<e0850347>] scsi_run_queue+0x187/0x190 [scsi_mod]
Jan 26 17:14:12 fallguy kernel:  [<e084fd01>] scsi_wait_req+0xa1/0xb0 [scsi_mod]
Jan 26 17:14:12 fallguy kernel:  [<e084fb90>] scsi_wait_done+0x0/0xd0 [scsi_mod]
Jan 26 17:14:12 fallguy kernel:  [<e084a02e>] scsi_allocate_request+0x2e/0x70 [scsi_mod]
Jan 26 17:14:12 fallguy kernel:  [<e084bf7d>] ioctl_internal_command+0x6d/0x200 [scsi_mod]
Jan 26 17:14:12 fallguy kernel:  [<e084c17f>] scsi_set_medium_removal+0x6f/0xa0 [scsi_mod]
Jan 26 17:14:12 fallguy kernel:  [<e0829602>] sd_release+0x72/0x90 [sd_mod]
Jan 26 17:14:12 fallguy kernel:  [<c0176b54>] blkdev_put+0x214/0x260
Jan 26 17:14:12 fallguy kernel:  [<c016d60a>] __fput+0x10a/0x120
Jan 26 17:14:12 fallguy kernel:  [<c016b7a9>] filp_close+0x59/0x90
Jan 26 17:14:13 fallguy kernel:  [<c016b85f>] sys_close+0x7f/0x100
Jan 26 17:14:13 fallguy kernel:  [<c010b8af>] syscall_call+0x7/0xb
Jan 26 17:14:13 fallguy kernel:

Somehow it appears that io completion sometimes happens twice without 
current_sdev->sdev_target->starget_sdev_user being set to a new owner so
that the  WARN_ON(!current_sdev->sdev_target->starget_sdev_user) triggers...

(I have proven to my satisfaction that no path exists that can set
current_sdev->sdev_target->starget_sdev_user to NULL to cause this).

Setting starget_sdev_user happens in scsi_request_fn(). Do any paths exist
that start io that don't use it?

Probably to simple minded to suspect the request sense following a command that
reports "Check Condition"?

Ideas of where to look next appreciated.

Thanks, Willem Riede.

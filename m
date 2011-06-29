From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 38312] New: Oops in kmem_cache_alloc
Date: Wed, 29 Jun 2011 14:19:52 -0700
Message-ID: <20110629141952.9d14c36f.akpm@linux-foundation.org>
References: <bug-38312-10286@https.bugzilla.kernel.org/>
	<20110627133007.f6cba848.akpm@linux-foundation.org>
	<1309207300.2605.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754199Ab1F2VVc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jun 2011 17:21:32 -0400
In-Reply-To: <1309207300.2605.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, sgunderson@bigfoot.com, Jens Axboe <axboe@kernel.dk>, Greg KH <greg@kroah.com>, chf.fritz@googlemail.com

On Mon, 27 Jun 2011 15:41:40 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> You're right, all the refcounting fixes I know are in -rc4.

Wanna take a look at https://bugzilla.kernel.org/show_bug.cgi?id=38412 please?

Jun 28 11:39:20 kfovle kernel: usb 1-1: USB disconnect, device number 6
Jun 28 11:39:20 kfovle kernel: BUG: unable to handle kernel paging request at 2f327473
Jun 28 11:39:20 kfovle kernel: IP: [<2f327473>] 0x2f327472
Jun 28 11:39:20 kfovle kernel: *pde = 00000000 
Jun 28 11:39:20 kfovle kernel: Oops: 0000 [#1] PREEMPT 
Jun 28 11:39:20 kfovle kernel: Modules linked in: usb_storage usbhid dvb_usb_dib0700 dib7000p dib0090 dib7000m dib0070 dvb_usb dib8000 mt2266 tuner_xc2028 dib3000mc mxl5007t xc5000 s5h1411 ir_lirc_codec mt2060 lirc_dev lgdt3305 dvb_core rc_core dibx000_common acpi_cpufreq mperf cpufreq_ondemand cpufreq_userspace cpufreq_stats cpufreq_conservative freq_table cpufreq_powersave binfmt_misc fuse sha256_generic cryptd aes_i586 aes_generic cm4040_cs sg pcmcia i915 sr_mod cdrom drm_kms_helper cfbcopyarea cfbimgblt cfbfillrect yenta_socket b44 mii video backlight
Jun 28 11:39:20 kfovle kernel:
Jun 28 11:39:20 kfovle kernel: Pid: 5846, comm: eject Tainted: G       A    3.0.0-rc4devel+ #47 Hewlett-Packard HP Compaq nx6110 (EK201ET#ABD)/3088
Jun 28 11:39:20 kfovle kernel: EIP: 0060:[<2f327473>] EFLAGS: 00010002 CPU: 0
Jun 28 11:39:20 kfovle kernel: EIP is at 0x2f327473
Jun 28 11:39:20 kfovle kernel: EAX: f4eed270 EBX: f637e418 ECX: 2f327473 EDX: f4eed270
Jun 28 11:39:20 kfovle kernel: ESI: f4eed270 EDI: 02224801 EBP: f5297200 ESP: f5b9bdb0
Jun 28 11:39:20 kfovle kernel: DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Jun 28 11:39:20 kfovle kernel: Process eject (pid: 5846, ti=f5b9a000 task=f5b19a80 task.ti=f5b9a000)
Jun 28 11:39:20 kfovle kernel: Stack:
Jun 28 11:39:20 kfovle kernel: c1198600 c119ac69 00000256 00000000 00000002 c119b2f9 f4eed270 c11a3237
Jun 28 11:39:20 kfovle kernel: 00000000 f5297200 f637e418 00005309 0000005d c11a3378 0000005d 00000000
Jun 28 11:39:20 kfovle kernel: f5c1b700 00000000 f5c02e00 00000000 f4a2e1f4 f59c0700 c10d1bc3 f53ed001
Jun 28 11:39:20 kfovle kernel: Call Trace:
Jun 28 11:39:20 kfovle kernel: [<c1198600>] ? elv_put_request+0x10/0x20
Jun 28 11:39:20 kfovle kernel: [<c119ac69>] ? __blk_put_request+0x99/0xc0
Jun 28 11:39:20 kfovle kernel: [<c119b2f9>] ? blk_put_request+0x19/0x40
Jun 28 11:39:20 kfovle kernel: [<c11a3237>] ? T.593+0x77/0x90
Jun 28 11:39:20 kfovle kernel: [<c11a3378>] ? scsi_cmd_ioctl+0x128/0x440
Jun 28 11:39:20 kfovle kernel: [<c10d1bc3>] ? blkdev_get+0x43/0x380
Jun 28 11:39:20 kfovle kernel: [<c10d1000>] ? bd_acquire+0x20/0xd0
Jun 28 11:39:20 kfovle kernel: [<c10a2a6d>] ? __dentry_open+0x1cd/0x2a0
Jun 28 11:39:20 kfovle kernel: [<c10a2c30>] ? nameidata_to_filp+0x70/0x80
Jun 28 11:39:20 kfovle kernel: [<c10d1f00>] ? blkdev_get+0x380/0x380
Jun 28 11:39:20 kfovle kernel: [<c125e582>] ? sd_ioctl+0x82/0xc0
Jun 28 11:39:20 kfovle kernel: [<c125e500>] ? sd_check_events+0x140/0x140
Jun 28 11:39:20 kfovle kernel: [<c11a02d9>] ? __blkdev_driver_ioctl+0x29/0x40
Jun 28 11:39:20 kfovle kernel: [<c11a07d3>] ? blkdev_ioctl+0x213/0x7e0
Jun 28 11:39:20 kfovle kernel: [<c10b1854>] ? do_filp_open+0x34/0x90
Jun 28 11:39:20 kfovle kernel: [<c10d0715>] ? block_ioctl+0x35/0x50
Jun 28 11:39:20 kfovle kernel: [<c10d06e0>] ? blkdev_get_block+0x50/0x50
Jun 28 11:39:20 kfovle kernel: [<c10b2b92>] ? do_vfs_ioctl+0x92/0x610
Jun 28 11:39:20 kfovle kernel: [<c10a262e>] ? do_sys_open+0x16e/0x1c0
Jun 28 11:39:20 kfovle kernel: [<c10a262e>] ? do_sys_open+0x16e/0x1c0
Jun 28 11:39:20 kfovle kernel: [<c10b314d>] ? sys_ioctl+0x3d/0x70
Jun 28 11:39:20 kfovle kernel: [<c1394ad0>] ? sysenter_do_call+0x12/0x26
Jun 28 11:39:20 kfovle kernel: Code:  Bad EIP value.

We've seen quite a lot of reports like this after 2.6.39 and it looks
like we aren't out of the weeds yet.

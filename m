From: Neil Brown <neilb@suse.de>
Subject: Re: MD RAID1 deadlock on failed disk
Date: Wed, 27 Oct 2010 20:52:38 +1100
Message-ID: <20101027205238.4e1a4b68@notabene>
References: <0AFEJ5E11@briare1.fullpliant.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:33811 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab0J0Jwq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2010 05:52:46 -0400
In-Reply-To: <0AFEJ5E11@briare1.fullpliant.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hubert Tonneau <hubert.tonneau@fullpliant.org>
Cc: linux-scsi@vger.kernel.org

On Wed, 27 Oct 2010 10:44:02 GMT
Hubert Tonneau <hubert.tonneau@fullpliant.org> wrote:

> Hi,
> 
> The configuration is:
> Perc H200 controller configured with no RAID (mpt2sas driver),
> 2 SATA disks (sda and sdb),
> Linux MD Sofware RAID1 (md0),
> stock Linux 2.6.35.7 kernel.
> 
> I hotunplug the second (sdb) disk, and the result is:
> . as expected, I can read sda device,
> . as expected, any read to sdb device fails,
> . unexpectedly, any read to md0 never returns.
> 
> No oops or thing like that in the kernel log.
> I did not try the same with other kernel releases.
> 
> 2.6.32.24 kernel worked fine.
> 
> Neil Brown asked for /proc/sysrq-trigger ouput,
> and concluded that the problem is related to 'fw_event0'.
> See his answer bellow.
> 
> Regards,
> Hubert Tonneau
> 
> 
> Neil Brown wrote:
> >
> > The fw_event0 process is interesting.
> > It seems to be hung trying to 'sync' the drive that has just been pulled.
> > If that is somehow causing some IO request from the md/raid1 to be delayed
> > then that would certainly hang the array.
> > 
> > There is a section in the middle of the trace which is missing - presumably
> > the sysrq-trigger output overflowed a buffer - that isn't uncommon.
> > 
> > So I cannot see all the timing clearly.
> > How long after pulling the drive was this trace taken?
> > 
> > I suspect that you need to post this to linux-scsi@vger.kernel.org
> > and ask about that fw_event0 thread - whether that should happen, whether it
> > has been fixed, and whether it could delay pending IO requests.
> > 
> > NeilBrown

It probably would help to have included the sysrq-T output so the scsi people
could see why I pointed the finger at fw_event0.

Here is that part of the trace

<6>[  318.881486] fw_event0     D 0000000000000000     0   244      2 0x00000000
<4>[  318.881493]  ffff88081d191570 0000000000000046 ffff880800000000 00000000000158c0
<4>[  318.881500]  ffff88081d191fd8 00000000000158c0 ffff88081d191fd8 ffff88081d188000
<4>[  318.881507]  00000000000158c0 00000000000158c0 ffff88081d191fd8 00000000000158c0
<4>[  318.881514] Call Trace:
<4>[  318.881520]  [<ffffffff815a296d>] schedule_timeout+0x22d/0x310
<4>[  318.881526]  [<ffffffff813a21f0>] ? __scsi_queue_insert+0xb0/0x130
<4>[  318.881533]  [<ffffffff815a252b>] wait_for_common+0xdb/0x1a0
<4>[  318.881540]  [<ffffffff81051910>] ? default_wake_function+0x0/0x20
<4>[  318.881546]  [<ffffffff81294093>] ? __generic_unplug_device+0x33/0x40
<4>[  318.881553]  [<ffffffff815a26cd>] wait_for_completion+0x1d/0x20
<4>[  318.881560]  [<ffffffff8129a9fe>] blk_execute_rq+0x8e/0xf0
<4>[  318.881567]  [<ffffffff8129666c>] ? blk_get_request+0x6c/0xa0
<4>[  318.881573]  [<ffffffff813a129c>] scsi_execute+0xfc/0x160
<4>[  318.881580]  [<ffffffff813a2cec>] scsi_execute_req+0xac/0x180
<4>[  318.881589]  [<ffffffff813c5fd0>] sd_sync_cache+0xd0/0x120
<4>[  318.881598]  [<ffffffff815a187a>] ? printk+0x68/0x6e
<4>[  318.881604]  [<ffffffff813c6283>] sd_shutdown+0x83/0x1b0
<4>[  318.881610]  [<ffffffff813c6562>] sd_remove+0x62/0xa0
<4>[  318.881618]  [<ffffffff81377555>] __device_release_driver+0x75/0xe0
<4>[  318.881624]  [<ffffffff81377acd>] device_release_driver+0x2d/0x40
<4>[  318.881631]  [<ffffffff81376532>] bus_remove_device+0xb2/0xf0
<4>[  318.881637]  [<ffffffff81374237>] device_del+0x127/0x1b0
<4>[  318.881644]  [<ffffffff813a74d5>] __scsi_remove_device+0xb5/0xc0
<4>[  318.881650]  [<ffffffff813a7510>] scsi_remove_device+0x30/0x50
<4>[  318.881656]  [<ffffffff813a7601>] __scsi_remove_target+0xb1/0xe0
<4>[  318.881662]  [<ffffffff813a76a0>] ? __remove_child+0x0/0x30
<4>[  318.881667]  [<ffffffff813a76c3>] __remove_child+0x23/0x30
<4>[  318.881673]  [<ffffffff8137399c>] device_for_each_child+0x4c/0x80
<4>[  318.881679]  [<ffffffff813a766e>] scsi_remove_target+0x3e/0x70
<4>[  318.881686]  [<ffffffff813abcc5>] sas_rphy_remove+0x75/0x80
<4>[  318.881692]  [<ffffffff813ac266>] sas_rphy_delete+0x16/0x30
<4>[  318.881698]  [<ffffffff813ac2aa>] sas_port_delete+0x2a/0x130
<4>[  318.881704]  [<ffffffff813bf3ca>] mpt2sas_transport_port_remove+0x15a/0x240
<4>[  318.881711]  [<ffffffff813ba9ed>] _scsih_remove_device+0xcd/0x120
<4>[  318.881720]  [<ffffffff81035d09>] ? default_spin_lock_flags+0x9/0x10
<4>[  318.881726]  [<ffffffff813bea00>] ? mpt2sas_transport_update_links+0x80/0x1a0
<4>[  318.881733]  [<ffffffff813be0ee>] _firmware_event_work+0x155e/0x1af0
<4>[  318.881742]  [<ffffffff8100860b>] ? __switch_to+0xcb/0x350
<4>[  318.881749]  [<ffffffff8104de5a>] ? finish_task_switch+0x4a/0xd0
<4>[  318.881756]  [<ffffffff813bcb90>] ? _firmware_event_work+0x0/0x1af0
<4>[  318.881762]  [<ffffffff810792cf>] worker_thread+0x17f/0x2b0
<4>[  318.881769]  [<ffffffff8107d9c0>] ? autoremove_wake_function+0x0/0x40
<4>[  318.881775]  [<ffffffff81079150>] ? worker_thread+0x0/0x2b0
<4>[  318.881781]  [<ffffffff8107d466>] kthread+0x96/0xa0
<4>[  318.881787]  [<ffffffff8100ae64>] kernel_thread_helper+0x4/0x10
<4>[  318.881794]  [<ffffffff8107d3d0>] ? kthread+0x0/0xa0
<4>[  318.881799]  [<ffffffff8100ae60>] ? kernel_thread_helper+0x0/0x10


It seems to hang here, and while it hangs old IO requests don't complete so
md/raid1 cannot proceed.

NeilBrown

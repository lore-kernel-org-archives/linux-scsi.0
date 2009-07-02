From: Paul Smith <paul@mad-scientist.net>
Subject: [2.6.27.25] Hang in SCSI sync cache when a disk is removed--?
Date: Thu, 02 Jul 2009 12:22:52 -0400
Message-ID: <1246551772.9022.7192.camel@psmith-ubeta.netezza.com>
Reply-To: paul@mad-scientist.net
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta.netezza.com ([12.148.248.132]:65377 "EHLO netezza.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750726AbZGBQhw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jul 2009 12:37:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all; we are seeing a problem where, when we pull a disk out of our
disk array (even one that's not actively being used), the entire IO
subsystem in Linux hangs.  Here are some details:

I have an IBM Bladecenter with an LSI EXP3000 SAS expander with 12 1TB
Seagate SAS disks.  Relevant lspci output for the SAS controllers:

        # lspci | grep LSI
        02:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064ET PCI-Express Fusion-MPT SAS (rev 02)
        08:01.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064 PCI-X Fusion-MPT SAS (rev 03)
        14:01.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064 PCI-X Fusion-MPT SAS (rev 03)

On this system we are running an embedded/custom version of Linux in a
ramdisk, based on Linux 2.6.27.25.  Unfortunately it's quite
difficult/impossible for us to upgrade to a newer kernel at this time,
however if this problem rings a bell I'm happy to backport patches,
fixes, etc.

As I mentioned, when we pull one of the disks from the EXP3000 the IO
subsystem completely hangs.  Since we're running on a ramdisk this
doesn't hang our system completely, but any attempt to do any disk IO
thereafter hangs, so we have to power-cycle the blade (because reboot
tries to write to the disks).  This quite reproducible in our
environment BUT it is very timing-sensitive, as shown below.  If we
enable too much logging, etc. it goes away.

We've been in touch with some driver folks at LSI and they seem to feel
that the problem is a SCSI midlayer race condition, rather than in the
mptlinux driver itself.  So I'm hoping someone here has ideas.

On a working disk pull we get log messages like this:

        mptscsih: ioc1: attempting host reset! (sc=ffff8804619e2640)
        mptscsih: ioc1: host reset: SUCCESS (sc=ffff8804619e2640)
        mptbase: ioc1: LogInfo(0x30030501): Originator={IOP}, Code={Invalid Page}, SubCode(0x0501)
        mptsas: ioc1: removing ssp device: fw_channel 0, fw_id 72, phy 11, sas_addr 0x5000c5000d2987b6
        sd 3:0:11:0: [sdx] Synchronizing SCSI cache
        sd 3:0:11:0: Device offlined - not ready after error recovery
        sg_cmd_done: device detached

Note that the "host reset: SUCCESS" message here comes BEFORE the
"Synchronizing SCSI cache" message.  On a hanging disk pull we get log
messages like this:

        mptscsih: ioc1: attempting host reset! (sc=ffff8804622b48c0)
        mptsas: ioc1: removing ssp device: fw_channel 0, fw_id 72, phy 11, sas_addr 0x5000c5000d2987b6
        sd 3:0:11:0: [sdx] Synchronizing SCSI cache

and it hangs right here.  In this situation the host reset does not
complete before we try to sync, and that appears to be the indicator of
the problem.  Here's a backtrace; note we're in sd_sync_cache():

        Call Trace:
         [<ffffffff8048d88f>] _spin_lock_irqsave+0x1f/0x50
         [<ffffffff8048daf2>] _spin_unlock_irqrestore+0x12/0x40
         [<ffffffffa00080fc>] scsi_get_command+0x8c/0xc0 [scsi_mod]
         [<ffffffff8048c11d>] schedule_timeout+0xad/0xf0
         [<ffffffff8034df1d>] elv_next_request+0x15d/0x290
         [<ffffffff8048b1ea>] wait_for_common+0xba/0x170
         [<ffffffff80237460>] default_wake_function+0x0/0x10
         [<ffffffff80353b77>] blk_execute_rq+0x67/0xa0
         [<ffffffff80350e71>] get_request_wait+0x21/0x1d0
         [<ffffffff8023e972>] vprintk+0x1f2/0x490
         [<ffffffff8048dab1>] _spin_unlock_irq+0x11/0x40
         [<ffffffffa000e5a4>] scsi_execute+0xf4/0x150 [scsi_mod]
         [<ffffffffa000e691>] scsi_execute_req+0x91/0x100 [scsi_mod]
         [<ffffffffa00f89bc>] sd_sync_cache+0xac/0x100 [sd_mod]
         [<ffffffff80360000>] compat_blkdev_ioctl+0x80/0x1740
         [<ffffffff80364062>] kobject_get+0x12/0x20
         [<ffffffffa00fac51>] sd_shutdown+0x71/0x160 [sd_mod]
         [<ffffffffa00fad7c>] sd_remove+0x3c/0x80 [sd_mod]
         [<ffffffffa0012122>] scsi_bus_remove+0x42/0x60 [scsi_mod]
         [<ffffffff803d8ba9>] __device_release_driver+0x99/0x100
         [<ffffffff803d8d08>] device_release_driver+0x28/0x40
         [<ffffffff803d8087>] bus_remove_device+0xb7/0xf0
         [<ffffffff803d66c9>] device_del+0x119/0x1a0
         [<ffffffffa001245c>] __scsi_remove_device+0x5c/0xb0 [scsi_mod]
         [<ffffffffa00124d8>] scsi_remove_device+0x28/0x40 [scsi_mod]
         [<ffffffffa00125a0>] __scsi_remove_target+0xa0/0xd0 [scsi_mod]
         [<ffffffffa0012640>] __remove_child+0x0/0x30 [scsi_mod]
         [<ffffffffa0012656>] __remove_child+0x16/0x30 [scsi_mod]
         [<ffffffff803d5c3b>] device_for_each_child+0x3b/0x60
         [<ffffffffa0012606>] scsi_remove_target+0x36/0x70 [scsi_mod]
         [<ffffffffa010c5f5>] sas_rphy_remove+0x75/0x80 [scsi_transport_sas]
         [<ffffffffa010c609>] sas_rphy_delete+0x9/0x20 [scsi_transport_sas]
         [<ffffffffa010c642>] sas_port_delete+0x22/0x140 [scsi_transport_sas]
         [<ffffffffa013c230>] mptsas_del_end_device+0x230/0x2c0 [mptsas]
         [<ffffffffa013c8a1>] mptsas_hotplug_work+0x291/0xb20 [mptsas]
         [<ffffffff80369c9a>] vsnprintf+0x2ea/0x7c0
         [<ffffffff80287dac>] free_hot_cold_page+0x1fc/0x2f0
         [<ffffffff80287ed8>] __pagevec_free+0x38/0x50
         [<ffffffff8028b730>] release_pages+0x180/0x1d0
         [<ffffffff80362789>] __next_cpu+0x19/0x30
         [<ffffffff802321ec>] find_busiest_group+0x1dc/0x960
         [<ffffffff80362789>] __next_cpu+0x19/0x30
         [<ffffffff802321ec>] find_busiest_group+0x1dc/0x960
         [<ffffffffa013e4a9>] mptsas_firmware_event_work+0xd29/0x1110 [mptsas]
         [<ffffffff8022dc94>] update_curr+0x84/0xd0
         [<ffffffff80230370>] __dequeue_entity+0x60/0x90
         [<ffffffff8048dab1>] _spin_unlock_irq+0x11/0x40
         [<ffffffff802364fb>] finish_task_switch+0x3b/0xd0
         [<ffffffff8048b911>] thread_return+0xa3/0x662
         [<ffffffffa013d780>] mptsas_firmware_event_work+0x0/0x1110 [mptsas]
         [<ffffffff80250e65>] run_workqueue+0x85/0x150
         [<ffffffff80250fcf>] worker_thread+0x9f/0x110
         [<ffffffff802553b0>] autoremove_wake_function+0x0/0x30
         [<ffffffff80250f30>] worker_thread+0x0/0x110
         [<ffffffff80254ef7>] kthread+0x47/0x90
         [<ffffffff80254eb0>] kthread+0x0/0x90
         [<ffffffff8020d5f9>] child_rip+0xa/0x11
         [<ffffffff80254eb0>] kthread+0x0/0x90
         [<ffffffff80254eb0>] kthread+0x0/0x90
         [<ffffffff8020d5ef>] child_rip+0x0/0x11

According to sd.c:sd_synch_cache() it's supposed to retry the
scsi_execute_req() three times then give up, but instead it never
returns.  It seems that if the host reset is not completed yet, then we
find this event on the workqueue and get into some kind of deadlock
situation.

We're kind of stuck on this and I was wondering if anyone has any
thoughts or avenues to look at to move us forward on resolving this?

Thanks!


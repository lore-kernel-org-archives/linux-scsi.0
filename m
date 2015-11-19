From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [BISECTED] v4.4-rc1 SCSI disk init crash
Date: Thu, 19 Nov 2015 11:54:06 -0800
Message-ID: <564E28DE.6010200@sandisk.com>
References: <20151119192135.GD18138@blackmetal.musicnaut.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0072.outbound.protection.outlook.com ([157.56.110.72]:34064
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758812AbbKSTyJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2015 14:54:09 -0500
In-Reply-To: <20151119192135.GD18138@blackmetal.musicnaut.iki.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaro Koskinen <aaro.koskinen@iki.fi>, James Bottomley <JBottomley@Odin.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 11/19/2015 11:22 AM, Aaro Koskinen wrote:
> I get the below crash when cold booting OCTEON router with USB disk as
> rootfs. Bisected to:
>
> 	commit bf2cf3baa20b0a6cd2d08707ef05dc0e992a8aa0
> 	Author: Bart Van Assche <bart.vanassche@sandisk.com>
> 	Date:   Fri Sep 18 17:23:42 2015 -0700
>
> 	    scsi: Fix a bdi reregistration race
>
> Reverting the patch makes the board boot fine again.
>
> A.
>
> Waiting for rootfs media to appear... Press ENTER to interrupt.
> [    1.540522] usb 1-1: new high-speed USB device number 2 using ehci-platform
> [    1.699752] usb-storage 1-1:1.0: USB Mass Storage device detected
> [    1.706054] scsi host0: usb-storage 1-1:1.0
> [    2.702105] scsi 0:0:0:0: Direct-Access     Ext Hard  Disk                 PQ: 0 ANSI: 5
> [    2.714214] sd 0:0:0:0: [sda] Spinning up disk...
> [    3.720503] ...
> [    6.674040] usb 1-1: USB disconnect, device number 2
> [    6.750508] .ready
> [    6.752558] sd 0:0:0:0: [sda] Read Capacity(10) failed: Result: hostbyte=0x00 driverbyte=0x04
> [    6.761112] sd 0:0:0:0: [sda] Sense not available.
> [    6.765918] sd 0:0:0:0: [sda] Write Protect is off
> [    6.770741] sd 0:0:0:0: [sda] Asking for cache data failed
> [    6.776236] sd 0:0:0:0: [sda] Assuming drive cache: write through
> [    6.782745] ------------[ cut here ]------------
> [    6.787383] WARNING: CPU: 1 PID: 15 at /home/aaro/git/linux/block/genhd.c:626 add_disk+0x41c/0x478()
> [    6.796549] Modules linked in:
> [    6.799624] CPU: 1 PID: 15 Comm: kworker/u4:1 Not tainted 4.4.0-rc1-octeon-los_73f9f-00002-gd81c963 #1
> [    6.808959] Workqueue: events_unbound async_run_entry_fn
> [    6.814296] Stack : 0000000000000001 0000000000000004 ffffffff81760000 0000000000000000
> 	  0000000000000001 0000000000000000 0000000000000000 0000000000000000
> 	  ffffffff81f3abc8 ffffffff811893f8 0000000000000000 ffffffff81f3a758
> 	  0000000000000000 0000000000000002 0000000000000001 ffffffff81f40000
> 	  ffffffff816b78f8 80000000330e9000 0000000000000272 0000000000000009
> 	  ffffffff813471cc 0000000000000000 80000000330086a0 8000000033008400
> 	  80000000330e9000 ffffffff811cea44 800000003314bb68 8000000033008400
> 	  80000000330e9000 800000003314ba70 800000003314bb88 ffffffff8135331c
> 	  000000000000015f ffffffff813c0900 000000000000006e 0000000000000000
> 	  735f756e626f756e ffffffff81124190 0000000000000000 0000000000000000
> 	  ...
> [    6.879950] Call Trace:
> [    6.882414] [<ffffffff81124190>] show_stack+0x88/0xa8
> [    6.887475] [<ffffffff8135331c>] dump_stack+0x6c/0x90
> [    6.892549] [<ffffffff81141cb4>] warn_slowpath_common+0x94/0xd8
> [    6.898481] [<ffffffff813471cc>] add_disk+0x41c/0x478
> [    6.903552] [<ffffffff81400794>] sd_probe_async+0xfc/0x218
> [    6.909047] [<ffffffff8116373c>] async_run_entry_fn+0x4c/0x120
> [    6.914898] [<ffffffff8115a83c>] process_one_work+0x17c/0x438
> [    6.920663] [<ffffffff8115ac60>] worker_thread+0x168/0x5e0
> [    6.926159] [<ffffffff81160dc4>] kthread+0xd4/0xf0
> [    6.930968] [<ffffffff8111e9d8>] ret_from_kernel_thread+0x14/0x1c
> [    6.937069]

Hello Aaro,

The patch you mentioned changes the device removal code. The above 
output shows a warning triggered by the device probing code. That makes 
it unlikely that the above warning is caused by my patch. Please double 
check your bisect results.

Thanks,

Bart.

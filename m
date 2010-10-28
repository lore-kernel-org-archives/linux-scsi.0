From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 21372] NULL pointer deference at disk_replace_part_tbl+0x32
Date: Thu, 28 Oct 2010 17:52:38 GMT
Message-ID: <201010281752.o9SHqcRE004778@demeter2.kernel.org>
References: <bug-21372-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:37561 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S934012Ab0J1Rwl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 13:52:41 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9SHqdfm004809
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2010 17:52:39 GMT
In-Reply-To: <bug-21372-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=21372





--- Comment #1 from Andrew Morton <akpm@linux-foundation.org>  2010-10-28 17:52:35 ---
(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Thu, 28 Oct 2010 17:22:47 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=21372
> 
>            Summary: NULL pointer deference at disk_replace_part_tbl+0x32
>            Product: Drivers
>            Version: 2.5
>     Kernel Version: 2.6.36
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: USB
>         AssignedTo: greg@kroah.com
>         ReportedBy: mcgrof@gmail.com
>                 CC: rjw@sisk.pl
>         Regression: Yes

hm, who did this.

Jens, I think you were fixing something up in this area recently?

> 
> I get the following NULL pointer dereference when I hook up my Nexus One to my
> laptop to enable USB tether. This is a regression between v2.6.36-rc8 and
> v2.6.36. I will bisect when I get a chance.
> 
> input: TPPS/2 IBM TrackPoint as
> /devices/platform/i8042/serio1/serio2/input/input7
> usb 1-3: USB disconnect, address 4
> BUG: unable to handle kernel NULL pointer dereference at 00000000000003a0
> IP: [<ffffffff812aec32>] disk_replace_part_tbl+0x32/0x80
> PGD 0 
> Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
> CPU 0 
> Modules linked in: <etc>
> Pid: 22, comm: khubd Not tainted 2.6.36-wl+ #13 6460DWU/6460DWU
> RIP: 0010:[<ffffffff812aec32>]  [<ffffffff812aec32>]
> disk_replace_part_tbl+0x32/0x80
> RSP: 0018:ffff88003b921990  EFLAGS: 00010282
> RAX: ffffea0000cd0708 RBX: ffff880038a0cee0 RCX: ffff88003d001490
> RDX: ffffea0000cb5c40 RSI: 0000000000000000 RDI: ffff880039f61df8
> RBP: ffff88003b9219a0 R08: 0000000000000000 R09: ffff88003a1a58a8
> R10: dead000000100100 R11: 0000000000000228 R12: 0000000000000000
> R13: 0000000000000000 R14: ffff8800388f6e98 R15: 0000000000000293
> FS:  0000000000000000(0000) GS:ffff88003ec00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00000000000003a0 CR3: 0000000001a24000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process khubd (pid: 22, threadinfo ffff88003b920000, task ffff88003b918000)
> Stack:
>  ffff880039f61df8 ffffffff81a67a60 ffff88003b9219c0 ffffffff812aed08
> <0> ffff88003b9219c0 0000000000000000 ffff88003b9219e0 ffffffff813833f7
> <0> 0000000000000086 ffff880039f61e68 ffff88003b921a10 ffffffff812bcd87
> Call Trace:
> 
>  [<ffffffff812aed08>] disk_release+0x28/0x50
>  [<ffffffff813833f7>] device_release+0x27/0xa0
>  [<ffffffff812bcd87>] kobject_release+0x47/0x90
>  [<ffffffff812bcd40>] ? kobject_release+0x0/0x90
>  [<ffffffff812be1e7>] kref_put+0x37/0x70
>  [<ffffffff812bcc47>] kobject_put+0x27/0x60
>  [<ffffffff812bcd40>] ? kobject_release+0x0/0x90
>  [<ffffffff812aed47>] put_disk+0x17/0x20
>  [<ffffffff813c3c37>] sg_device_destroy+0x67/0xa0
>  [<ffffffff813c3bd0>] ? sg_device_destroy+0x0/0xa0
>  [<ffffffff812be1e7>] kref_put+0x37/0x70
>  [<ffffffff813c3b9e>] sg_remove+0xfe/0x130
>  [<ffffffff81383d51>] device_del+0xc1/0x1d0
>  [<ffffffff81383e76>] device_unregister+0x16/0x30
>  [<ffffffff813b6e95>] __scsi_remove_device+0xa5/0xc0
>  [<ffffffff813b322c>] scsi_forget_host+0x5c/0x80
>  [<ffffffff813aab1f>] scsi_remove_host+0x6f/0x120
>  [<ffffffffa004c46b>] quiesce_and_remove_host+0x6b/0xc0 [usb_storage]
>  [<ffffffffa004c592>] usb_stor_disconnect+0x22/0x40 [usb_storage]
>  [<ffffffff8140934a>] usb_unbind_interface+0x5a/0x1a0
>  [<ffffffff81387055>] __device_release_driver+0x75/0xe0
>  [<ffffffff813871bd>] device_release_driver+0x2d/0x40
>  [<ffffffff8138617e>] bus_remove_device+0xae/0xf0
>  [<ffffffff81383db7>] device_del+0x127/0x1d0
>  [<ffffffff81405be0>] usb_disable_device+0x70/0x130
>  [<ffffffff813fee13>] usb_disconnect+0x93/0x130
>  [<ffffffff814004e7>] hub_thread+0x487/0x1230
>  [<ffffffff8105a5fb>] ? dequeue_task_fair+0x8b/0x90
>  [<ffffffff81082900>] ? autoremove_wake_function+0x0/0x40
>  [<ffffffff81400060>] ? hub_thread+0x0/0x1230
>  [<ffffffff810823a6>] kthread+0x96/0xa0
>  [<ffffffff8100bea4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81082310>] ? kthread+0x0/0xa0
>  [<ffffffff8100bea0>] ? kernel_thread_helper+0x0/0x10
> Code: 10 48 89 1c 24 4c 89 64 24 08 0f 1f 44 00 00 48 8b 5f 38 4c 8b a7 00 03
> 00 00 48 85 db 48 89 77 38 74 42 48 c7 43 18 00 00 00 00 <49> 8b bc 24 a0 03 00
> 00 e8 61 58 2c 00 4c 89 e7 e8 89 2e ff ff 
> RIP  [<ffffffff812aec32>] disk_replace_part_tbl+0x32/0x80
>  RSP <ffff88003b921990>
> CR2: 00000000000003a0
> ---[ end trace 4704f0507cd6c869 ]---
> 
> -- 
> Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

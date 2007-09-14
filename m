From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 9018] New: Kernel bug in aic94xx driver
 shipped with kernel 2.6.21.7
Date: Fri, 14 Sep 2007 13:56:00 -0700
Message-ID: <20070914135600.67f798e3.akpm@linux-foundation.org>
References: <bug-9018-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44635 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754143AbXINU4h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2007 16:56:37 -0400
In-Reply-To: <bug-9018-10286@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bugme-new@lists.osdl.org, martijn@databoss.nl, "Darrick J. Wong" <djwong@us.ibm.com>

On Fri, 14 Sep 2007 07:11:54 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=9018
> 
>            Summary: Kernel bug in aic94xx driver shipped with kernel
>                     2.6.21.7
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.21.7
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: drivers_other@kernel-bugs.osdl.org
>         ReportedBy: martijn@databoss.nl
> 
> 
> While rebuilding a MD raid5, every time I try to rebuild:
> 
> -- START DUMP --
> RAID5 conf printout:
>  --- rd:3 wd:2
>  disk 0, o:1, dev:sdb1
>  disk 1, o:1, dev:sdc1
>  disk 2, o:1, dev:sdd1
> md: recovery of RAID array md0
> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec)
> for recovery.
> md: using 128k window, over a total of 71681920 blocks.
> ------------[ cut here ]------------
> kernel BUG at drivers/scsi/aic94xx/aic94xx_hwi.h:354!

whee!  That's BUG_ON(!list_empty(&ascb->list));

yet anoher scsi driver with no entry in MAINTAINERS.  Darrick, maybe?

> invalid opcode: 0000 [1] SMP
> CPU 1
> Modules linked in: aic94xx
> Pid: 1182, comm: scsi_eh_2 Not tainted 2.6.21.7 #2
> RIP: 0010:[<ffffffff8800a78d>]  [<ffffffff8800a78d>]
> :aic94xx:asd_abort_task+0x3c3/0x4d6
> RSP: 0018:ffff81022e4c5d80  EFLAGS: 00010287
> RAX: 0000000000000000 RBX: ffff810228226380 RCX: 0000000000000001
> RDX: ffff810228226410 RSI: 0000000000000282 RDI: ffff8102280d1098
> RBP: ffff81022fb08000 R08: 0000000000000000 R09: 0000000000000001
> R10: 0000000000000001 R11: ffff81022e3b4480 R12: ffff810228224c80
> R13: 0000000000000000 R14: ffff8102280d1098 R15: ffff810228226380
> FS:  0000000000000000(0000) GS:ffff81022fc3a940(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00000000005b2b50 CR3: 0000000000201000 CR4: 00000000000006e0
> Process scsi_eh_2 (pid: 1182, threadinfo ffff81022e4c4000, task
> ffff81022f470440)
> Stack:  ffff81022f470440 0000018de129b192 000000002fe8c100 ffff81022fb08108
>  0000000000000000 ffff8102280d1080 ffff8102280d1098 ffff81022e4c5eb0
>  ffff810228262a80 ffffffff803c4f1b 0000000000000000 ffff81022e4c5e20
> Call Trace:
>  [<ffffffff803c4f1b>] sas_scsi_recover_host+0x1eb/0x690
>  [<ffffffff803b22c5>] scsi_error_handler+0xa5/0x300
>  [<ffffffff803b2220>] scsi_error_handler+0x0/0x300
>  [<ffffffff80288d09>] keventd_create_kthread+0x0/0x65
>  [<ffffffff802315fb>] kthread+0xcb/0xf5
>  [<ffffffff8025cf38>] child_rip+0xa/0x12
>  [<ffffffff80288d09>] keventd_create_kthread+0x0/0x65
>  [<ffffffff80231530>] kthread+0x0/0xf5
>  [<ffffffff8025cf2e>] child_rip+0x0/0x12
> 
> 
> Code: 0f 0b eb fe 48 8d bd f0 41 00 00 e8 c6 91 25 f8 48 89 c6 8b
> RIP  [<ffffffff8800a78d>] :aic94xx:asd_abort_task+0x3c3/0x4d6
>  RSP <ffff81022e4c5d80>
> -- END DUMP --
> 
> 
> -- 
> Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.

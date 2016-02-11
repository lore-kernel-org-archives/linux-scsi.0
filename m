From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 00/23] ALUA device handler update, part II
Date: Thu, 11 Feb 2016 13:24:57 -0800
Message-ID: <56BCFC29.7020508@sandisk.com>
References: <1454942086-128704-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0056.outbound.protection.outlook.com ([65.55.169.56]:15475
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751467AbcBKVZB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Feb 2016 16:25:01 -0500
In-Reply-To: <1454942086-128704-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On 02/08/2016 06:34 AM, Hannes Reinecke wrote:
> as promised here is now the second part of my ALUA device handler update.

Hello Hannes,

Please test this patch series with lockdep enabled and fix the
resulting complaints. This is what was reported on my test setup
shortly after multipathd was started:


=====================================
[ BUG: bad unlock balance detected! ]
4.5.0-rc3+ #6 Tainted: G            E  
-------------------------------------
kworker/3:1/141 is trying to release lock (port_group_lock) at:
[<ffffffffa041be19>] alua_rtpg+0x329/0x890 [scsi_dh_alua]
but there are no more locks to release!

other info that might help us debug this:
2 locks held by kworker/3:1/141:
 #0:  ("kaluad"){.+.+.+}, at: [<ffffffff8107225a>] process_one_work+0x16a/0x480
 #1:  ((&(&pg->rtpg_work)->work)){+.+.+.}, at: [<ffffffff8107225a>] process_one_work+0x16a/0x480

stack backtrace:
CPU: 3 PID: 141 Comm: kworker/3:1 Tainted: G            E   4.5.0-rc3+ #6
Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 11/17/2014
Workqueue: kaluad alua_rtpg_work [scsi_dh_alua]
 0000000000000000 ffff880456807978 ffffffff81263ba7 0000000000000007
 0000000000000006 ffff880456ff9f80 ffffffffa041be19 ffff8804568079a8
 ffffffff810a29a9 ffff8803f61b7bb8 ffff880456ff9f80 ffffffffa041d878
Call Trace:
 [<ffffffff81263ba7>] dump_stack+0x6b/0xa4
 [<ffffffffa041be19>] ? alua_rtpg+0x329/0x890 [scsi_dh_alua]
 [<ffffffff810a29a9>] print_unlock_imbalance_bug+0xf9/0x100
 [<ffffffffa041be19>] ? alua_rtpg+0x329/0x890 [scsi_dh_alua]
 [<ffffffff810a68af>] __lock_release+0x25f/0x3a0
 [<ffffffff810a6714>] ? __lock_release+0xc4/0x3a0
 [<ffffffffa041be19>] ? alua_rtpg+0x329/0x890 [scsi_dh_alua]
 [<ffffffff810a6a29>] lock_release+0x39/0x60
 [<ffffffff81534799>] _raw_spin_unlock_irqrestore+0x29/0x60
 [<ffffffffa041be19>] alua_rtpg+0x329/0x890 [scsi_dh_alua]
 [<ffffffffa041bec5>] ? alua_rtpg+0x3d5/0x890 [scsi_dh_alua]
 [<ffffffff810a6714>] ? __lock_release+0xc4/0x3a0
 [<ffffffff810a3be0>] ? check_usage_forwards+0x100/0x100
 [<ffffffff810a4e81>] ? mark_held_locks+0x71/0x90
 [<ffffffff815347ab>] ? _raw_spin_unlock_irqrestore+0x3b/0x60
 [<ffffffff810a514c>] ? trace_hardirqs_on_caller+0xfc/0x1c0
 [<ffffffffa041c53e>] alua_rtpg_work+0x1be/0x370 [scsi_dh_alua]
 [<ffffffff810722ca>] process_one_work+0x1da/0x480
 [<ffffffff8107225a>] ? process_one_work+0x16a/0x480
 [<ffffffff810a6714>] ? __lock_release+0xc4/0x3a0
 [<ffffffff81073069>] worker_thread+0x169/0x520
 [<ffffffff8109a1a8>] ? complete+0x48/0x60
 [<ffffffff815347ab>] ? _raw_spin_unlock_irqrestore+0x3b/0x60
 [<ffffffff81072f00>] ? maybe_create_worker+0x110/0x110
 [<ffffffff81072f00>] ? maybe_create_worker+0x110/0x110
 [<ffffffff8152f412>] ? schedule+0x42/0xb0
 [<ffffffff81072f00>] ? maybe_create_worker+0x110/0x110
 [<ffffffff810793e4>] kthread+0xe4/0x100
 [<ffffffff810a521d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff810820e9>] ? schedule_tail+0x19/0xd0
 [<ffffffff81079300>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff81534eff>] ret_from_fork+0x3f/0x70
 [<ffffffff81079300>] ? __init_kthread_worker+0x70/0x70
sd 13:0:0:1: alua: port group 101 state A preferred supports tOlUSNA
BUG: workqueue leaked lock or atomic: kworker/3:1/0x7ffffffe/141
     last function: alua_rtpg_work [scsi_dh_alua]
INFO: lockdep is turned off.
CPU: 3 PID: 141 Comm: kworker/3:1 Tainted: G            E   4.5.0-rc3+ #6
Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 11/17/2014
Workqueue: kaluad alua_rtpg_work [scsi_dh_alua]
 0000000000000000 ffff880456807c38 ffffffff81263ba7 0000000000000001
 0000000000000000 ffff880457355960 ffff880456ff9f80 ffff880456807d28
 ffffffff81072472 ffffffff8107225a ffffffff810a6714 ffffe8fffec71f05
Call Trace:
 [<ffffffff81263ba7>] dump_stack+0x6b/0xa4
 [<ffffffff81072472>] process_one_work+0x382/0x480
 [<ffffffff8107225a>] ? process_one_work+0x16a/0x480
 [<ffffffff810a6714>] ? __lock_release+0xc4/0x3a0
 [<ffffffff81073069>] worker_thread+0x169/0x520
 [<ffffffff8109a1a8>] ? complete+0x48/0x60
 [<ffffffff815347ab>] ? _raw_spin_unlock_irqrestore+0x3b/0x60
 [<ffffffff81072f00>] ? maybe_create_worker+0x110/0x110
 [<ffffffff81072f00>] ? maybe_create_worker+0x110/0x110
 [<ffffffff8152f412>] ? schedule+0x42/0xb0
 [<ffffffff81072f00>] ? maybe_create_worker+0x110/0x110
 [<ffffffff810793e4>] kthread+0xe4/0x100
 [<ffffffff810a521d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff810820e9>] ? schedule_tail+0x19/0xd0
 [<ffffffff81079300>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff81534eff>] ret_from_fork+0x3f/0x70
 [<ffffffff81079300>] ? __init_kthread_worker+0x70/0x70

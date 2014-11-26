From: Tim Small <tim@seoss.co.uk>
Subject: Re: [PATCH 0/4] Fix performance burning or extracting audio etc.
 from multiple optical drives.
Date: Wed, 26 Nov 2014 15:33:49 +0000
Message-ID: <5475F2DD.9030906@seoss.co.uk>
References: <20141121100210.GC8866@infradead.org> <1416924562-16849-1-git-send-email-tim@seoss.co.uk> <20141125162620.GA31478@infradead.org> <5474AE9B.40104@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.allsecuredomains.com ([78.47.234.210]:52778 "EHLO
	relay1.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752732AbaKZPeD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2014 10:34:03 -0500
In-Reply-To: <5474AE9B.40104@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>
Cc: tim@buttersideup.com, Wakko Warner <wakko@animx.eu.org>, linux-scsi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Tim Waugh <tim@cyberelk.net>

On 25/11/14 16:30, Jens Axboe wrote:

> do we really need to do paride here?

I did consider this, but I made the change there too on the basis that:

. paride has received a few commits this year (and is listed as being
    maintained)
. The change is trivial
. It fixes a performance regression which was introduced during the BKL
    removal (mutex being retained by sleeping processes).

I'm happy to drop it, if you prefer.

> Patches 2-4 have identical subjects, and no commit message...

Sorry about that, will fix it with next version.

Having just seen this thread from 2013:

http://permalink.gmane.org/gmane.linux.scsi/79483

I decided to exercise the eject code path a bit more by triggering
simultaneous eject commands on all 11 optical drives in my test box,
followed by simultaneous close-tray commands, repeatedly.

I haven't been able to reproduce the error reported in that email, but
from observing the behaviour of the drives it looks like access to pata
drives is being serialising elsewhere, so the issue in that link may
have been fixed?

Unfortunately running these tests did eventually make all further
attempts to open /dev/sr* block on my test box.

I've stared at the code for a while, but not making any headway
currently, except that a blocking blk_execute_rq (called by
test_unit_ready) is then causing all over cdrom open/close calls to
block (because sr_mutex is held by sr_block_open(), and in turn calls
check_disk_change... scsi_test_unit_ready).

How do I work out why blk_execute_rq is blocking?

# ps -l 3779 2383 3780
F S   UID   PID  PPID  C PRI  NI ADDR SZ WCHAN  TTY        TIME CMD
1 D     0  2383     2  0  80   0 -     0 blk_ex ?          0:00 [kworker/1:2]
0 D     0  3779  1034  0  80   0 -  1057 blk_ex pts/0      0:00 eject -t /dev/sr7
0 D     0  3780  1034  0  80   0 -     0 sr_blo pts/0      0:00 [eject]



/proc/3779/stack-[<ffffffff812e47cb>] blk_execute_rq+0x16b/0x210
/proc/3779/stack-[<ffffffffa0291cb1>] scsi_execute+0x141/0x1f0 [scsi_mod]
/proc/3779/stack-[<ffffffffa0293e1e>] scsi_execute_req_flags+0x8e/0x100 [scsi_mod]
/proc/3779/stack-[<ffffffffa02944f3>] scsi_test_unit_ready+0x83/0x130 [scsi_mod]
/proc/3779/stack:[<ffffffffa05a9a7c>] sr_check_events+0x13c/0x310 [sr_mod]
/proc/3779/stack-[<ffffffffa06cd05c>] cdrom_check_events+0x1c/0x40 [cdrom]
/proc/3779/stack:[<ffffffffa05a9ecd>] sr_block_check_events+0x2d/0x30 [sr_mod]
/proc/3779/stack-[<ffffffff812eed41>] disk_check_events+0x51/0x170
/proc/3779/stack-[<ffffffff812f068c>] disk_clear_events+0x6c/0x130
/proc/3779/stack-[<ffffffff81227150>] check_disk_change+0x30/0x80
/proc/3779/stack-[<ffffffffa06cfd9a>] cdrom_open+0x4a/0xba0 [cdrom]
/proc/3779/stack:[<ffffffffa05aa6c2>] sr_block_open+0x92/0x130 [sr_mod]
/proc/3779/stack-[<ffffffff81227b71>] __blkdev_get+0xd1/0x4b0
/proc/3779/stack-[<ffffffff81227f91>] blkdev_get+0x41/0x3e0
/proc/3779/stack-[<ffffffff812283fe>] blkdev_open+0x6e/0x90
/proc/3779/stack-[<ffffffff811e6cbd>] do_dentry_open+0x1ed/0x360
/proc/3779/stack-[<ffffffff811e6f99>] vfs_open+0x49/0x50
/proc/3779/stack-[<ffffffff811fa849>] do_last+0x239/0x1520
/proc/3779/stack-[<ffffffff811fbbe7>] path_openat+0xb7/0x6a0
/proc/3779/stack-[<ffffffff811fd3ea>] do_filp_open+0x3a/0xb0
/proc/3779/stack-[<ffffffff811e896c>] do_sys_open+0x12c/0x220
/proc/3779/stack-[<ffffffff811e8a7e>] SyS_open+0x1e/0x20


/proc/2383/stack-[<ffffffff812e47cb>] blk_execute_rq+0x16b/0x210
/proc/2383/stack-[<ffffffffa0291cb1>] scsi_execute+0x141/0x1f0 [scsi_mod]
/proc/2383/stack-[<ffffffffa0293e1e>] scsi_execute_req_flags+0x8e/0x100 [scsi_mod]
/proc/2383/stack-[<ffffffffa02944f3>] scsi_test_unit_ready+0x83/0x130 [scsi_mod]
/proc/2383/stack:[<ffffffffa05a9a7c>] sr_check_events+0x13c/0x310 [sr_mod]
/proc/2383/stack-[<ffffffffa06cd05c>] cdrom_check_events+0x1c/0x40 [cdrom]
/proc/2383/stack:[<ffffffffa05a9ecd>] sr_block_check_events+0x2d/0x30 [sr_mod]
/proc/2383/stack-[<ffffffff812eed41>] disk_check_events+0x51/0x170
/proc/2383/stack-[<ffffffff812eee7c>] disk_events_workfn+0x1c/0x20
/proc/2383/stack-[<ffffffff8108b91f>] process_one_work+0x1df/0x520
/proc/2383/stack-[<ffffffff8108bf3b>] worker_thread+0x6b/0x4a0
/proc/2383/stack-[<ffffffff8109130b>] kthread+0x10b/0x130
/proc/2383/stack-[<ffffffff815b8afc>] ret_from_fork+0x7c/0xb0
/proc/2383/stack-[<ffffffffffffffff>] 0xffffffffffffffff


/proc/3780/stack:[<ffffffffa05aa604>] sr_block_release+0x24/0x50 [sr_mod]
/proc/3780/stack-[<ffffffff81227a65>] __blkdev_put+0x185/0x1c0
/proc/3780/stack-[<ffffffff81228472>] blkdev_put+0x52/0x180
/proc/3780/stack-[<ffffffff81228658>] blkdev_close+0x28/0x30
/proc/3780/stack-[<ffffffff811eb4e5>] __fput+0xf5/0x210
/proc/3780/stack-[<ffffffff811eb64e>] ____fput+0xe/0x10
/proc/3780/stack-[<ffffffff8108f824>] task_work_run+0xc4/0xf0
/proc/3780/stack-[<ffffffff810734fa>] do_exit+0x3da/0xb70
/proc/3780/stack-[<ffffffff81073d34>] do_group_exit+0x54/0xe0
/proc/3780/stack-[<ffffffff81073dd4>] SyS_exit_group+0x14/0x20
/proc/3780/stack-[<ffffffff815b8bad>] system_call_fastpath+0x16/0x1b


# grep -l scsi_exec /proc/*/stack
/proc/2383/stack
/proc/3779/stack
# grep -l ioctl /proc/*/stack
# grep -l blk_execute /proc/*/stack
/proc/2383/stack
/proc/3779/stack
#


Cheers,

Tim.



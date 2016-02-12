From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv6 00/23] ALUA device handler update, part II
Date: Fri, 12 Feb 2016 11:28:23 -0800
Message-ID: <56BE3257.9070808@sandisk.com>
References: <1455265546-44470-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0062.outbound.protection.outlook.com ([65.55.169.62]:63264
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750852AbcBLT22 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Feb 2016 14:28:28 -0500
In-Reply-To: <1455265546-44470-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 02/12/2016 12:25 AM, Hannes Reinecke wrote:
> as promised here is now the second part of my ALUA device handler update.

Hello Hannes,

Thanks for the quick respin. The first lockdep warning I noticed with the
previous version is gone. But I saw the following with this patch series:

------------[ cut here ]------------
WARNING: CPU: 7 PID: 43 at kernel/locking/mutex.c:869 mutex_trylock+0x1ad/0x1c0()
DEBUG_LOCKS_WARN_ON(in_interrupt())
CPU: 7 PID: 43 Comm: ksoftirqd/7 Tainted: G            E   4.5.0-rc3+ #8
Call Trace:
 [<ffffffff81263ba7>] dump_stack+0x6b/0xa4
 [<ffffffff81057acb>] warn_slowpath_common+0x8b/0xd0
 [<ffffffff81057bb1>] warn_slowpath_fmt+0x41/0x70
 [<ffffffff815307bd>] mutex_trylock+0x1ad/0x1c0
 [<ffffffffa041c731>] alua_check+0x31/0x260 [scsi_dh_alua]
 [<ffffffffa041c9ce>] alua_check_sense+0x6e/0x90 [scsi_dh_alua]
 [<ffffffff8136adf1>] scsi_check_sense+0x71/0x270
 [<ffffffff8136b1ee>] scsi_decide_disposition+0x18e/0x200
 [<ffffffff81371065>] scsi_softirq_done+0x65/0x150
 [<ffffffff812495d1>] __blk_mq_complete_request+0x81/0x100
 [<ffffffff812496e7>] blk_mq_complete_request+0x17/0x20
 [<ffffffff8136f4d6>] scsi_mq_done+0x16/0x20
 [<ffffffffa03f112e>] srp_process_rsp+0x13e/0x280 [ib_srp]
 [<ffffffffa03f4127>] srp_recv_done+0x187/0x380 [ib_srp]
 [<ffffffffa012f3f3>] __ib_process_cq+0x43/0xc0 [ib_core]
 [<ffffffffa012f7cd>] ib_poll_handler+0x2d/0x80 [ib_core]
 [<ffffffff81294c88>] irq_poll_softirq+0xa8/0xf0
 [<ffffffff8105be66>] __do_softirq+0xf6/0x240
 [<ffffffff8105bfca>] run_ksoftirqd+0x1a/0x60
 [<ffffffff8107cf43>] smpboot_thread_fn+0x113/0x1d0
 [<ffffffff810793e4>] kthread+0xe4/0x100
 [<ffffffff81534eff>] ret_from_fork+0x3f/0x70
---[ end trace 34fb3b7c104f6c3d ]---

Can you also address this warning ?

Thanks,

Bart.

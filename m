From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] blk-mq: Fix several SCSI request queue lockups
Date: Tue, 5 Dec 2017 06:42:06 +0800
Message-ID: <20171204224200.GA6888@ming.t460p>
References: <20171204173032.16330-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48862 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751989AbdLDWmW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Dec 2017 17:42:22 -0500
Content-Disposition: inline
In-Reply-To: <20171204173032.16330-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Mon, Dec 04, 2017 at 09:30:32AM -0800, Bart Van Assche wrote:
> Commit 0df21c86bdbf introduced several bugs:
> * A SCSI queue stall for queue depths > 1, addressed by commit
>   88022d7201e9 ("blk-mq: don't handle failure in .get_budget")

This one is committed already.

> * A systematic lockup for SCSI queues with queue depth 1. The
>   following test reproduces that bug systematically:
>   - Change the SRP initiator such that SCSI target queue depth is
>     limited to 1.
>   - Run the following command:
>       srp-test/run_tests -f xfs -d -e none -r 60 -t 01
>   See also "[PATCH 4/7] blk-mq: Avoid that request processing
>   stalls when sharing tags"
>   (https://marc.info/?l=linux-block&m=151208695316857). Note:
>   reverting commit 0df21c86bdbf also fixes a sporadic SCSI request
>   queue lockup while inserting a blk_mq_sched_mark_restart_hctx()
>   before all blk_mq_dispatch_rq_list() calls only fixes the
>   systematic lockup for queue depth 1.

You are the only reproducer, and you don't want to provide any kernel
log about this issue, so how can we help you fix your issue?

You said that your patch fixes 'commit b347689ffbca ("blk-mq-sched:
improve dispatching from sw queue")', but you don't mention any issue
about that commit, and your patch is actually nothing to do with
commit b347689ffbca, and seems your work style is just try and guess.

Also both Jens and I have run tests on null_blk and scsi_debug by setting
queue_depth as one, and we all can't see IO hang with current blk-mq.

> * A scsi_debug lockup - see also "[PATCH] SCSI: delay run queue if
>   device is blocked in scsi_dev_queue_ready()"
>   (https://marc.info/?l=linux-block&m=151223233407154).

This issue is clearly explained in theory, and can be reproduced/verified
by scsi_debug, so why can't we apply it to fix the issue? And the fix is
simply and can be thought as cleanup too, since the handling for this case
becomes same with non-mq path now.

> 
> I think the above means that it is too risky to try to fix all bugs
> introduced by commit 0df21c86bdbf before kernel v4.15 is released.
> Hence revert that commit.

What is the risk?

> 
> Fixes: commit 0df21c86bdbf ("scsi: implement .get_budget and .put_budget for blk-mq")
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org

This commit fixes one important SCSI_MQ performance issue, we can't
simply revert it just because of one un-confirmed report from you
only(without any kernel log provided).

So Nak.

-- 
Ming

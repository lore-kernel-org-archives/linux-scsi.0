Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C289C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 19:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbiCCTY3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Mar 2022 14:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiCCTY2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2022 14:24:28 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B851CED94A;
        Thu,  3 Mar 2022 11:23:41 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 313DC68AFE; Thu,  3 Mar 2022 20:23:38 +0100 (CET)
Date:   Thu, 3 Mar 2022 20:23:38 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: move more work to disk_release v2
Message-ID: <20220303192338.GA23351@lst.de>
References: <20220227172144.508118-1-hch@lst.de> <741e087a-43f8-dc90-b679-7865cf503ac3@acm.org> <20220301125632.GA3911@lst.de> <c61b6a0d-c3b5-30e2-14c5-efa7ea475c23@acm.org> <20220302150319.GA30076@lst.de> <9e818df5-e8c0-b397-ae21-1a0745074094@acm.org> <20220303105455.GA14991@lst.de> <7b4ba630-b51c-9675-88b4-d79649756abd@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b4ba630-b51c-9675-88b4-d79649756abd@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 03, 2022 at 10:19:34AM -0800, Bart Van Assche wrote:
> On 3/3/22 02:54, Christoph Hellwig wrote:
>> Maybe you can try to figure out what derefernce causes
>> the null-ptr-deref, and what kind of command causes this?  Also
>> I suspect this is the first patch in the series, so it would be
>> great to verify the problem with just that.
>
> Hi Christoph,
>
> I can reproduce the crash by cherry-picking patch "blk-mq: do not include 
> passthrough requests in I/O accounting" on top of Jens' for-next branch.
>
> From the struct request that triggers the crash (the flag names have been 
> looked up manually and hence may be wrong):
> * cmd_flags 0x44202 = REQ_PREFLUSH | REQ_NOMERGE | REQ_FAILFAST_TRANSPORT |
>   REQ_OP_FLUSH.
> * rq_flags 0x2000 = RQF_IO_STAT.

So this is a flush request.  Flush request from the flush state machine.
Normally they don't go through the I/O accounting because the I/O
accounting happens before we call into the flush state machine.  But
with blk-mq we can run the flush state machine on the upper dm-mpath
device and then hand a request with a NULL bio down.

I can't really explain why you hit that path and I don't withthe same
test.

Can you try this patch on top of the series?

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6a072543bde4d..73b8bc9d67cf6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -883,7 +883,10 @@ static inline void blk_account_io_done(struct request *req, u64 now)
 
 static void __blk_account_io_start(struct request *rq)
 {
-	rq->part = rq->bio->bi_bdev;
+	if (rq->bio)
+		rq->part = rq->bio->bi_bdev;
+	else /* should only happen for dm-mpath flush requests */
+		rq->part = rq->q->disk->part0;
 
 	part_stat_lock();
 	update_io_ticks(rq->part, jiffies, false);

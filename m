Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC28C3A5A6
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 09:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD2A9217D6
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 09:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731642AbfISJV2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 05:21:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43588 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730677AbfISJV2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Sep 2019 05:21:28 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F2CA83024558;
        Thu, 19 Sep 2019 09:21:26 +0000 (UTC)
Received: from ming.t460p (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 76C3B60872;
        Thu, 19 Sep 2019 09:21:19 +0000 (UTC)
Date:   Thu, 19 Sep 2019 17:21:15 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Andrea Vai <andrea.vai@unipv.it>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
Message-ID: <20190919092114.GB4541@ming.t460p>
References: <Pine.LNX.4.44L0.1909181213141.1507-100000@iolanthe.rowland.org>
 <BYAPR04MB58160E6FEBD92D04ECA7D303E7890@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20190919085555.GA4541@ming.t460p>
 <BYAPR04MB58163D3C66FEA00A754CF7C7E7890@BYAPR04MB5816.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR04MB58163D3C66FEA00A754CF7C7E7890@BYAPR04MB5816.namprd04.prod.outlook.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 19 Sep 2019 09:21:27 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 19, 2019 at 09:09:33AM +0000, Damien Le Moal wrote:
> On 2019/09/19 10:56, Ming Lei wrote:
> > On Thu, Sep 19, 2019 at 08:26:32AM +0000, Damien Le Moal wrote:
> >> On 2019/09/18 18:30, Alan Stern wrote:
> >>> On Wed, 18 Sep 2019, Andrea Vai wrote:
> >>>
> >>>>> Also, I wonder if the changing the size of the data transfers would
> >>>>> make any difference.  This is easy to try; just write "64" to
> >>>>> /sys/block/sd?/queue/max_sectors_kb (where the ? is the appropriate
> >>>>> drive letter) after the drive is plugged in but before the test
> >>>>> starts.
> >>>>
> >>>> ok, so I duplicated the tests above for the "64" case (it was
> >>>> initially set as "120", if it is relevant to know), leading to 40 tests named as
> >>>>
> >>>> bad.mon.out_50000000_64_TIMESTAMP
> >>>> bad.mon.out_50000000_non64_TIMESTAMP
> >>>> good.mon.out_50000000_64_TIMESTAMP
> >>>> good.mon.out_50000000_non64_TIMESTAMP
> >>>>
> >>>> where "64" denotes the ones done with that value in max_sectors_kb,
> >>>> and "not64" the ones without it (as far as I can tell, it has been
> >>>> always "120").
> >>>>
> >>>> So, we have 40 traces total. Each set of 10 trials is identified by
> >>>> a text file, which contains the output log of the test script (and the
> >>>> timestamps), also available in the download zipfile.
> >>>>
> >>>> Just to summarize here the times, they are respectively (number
> >>>> expressed  in seconds):
> >>>>
> >>>> BAD:
> >>>>   Logs: log_10trials_50MB_BAD_NonCanc_64.txt,
> >>>> log_10trials_50MB_BAD_NonCanc_non64.txt
> >>>>   64: 34, 34, 35, 39, 37, 32, 42, 44, 43, 40
> >>>>   not64: 61, 71, 59, 71, 62, 75, 62, 70, 62, 68
> >>>> GOOD:
> >>>>   Logs: log_10trials_50MB_GOOD_NonCanc_64.txt,
> >>>> log_10trials_50MB_GOOD_NonCanc_non64.txt
> >>>>   64: 34, 32, 35, 34, 35, 33, 34, 33, 33, 33
> >>>>   not64: 32, 30, 32, 31, 31, 30, 32, 30, 32, 31
> >>>
> >>> The improvement from using "64" with the bad kernel is quite large.  
> >>> That alone would be a big help for you.
> >>>
> >>> However, I did see what appears to be a very significant difference 
> >>> between the bad and good kernel traces.  It has to do with the order in 
> >>> which the blocks are accessed.
> >>>
> >>> Here is an extract from one of the bad traces.  I have erased all the 
> >>> information except for the columns containing the block numbers to be 
> >>> written:
> >>>
> >>> 00019628 00
> >>> 00019667 00
> >>> 00019628 80
> >>> 00019667 80
> >>> 00019629 00
> >>> 00019668 00
> >>> 00019629 80
> >>> 00019668 80
> >>>
> >>> Here is the equivalent portion from one of the good traces:
> >>>
> >>> 00019628 00
> >>> 00019628 80
> >>> 00019629 00
> >>> 00019629 80
> >>> 0001962a 00
> >>> 0001962a 80
> >>> 0001962b 00
> >>> 0001962b 80
> >>>
> >>> Notice that under the good kernel, the block numbers increase
> >>> monotonically in a single sequence.  But under the bad kernel, the
> >>> block numbers are not monotonic -- it looks like there are two separate
> >>> threads each with its own strictly increasing sequence.
> >>>
> >>> This is exactly the sort of difference one might expect to see from
> >>> the commit f664a3cc17b7 ("scsi: kill off the legacy IO path") you
> >>> identified as the cause of the problem.  With multiqueue I/O, it's not 
> >>> surprising to see multiple sequences of block numbers.
> >>>
> >>> Add it's not at all surprising that a consumer-grade USB storage device 
> >>> might do a much worse job of handling non-sequential writes than 
> >>> sequential ones.
> >>>
> >>> Which leads to a simple question for the SCSI or block-layer 
> >>> maintainers:  Is there a sysfs setting Andrea can tweak which will 
> >>> effectively restrict a particular disk device down to a single I/O
> >>> queue, forcing sequential access?
> >>
> >> The scheduling inefficiency you are seeing may be coming from the fact that the
> >> block layer does a direct issue of requests, bypassing the elevator, under some
> >> conditions. One of these is sync requests on a multiqueue device. We hit this
> >> problem on Zoned disks which can easily return an error for write requests
> >> without the elevator throttling writes per zones (zone write locking). This
> >> problem was discovered by Hans (on CC).
> >>
> >> I discussed this with Hannes yesterday and we think we have a fix, but we'll
> >> need to do a lot of testing as all block devices are potentially impacted by the
> >> change, including stacked drivers (DM). Performance regression is scary with any
> >> change in that area (see blk_mq_make_request() and use of
> >> blk_mq_try_issue_directly() vs blk_mq_sched_insert_request()).
> > 
> > Not sure this one is same with yours, for USB, mq-deadline is used at
> > default, and direct issue won't be possible. Direct issue is only used
> > in case of none or underlying queues of DM multipath.
> 
> For a multi-queue zoned disk, mq-deadline is also set, but we have observed
> unaligned write IO errors for sync writes because of mq-deadline being bypassed
> and as a result zones not being write-locked.
> 
> In blk_mq_make_request(), at the end, you have:
> 
> 	} else if ((q->nr_hw_queues > 1 && is_sync) || (!q->elevator &&
> 			!data.hctx->dispatch_busy)) {
> 		blk_mq_try_issue_directly(data.hctx, rq, &cookie);
> 	} else {
> 		blk_mq_sched_insert_request(rq, false, true, true);
> 	}
> 
> Which I read as "for a sync req on a multi-queue device, direct issue",
> regardless of the elevator being none or something else.

Yeah, looks elevator is bypassed in the above case, which seems a bug.
USB storage has only single queue.

> 
> The correct test should probably be:
> 
> 	} else if (!q->elevator &&
> 		   ((q->nr_hw_queues > 1 && is_sync) || 	
> 		     !data.hctx->dispatch_busy))) {
> 		blk_mq_try_issue_directly(data.hctx, rq, &cookie);
> 	} else {
> 		blk_mq_sched_insert_request(rq, false, true, true);
> 	}
> 
> That is, never bypass the elevator if one is set. Thoughts ?

IMO, elevator shouldn't be bypassed any time, looks it is bypassed
in the following branch too, but may not be reached for zone device.

blk_mq_make_request()
 ...
 } else if (plug && !blk_queue_nomerges(q)) {
	...
	if (same_queue_rq) {
                        data.hctx = same_queue_rq->mq_hctx;
                        trace_block_unplug(q, 1, true);
                        blk_mq_try_issue_directly(data.hctx, same_queue_rq,
                                        &cookie);
                }
 }


Thanks,
Ming

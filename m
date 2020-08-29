Return-Path: <SRS0=Q1Hz=CH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B782C433E7
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Aug 2020 18:56:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 171F5208CA
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Aug 2020 18:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgH2S4y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Aug 2020 14:56:54 -0400
Received: from netrider.rowland.org ([192.131.102.5]:48013 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1728373AbgH2S4y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Aug 2020 14:56:54 -0400
Received: (qmail 502630 invoked by uid 1000); 29 Aug 2020 14:56:53 -0400
Date:   Sat, 29 Aug 2020 14:56:53 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, kernel@puri.sm
Subject: Re: [PATCH] block: Fix bug in runtime-resume handling
Message-ID: <20200829185653.GB501978@rowland.harvard.edu>
References: <6f0c530f-4309-ab1e-393b-83bf8367f59e@puri.sm>
 <20200823145733.GC303967@rowland.harvard.edu>
 <3e5a465e-8fe0-b379-a80e-23e2f588c71a@acm.org>
 <20200824201343.GA344424@rowland.harvard.edu>
 <5152a510-bebf-bf33-f6b3-4549e50386ab@puri.sm>
 <4c636f2d-af7f-bbde-a864-dbeb67c590ec@puri.sm>
 <20200827202952.GA449067@rowland.harvard.edu>
 <478fdc57-f51e-f480-6fde-f34596394624@puri.sm>
 <20200829152635.GA498519@rowland.harvard.edu>
 <6d22ec22-a0c7-6a9d-439e-38ef87b0207c@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d22ec22-a0c7-6a9d-439e-38ef87b0207c@puri.sm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Aug 29, 2020 at 06:33:26PM +0200, Martin Kepplinger wrote:
> On 29.08.20 17:26, Alan Stern wrote:
> > Hmmm.  I'm wondering about something you wrote back in June 
> > (https://marc.info/?l=linux-scsi&m=159345778431615&w=2):
> > 
> > 	blk_queue_enter() always - especially when sd is runtime 
> > 	suspended and I try to mount as above - sets success to be true 
> > 	for me, so never continues down to bkl_pm_request_resume(). All 
> > 	I see is "PM: Removing info for No Bus:sda1".
> > 
> > blk_queue_enter() would always set success to be true because pm 
> > (derived from the BLK_MQ_REQ_PREEMPT flag) is true.  But why was the 
> > BLK_MQ_REQ_PREEMPT flag set?  In other words, where was 
> > blk_queue_enter() called from?
> > 
> > Can you get a stack trace (i.e., call dump_stack()) at exactly this 
> > point, that is, when pm is true and q->rpm_status is RPM_SUSPENDED?  Or 
> > do you already know the answer?
> > 
> >
> 
> I reverted any scsi/block out-of-tree fixes for this.
> 
> when I try to mount, pm is TRUE (BLK_MQ_REQ_PREEMT set) and that's the
> first stack trace I get in this condition, inside of blk_queue_enter():
> 
> There is more, but I don't know if that's interesting.
> 
> [   38.642202] CPU: 2 PID: 1522 Comm: mount Not tainted 5.8.0-1-librem5 #487
> [   38.642207] Hardware name: Purism Librem 5r3 (DT)
> [   38.642213] Call trace:
> [   38.642233]  dump_backtrace+0x0/0x210
> [   38.642242]  show_stack+0x20/0x30
> [   38.642252]  dump_stack+0xc8/0x128
> [   38.642262]  blk_queue_enter+0x1b8/0x2d8
> [   38.642271]  blk_mq_alloc_request+0x54/0xb0
> [   38.642277]  blk_get_request+0x34/0x78
> [   38.642286]  __scsi_execute+0x60/0x1c8
> [   38.642291]  scsi_test_unit_ready+0x88/0x118
> [   38.642298]  sd_check_events+0x110/0x158
> [   38.642306]  disk_check_events+0x68/0x188
> [   38.642312]  disk_clear_events+0x84/0x198
> [   38.642320]  check_disk_change+0x38/0x90
> [   38.642325]  sd_open+0x60/0x148
> [   38.642330]  __blkdev_get+0xcc/0x4c8
> [   38.642335]  __blkdev_get+0x278/0x4c8
> [   38.642339]  blkdev_get+0x128/0x1a8
> [   38.642345]  blkdev_open+0x98/0xb0
> [   38.642354]  do_dentry_open+0x130/0x3c8
> [   38.642359]  vfs_open+0x34/0x40
> [   38.642366]  path_openat+0xa30/0xe40
> [   38.642372]  do_filp_open+0x84/0x100
> [   38.642377]  do_sys_openat2+0x1f4/0x2b0
> [   38.642382]  do_sys_open+0x60/0xa8
> (...)
> 
> and of course it doesn't work and /dev/sda1 disappears, see the initial
> discussion that led to your fix.

Great!  That's exactly what I was looking for, thank you.

Bart, this is a perfect example of the potential race I've been talking 
about in the other email thread.  Suppose thread 0 is carrying out a 
runtime suspend of a SCSI disk and at the same time, thread 1 is opening 
the disk's block device (as we see in the stack trace here).  Then we 
could have the following:

	Thread 0		Thread 1
	--------		--------
	Start runtime suspend
	blk_pre_runtime_suspend calls
	  blk_set_pm_only and sets
	  q->rpm_status to RPM_SUSPENDING

				Call sd_open -> ... -> scsi_test_unit_ready
				  -> __scsi_execute -> ...
				  -> blk_queue_enter
				Sees BLK_MQ_REQ_PREEMPT set and
				  RPM_SUSPENDING queue status, so does 
				  not postpone the request

	blk_post_runtime_suspend sets
	  q->rpm_status to RPM_SUSPENDED
	The drive goes into runtime suspend

				Issues the TEST UNIT READY request
				Request fails because the drive is suspended

One way to avoid this race is mutual exclusion: We could make sd_open 
prevent the drive from being runtime suspended until it returns.  
However I don't like this approach; it would mean tracking down every 
possible pathway to __scsi_execute and making sure that runtime suspend 
is blocked.

A more fine-grained approach would be to have __scsi_execute itself call 
scsi_autopm_get/put_device whenever the rq_flags argument doesn't 
contain RQF_PM.  This way we wouldn't have to worry about missing any 
possiible pathways.  But it relies on an implicit assumption that 
__scsi_execute is the only place where the PREEMPT flag gets set.

A third possibility is the approach I outlined before, adding a 
BLK_MQ_REQ_PM flag.  But to avoid the deadlock you pointed out, I would 
make blk_queue_enter smarter about whether to postpone a request.  The 
logic would go like this:

	If !blk_queue_pm_only:
		Allow
	If !BLK_MQ_REQ_PREEMPT:
		Postpone
	If q->rpm_status is RPM_ACTIVE:
		Allow
	If !BLK_MQ_REQ_PM:
		Postpone
	If q->rpm_status is RPM_SUSPENDED:
		Postpone
	Else:
		Allow

The assumption here is that the PREEMPT flag is set whenever the PM flag 
is.

I believe either the second or third possibility would work.  The second 
looks to be the simplest

What do you think?

Alan Stern

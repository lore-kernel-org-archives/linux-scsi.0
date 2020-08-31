Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D10F4C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 18:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A46A32067C
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 18:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgHaSZ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 14:25:28 -0400
Received: from netrider.rowland.org ([192.131.102.5]:43663 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726174AbgHaSZ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2020 14:25:27 -0400
Received: (qmail 560428 invoked by uid 1000); 31 Aug 2020 14:25:26 -0400
Date:   Mon, 31 Aug 2020 14:25:26 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Can Guo <cang@codeaurora.org>
Subject: Re: [PATCH RFC 6/6] block, scsi, ide: Only submit power management
 requests in state RPM_SUSPENDED
Message-ID: <20200831182526.GA558270@rowland.harvard.edu>
References: <20200831025357.32700-1-bvanassche@acm.org>
 <20200831025357.32700-7-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831025357.32700-7-bvanassche@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Aug 30, 2020 at 07:53:57PM -0700, Bart Van Assche wrote:
> Recently Martin Kepplinger reported a problem with the SCSI runtime PM
> code. Alan Stern root-caused that deadlock as follows:
> 
> 	Thread 0		Thread 1
> 	--------		--------
> 	Start runtime suspend
> 	blk_pre_runtime_suspend calls
> 	  blk_set_pm_only and sets
> 	  q->rpm_status to RPM_SUSPENDING
> 
> 				Call sd_open -> ... -> scsi_test_unit_ready
> 				  -> __scsi_execute -> ...
> 				  -> blk_queue_enter
> 				Sees BLK_MQ_REQ_PREEMPT set and
> 				  RPM_SUSPENDING queue status, so does
> 				  not postpone the request
> 
> 	blk_post_runtime_suspend sets
> 	  q->rpm_status to RPM_SUSPENDED
> 	The drive goes into runtime suspend
> 
> 				Issues the TEST UNIT READY request
> 				Request fails because the drive is suspended
> 
> Fix that deadlock by only accepting power management requests while
> suspended. Remove flag RQF_PREEMPT.

Let me clarify this description.

Firstly, the second-to-last sentence is ambiguous.  The word "only" is
all too easy to misuse through carelessness.  In this case you meant
to say "by accepting only power management requests while suspended",
but what you actually wrote was equivalent to "by accepting power
management requests only while suspended".  And as it happens, both
meanings are incorrect because we don't want to accept _any_ requests
while the device is suspended -- not even power-management requests.
The description should have said "by postponing all non-power-management 
requests while the device is suspending, suspended, or resuming."

Secondly, the scenario described above is not a deadlock; it is a race 
leading to a command failure.  Namely, the thread setting q->rpm_status 
to RPM_SUSPENDED races with the thread testing q->rpm_status.

Thirdly, this race is _not_ the problem that Martin encountered.  His 
problem was a simple bug (failure to postpone a request), not a race or 
a deadlock.

Fourthly, the race illustrated above is, for now, theoretical.  It 
cannot occur with the existing code base (mostly because the existing 
code is buggy).  The advantage of your series over the patch I submitted 
on Aug. 23 ("block: Fix bug in runtime-resume handling") is that it 
fixes Martin's problem without introducing this new race.

Alan Stern

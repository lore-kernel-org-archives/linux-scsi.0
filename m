Return-Path: <SRS0=qcVN=CF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81AA1C433E3
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 20:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D07D2084C
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 20:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgH0U3y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 16:29:54 -0400
Received: from netrider.rowland.org ([192.131.102.5]:52689 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726706AbgH0U3y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2020 16:29:54 -0400
Received: (qmail 450277 invoked by uid 1000); 27 Aug 2020 16:29:52 -0400
Date:   Thu, 27 Aug 2020 16:29:52 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, kernel@puri.sm
Subject: Re: [PATCH] block: Fix bug in runtime-resume handling
Message-ID: <20200827202952.GA449067@rowland.harvard.edu>
References: <d3b6f7b8-5345-1ae1-4f79-5dde226e74f1@puri.sm>
 <20200809152643.GA277165@rowland.harvard.edu>
 <60150284-be13-d373-5448-651b72a7c4c9@puri.sm>
 <20200810141343.GA299045@rowland.harvard.edu>
 <6f0c530f-4309-ab1e-393b-83bf8367f59e@puri.sm>
 <20200823145733.GC303967@rowland.harvard.edu>
 <3e5a465e-8fe0-b379-a80e-23e2f588c71a@acm.org>
 <20200824201343.GA344424@rowland.harvard.edu>
 <5152a510-bebf-bf33-f6b3-4549e50386ab@puri.sm>
 <4c636f2d-af7f-bbde-a864-dbeb67c590ec@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c636f2d-af7f-bbde-a864-dbeb67c590ec@puri.sm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 27, 2020 at 07:42:43PM +0200, Martin Kepplinger wrote:
> On 26.08.20 09:48, Martin Kepplinger wrote:
> > On 24.08.20 22:13, Alan Stern wrote:

> >> Martin:
> >>
> >> (I forgot to ask this question several weeks ago, while you were running 
> >> your tests.  Better ask it now before I forget again...)
> >>
> >> I suspect the old runtime-PM code in the block layer would have worked 
> >> okay in your SD cardreader test if the BLK_MQ_REQ_PREEMPT flag had not 
> >> been set.  Do you know why the flag was set, or what line of code caused 
> >> it to be set?
> > 
> > Correct. if not set, I could handle all I need in the scsi error path.
> 
> this thread becomes a bit confusing. I thought about REQ_FAILFAST_DEV
> but you're talking about something different.
> 
> the only place I see BLK_MQ_REQ_PREEMPT getting passed on is in
> __scsi_execute() which is the case when mounting/unmounting. At least
> that about the only place I can find.

Ah yes, I see what you mean.

> I remember *only* your block pm fix would let me mount/unmount, but not
> use files yet (REQ_FAILFAST_DEV and so on).
> 
> When I revert your fix and remove BLK_MQ_REQ_PREEMPT from being passed
> on to blk_get_request() in __scsi_execute(), that line gets executed
> exactly once during startup and I'm missing the /dev/sda device from the
> cardreader then.
> 
> Is this what you're asking?

Not quite sure, but it doesn't matter.  Removing BLK_MQ_REQ_PREEMPT in 
__scsi_execute() is probably not a safe thing to do.

Instead, look at sd_resume().  That routine calls __scsi_execute() 
indirectly through sd_start_stop_device(), and the only reason it does 
this is because the sdkp->device->manage_start_stop flag is set.  You 
ought to be able to clear this flag in sysfs, by writing to 
/sys/block/sda/device/scsi_disk/*/manage_start_stop.  If you do this 
before allowing the card reader to go into runtime suspend, does it then 
resume okay?

(Yes, I know you still won't be able to read it because of the FAILFAST 
flag.  I just want to know if the runtime resume actually takes place.)

Alan Stern

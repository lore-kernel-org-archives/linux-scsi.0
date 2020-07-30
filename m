Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28126C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 15:14:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11E7B207F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 15:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgG3POG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 11:14:06 -0400
Received: from netrider.rowland.org ([192.131.102.5]:38007 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726275AbgG3POG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 11:14:06 -0400
Received: (qmail 6915 invoked by uid 1000); 30 Jul 2020 11:14:05 -0400
Date:   Thu, 30 Jul 2020 11:14:05 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     Bart Van Assche <bvanassche@acm.org>, jejb@linux.ibm.com,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200730151405.GC6332@rowland.harvard.edu>
References: <20200623111018.31954-1-martin.kepplinger@puri.sm>
 <ed9ae198-4c68-f82b-04fc-2299ab16df96@acm.org>
 <eccacce9-393c-ca5d-e3b3-09961340e0db@puri.sm>
 <1379e21d-c51a-3710-e185-c2d7a9681fb7@acm.org>
 <20200626154441.GA296771@rowland.harvard.edu>
 <c19f1938-ae47-2357-669d-5b4021aec154@puri.sm>
 <20200629161536.GA405175@rowland.harvard.edu>
 <c253dde7-9347-b3dc-9c91-65d685793b29@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c253dde7-9347-b3dc-9c91-65d685793b29@puri.sm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 30, 2020 at 10:05:50AM +0200, Martin Kepplinger wrote:
> On 29.06.20 18:15, Alan Stern wrote:
> > On Mon, Jun 29, 2020 at 11:42:59AM +0200, Martin Kepplinger wrote:
> >>
> >>
> >> On 26.06.20 17:44, Alan Stern wrote:
> >>> Martin's best approach would be to add some debugging code to find out why 
> >>> blk_queue_enter() isn't calling bkl_pm_request_resume(), or why that call 
> >>> doesn't lead to pm_request_resume().
> >>>
> >>> Alan Stern
> >>>
> >>
> >> Hi Alan,
> >>
> >> blk_queue_enter() always - especially when sd is runtime suspended and I
> >> try to mount as above - sets success to be true for me, so never
> >> continues down to bkl_pm_request_resume(). All I see is "PM: Removing
> >> info for No Bus:sda1".
> > 
> > Aha.  Looking at this more closely, it's apparent that the code in 
> > blk-core.c contains a logic bug: It assumes that if the BLK_MQ_REQ_PREEMPT 
> > flag is set then the request can be issued regardless of the queue's 
> > runtime status.  That is not correct when the queue is suspended.
> > 
> > Below is my attempt to fix this up.  I'm not sure that the patch is 
> > entirely correct, but it should fix this logic bug.  I would appreciate a 
> > critical review.
> > 
> > Martin, does this fix the problem?
> > 
> > Alan Stern
> 
> Hi Alan,
> 
> So in the block layer your change below indeed fixes the problem and if
> you want to submit that 1:1 feel free to add
> 
> Tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>
> 
> thanks for your help in this!

Thank you for _your_ help!

The next merge window is coming up soon.  I think I'll wait until it is 
over before submitting the patch (maintainers tend to be too busy to 
consider new patches during a merge window).

But I am still open to comments or criticism of the patch in the 
meantime.  There hasn't been any feedback since Bart's initial set of 
questions.

Alan Stern

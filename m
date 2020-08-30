Return-Path: <SRS0=rOw5=CI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69580C433E6
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 01:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46E4120776
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 01:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgH3BG2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Aug 2020 21:06:28 -0400
Received: from netrider.rowland.org ([192.131.102.5]:48855 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1728448AbgH3BG1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Aug 2020 21:06:27 -0400
Received: (qmail 508788 invoked by uid 1000); 29 Aug 2020 21:06:26 -0400
Date:   Sat, 29 Aug 2020 21:06:26 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Martin Kepplinger <martin.kepplinger@puri.sm>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, kernel@puri.sm
Subject: Re: [PATCH] block: Fix bug in runtime-resume handling
Message-ID: <20200830010626.GA507988@rowland.harvard.edu>
References: <3e5a465e-8fe0-b379-a80e-23e2f588c71a@acm.org>
 <20200824201343.GA344424@rowland.harvard.edu>
 <5152a510-bebf-bf33-f6b3-4549e50386ab@puri.sm>
 <4c636f2d-af7f-bbde-a864-dbeb67c590ec@puri.sm>
 <20200827202952.GA449067@rowland.harvard.edu>
 <478fdc57-f51e-f480-6fde-f34596394624@puri.sm>
 <20200829152635.GA498519@rowland.harvard.edu>
 <6d22ec22-a0c7-6a9d-439e-38ef87b0207c@puri.sm>
 <20200829185653.GB501978@rowland.harvard.edu>
 <eb208ee3-b94b-c020-990f-c7151ecaae03@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb208ee3-b94b-c020-990f-c7151ecaae03@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Aug 29, 2020 at 05:38:50PM -0700, Bart Van Assche wrote:
> On 2020-08-29 11:56, Alan Stern wrote:
> > A third possibility is the approach I outlined before, adding a 
> > BLK_MQ_REQ_PM flag.  But to avoid the deadlock you pointed out, I would 
> > make blk_queue_enter smarter about whether to postpone a request.  The 
> > logic would go like this:
> > 
> > 	If !blk_queue_pm_only:
> > 		Allow
> > 	If !BLK_MQ_REQ_PREEMPT:
> > 		Postpone
> > 	If q->rpm_status is RPM_ACTIVE:
> > 		Allow
> > 	If !BLK_MQ_REQ_PM:
> > 		Postpone
> > 	If q->rpm_status is RPM_SUSPENDED:
> > 		Postpone
> > 	Else:
> > 		Allow
> > 
> > The assumption here is that the PREEMPT flag is set whenever the PM flag 
> > is.
> 
> Hi Alan,
> 
> Although interesting, these solutions sound like workarounds to me. How
> about fixing the root cause by modifying the SCSI DV implementation such
> that it doesn't use scsi_device_quiesce() anymore()? That change would
> allow to remove BLK_MQ_REQ_PREEMPT / RQF_PREEMPT from the block layer and
> move these flags into the SCSI and IDE code.

That's a perfectly reasonable approach, but I have no idea how to do it.
Any suggestions?

Alan Stern

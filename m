Return-Path: <SRS0=Q1Hz=CH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F323C433E2
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Aug 2020 15:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5984C20BED
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Aug 2020 15:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgH2P0h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Aug 2020 11:26:37 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45821 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1728196AbgH2P0h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Aug 2020 11:26:37 -0400
Received: (qmail 499010 invoked by uid 1000); 29 Aug 2020 11:26:35 -0400
Date:   Sat, 29 Aug 2020 11:26:35 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, kernel@puri.sm
Subject: Re: [PATCH] block: Fix bug in runtime-resume handling
Message-ID: <20200829152635.GA498519@rowland.harvard.edu>
References: <60150284-be13-d373-5448-651b72a7c4c9@puri.sm>
 <20200810141343.GA299045@rowland.harvard.edu>
 <6f0c530f-4309-ab1e-393b-83bf8367f59e@puri.sm>
 <20200823145733.GC303967@rowland.harvard.edu>
 <3e5a465e-8fe0-b379-a80e-23e2f588c71a@acm.org>
 <20200824201343.GA344424@rowland.harvard.edu>
 <5152a510-bebf-bf33-f6b3-4549e50386ab@puri.sm>
 <4c636f2d-af7f-bbde-a864-dbeb67c590ec@puri.sm>
 <20200827202952.GA449067@rowland.harvard.edu>
 <478fdc57-f51e-f480-6fde-f34596394624@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478fdc57-f51e-f480-6fde-f34596394624@puri.sm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Aug 29, 2020 at 09:24:30AM +0200, Martin Kepplinger wrote:
> On 27.08.20 22:29, Alan Stern wrote:
> > Instead, look at sd_resume().  That routine calls __scsi_execute() 
> > indirectly through sd_start_stop_device(), and the only reason it does 
> > this is because the sdkp->device->manage_start_stop flag is set.  You 
> > ought to be able to clear this flag in sysfs, by writing to 
> > /sys/block/sda/device/scsi_disk/*/manage_start_stop.  If you do this 
> > before allowing the card reader to go into runtime suspend, does it then 
> > resume okay?
> 
> manage_start_stop in sysfs is 0 here.

Hmmm.  I'm wondering about something you wrote back in June 
(https://marc.info/?l=linux-scsi&m=159345778431615&w=2):

	blk_queue_enter() always - especially when sd is runtime 
	suspended and I try to mount as above - sets success to be true 
	for me, so never continues down to bkl_pm_request_resume(). All 
	I see is "PM: Removing info for No Bus:sda1".

blk_queue_enter() would always set success to be true because pm 
(derived from the BLK_MQ_REQ_PREEMPT flag) is true.  But why was the 
BLK_MQ_REQ_PREEMPT flag set?  In other words, where was 
blk_queue_enter() called from?

Can you get a stack trace (i.e., call dump_stack()) at exactly this 
point, that is, when pm is true and q->rpm_status is RPM_SUSPENDED?  Or 
do you already know the answer?

Alan Stern

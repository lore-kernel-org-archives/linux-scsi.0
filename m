Return-Path: <SRS0=xqUt=CC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CC0C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 20:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 300032072D
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 20:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgHXUNq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 16:13:46 -0400
Received: from netrider.rowland.org ([192.131.102.5]:59161 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1725946AbgHXUNp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2020 16:13:45 -0400
Received: (qmail 345249 invoked by uid 1000); 24 Aug 2020 16:13:43 -0400
Date:   Mon, 24 Aug 2020 16:13:43 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, kernel@puri.sm
Subject: Re: [PATCH] block: Fix bug in runtime-resume handling
Message-ID: <20200824201343.GA344424@rowland.harvard.edu>
References: <20200807143002.GE226516@rowland.harvard.edu>
 <b0abab28-880e-4b88-eb3c-9ffd927d1ed9@puri.sm>
 <20200808150542.GB256751@rowland.harvard.edu>
 <d3b6f7b8-5345-1ae1-4f79-5dde226e74f1@puri.sm>
 <20200809152643.GA277165@rowland.harvard.edu>
 <60150284-be13-d373-5448-651b72a7c4c9@puri.sm>
 <20200810141343.GA299045@rowland.harvard.edu>
 <6f0c530f-4309-ab1e-393b-83bf8367f59e@puri.sm>
 <20200823145733.GC303967@rowland.harvard.edu>
 <3e5a465e-8fe0-b379-a80e-23e2f588c71a@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e5a465e-8fe0-b379-a80e-23e2f588c71a@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 24, 2020 at 10:48:32AM -0700, Bart Van Assche wrote:
> On 2020-08-23 07:57, Alan Stern wrote:
> > The problem is fixed by checking that the queue's runtime-PM status
> > isn't RPM_SUSPENDED before allowing a request to be issued, [ ... ]
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> 
> Can, can you help with testing this patch?
> 
> Thanks,
> 
> Bart.

Martin:

(I forgot to ask this question several weeks ago, while you were running 
your tests.  Better ask it now before I forget again...)

I suspect the old runtime-PM code in the block layer would have worked 
okay in your SD cardreader test if the BLK_MQ_REQ_PREEMPT flag had not 
been set.  Do you know why the flag was set, or what line of code caused 
it to be set?

As I recall, the request that failed was a read-ahead.  It's not clear 
to me why such a request would need to have BLK_MQ_REQ_PREEMPT set.  
Although there may be other reasons for having that flag, at this point 
we're concerned with requests that are part of the runtime-resume 
procedure.  A read-ahead does not fall into that category.

Do you think you can find the answer?  Perhaps we should add a separate 
BLK_MQ_REQ_PM flag.

Alan Stern

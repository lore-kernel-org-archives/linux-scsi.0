From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH] SCSI: don't do bogus retries
Date: Tue, 30 Sep 2008 11:41:06 -0400 (EDT)
Message-ID: <20080930.114106.74753887.k-ueda@ct.jp.nec.com>
References: <Pine.LNX.4.44L0.0809291711440.4420-100000@iolanthe.rowland.org>
	<20080930.101418.74753689.k-ueda@ct.jp.nec.com>
	<1222785998.3232.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51265 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbYI3Pot (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2008 11:44:49 -0400
In-Reply-To: <1222785998.3232.23.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com
Cc: stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, k-ueda@ct.jp.nec.com

Hi James, Jens,

On Tue, 30 Sep 2008 09:46:38 -0500, James Bottomley wrote:
> On Tue, 2008-09-30 at 10:14 -0400, Kiyoshi Ueda wrote:
> > I think you should use blk_end_request(req, -EIO, blk_rq_bytes(rq))
> > here instead of end_dequeued_request(req, -EIO).
> > 
> > end_dequeued_request() needs to be called with queue lock held,
> > but I can't see any queue lock in your patches.
> > Also, if you add the queue lock and still use end_dequeued_request(),
> > __end_that_request_first(), which completes BIOs in the request,
> > is called with the queue lock held, though it doesn't require queue
> > lock actually.  So that might cause some performance regressions.
> 
> Yes, I was just getting around to noticing this.  Several other issues
> spring immediately to mind
> 
>      1. Why are there both end_dequeued_request and end_queued_request?
>         They both (by design since we tried to make the end cases the
>         same) do the same thing

They originally differed a little bit, but when blk_end_request
interfaces were introduced, they became exactly same:
    http://marc.info/?t=120008891100007&r=1&w=2

So I tried to kill them:
    http://marc.info/?t=120008891100007&r=1&w=2
But Jens suggested keep them for a while at the time.

Is it the time now to kill them, Jens?

Thanks,
Kiyoshi Ueda

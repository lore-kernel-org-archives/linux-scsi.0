From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: don't do bogus retries
Date: Tue, 30 Sep 2008 09:46:38 -0500
Message-ID: <1222785998.3232.23.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0809291711440.4420-100000@iolanthe.rowland.org>
	 <20080930.101418.74753689.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57575 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301AbYI3OrH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2008 10:47:07 -0400
In-Reply-To: <20080930.101418.74753689.k-ueda@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: stern@rowland.harvard.edu, linux-scsi@vger.kernel.org

On Tue, 2008-09-30 at 10:14 -0400, Kiyoshi Ueda wrote:
> I think you should use blk_end_request(req, -EIO, blk_rq_bytes(rq))
> here instead of end_dequeued_request(req, -EIO).
> 
> end_dequeued_request() needs to be called with queue lock held,
> but I can't see any queue lock in your patches.
> Also, if you add the queue lock and still use end_dequeued_request(),
> __end_that_request_first(), which completes BIOs in the request,
> is called with the queue lock held, though it doesn't require queue
> lock actually.  So that might cause some performance regressions.

Yes, I was just getting around to noticing this.  Several other issues
spring immediately to mind

     1. Why are there both end_dequeued_request and end_queued_request?
        They both (by design since we tried to make the end cases the
        same) do the same thing
     2. Why don't they follow the block naming convention (they should
        begin blk_rq_ to indicate they're functions in block and act on
        requests).
     3. The block convention is for unlocked variants to be preceded by
        two underscores (although not universally adhered to).

James



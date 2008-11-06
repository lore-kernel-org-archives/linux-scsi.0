From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Problems with the block-layer timeouts
Date: Thu, 6 Nov 2008 09:01:09 +0900
Message-ID: <20081106090117U.fujita.tomonori@lab.ntt.co.jp>
References: <Pine.LNX.4.44L0.0811011214470.21703-100000@netrider.rowland.org>
	<20081103085247.GO31673@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:34861 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbYKFABr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Nov 2008 19:01:47 -0500
In-Reply-To: <20081103085247.GO31673@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: stern@rowland.harvard.edu, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 3 Nov 2008 09:52:48 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> > In blk_del_timer(), there's no reason to test q->rq_timed_out_fn.  If 
> > the method pointer is NULL then req->deadline would be 0 anyway.  In 
> > addition, req->deadline should be set to 0 and the end of the routine, 
> > just in case req gets requeued.
> > 
> > In blk_add_timer(), the line
> > 
> > 	expiry = round_jiffies(req->deadline);
> > 
> > is not optimal.  round_jiffies() will sometimes round a value _down_ to
> > the nearest second.  But blk_rq_timed_out_timer() tests whether
> > req->deadline is in the past -- and if the deadline was rounded down
> > then this won't be true the first time through.  You wind up getting an
> > unnecessary timer interrupt.  Instead there should be a
> > round_jiffies_up() utility routine, and it should be used in both
> > blk_add_timer() and blk_rq_timed_out_timer().
> 
> Very good point, we do indeed want a round_jiffies_up() for this!

Just out of curiosity, why do we need to use round_jiffies here? We
didn't do that for SCSI, right?

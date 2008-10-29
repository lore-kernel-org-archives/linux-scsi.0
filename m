From: malahal@us.ibm.com
Subject: Re: [PATCH] block: optimizations in blk_rq_timed_out_timer()
Date: Wed, 29 Oct 2008 11:21:04 -0700
Message-ID: <20081029182104.GA543@us.ibm.com>
References: <20081028182243.GA6716@us.ibm.com> <20081029130656G.fujita.tomonori@lab.ntt.co.jp> <20081029060625.GA5080@us.ibm.com> <20081029132614.GD31673@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:39667 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbYJ2SVU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2008 14:21:20 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id m9TIKdc0011222
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 12:20:39 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9TIL8Gv059848
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 12:21:09 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9TIL78S031794
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 12:21:08 -0600
Content-Disposition: inline
In-Reply-To: <20081029132614.GD31673@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

Jens Axboe [jens.axboe@oracle.com] wrote:
> > Yes, we should not access it although I don't think the request can be
> > freed while the existing code is accessing the deadline field. What 
> > likely can happen is that we may call mod_timer with jiffies that is
> > older than current which would call the timer immediately...
> 
> That would not call the timer immediately, that will not call it until
> jiffies reaches that value again. So you're looking at a minimum of 49
> days :-)

I remember the timer code treating "past" expiry times as special. If
not, then we have a real bug! It is also hard to guarantee in
blk_rq_timed_out_timer() that we always call mod_timer with future
expiry time!

--Malahal.

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] block: optimizations in blk_rq_timed_out_timer()
Date: Thu, 30 Oct 2008 17:29:25 +0900
Message-ID: <20081030172918Z.fujita.tomonori@lab.ntt.co.jp>
References: <20081029060625.GA5080@us.ibm.com>
	<20081030113309R.fujita.tomonori@lab.ntt.co.jp>
	<20081030074907.GN31673@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46295 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbYJ3I3m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2008 04:29:42 -0400
In-Reply-To: <20081030074907.GN31673@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, malahal@us.ibm.com, linux-scsi@vger.kernel.org

On Thu, 30 Oct 2008 08:49:07 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> > > What 
> > > likely can happen is that we may call mod_timer with jiffies that is
> > > older than current which would call the timer immediately...
> > 
> > Yeah, I think that the timer is called immediately here. It's
> > unnecessary.
> 
> Hmm, just checked the code, and indeed it does. Have the timers always
> behaved like that?

I guess so because it's unrealistic that the caller of mod_time makes
sure that expires is future time, in particular if the caller wants
short timeout?

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: optimizations in blk_rq_timed_out_timer()
Date: Thu, 30 Oct 2008 09:55:20 +0100
Message-ID: <20081030085520.GP31673@kernel.dk>
References: <20081029060625.GA5080@us.ibm.com> <20081030113309R.fujita.tomonori@lab.ntt.co.jp> <20081030074907.GN31673@kernel.dk> <20081030172918Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:45372 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbYJ3I4c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2008 04:56:32 -0400
Content-Disposition: inline
In-Reply-To: <20081030172918Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: malahal@us.ibm.com, linux-scsi@vger.kernel.org

On Thu, Oct 30 2008, FUJITA Tomonori wrote:
> On Thu, 30 Oct 2008 08:49:07 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > > > What 
> > > > likely can happen is that we may call mod_timer with jiffies that is
> > > > older than current which would call the timer immediately...
> > > 
> > > Yeah, I think that the timer is called immediately here. It's
> > > unnecessary.
> > 
> > Hmm, just checked the code, and indeed it does. Have the timers always
> > behaved like that?
> 
> I guess so because it's unrealistic that the caller of mod_time makes
> sure that expires is future time, in particular if the caller wants
> short timeout?

It's all a little confusing, I think. When do you stop considering it a
little in the past and long into the future?

-- 
Jens Axboe


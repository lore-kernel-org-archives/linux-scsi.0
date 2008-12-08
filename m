From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Correctly release and allocate a new request on TUR	retries
Date: Mon, 8 Dec 2008 14:29:08 +0100
Message-ID: <20081208132908.GA23742@kernel.dk>
References: <49393C88.8080103@hp.com> <20081205144954.GO18255@kernel.dk> <20081205180851.GA9671@linux.vnet.ibm.com> <493D1DE2.5090907@hp.com> <20081208132058.GB18255@kernel.dk> <493D2042.6030800@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:13532 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbYLHN3V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Dec 2008 08:29:21 -0500
Content-Disposition: inline
In-Reply-To: <493D2042.6030800@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, James.Bottomley@HansenPartnership.com

On Mon, Dec 08 2008, Alan D. Brunelle wrote:
> Jens Axboe wrote:
> > On Mon, Dec 08 2008, Alan D. Brunelle wrote:
> >> Mike Anderson wrote:
> >>> Jens Axboe <jens.axboe@oracle.com> wrote:
> >>>> On Fri, Dec 05 2008, Alan D. Brunelle wrote:
> >>>>> Commands needing to be retried (TUR in this case) would result in a block
> >>>>> I/O request being re-used, without being re-initialized properly. This
> >>>>> patch ensures that the requests are correctly re-initialized via
> >>>>> standard allocation means.
> >>>>>
> >>>>> Prior to this patch, boots were failing consistently as in:
> >>>>> http://lkml.org/lkml/2008/12/5/161
> >>>>>
> >>>>> With this patch in place, the system is booting reliably.
> >>>>>
> >>>>> Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
> >>>>> Cc: Jens Axboe <jens.axboe@oracle.com>
> >>>> Looks good.
> >>>>
> >>>> Acked-by: Jens Axboe <jens.axboe@oracle.com>
> >>>>
> >>>> Perhaps James can push it in, I'm about to shutdown for the day...
> >>>>
> >>> I know a failure was not detected in the hp_sw_start_stop function, but it
> >>> uses the same retry method as hp_sw_tur we should update this function
> >>> also.
> >>>
> >>> I made a quick scope of callers of blk_get_request and I did not see a
> >>> repeated of this retry usage model. I will make another pass to see if I
> >>> missed something.
> >> drivers/cdrom/cdrom.c:cdrom_read_cdda_bpc() is even worse: it gets one
> >> request, then sits in a while loop re-using the same request over and
> >> over again.
> > 
> > Sigh, it does indeed look messy...
> > 
> >> Since blk_rq_init() is an exported symbol, perhaps instead of having the
> >> three callers realloc, it _may_ be sufficient to just have them call
> >> that before re-use? (See attached un-tested patch for an example.)
> > 
> > I think that's a really bad idea, since it basically just clears the
> > 'rq'. If you have that rq on some list (timeout, for instance), the
> > kernel will not be happy. I think we have to, for now at least, put and
> > get a request before looping. Then for 2.6.29 we can hopefully improve
> > this situation!
> 
> OK, I'll work that one up for 2.6.28 and test it out this morning.

Thanks Alan, if do you that and confirm that it works with your hw
handler problem at least, then I'll get it upstream asap.

-- 
Jens Axboe


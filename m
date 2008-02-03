From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND number 2] libata: eliminate the home grown dma
	padding in favour of that provided by the block layer
Date: Sat, 02 Feb 2008 22:32:54 -0600
Message-ID: <1202013174.3187.69.camel@localhost.localdomain>
References: <1199138168.3110.12.camel@localhost.localdomain>
	 <1200698057.3111.68.camel@localhost.localdomain>
	 <1201894847.3134.59.camel@localhost.localdomain>
	 <47A37AF3.3030503@garzik.org>
	 <1201900175.3134.67.camel@localhost.localdomain> <47A52F23.70506@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60942 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856AbYBCEdB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Feb 2008 23:33:01 -0500
In-Reply-To: <47A52F23.70506@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>


On Sun, 2008-02-03 at 12:04 +0900, Tejun Heo wrote:
> James Bottomley wrote:
> > On Fri, 2008-02-01 at 15:02 -0500, Jeff Garzik wrote:
> >> James Bottomley wrote:
> >>> Could we please get this in ... I thought I mentioned several times that
> >>> it fixes a fatal oops in both aic94xx and ipr.
> >> Tejun has a persistent objection...  see other email.
> > 
> > Actually, see other email .. I meant that this patch (eliminate dma
> > padding) is independent of the drain one.
> 
> Sorry about the delay.
> 
> There's a problem here.  For the blk layer dma padding itself, it's okay
> but the problem is that it blocks the pending draining patch without
> supplying usable alternative at the moment.

The alternative is already there.  The current drain infrastructure is
already in the block layer.  The patch I sent merely activates it for
ATA.  Is there some issue with this that I haven't forseen?  My analysis
is that it should do everything your patch does (except at the block
layer and in a manner that doesn't trigger the aic94xx panic).

>   I agree that the long term
> solution should be in the block layer && I understand that it causes
> problem for SAS controllers but for the moment if we don't include the
> existing draining patch, far more ATAPI devices are affected.  So, it's
> catch-22 situation.
> 
> I think the best solution is to update block layer draining such that it
> can be included together before the merge window closes.  I'll dig into it.

Like I said, the block layer pieces are already upstream.  All we need
is the ATA bits and I think it should all work ... unless there's some
part I haven't though of?

James



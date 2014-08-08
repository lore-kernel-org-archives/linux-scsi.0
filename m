From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/1] dpt_i2o: delete unnecessary null test on array
Date: Fri, 8 Aug 2014 19:16:52 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1408081916280.2348@hadrien>
References: <1407321551-27479-1-git-send-email-Julia.Lawall@lip6.fr>   <1407321551-27479-2-git-send-email-Julia.Lawall@lip6.fr>  <1407517179.2044.13.camel@jarvis.lan>  <alpine.DEB.2.10.1408081902400.2348@hadrien>
 <1407518045.1686.0.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:20968
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978AbaHHRRW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2014 13:17:22 -0400
In-Reply-To: <1407518045.1686.0.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, joe@perches.com

On Fri, 8 Aug 2014, James Bottomley wrote:

> On Fri, 2014-08-08 at 19:03 +0200, Julia Lawall wrote:
> > > > diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> > > > index 67283ef..62e276b 100644
> > > > --- a/drivers/scsi/dpt_i2o.c
> > > > +++ b/drivers/scsi/dpt_i2o.c
> > > > @@ -1169,11 +1169,6 @@ static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u6
> > > >  	if(chan < 0 || chan >= MAX_CHANNEL)
> > > >  		return NULL;
> > > >
> > > > -	if( pHba->channel[chan].device == NULL){
> > > > -		printk(KERN_DEBUG"Adaptec I2O RAID: Trying to find device before they are allocated\n");
> > > > -		return NULL;
> > > > -	}
> > >
> > > dpt_i2o is always weirdly fun, but I think, based on the message, this
> > > check is supposed to be
> > >
> > > if( pHba->channel[chan].device[id] == NULL){
> > >
> > > Since device is an array of device pointers which are allocated by
> > > parsing data.
> >
> > That seems to be already checked immediately below:
> >
> >         d = pHba->channel[chan].device[id];
> > 	if(!d || d->tid == 0) {
> >                 return NULL;
>
> Yes, I know, but no message is emitted.  The message seems to be for a
> violation of the state machine which device[id] = NULL implies.

OK, if the message seems helpful, then I can split up the tests.

julia

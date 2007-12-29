From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] libsas: add host SMP processing
Date: Sun, 30 Dec 2007 01:06:34 +0900
Message-ID: <20071230010931H.tomof@acm.org>
References: <1198884998.3174.5.camel@localhost.localdomain>
	<200712290524.lBT5Ot2u004870@mbox.iij4u.or.jp>
	<1198943072.3264.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:36282 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843AbXL2QGn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Dec 2007 11:06:43 -0500
In-Reply-To: <1198943072.3264.23.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: tomof@acm.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jpfujita.tomonori@lab.ntt.co.jp

On Sat, 29 Dec 2007 09:44:32 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Sat, 2007-12-29 at 14:24 +0900, FUJITA Tomonori wrote:
> > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > --- a/drivers/scsi/libsas/sas_expander.c
> > > +++ b/drivers/scsi/libsas/sas_expander.c
> > > @@ -1896,11 +1896,9 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
> > >  	}
> > >  
> > >  	/* no rphy means no smp target support (ie aic94xx host) */
> > > -	if (!rphy) {
> > > -		printk("%s: can we send a smp request to a host?\n",
> > > -		       __FUNCTION__);
> > > -		return -EINVAL;
> > > -	}
> > > +	if (!rphy)
> > > +		return sas_smp_host_handler(shost, req, rsp);
> > > +
> > 
> > I have one related question.
> > 
> > Currently, bsg doesn't return an error to user space since I had no
> > idea how to convert errors such as EINVAL and ENOMEM into
> > driver_status, transport_status, and device_status in struct sg_io_v4.
> > I think that it's confusing that bsg don't return an error even if SMP
> > requests aren't sent (e.g. devices are offline).
> > 
> > Do we need to map errors to the current error code in scsi/scsi.h
> > (like DID_*) or define a new one for SMP?
> 
> Neither, I think ... the DID codes are only for things that actually
> pass through the SCSI stack.  The way you implemented the smp functions
> in bsg, they're direct queue handlers themselves (Incidentally, that's
> another point about this: I think almost every use of bsg like this is
> going to be for SG_IO only, so it makes sense to move the actual queue
> handler into bsg, since they'll all share it).
> 
> The attached is the simplest patch that implements this.  However, it
> unfortunately can't be applied yet ... the current SMP tools send
> receive buffers too large and libsas actually returns a data underrun
> error (which is now propagated).

bsg read/write interface doens't return errors in this way (compatible
with sg3 read/write interface). If we support only SG_IO for non SCSI
request/response protocols, then that's fine.

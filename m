From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] libsas: add host SMP processing
Date: Sun, 30 Dec 2007 15:07:07 +0900
Message-ID: <200712300607.lBU677Sh022731@mbox.iij4u.or.jp>
References: <1198943072.3264.23.camel@localhost.localdomain>
	<20071230010931H.tomof@acm.org>
	<1198947594.3264.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:58852 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbXL3GKY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Dec 2007 01:10:24 -0500
In-Reply-To: <1198947594.3264.31.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: tomof@acm.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jpfujita.tomonori@lab.ntt.co.jp

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] libsas: add host SMP processing
Date: Sat, 29 Dec 2007 10:59:53 -0600

> 
> On Sun, 2007-12-30 at 01:06 +0900, FUJITA Tomonori wrote:
> > On Sat, 29 Dec 2007 09:44:32 -0600
> > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > On Sat, 2007-12-29 at 14:24 +0900, FUJITA Tomonori wrote:
> > > > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > > > --- a/drivers/scsi/libsas/sas_expander.c
> > > > > +++ b/drivers/scsi/libsas/sas_expander.c
> > > > > @@ -1896,11 +1896,9 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
> > > > >  	}
> > > > >  
> > > > >  	/* no rphy means no smp target support (ie aic94xx host) */
> > > > > -	if (!rphy) {
> > > > > -		printk("%s: can we send a smp request to a host?\n",
> > > > > -		       __FUNCTION__);
> > > > > -		return -EINVAL;
> > > > > -	}
> > > > > +	if (!rphy)
> > > > > +		return sas_smp_host_handler(shost, req, rsp);
> > > > > +
> > > > 
> > > > I have one related question.
> > > > 
> > > > Currently, bsg doesn't return an error to user space since I had no
> > > > idea how to convert errors such as EINVAL and ENOMEM into
> > > > driver_status, transport_status, and device_status in struct sg_io_v4.
> > > > I think that it's confusing that bsg don't return an error even if SMP
> > > > requests aren't sent (e.g. devices are offline).
> > > > 
> > > > Do we need to map errors to the current error code in scsi/scsi.h
> > > > (like DID_*) or define a new one for SMP?
> > > 
> > > Neither, I think ... the DID codes are only for things that actually
> > > pass through the SCSI stack.  The way you implemented the smp functions
> > > in bsg, they're direct queue handlers themselves (Incidentally, that's
> > > another point about this: I think almost every use of bsg like this is
> > > going to be for SG_IO only, so it makes sense to move the actual queue
> > > handler into bsg, since they'll all share it).
> > > 
> > > The attached is the simplest patch that implements this.  However, it
> > > unfortunately can't be applied yet ... the current SMP tools send
> > > receive buffers too large and libsas actually returns a data underrun
> > > error (which is now propagated).
> > 
> > bsg read/write interface doens't return errors in this way (compatible
> > with sg3 read/write interface). If we support only SG_IO for non SCSI
> > request/response protocols, then that's fine.
> 
> OK, guilty of disliking the read/write interface (and therefore not
> thinking about it).  However, it's easy to fix.  How about this?  Note,
> I think returning errors when they occur is more important than
> preserving compatibility and swallowing the error somewhere, especially
> as the bsg v3 interface *only* dealt with SCSI, so this is more like an
> extension to non-scsi error returning.

Oops, I remember wrongly. I've just realized that sgv3 returns errors
in this way (that is, returns negative values) though bsg doesn't (I
guess Jens did that because bsg read/write interface handle multiple
request/responses). There isn't the compatibility issue.

The patch looks fine.

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>


>  But if I'd had my way, bsg
> wouldn't have had a read/write interface, so I'm happy to do whatever
> people who actually use it want.

I don't like the read/write interface much but OSD people need an
efficient interface to perform SCSI commands (the interface should to
handle multiple requests/response at a time and work
asynchronously). Some of them seem to use bsg read/write interface. So
I guess that we to invent a substitute to kill the read/write
interface.

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: ses: fix VPD inquiry overrun
Date: Wed, 30 Jul 2008 09:53:04 -0500
Message-ID: <1217429584.3335.0.camel@localhost.localdomain>
References: <1217349505.6103.15.camel@localhost.localdomain>
	 <48903800.7000008@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51376 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752615AbYG3OxI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2008 10:53:08 -0400
In-Reply-To: <48903800.7000008@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2008-07-30 at 12:44 +0300, Boaz Harrosh wrote:
> James Bottomley wrote:
> > There are a few kerneloops.org reports like this one:
> > 
> > http://www.kerneloops.org/search.php?search=ses_match_to_enclosure
> > 
> > That seem to imply we're running off the end of the VPD inquiry data
> > (although at 512 bytes, it should be long enough for just about
> > anything).  we should be using correctly sized buffers anyway, so put
> > those in and hope this oops goes away.
> > 
> > James
> > 
> > ---
> > 
> > diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> > index 0fe031f..f2d89be 100644
> > --- a/drivers/scsi/ses.c
> > +++ b/drivers/scsi/ses.c
> > @@ -345,14 +345,14 @@ static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
> >  	return 0;
> >  }
> >  
> > -#define VPD_INQUIRY_SIZE 512
> > +#define VPD_INQUIRY_SIZE 36
> >  
> >  static void ses_match_to_enclosure(struct enclosure_device *edev,
> >  				   struct scsi_device *sdev)
> >  {
> >  	unsigned char *buf = kmalloc(VPD_INQUIRY_SIZE, GFP_KERNEL);
> >  	unsigned char *desc;
> > -	int len;
> > +	u16 vpd_len;
> >  	struct efd efd = {
> >  		.addr = 0,
> >  	};
> > @@ -372,9 +372,19 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
> >  			     VPD_INQUIRY_SIZE, NULL, SES_TIMEOUT, SES_RETRIES))
> >  		goto free;
> >  
> > -	len = (buf[2] << 8) + buf[3];
> > +	vpd_len = (buf[2] << 8) + buf[3];
> 
> +	vpd_len = get_unaligned_be16(&buf[2]);

Not at the moment.  Matthew had a patch to add the necessary scsi
wrappers (including the missing 24 bit one) to replace our current u32
one.

But that goes after this, and this will be a backport.

James



From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] zfcp: Test kmalloc failure in scsi_get_vpd_page()
Date: Wed, 04 Nov 2009 09:09:20 -0600
Message-ID: <1257347360.2697.20.camel@mulgrave.site>
References: <4A92BE18.50208@gmail.com>
	 <1251416731.27356.8.camel@mulgrave.site>  <4A9A6676.8050304@panasas.com>
	 <1251642902.10135.4.camel@mulgrave.site>
	 <1257273187.9427.22.camel@mulgrave.site>  <4AF14147.4050102@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755792AbZKDPJY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Nov 2009 10:09:24 -0500
In-Reply-To: <4AF14147.4050102@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Roel Kluin <roel.kluin@gmail.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Wed, 2009-11-04 at 10:54 +0200, Boaz Harrosh wrote:
> On 11/03/2009 08:33 PM, James Bottomley wrote:
> > On Sun, 2009-08-30 at 09:35 -0500, James Bottomley wrote:
> >> On Sun, 2009-08-30 at 14:45 +0300, Boaz Harrosh wrote:
> >>> On 08/28/2009 02:45 AM, James Bottomley wrote:
> >>>> On Mon, 2009-08-24 at 18:21 +0200, Roel Kluin wrote:
> >>>>> kmalloc() may fail, so test whether it succeeded.
> >>>>>
> >>>>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> >>>>> ---
> >>>>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> >>>>> index 2de5f3a..34fdde0 100644
> >>>>> --- a/drivers/scsi/scsi.c
> >>>>> +++ b/drivers/scsi/scsi.c
> >>>>> @@ -1056,6 +1056,9 @@ unsigned char *scsi_get_vpd_page(struct scsi_device *sdev, u8 page)
> >>>>>  
> >>>>>  	kfree(buf);
> >>>>>  	buf = kmalloc(len + 4, GFP_KERNEL);
> >>>>> +	if (!buf)
> >>>>> +		return NULL;
> >>>>> +
> >>>>
> >>>> Firstly, this won't actually apply ... you should be developing against
> >>>> either the SCSI trees or linux-next to get the latest versions in git.
> >>>>
> >>>> Secondly it's not really right for the most common use cases, which
> >>>> don't usually want the whole vpd buffer anyway.  I don't really see a
> >>>> simple way of fixing it without altering the interface, though.
> >>>>
> >>>
> >>> "most common use cases" do not have pages bigger then 255. Can you think
> >>> of any? For these few places that anticipate pages bigger then 255 I don't
> >>> see much choice, we just freed 255 bytes and tried a new size, say 317, which
> >>> failed with GFP_KERNEL, In such a busy system, better fail with NULL then BUG,
> >>> No? In any way caller must check for NULL because of the first allocation.
> >>
> >> Other way around: common use cases means the callers.  What I'm saying
> >> is that regardless of the size of the VPD page, the caller usually only
> >> wants a few bytes into it.  Once we have all the information the caller
> >> ever needs, there's no point in trying again with a larger buffer just
> >> because the VPD page is larger ... to code this into the interface,
> >> though, the caller would need to specify the max length it is looking
> >> for.
> > 
> > OK, it's been a couple of months and  no patch has been forthcoming on
> > this, so how about the attached?  It does the query and only adjusts the
> > size where the caller actually wants to bother.
> > 
> > James
> > 
> > ---
> > 
> > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > index a60da55..513661f 100644
> > --- a/drivers/scsi/scsi.c
> > +++ b/drivers/scsi/scsi.c
> > @@ -1026,55 +1026,39 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
> >   * responsible for calling kfree() on this pointer when it is no longer
> >   * needed.  If we cannot retrieve the VPD page this routine returns %NULL.
> >   */
> 
> The comment is wrong now, I would also say something about buf_len is recommended
> to be 255 or more since other wise we might miss out on pages in the first inquiry.

Will fix.

> > -unsigned char *scsi_get_vpd_page(struct scsi_device *sdev, u8 page)
> > +int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
> > +		      int buf_len)
> >  {
> >  	int i, result;
> > -	unsigned int len;
> > -	const unsigned int init_vpd_len = 255;
> > -	unsigned char *buf = kmalloc(init_vpd_len, GFP_KERNEL);
> > -
> > -	if (!buf)
> > -		return NULL;
> >  
> >  	/* Ask for all the pages supported by this device */
> > -	result = scsi_vpd_inquiry(sdev, buf, 0, init_vpd_len);
> > +	result = scsi_vpd_inquiry(sdev, buf, 0, buf_len);
> >  	if (result)
> >  		goto fail;
> >  
> >  	/* If the user actually wanted this page, we can skip the rest */
> >  	if (page == 0)
> > -		return buf;
> > +		return -EINVAL;
> >  
> 
> Why -EINVAL; Look at the comment above, return 0 would be better.

Bug in code (well spotted), will fix.

> > -	for (i = 0; i < buf[3]; i++)
> > +	for (i = 0; i < min((int)buf[3], buf_len - 4); i++)
> >  		if (buf[i + 4] == page)
> >  			goto found;
> > +
> > +	if (i < buf[3] && i > buf_len)
> > +		/* ran off the end of the buffer, give us benefit of doubt */
> > +		goto found;
> 
> Some cheep devices are known to break when asked for pages they do not support
> better return an -ETOOSMALL the user can check for. (And the comment above should
> also take care of it)

OK, so I struggled with this.  The reason for the behaviour is  that
only USB devices with incredibly small page lists are likely to exhibit
the problem.  Whereas the page lists in array type devices are likely to
grow.  I don't want to run into the situation that your new $10m array
suddenly gives an error with DIF/DIX because the page list is too big
and the problem this is checking for only afflicts cheap and badly
implemented HW.

> >  	/* The device claims it doesn't support the requested page */
> >  	goto fail;
> >  
> >   found:
> > -	result = scsi_vpd_inquiry(sdev, buf, page, 255);
> > +	result = scsi_vpd_inquiry(sdev, buf, page, buf_len);
> >  	if (result)
> >  		goto fail;
> >  
> > -	/*
> > -	 * Some pages are longer than 255 bytes.  The actual length of
> > -	 * the page is returned in the header.
> > -	 */
> > -	len = ((buf[2] << 8) | buf[3]) + 4;
> > -	if (len <= init_vpd_len)
> > -		return buf;
> > -
> > -	kfree(buf);
> > -	buf = kmalloc(len, GFP_KERNEL);
> > -	result = scsi_vpd_inquiry(sdev, buf, page, len);
> > -	if (result)
> > -		goto fail;
> > -
> > -	return buf;
> > +	return 0;
> >  
> >   fail:
> > -	kfree(buf);
> > -	return NULL;
> > +	return -EINVAL;
> 
> why -EINVAL? should we not return result, as received from scsi_vpd_inquiry?

Yes, was in two minds about that.  Since zero is success, we can return
result easily ... I just like the idea of negative error numbers.

> >  }
> >  EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
> >  
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index 9093c72..fd1bd8f 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -1864,19 +1864,20 @@ void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
> >  static void sd_read_block_limits(struct scsi_disk *sdkp)
> >  {
> >  	unsigned int sector_sz = sdkp->device->sector_size;
> > -	char *buffer;
> > +	const int vpd_len = 32;
> > +	unsigned char *buffer = kmalloc(vpd_len, GFP_KERNEL);
> >  
> 
> 32 sounds two small for me. Not because of the page but because of the
> first pass. Why not just 255 as a rule. We kmalloc it anyway.

It only needs 16 if you look at the code.  32 is actually the smallest
kmalloc slab on 32 bit systems.

> We used to allocate 255 here, for some devices out there this is surly
> a regression.

We did 255 because we were concerned about space for the page list ...
hopefully I answered that one above.

James



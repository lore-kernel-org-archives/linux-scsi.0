From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: [RFC] Sanitize INQUIRY vendor, product and revision strings
Date: Mon, 14 Aug 2006 13:37:09 -0400
Message-ID: <20060814173709.GJ32218@vienna.egenera.com>
References: <Pine.LNX.4.44L0.0608141221520.7399-100000@iolanthe.rowland.org> <20060814170730.GE4340@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:44978 "EHLO
	roadrunner-base.egenera.com") by vger.kernel.org with ESMTP
	id S932207AbWHNRhq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Aug 2006 13:37:46 -0400
Content-Disposition: inline
In-Reply-To: <20060814170730.GE4340@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, Klaus Muth <muth@hagos.de>


Hi,

Rumor has it that on Mon, Aug 14, 2006 at 11:07:31AM -0600 Matthew Wilcox said:
> On Mon, Aug 14, 2006 at 12:34:56PM -0400, Alan Stern wrote:
> > Does anyone object to the patch below?  It would help at least one person; 
> > I'm concerned that it might cause trouble somewhere else.
> 
> > @@ -526,6 +519,12 @@ static int scsi_probe_lun(struct scsi_de
> >  		if (response_len > 255)
> >  			response_len = first_inquiry_len;	/* sanity */
> >  
> > +		/* Sanitize the Vendor, Product, and Revision fields. */
> > +		for (i = 8; i < 36; ++i) {
> > +			if (inq_result[i] < 0x20 || inq_result[i] > 0x7e)
> > +				inq_result[i] = ' ';
> > +		}
> > +
> >  		/*
> 
> If we have one non-printable character, should we not overwrite all
> subsequent characters with spaces?  I'm concerned that they may
> NUL-terminate a string, then the remnants be garbage.  

I wouldn't make an exception for NUL. Trying to guess that the device 
vendor really meant to NUL-terminate does not seem right to me. 
Plus it will hide out of spec devices more than "spacing" unprintable 
characters.

...

> This of course begs the questions:
>  - Do we want to mangle the inquiry return like this?
>  - Should we simply copy out the strings from the raw inquiry result, and
>    fix them at copy time

This is probably better, at the expense of some space though. 


FWIW,


Phil



-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Software Architect                            165 Forest St.
(508) 858-2628                            Marlboro, MA 01752

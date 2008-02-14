From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] SCSI: fix data corruption caused by ses
Date: Wed, 13 Feb 2008 16:07:59 -0800
Message-ID: <200802131608.00493.yinghai.lu@sun.com>
References: <200802090413.53275.yinghai.lu@sun.com>
 <200802122310.23050.yinghai.lu@sun.com>
 <1202945127.3109.89.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38193 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043AbYBMXsD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2008 18:48:03 -0500
In-reply-to: <1202945127.3109.89.camel@localhost.localdomain>
Content-disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, kristen.c.accardi@intel.com, Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>

On Wednesday 13 February 2008 03:25:27 pm James Bottomley wrote:
> On Tue, 2008-02-12 at 23:10 -0800, Yinghai Lu wrote:
> >  			if (type_ptr[0] != ENCLOSURE_COMPONENT_DEVICE &&
> >  			    type_ptr[0] != ENCLOSURE_COMPONENT_ARRAY_DEVICE)
> > -				continue;
> > +				goto next;
> > +
> >  			ecomp =	enclosure_component_register(edev,
> >  							     components++,
> >  							     type_ptr[0],
> >  							     name);
> > +
> > +			if (desc_ptr && !IS_ERR(ecomp) && addl_desc_ptr)
> > +				ses_process_descriptor(ecomp,
> > +						       addl_desc_ptr);
> > +		next:
> >  			if (desc_ptr) {
> >  				desc_ptr += len;
> > -				if (!IS_ERR(ecomp))
> > -					ses_process_descriptor(ecomp,
> > -							       addl_desc_ptr);
> >  
> >  				if (addl_desc_ptr)
> >  					addl_desc_ptr += addl_desc_ptr[1] + 2;
> 
> Everything looks fine, thanks, except this piece.
> 
> That 
> 
> if (x)
>      goto next;
> ...
> next:
> 
> Needs to be
> 
> if (!x) {
>    ...
> }
> 

find other problems about sub_enclosure...

will send you updated one.

YH

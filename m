From: "Smart, James" <James.Smart@Emulex.Com>
Subject: RE: [Emulex] Ready for next round... (log function)
Date: Fri, 18 Jun 2004 11:38:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28034F9526@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33752 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S265212AbUFRPib
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2004 11:38:31 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

Christoph,

Can you be more specific than "it's horrible" ?

The api we essentially have is :
  lpfc_printf_log(ha, level, mask, fmt, arg...) and this uses the
dev_info/warn/err defines for dev_printk.

So, other than ordering, the only difference we have is the "mask" element.
This element lets us filter by logical function or component via a
runtime-changable flag, something our customers have asked for. In fact,
they've asked for even more detail than what is there.

Are you complaining about the implementation of lpfc_printf_log() itself vs
being a #define for dev_printk ? The only ugliness is the addition of
preambles for compatibility with what was there previously. I don't mind
removing this (and have already kicked this off).  But - is there more? The
api used throughout the driver is basically the same as the one referenced.
A small amount of code is needed just to implement a runtime filter, but
it's constrained to 1 small function.

-- James S



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, June 16, 2004 4:20 AM
> To: Smart, James
> Cc: Linux SCSI Reflector
> Subject: Re: [Emulex] Ready for next round...
> 
> 
> On Tue, Jun 15, 2004 at 01:32:56PM -0400, Smart, James wrote:
> > Comments:
> > --------------
> > [From 5/9] Re: lpfc_msg* stuff is not acceptable.
> > We've inlined the print strings and filter values. Should 
> be acceptable now.
> 
> Still quite horrible.  Please use dev_printk ala qlogic:
> 
> #define qla_printk(level, ha, format, arg...) \
>         dev_printk(level , &((ha)->pdev->dev) , format , ## arg)
> 
> 

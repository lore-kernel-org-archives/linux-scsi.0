From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [Emulex] Ready for next round... (log function)
Date: Fri, 18 Jun 2004 21:46:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040618204626.GA27095@infradead.org>
References: <3356669BBE90C448AD4645C843E2BF28034F9526@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:21700 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S263079AbUFRUq2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2004 16:46:28 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F9526@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

On Fri, Jun 18, 2004 at 11:38:19AM -0400, Smart, James wrote:
> Can you be more specific than "it's horrible" ?
> 
> The api we essentially have is :
>   lpfc_printf_log(ha, level, mask, fmt, arg...) and this uses the
> dev_info/warn/err defines for dev_printk.
> 
> So, other than ordering, the only difference we have is the "mask" element.
> This element lets us filter by logical function or component via a
> runtime-changable flag, something our customers have asked for. In fact,
> they've asked for even more detail than what is there.
> 
> Are you complaining about the implementation of lpfc_printf_log() itself vs
> being a #define for dev_printk ? The only ugliness is the addition of
> preambles for compatibility with what was there previously. I don't mind
> removing this (and have already kicked this off).  But - is there more? The
> api used throughout the driver is basically the same as the one referenced.
> A small amount of code is needed just to implement a runtime filter, but
> it's constrained to 1 small function.

lpfc_logmsg.c must die.  The whole comment mess doesn't belong into a driver
source file, it needs to go into your support handbook or whatever.
lpfc_printf_log is still far too comlicated, if you want to add your region
specifiers to it do it transparently by adding them as string constant
into the printk string.  You're far too deep into the world of overengineering
here.

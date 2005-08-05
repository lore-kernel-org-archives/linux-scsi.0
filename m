From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] uninline exported ata_host_intr
Date: Fri, 5 Aug 2005 13:10:51 -0700
Message-ID: <20050805131051.54f333dc.akpm@osdl.org>
References: <42F39DA0.5000208@pobox.com>
	<200508051737.j75Hb4s9008109@falcon30.maxeymade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:28624 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S263120AbVHEUP3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2005 16:15:29 -0400
In-Reply-To: <200508051737.j75Hb4s9008109@falcon30.maxeymade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@maxeymade.com>
Cc: jgarzik@pobox.com, olh@suse.de, linux-scsi@vger.kernel.org

Doug Maxey <dwm@maxeymade.com> wrote:
>
> 
> On Fri, 05 Aug 2005 13:10:56 EDT, Jeff Garzik wrote:
> >Olaf Hering wrote:
> >> ata_host_intr cant be either inline or exported.
> >> 
> >> Signed-off-by: Olaf Hering <olh@suse.de>
> >> 
> >> Index: linux-2.6.12/drivers/scsi/libata-core.c
> >> ===================================================================
> >> --- linux-2.6.12.orig/drivers/scsi/libata-core.c
> >> +++ linux-2.6.12/drivers/scsi/libata-core.c
> >> @@ -3487,7 +3487,7 @@ void ata_bmdma_stop(struct ata_port *ap)
> >>   *	One if interrupt was handled, zero if not (shared irq).
> >>   */
> >>  
> >> -inline unsigned int ata_host_intr (struct ata_port *ap,
> >> +unsigned int ata_host_intr (struct ata_port *ap,
> >
> >er, huh?
> >
> >When I wrote this, the compiler did what I expected:  it inlined the 
> >local copy, and exported a copy for external modules to call.
> >
> >Have you verified the asm does not do this?  What changed?
> >
> >	Jeff
> 
> breaks on ppc64.
>  

I don't see why it should break.  What the code's trying to do there is
bloaty-but-legitimate.

The function is decared `extern unsigned int ata_host_intr(...)' in .h and
`inline unsigned int ata_host_intr(...)' in .c.  Should all work.

Can you share the error messages?

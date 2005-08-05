From: Doug Maxey <dwm@maxeymade.com>
Subject: Re: [PATCH] uninline exported ata_host_intr
Date: Fri, 05 Aug 2005 15:49:11 -0500
Message-ID: <200508052049.j75KnBst009233@falcon30.maxeymade.com>
References: <20050805131051.54f333dc.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:3223 "EHLO
	falcon30.maxeymade.com") by vger.kernel.org with ESMTP
	id S262972AbVHEUwI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2005 16:52:08 -0400
In-reply-to: <20050805131051.54f333dc.akpm@osdl.org> 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Doug Maxey <dwm@maxeymade.com>, jgarzik@pobox.com, olh@suse.de, linux-scsi@vger.kernel.org


On Fri, 05 Aug 2005 13:10:51 PDT, Andrew Morton wrote:
>Doug Maxey <dwm@maxeymade.com> wrote:
>>
>> 
>> On Fri, 05 Aug 2005 13:10:56 EDT, Jeff Garzik wrote:
>> >Olaf Hering wrote:
>> >> ata_host_intr cant be either inline or exported.
>> >> 
>> >> Signed-off-by: Olaf Hering <olh@suse.de>
>> >> 
>> >> Index: linux-2.6.12/drivers/scsi/libata-core.c
>> >> ===================================================================
>> >> --- linux-2.6.12.orig/drivers/scsi/libata-core.c
>> >> +++ linux-2.6.12/drivers/scsi/libata-core.c
>> >> @@ -3487,7 +3487,7 @@ void ata_bmdma_stop(struct ata_port *ap)
>> >>   *	One if interrupt was handled, zero if not (shared irq).
>> >>   */
>> >>  
>> >> -inline unsigned int ata_host_intr (struct ata_port *ap,
>> >> +unsigned int ata_host_intr (struct ata_port *ap,
>> >
>> >er, huh?
>> >
>> >When I wrote this, the compiler did what I expected:  it inlined the 
>> >local copy, and exported a copy for external modules to call.
>> >
>> >Have you verified the asm does not do this?  What changed?
>> >
>> >	Jeff
>> 
>> breaks on ppc64.
>>  
>
>I don't see why it should break.  What the code's trying to do there is
>bloaty-but-legitimate.
>
>The function is decared `extern unsigned int ata_host_intr(...)' in .h and
>`inline unsigned int ata_host_intr(...)' in .c.  Should all work.
>
>Can you share the error messages?
>

Um, er, no.  This was a ways back.  Using 3.3.x would not complain, but 
3.4.x did.  

Not this specific instance, but with another driver that had a similar
construct.  IIRC, the header had a defined "extern inline" and there was
a definition in the .c file without inline.   It should be an error, IMHO.

++doug



From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] uninline exported ata_host_intr
Date: Fri, 05 Aug 2005 13:10:56 -0400
Message-ID: <42F39DA0.5000208@pobox.com>
References: <20050805170349.GA6065@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:10635 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S263051AbVHERLQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2005 13:11:16 -0400
In-Reply-To: <20050805170349.GA6065@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

Olaf Hering wrote:
> ata_host_intr cant be either inline or exported.
> 
> Signed-off-by: Olaf Hering <olh@suse.de>
> 
> Index: linux-2.6.12/drivers/scsi/libata-core.c
> ===================================================================
> --- linux-2.6.12.orig/drivers/scsi/libata-core.c
> +++ linux-2.6.12/drivers/scsi/libata-core.c
> @@ -3487,7 +3487,7 @@ void ata_bmdma_stop(struct ata_port *ap)
>   *	One if interrupt was handled, zero if not (shared irq).
>   */
>  
> -inline unsigned int ata_host_intr (struct ata_port *ap,
> +unsigned int ata_host_intr (struct ata_port *ap,

er, huh?

When I wrote this, the compiler did what I expected:  it inlined the 
local copy, and exported a copy for external modules to call.

Have you verified the asm does not do this?  What changed?

	Jeff




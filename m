From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] remove MULTI_LUN config option
Date: Mon, 01 Sep 2003 22:31:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F5400E6.3000104@pobox.com>
References: <20030902021145.GC1941@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:2752 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263484AbTIBCbP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Sep 2003 22:31:15 -0400
In-Reply-To: <20030902021145.GC1941@krispykreme>
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: linux-scsi@vger.kernel.org

Anton Blanchard wrote:
> diff -Nru a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> --- a/drivers/scsi/dc395x.c	Tue Sep  2 10:20:06 2003
> +++ b/drivers/scsi/dc395x.c	Tue Sep  2 10:20:06 2003
> @@ -633,9 +633,7 @@
>  		CFG_PARAM_UNSET,
>  		0,
>  		0x2f,
> -#ifdef CONFIG_SCSI_MULTI_LUN
>  			NAC_SCANLUN |
> -#endif
>  		NAC_GT2DRIVES | NAC_GREATER_1G | NAC_POWERON_SCSI_RESET
>  			/*| NAC_ACTIVE_NEG*/,
>  		NAC_GT2DRIVES | NAC_GREATER_1G | NAC_POWERON_SCSI_RESET | 0x08


I like the patch, but I worry about the above piece.  I would think that 
a better patch might make NAC_SCANLUN, LUN_CHECK (tmscsim.c), and 
similar bits conditional on the module_param you mention?  Ditto for the 
loops which are now unconditionally executed.  They would still need to 
be conditional on a runtime variable, right?

As a tangent, I always build with CONFIG_SCSI_MULTI_LUN=y, so I 
definitely support this idea behind this patch...

	Jeff




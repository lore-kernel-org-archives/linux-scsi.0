From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] DVD-RAM rewritable again
Date: Wed, 4 Aug 2004 06:58:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040804045839.GA8139@suse.de>
References: <1091568097.3644.27.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:38065 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266730AbUHDE6r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 00:58:47 -0400
Content-Disposition: inline
In-Reply-To: <1091568097.3644.27.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org, Marcelo Tosatti <marcelo.tosatti@cyclades.com>, John McKell <McKellj@iomega.com>

On Tue, Aug 03 2004, Pat LaVarre wrote:
> Jens A:
> 
> Can I help by offering the trivial patch shown here?  Or can I help in
> some other way?
> 
> I ask because I see this patch makes my PATAPI DVD-RAM disc as
> rewritable as it was in 2.4.26.
> 
> Per my understanding of your instructions, I defer, until 2.4.28, the
> non-trivial work of making PATAPI and USB DVD-RAM discs behave the same.
> 
> Per my understanding of your instructions, I leave USB DVD-RAM discs not
> rewritable until 2.4.28, since those discs have not been rewritable at
> least since 2.4.26.
> 
> Pat LaVarre
> 
> diff -urp linux-2.4.27-rc4/drivers/cdrom/cdrom.c linux-2.4.27-rc4-pel/drivers/cdrom/cdrom.c
> --- linux-2.4.27-rc4/drivers/cdrom/cdrom.c	2004-08-01 08:50:45.000000000 -0600
> +++ linux-2.4.27-rc4-pel/drivers/cdrom/cdrom.c	2004-08-03 15:10:48.048576912 -0600
> @@ -536,6 +536,8 @@ static int cdrom_open_write(struct cdrom
>  	if (CDROM_CAN(CDC_RAM) &&
>  	    !CDROM_CAN(CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R)) 
>  		ret = cdrom_ram_open_write(cdi);
> +	else if (CDROM_CAN(CDC_DVD_RAM))
> +		ret = 0;
>  	else
>  		ret = 1;

That looks fine!

-- 
Jens Axboe


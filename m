From: Andreas Barth <aba@not.so.argh.org>
Subject: Re: Fw: gdth SCSI driver(?) fails with more than 4GB of memory
Date: Mon, 7 Aug 2006 17:27:29 +0200
Message-ID: <20060807152729.GS18390@mails.so.argh.org>
References: <20060717184659.04ae83e7.akpm@osdl.org> <1153229420.3704.17.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from neualius.turmzimmer.net ([217.160.169.58]:47294 "EHLO
	neualius.turmzimmer.net") by vger.kernel.org with ESMTP
	id S932160AbWHGP2P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Aug 2006 11:28:15 -0400
Content-Disposition: inline
In-Reply-To: <1153229420.3704.17.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

* James Bottomley (James.Bottomley@SteelEye.com) [060718 15:37]:
> My strongest suspicion here is that the device is lying when it claims
> to support 64 bit DMA. Can you try this?  It will turn off 64 bit DMA
> and only allow 32 bit DMA on your 6GB platform.  If that works, we'll
> beed help from the gdth people to understand the issue.

> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index 43afd47..83cf3ca 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -1543,7 +1543,7 @@ static int __init gdth_init_pci(gdth_pci
>          if (prot_ver < 0x2b)      /* FW < x.43: no 64-bit DMA support */
>              ha->dma64_support = 0;
>          else 
> -            ha->dma64_support = 1;
> +            ha->dma64_support = 0;
>      }
>  
>      return 1;


Sorry, this patch didn't help me.


Cheers,
Andi
-- 
  http://home.arcor.de/andreas-barth/

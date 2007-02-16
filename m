From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH][SCSI] sgiwd93.c: interfacing to wd33c93
Date: Fri, 16 Feb 2007 09:36:02 -0600
Message-ID: <1171640162.3443.19.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.58.0702121522570.433@Indigo2.Peter>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:49866 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945933AbXBPPgI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Feb 2007 10:36:08 -0500
In-Reply-To: <Pine.LNX.4.58.0702121522570.433@Indigo2.Peter>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: post@pfrst.de
Cc: linux-scsi@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, Kumba <kumba@gentoo.org>, Thiemo Seufer <ths@networkno.de>, Tim Yamin <plasmaroo@gentoo.org>

On Mon, 2007-02-12 at 15:27 +0100, peter fuerst wrote:
> ========================================================================
> --- dc7bdc97927ea1c519f0d8bd3133739600c841d4/drivers/scsi/sgiwd93.c	Sat Oct  7 00:00:00 2006
> +++ new/drivers/scsi/sgiwd93.c	Sun Feb 11 22:10:06 2007
> @@ -250,3 +250,3 @@
> 
> -	hdata->wh.no_sync = 0;
> +	if (0xff == hdata->wh.no_sync) hdata->wh.no_sync = 0;
> 
> ========================================================================
> 
> 
> ========================================================================
> --- dc7bdc97927ea1c519f0d8bd3133739600c841d4/drivers/scsi/sgiwd93.c	Sat Oct  7 00:00:00 2006
> +++ stage2/drivers/scsi/sgiwd93.c	Sun Feb 11 22:10:06 2007
> @@ -248,3 +248,3 @@
> 
> -	wd33c93_init(host, regs, dma_setup, dma_stop, WD33C93_FS_16_20);
> +	wd33c93_init(host, regs, dma_setup, dma_stop, WD33C93_FS_MHZ(20));
> 
> ========================================================================

You don't make it easy, do you ... these are two separate patches for
overlapping regions of the file ... neither quilt nor git likes this way
of doing things.  Plus the if should be

if (hdata->wh.no_sync == 0xff)
	hdata->wh.no_sync = 0;

to match the style of the sgiwd93.c.

Since this is pretty simple, I fixed it up.

James



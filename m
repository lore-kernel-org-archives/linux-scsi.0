From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: aic7xxx: Missing parentheses in ahc_init()?
Date: Tue, 03 Nov 2009 16:57:26 -0600
Message-ID: <1257289046.2454.11.camel@mulgrave.site>
References: <4AF0B0FF.6000706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51600 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbZKCW5Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 17:57:25 -0500
In-Reply-To: <4AF0B0FF.6000706@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Tue, 2009-11-03 at 23:38 +0100, Roel Kluin wrote:
> This looks odd, are there maybe parentheses missing here?
> 
> Thanks, Roel
> 
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
> index 8dfb59d..e6aad3e 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_core.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
> @@ -5534,8 +5534,8 @@ ahc_init(struct ahc_softc *ahc)
>  					 * so the format is different.
>  					 */
>  					scsirate = (scsirate & SXFR) >> 4
> -						 | (ultraenb & mask)
> -						  ? 0x08 : 0x0
> +						 | ((ultraenb & mask)
> +						  ? 0x08 : 0x0)

I really don't think so.  The top 4 bits of the scsirate registers are
supposed to be transfer features; it would make no sense to be
transferring them to the bottom 4 bits and oring in an extra flag.

James



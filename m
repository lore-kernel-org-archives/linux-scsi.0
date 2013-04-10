From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V3 01/12] pm80xx: fix for memory region free
Date: Wed, 10 Apr 2013 13:13:14 -0700
Message-ID: <1365624794.1942.17.camel@dabdike>
References: <5149EFF9.6070604@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39912 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935970Ab3DJUNQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Apr 2013 16:13:16 -0400
In-Reply-To: <5149EFF9.6070604@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand <anandkumar_santhanam@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, Harry.Yang@pmcs.com, rich.Bono@pmcs.com, sakthivel.sk@hcl.com, Sangeetha.Gnanasekaran@pmcs.com, xjtuwjp@gmail.com, Vishwanath.Maram@pmcs.com

On Wed, 2013-03-20 at 10:20 -0700, Anand wrote:
> >From 700bfe79294e9f9e1a5def178af52b13928902a9 Mon Sep 17 00:00:00 2001
> From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Date: Mon, 4 Feb 2013 12:10:02 +0530
> Subject: [PATCH V3 01/12] pm80xx: fix for memory region free
> 
> All memory regions are allocated based on variables total_len
> and alignment but free was based on element_size.

This patch doesn't compile.  It's giving

ERROR: "pm8001_80xx_dispatch" [drivers/scsi/pm8001/pm8001.ko] undefined!
make[1]: *** [__modpost] Error 1


This is because of this hunk:


> @@ -44,8 +44,16 @@
>  
>  static struct scsi_transport_template *pm8001_stt;
>  
> +/**
> + * chip info structure to identify chip key functionality as
> + * encryption available/not, no of ports, hw specific function ref
> + */
>  static const struct pm8001_chip_info pm8001_chips[] = {
> -	[chip_8001] = {  8, &pm8001_8001_dispatch,},
> +	[chip_8001] = {0,  8, &pm8001_8001_dispatch,},
> +	[chip_8008] = {0,  8, &pm8001_80xx_dispatch,},
> +	[chip_8009] = {1,  8, &pm8001_80xx_dispatch,},
> +	[chip_8018] = {0,  16, &pm8001_80xx_dispatch,},
> +	[chip_8019] = {1,  16, &pm8001_80xx_dispatch,},

But the structure isn't defined until patch 06/12.  This patch series
has to be bisectable and buildable.  That means each individual patch
must apply, compile and run in sequence.  Please fix this.

Thanks,

James



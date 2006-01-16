From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] aic79xx: Update to adaptec version 2.0.14
Date: Mon, 16 Jan 2006 12:05:17 +0000
Message-ID: <20060116120517.GB12554@infradead.org>
References: <43CB6F8F.7040801@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:27620 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750724AbWAPMFT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2006 07:05:19 -0500
Content-Disposition: inline
In-Reply-To: <43CB6F8F.7040801@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> -MODULE_AUTHOR("Maintainer: Justin T. Gibbs <gibbs@scsiguy.com>");
> +MODULE_AUTHOR("Maintainer: Luben Tuikov <luben_tuikov@adaptec.com>");

Does Luben plan to actually maintain the driver we have now?  I suspect
that correct person to put here would be either you or James.

>  MODULE_DESCRIPTION("Adaptec Aic790X U320 SCSI Host Bus Adapter driver");
>  MODULE_LICENSE("Dual BSD/GPL");
>  MODULE_VERSION(AIC79XX_DRIVER_VERSION);
> @@ -343,6 +358,7 @@ MODULE_PARM_DESC(aic79xx,
>  "	amplitude:<int>		Set the signal amplitude (0-7).\n"
>  "	seltime:<int>		Selection Timeout:\n"
>  "				(0/256ms,1/128ms,2/64ms,3/32ms)\n"
> +"	slowcrc			Turn on the SLOWCRC bit (Rev B only)\n"		 
>  "\n"
>  "	Sample /etc/modprobe.conf line:\n"
>  "		Enable verbose logging\n"
> @@ -1003,6 +1019,7 @@ aic79xx_setup(char *s)
>  		{ "slewrate", NULL },
>  		{ "precomp", NULL },
>  		{ "amplitude", NULL },
> +		{ "slowcrc", &aic79xx_slowcrc },

please use a single module_param for each new paramater.  Adding them
for old ones aswell would also be very nice, then we could add a depreaction
message to the old ones and remove them after a year or two.

> +		if (cmd->request)
> +			msg_bytes = scsi_populate_tag_msg(cmd, tag_msgs);

cmd->request can't be zero.

> -	if (request_region(*base, 256, "aic79xx") == 0)
> +	if (request_region(*base, 256, "aic79xx") == NULL)
>  		return (ENOMEM);
> -	if (request_region(*base2, 256, "aic79xx") == 0) {
> -		release_region(*base2, 256);
> +	if (request_region(*base2, 256, "aic79xx") == NULL) {
> +		release_region(*base, 256);

What about just if (!request_region(...)) {

>  		if (request_mem_region(start, 0x1000, "aic79xx") == 0)
>  			error = ENOMEM;
>  		if (error == 0) {
> -			*maddr = ioremap_nocache(base_page, base_offset + 256);
> +			*maddr = ioremap_nocache(base_page, base_offset + 512);

so how could this work before?


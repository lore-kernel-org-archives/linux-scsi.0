From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [patch] 2.6 -- add IOI Media Bay to SCSI quirk list
Date: Thu, 12 Aug 2004 15:51:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040812225118.GA20904@beaverton.ibm.com>
References: <200408122137.i7CLbGU13688@ra.tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:52472 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S268859AbUHLWv3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2004 18:51:29 -0400
Content-Disposition: inline
In-Reply-To: <200408122137.i7CLbGU13688@ra.tuxdriver.com>
List-Id: linux-scsi@vger.kernel.org
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

We seem to be getting quite a few of these. In theory we could add a line
like this for every multi-lun SCSI device.

Can you instead try booting with scsi_mod.max_luns=8 (or such) or build
with SCSI_MULTI_LUN enabled?

You can also use the scsi devinfo stuff, but the above is easier and
should work fine, unless you have some device that hangs when IO is sent
to a non-zero LUN.

The same for 2.4, but AFAIR the option name is max_scsi_luns (but there is
no scsi devinfo imethod).

-- Patrick Mansfield

On Thu, Aug 12, 2004 at 05:37:16PM -0400, John W. Linville wrote:
> Patch to add IOI Media Bay 4-in-1 media reader to the SCSI quirk list...
> 
> "It works for me!"  Pretty simple patch, really...
> 
> John
> 
> diff -urNp linux-2.6.5-1.358/drivers/scsi/scsi_devinfo.c linux/drivers/scsi/scsi_devinfo.c
> --- linux-2.6.5-1.358/drivers/scsi/scsi_devinfo.c	2004-05-08 08:56:41.000000000 -0400
> +++ linux/drivers/scsi/scsi_devinfo.c	2004-08-11 06:08:00.000000000 -0400
> @@ -155,6 +155,7 @@ static struct {
>  	{"HP", "C1557A", NULL, BLIST_FORCELUN},
>  	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
>  	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
> +	{"IOI", "Media Bay", NULL, BLIST_FORCELUN},
>  	{"iomega", "jaz 1GB", "J.86", BLIST_NOTQ | BLIST_NOLUN},
>  	{"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
>  	{"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

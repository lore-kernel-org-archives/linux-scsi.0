From: Christoph Hellwig <hch@infradead.org>
Subject: Re: I2O enhancement for Adaptec management software
Date: Mon, 5 Apr 2004 11:18:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040405111843.B4077@infradead.org>
References: <40712A47.4090903@shadowconnect.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:32777 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261439AbUDEKSo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Apr 2004 06:18:44 -0400
Content-Disposition: inline
In-Reply-To: <40712A47.4090903@shadowconnect.com>; from Markus.Lidel@shadowconnect.com on Mon, Apr 05, 2004 at 11:43:35AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Markus Lidel <Markus.Lidel@shadowconnect.com>
Cc: linux-scsi@vger.kernel.org

> --- a/drivers/message/i2o/i2o_config.c	2004-02-18 04:59:26.000000000 =
+0100
> +++ b/drivers/message/i2o/i2o_config.c	2004-03-03 17:14:38.035056342 =
+0100
> @@ -5,21 +5,24 @@
>   *=09
>   * Written by Alan Cox, Building Number Three Ltd
>   *
> - * Modified 04/20/1999 by Deepak Saxena
> - *   - Added basic ioctl() support
> - * Modified 06/07/1999 by Deepak Saxena
> - *   - Added software download ioctl (still testing)
> - * Modified 09/10/1999 by Auvo H=E4kkinen
> - *   - Changes to i2o_cfg_reply(), ioctl_parms()
> - *   - Added ioct_validate()

Please separate gratious reformating from the actual patch.

> +static int ioctl_passthru(unsigned long arg)
> +{
> +	/* FIX: we have to move it to i2o.h, but don't know if it's already
> +	 *      defined there. so we make it quick and dirty.
> +	 */
> +	#define MAX_MESSAGE_SIZE (128)
> +	#define REPLY_FRAME_SIZE (17)
> +	#define SG_TABLESIZE (30)

Well, for a kernel submission I'd suggest to move them where they belon=
g.

> +        c=3Di2o_find_controller(cmd->iop);
> +	if(c =3D=3D NULL)
> +                return -ENXIO;

Codingstyle looks rather strange here and in a few other places.

Should be more like:

	c =3D i2o_find_controller(cmd->iop);
	if (!c)
		return -ENXIO;

etc..

> +	get_user(reply_size, &user_reply[0]);

You need to check the return value here.

Could you also please try to work out all the 64bit issues first?
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

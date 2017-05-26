From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi: sd: Use sysfs_match_string()
Date: Fri, 26 May 2017 21:09:46 +0000
Message-ID: <1495832984.2634.4.camel@sandisk.com>
References: <20170526170239.19709-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:1137 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944966AbdEZVJt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 May 2017 17:09:49 -0400
In-Reply-To: <20170526170239.19709-1-martin.petersen@oracle.com>
Content-Language: en-US
Content-ID: <F17465E3734A6F4EAC9AD12723265B3A@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Fri, 2017-05-26 at 13:02 -0400, Martin K. Petersen wrote:
> Avoid unnecessary snprintf() when formatting variables for display in
> sysfs and switch to sysfs_match_string() for validating user input.

Hello Martin,

Would it be worth it to split this patch into two patches - one for the
snprintf() conversion and another patch for the sysfs_match_string()
conversion?

> @@ -155,7 +155,7 @@ static ssize_t
>  cache_type_store(struct device *dev, struct device_attribute *attr,
>  		 const char *buf, size_t count)
>  {
> -	int i, ct =3D -1, rcd, wce, sp;
> +	int ct =3D -1, rcd, wce, sp;

Is it still necessary to initialize ct in this function?

> +	mode =3D sysfs_match_string(lbp_mode, buf);
> +	if (mode < 0)
>  		return -EINVAL;
> [ ... ]
> +	mode =3D sysfs_match_string(zeroing_mode, buf);
> +	if (mode < 0)
>=A0=A0		return -EINVAL;=A0

sysfs_match_string() only supports dense arrays. Maybe it's worth to add a
comment above lbp_mode[] and zeroing_mode[] that these must be dense arrays
or that the above calls to sysfs_match_string() will break?

Otherwise this patch looks fine to me.

Bart.=

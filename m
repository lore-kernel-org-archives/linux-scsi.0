From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 1/2] scsi: sd: Separate zeroout and discard command
 choices
Date: Fri, 7 Apr 2017 18:28:15 +0000
Message-ID: <1491589694.2559.16.camel@sandisk.com>
References: <20170405114111.26864-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:63530 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933434AbdDGS2S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Apr 2017 14:28:18 -0400
In-Reply-To: <20170405114111.26864-1-martin.petersen@oracle.com>
Content-Language: en-US
Content-ID: <F6D0102E6E31D743B16D54534119D232@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>

On Wed, 2017-04-05 at 07:41 -0400, Martin K. Petersen wrote:
> +static const char *zeroing_mode[] =3D {
> +	[SD_ZERO_WRITE]		=3D "write",
> +	[SD_ZERO_WS]		=3D "writesame",
> +	[SD_ZERO_WS16_UNMAP]	=3D "writesame_16_unmap",
> +	[SD_ZERO_WS10_UNMAP]	=3D "writesame_10_unmap",
> +};
> +
> +static ssize_t
> +zeroing_mode_show(struct device *dev, struct device_attribute *attr,
> +		  char *buf)
> +{
> +	struct scsi_disk *sdkp =3D to_scsi_disk(dev);
> +
> +	return snprintf(buf, 20, "%s\n", zeroing_mode[sdkp->zeroing_mode]);
> +}

Hello Martin,

If anyone would ever add a string to zeroing_mode[] that is longer than 20
characters then zeroing_mode_show() will truncate it. Since all strings in
the=A0zeroing_mode[] array are short, have you considered to use sprintf()
instead? And if you do not want to use sprintf(), how about using
snprintf(buf, PAGE_SIZE, ...)? I'm asking this because I'm no fan of magic
constants.
=20
> +static ssize_t
> +zeroing_mode_store(struct device *dev, struct device_attribute *attr,
> +		   const char *buf, size_t count)
> +{
> +	struct scsi_disk *sdkp =3D to_scsi_disk(dev);
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EACCES;
> +
> +	if (!strncmp(buf, zeroing_mode[SD_ZERO_WRITE], 20))
> +		sdkp->zeroing_mode =3D SD_ZERO_WRITE;
> +	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS], 20))
> +		sdkp->zeroing_mode =3D SD_ZERO_WS;
> +	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS16_UNMAP], 20))
> +		sdkp->zeroing_mode =3D SD_ZERO_WS16_UNMAP;
> +	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS10_UNMAP], 20))
> +		sdkp->zeroing_mode =3D SD_ZERO_WS10_UNMAP;
> +	else
> +		return -EINVAL;
> +
> +	return count;
> +}

Since sysfs guarantees that buf is '\0'-terminated, why does the above
function call strncmp() instead of strcmp()?

Can the above chain of if-statements be replaced by a for-loop such that
zeroing_mode_store() won't have to be updated if the zeroing_mode[] array
is modified?

Thanks,

Bart.=

From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 1/2] scsi: sd: Separate zeroout and discard command
 choices
Date: Fri, 7 Apr 2017 19:59:08 +0000
Message-ID: <1491595147.2559.26.camel@sandisk.com>
References: <20170405114111.26864-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:19269 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932813AbdDGT7K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Apr 2017 15:59:10 -0400
In-Reply-To: <20170405114111.26864-1-martin.petersen@oracle.com>
Content-Language: en-US
Content-ID: <F2678AF01D34F3499CE4FA5BF226DE85@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>

On Wed, 2017-04-05 at 07:41 -0400, Martin K. Petersen wrote:
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

An additional question about this function: if the shell command "echo" is =
used
without command-line option -n to modify the "zeroing_mode" sysfs attribute=
 then
a newline character will be present in buf. Does the above code handle newl=
ine
characters correctly?

Bart.=

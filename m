From: "Achim Leubner" <Achim_Leubner@pmc-sierra.com>
Subject: RE: [patch] [SCSI] aacraid: use lower snprintf() limit
Date: Wed, 5 Oct 2011 05:19:12 -0700
Message-ID: <FD2BDBE06AC58549AE9E16C08B45675D05D8ED9E@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
References: <20111005055046.GD32077@elgon.mountain> <d97a34694e741dc6a2a71fbcd49bab49.squirrel@webmail.sf-mail.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <d97a34694e741dc6a2a71fbcd49bab49.squirrel@webmail.sf-mail.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Looks good so far. But do we really need the last two lines?
> +	if (len > 16)
> +		len = 16;

Acked-by: Achim Leubner <Achim_Leubner@pmc-sierra.com> 

Thanks,
Achim


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Rolf Eike Beer
Sent: Mittwoch, 5. Oktober 2011 09:35
To: Dan Carpenter
Cc: Adaptec OEM Raid Solutions; James E.J. Bottomley;
linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
kernel-janitors@vger.kernel.org
Subject: Re: [patch] [SCSI] aacraid: use lower snprintf() limit

> This is just a cleanup, to silence static checker warnings.  It
> doesn't change how the code works.
>
> buf[] can either be BUF_SIZE if this is called from sysfs, or it can
> be 16 if it's called from aac_get_adapter_info() via
> aac_get_serial_number().  We use the smaller limit here.
>
> sizeof(dev->supplement_adapter_info.MfgPcbaSerialNo) is 12 so there
> is actually no chance of hitting either limit.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/scsi/aacraid/linit.c
b/drivers/scsi/aacraid/linit.c
> index 3382475..ea8d96e 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -894,15 +894,20 @@ static ssize_t aac_show_serial_number(struct
device
> *device,
>  	int len = 0;
>
>  	if (le32_to_cpu(dev->adapter_info.serial[0]) != 0xBAD0)
> -		len = snprintf(buf, PAGE_SIZE, "%06X\n",
> +		len = snprintf(buf, 16, "%06X\n",
>  		  le32_to_cpu(dev->adapter_info.serial[0]));
>  	if (len &&
>  	  !memcmp(&dev->supplement_adapter_info.MfgPcbaSerialNo[
>  	    sizeof(dev->supplement_adapter_info.MfgPcbaSerialNo)-len],
>  	  buf, len-1))
> -		len = snprintf(buf, PAGE_SIZE, "%.*s\n",
> +		len = snprintf(buf, 16, "%.*s\n",
>
(int)sizeof(dev->supplement_adapter_info.MfgPcbaSerialNo),
>  		  dev->supplement_adapter_info.MfgPcbaSerialNo);
> +
> +

One newline too much.

> +	if (len > 16)
> +		len = 16;

max()?

Eike

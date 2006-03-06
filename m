From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Mon, 06 Mar 2006 11:37:54 -0500
Message-ID: <440C6562.7060309@garzik.org>
References: <1141339085.3238.80.camel@mulgrave.il.steeleye.com>	 <20060306082614.GA27603@us.ibm.com> <1141657981.3167.3.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:64901 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751867AbWCFQh7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2006 11:37:59 -0500
In-Reply-To: <1141657981.3167.3.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

James Bottomley wrote:
> On Mon, 2006-03-06 at 00:26 -0800, Mike Anderson wrote:
> 
>>Ran into a issue that on the first load I did not have the
>>attach_HostRAID=1 that I need for my model of card so when I went to do a
>>modprobe -r; modprobe I got an oops. The patch below helps with the
>>describe case, but does not fix the problem of not being able to unload if
>>devices are found.
> 
> 
> Yes, that's part of the refcounting problems.  Eventually this will
> either become a transport class in its own right or an adjunct library
> to the sas transport class (in which case I'll make it inherit
> refcounting).
> 
> In the meantime attach_HostRAID shouldn't be a parameter, so I'll just
> get rid of it as well.
> 
> James
> 
> diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
> index f0c5cf2..924075d 100644
> --- a/drivers/scsi/aic94xx/aic94xx_init.c
> +++ b/drivers/scsi/aic94xx/aic94xx_init.c
> @@ -41,12 +41,6 @@
>  /* The format is "version.release.patchlevel" */
>  #define ASD_DRIVER_VERSION "1.0.2"
>  
> -static int attach_HostRAID = 0;
> -module_param_named(attach_HostRAID, attach_HostRAID, int, S_IRUGO|S_IWUSR);
> -MODULE_PARM_DESC(attach_HostRAID, "\n"
> -	"\tEnable(1) or disable(0) attaching to HostRAID enabled host adapters.\n"
> -	"\tDefault: 0");
> -
>  static int use_msi = 0;
>  module_param_named(use_msi, use_msi, int, S_IRUGO);
>  MODULE_PARM_DESC(use_msi, "\n"
> @@ -541,13 +535,6 @@ static int __devinit asd_pci_probe(struc
>  	struct asd_ha_struct *asd_ha;
>  	int err;
>  
> -	if (dev->class == (PCI_CLASS_STORAGE_RAID << 8) && !attach_HostRAID) {
> -		asd_printk("will not attach to HostRAID enabled device %s, "
> -			   "unless attach_HostRAID parameter is set\n",
> -			   pci_name(dev));
> -		return -ENODEV;
> -	}
> -

ACK, I meant to do this one myself.



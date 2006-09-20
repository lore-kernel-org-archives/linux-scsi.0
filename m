From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 2/5] aacraid:  expose physical devices
Date: Wed, 20 Sep 2006 08:50:24 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F02C7BCFA@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:51597 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1751227AbWITMuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2006 08:50:25 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mark Haverkamp <markh@osdl.org>

It has come to my attention that some folks view this patch as a means
of utilizing the scsi monitor tools with the aacraid class of adapters.

That issue was resolved with the no_uld_attach patch to aacraid which
showed up January of this year that allowed the physical devices to
attach to sg, but not sd, preventing their enumeration as /dev/sd*
devices. The scsi tools have demonstrated they work fine attaching to
the enumerated /dev/sg* devices.

This new patch allows the physical devices to also attach to sd when the
insmod parameter is set. For instance, we had one user that was
experimenting with his own user space RAID stack and did not want to
purchase yet another controller to access the physical devices or resort
to issuing scsi commands via /dev/sg*.

I hope this clarifies the purpose of this patch.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Mark Haverkamp [mailto:markh@osdl.org] 
> Sent: Tuesday, September 19, 2006 12:00 PM
> To: James Bottomley
> Cc: Salyzyn, Mark; linux-scsi
> Subject: [PATCH 2/5] aacraid: expose physical devices
> 
> 
> Received from Mark Salyzyn:
> 
> I am placing this functionality into an insmod parameter. 
> Normally the physical
> components are exported to sg, and are blocked from showing up in sd.
> 
> Note that the pass-through I/O path via the driver through 
> the Firmware to the
> physical disks is not an optimized path, the card is designed 
> for Hardware
> RAID, elevator sorting and caching. This should not be used 
> as a means for
> utilizing the aacraid based controllers as a generic 
> scsi/SATA/SAS controller,
> performance should suck by a few percentage points, any RAID 
> meta-data on the
> drives will confuse the controller about who owns the drives 
> and there is a
> high risk of destroying content in both directions. Unreliable and for
> experimentation or strange controlled circumstances only.
> 
> Signed-off-by: Mark Haverkamp <markh@osdl.org>
> 
> ---
> 
> --- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	
> 2006-09-12 09:49:31.000000000 -0700
> +++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	
> 2006-09-12 09:49:40.000000000 -0700
> @@ -169,6 +169,10 @@
>  int acbsize = -1;
>  module_param(acbsize, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(acbsize, "Request a specific adapter 
> control block (FIB) size. Valid values are 512, 2048, 4096 
> and 8192. Default is to use suggestion from Firmware.");
> +
> +int expose_physicals = 0;
> +module_param(expose_physicals, int, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(expose_physicals, "Expose physical 
> components of the arrays. 0=off, 1=on");
>  /**
>   *	aac_get_config_status	-	check the adapter configuration
>   *	@common: adapter to query
> @@ -1535,7 +1539,7 @@
>  				return 0;
>  			}
>  		} else {  /* check for physical non-dasd devices */
> -			if(dev->nondasd_support == 1){
> +			if ((dev->nondasd_support == 1) || 
> expose_physicals) {
>  				if (dev->in_reset)
>  					return -1;
>  				return aac_send_srb_fib(scsicmd);
> --- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	
> 2006-09-12 09:48:51.000000000 -0700
> +++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	
> 2006-09-12 09:49:40.000000000 -0700
> @@ -82,6 +82,8 @@
>  static int aac_cfg_major = -1;
>  char aac_driver_version[] = AAC_DRIVER_FULL_VERSION;
>  
> +extern int expose_physicals;
> +
>  /*
>   * Because of the way Linux names scsi devices, the order in 
> this table has
>   * become important.  Check for on-board Raid first, add-in 
> cards second.
> @@ -394,6 +396,7 @@
>  		sdev->skip_ms_page_3f = 1;
>  	}
>  	if ((sdev->type == TYPE_DISK) &&
> +			!expose_physicals &&
>  			(sdev_channel(sdev) != CONTAINER_CHANNEL)) {
>  		struct aac_dev *aac = (struct aac_dev 
> *)sdev->host->hostdata;
>  		if (!aac->raid_scsi_mode || (sdev_channel(sdev) != 2))
> @@ -928,7 +931,7 @@
>  	 * all containers are on the virtual channel 0 
> (CONTAINER_CHANNEL)
>  	 * physical channels are address by their actual 
> physical number+1
>  	 */
> -	if (aac->nondasd_support == 1)
> +	if ((aac->nondasd_support == 1) || expose_physicals)
>  		shost->max_channel = aac->maximum_num_channels;
>  	else
>  		shost->max_channel = 0;
> 
> -- 
> Mark Haverkamp <markh@osdl.org>
> 
> 

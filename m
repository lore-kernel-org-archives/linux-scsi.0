From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] dpt_i2o: 64 bit support (take 4)
Date: Fri, 25 Apr 2008 11:59:16 -0500
Message-ID: <1209142756.3087.23.camel@localhost.localdomain>
References: <20080424213459.GA21698@xs4all.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43901 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762047AbYDYQ7U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 12:59:20 -0400
In-Reply-To: <20080424213459.GA21698@xs4all.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-04-24 at 23:35 +0200, Miquel van Smoorenburg wrote:
> sysfs code.
> 
> # -------
> 
> This patch is an update for drivers/scsi/dpt_i2o.c.
> It applies to both 2.6.24.4 and 2.6.25
> 
> It contains the following changes:
> 
> * 64 bit code based on unofficial Adaptec 64 bit driver
> * removes scsi_module.c dependency, adds module_init / module_exit
>   this is needed because we need to pass the proper device to
>   scsi_add_host(), and the scsi_module.c passes NULL. With NULL,
>   code like arch/x64/kernel/pci-gart_64.c::need_iommu() crashes
>   because the dev pointer it is passed is NULL.
> * adds sysfs entry for /sys/class/dpt_i2o/dptiX so that udev
>   can create /dev/dptiX dynamically

The changelog and patch title really needs to reflect only the actual
changes ... (as in only sysfs).

> Obviously there are more cleanups that can be done to this code,
> but we need to start somewhere. Patch has been tested heavily on
> both 32 and 64 bit x86 platforms.
> 
> Signed-off-by: Miquel van Smoorenburg <miquels@cistron.nl>
> 
> diff -ruN linux-2.6.25/drivers/scsi/dpt_i2o.c linux-2.6.25-sysfs/drivers/scsi/dpt_i2o.c
> --- linux-2.6.25/drivers/scsi/dpt_i2o.c	2008-04-24 22:30:29.000000000 +0200
> +++ linux-2.6.25-sysfs/drivers/scsi/dpt_i2o.c	2008-04-24 23:26:08.000000000 +0200
> @@ -116,6 +116,8 @@
>  static adpt_hba* hba_chain = NULL;
>  static int hba_count = 0;
>  
> +static struct class *adpt_sysfs_class;
> +
>  #ifdef CONFIG_COMPAT
>  static long compat_adpt_ioctl(struct file *, unsigned int, unsigned long);
>  #endif
> @@ -259,6 +261,10 @@
>  		adpt_inquiry(pHba);
>  	}
>  
> +	adpt_sysfs_class = class_create(THIS_MODULE, "dpt_i2o");
> +	if (IS_ERR(adpt_sysfs_class))
> +		adpt_sysfs_class = NULL;
> +
>  	for (pHba = hba_chain; pHba; pHba = pHba->next) {
>  		if (adpt_scsi_host_alloc(pHba, sht) < 0){
>  			adpt_i2o_delete_hba(pHba);
> @@ -266,6 +272,11 @@
>  		}
>  		pHba->initialized = TRUE;
>  		pHba->state &= ~DPTI_STATE_RESET;
> +		if (adpt_sysfs_class) {
> +			class_device_create(adpt_sysfs_class,

Unfortunately, Greg and Kay are in the process of nuking the
class_device and all its associated functions.  Now the way it works is
that you use an ordinary struct device, with the class pointer set up
and with the parent pointing to the device that class_device->dev used
to point to.

To see an example of this, you can look at:

commit ee959b00c335d7780136c5abda37809191fe52c3
Author: Tony Jones <tonyj@suse.de>
Date:   Fri Feb 22 00:13:36 2008 +0100

    SCSI: convert struct class_device to struct device

James



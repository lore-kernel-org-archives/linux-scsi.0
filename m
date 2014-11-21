From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH RESEND 1/7] megaraid_sas : Driver version upgrade and
 remove some meta data of driver
Date: Fri, 21 Nov 2014 14:51:06 +0100
Message-ID: <546F434A.6020702@redhat.com>
References: <201411170957.sAH9vdRD008943@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758635AbaKUNve (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 08:51:34 -0500
In-Reply-To: <201411170957.sAH9vdRD008943@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On 11/17/2014 10:53 AM, Sumit.Saxena@avagotech.com wrote:
> Update driver version and remove some meta data(release date and extended version) about megaraid_sas driver.
>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h      |    4 +---
>  drivers/scsi/megaraid/megaraid_sas_base.c |   24 +-----------------------
>  2 files changed, 2 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index a49914d..fe546e6 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -33,9 +33,7 @@
>  /*
>   * MegaRAID SAS Driver meta data
>   */
> -#define MEGASAS_VERSION				"06.805.06.00-rc1"
> -#define MEGASAS_RELDATE				"Sep. 4, 2014"
> -#define MEGASAS_EXT_VERSION			"Thu. Sep. 4 17:00:00 PDT 2014"
> +#define MEGASAS_VERSION				"06.805.06.01-rc1"
>  
>  /*
>   * Device IDs
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index f6a69a3..6c74a67 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -6400,16 +6400,6 @@ static ssize_t megasas_sysfs_show_version(struct device_driver *dd, char *buf)
>  static DRIVER_ATTR(version, S_IRUGO, megasas_sysfs_show_version, NULL);
>  
>  static ssize_t
> -megasas_sysfs_show_release_date(struct device_driver *dd, char *buf)
> -{
> -	return snprintf(buf, strlen(MEGASAS_RELDATE) + 2, "%s\n",
> -			MEGASAS_RELDATE);
> -}
> -
> -static DRIVER_ATTR(release_date, S_IRUGO, megasas_sysfs_show_release_date,
> -		   NULL);
> -
> -static ssize_t
>  megasas_sysfs_show_support_poll_for_event(struct device_driver *dd, char *buf)
>  {
>  	return sprintf(buf, "%u\n", support_poll_for_event);
> @@ -6712,8 +6702,7 @@ static int __init megasas_init(void)
>  	/*
>  	 * Announce driver version and other information
>  	 */
> -	printk(KERN_INFO "megasas: %s %s\n", MEGASAS_VERSION,
> -	       MEGASAS_EXT_VERSION);
> +	pr_info("megasas: %s\n", MEGASAS_VERSION);
>  
>  	spin_lock_init(&poll_aen_lock);
>  
> @@ -6748,10 +6737,6 @@ static int __init megasas_init(void)
>  				  &driver_attr_version);
>  	if (rval)
>  		goto err_dcf_attr_ver;
> -	rval = driver_create_file(&megasas_pci_driver.driver,
> -				  &driver_attr_release_date);
> -	if (rval)
> -		goto err_dcf_rel_date;
>  
>  	rval = driver_create_file(&megasas_pci_driver.driver,
>  				&driver_attr_support_poll_for_event);
> @@ -6775,12 +6760,7 @@ err_dcf_support_device_change:
>  err_dcf_dbg_lvl:
>  	driver_remove_file(&megasas_pci_driver.driver,
>  			&driver_attr_support_poll_for_event);
> -
>  err_dcf_support_poll_for_event:
> -	driver_remove_file(&megasas_pci_driver.driver,
> -			   &driver_attr_release_date);
> -
> -err_dcf_rel_date:
>  	driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);
>  err_dcf_attr_ver:
>  	pci_unregister_driver(&megasas_pci_driver);
> @@ -6800,8 +6780,6 @@ static void __exit megasas_exit(void)
>  			&driver_attr_support_poll_for_event);
>  	driver_remove_file(&megasas_pci_driver.driver,
>  			&driver_attr_support_device_change);
> -	driver_remove_file(&megasas_pci_driver.driver,
> -			   &driver_attr_release_date);
>  	driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);
>  
>  	pci_unregister_driver(&megasas_pci_driver);

Reviewed-by: Tomas Henzl <thenzl@redhat.com>


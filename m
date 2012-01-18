From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 01/07] lpfc 8.3.29: BSG and User interface fixes
Date: Wed, 18 Jan 2012 16:21:55 -0600
Message-ID: <4F174603.8060104@cs.wisc.edu>
References: <1326921829.32733.10.camel@ogier>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60124 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988Ab2ARWWE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jan 2012 17:22:04 -0500
In-Reply-To: <1326921829.32733.10.camel@ogier>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

On 01/18/2012 03:23 PM, James Smart wrote:
> - Create character device to take a reference on the driver (126082)
>

Is this so the driver cannot get unloaded when doing multiple bsg/sysfs
requests? If so having every driver create its own char device seems
wrong. qla2xxx does this too.qla4xxx wants to do it.  Every driver has
the problem.

If we do this can we at least have a scsi lib helper function that can
enforce a consistent naming policy for the char devs so userspace apps
do not have to have some crazy look up table for every driver.

Or, is there a better way to support this? Maybe a common sysfs attr on
the host or a bsg request? Something common that works for all drivers
so we do not have to go around to every driver and add char device to them?



> diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> --- a/drivers/scsi/lpfc/lpfc_init.c	2012-01-12 22:43:34.000000000 -0500
> +++ b/drivers/scsi/lpfc/lpfc_init.c	2012-01-18 11:32:20.000000000 -0500
> @@ -32,6 +32,7 @@
>  #include <linux/aer.h>
>  #include <linux/slab.h>
>  #include <linux/firmware.h>
> +#include <linux/miscdevice.h>
>  
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_device.h>
> @@ -10012,6 +10013,36 @@ lpfc_io_resume(struct pci_dev *pdev)
>  	return;
>  }
>  
> +/**
> + * lpfc_mgmt_open - method called when 'lpfcmgmt' is opened from userspace
> + * @inode: pointer to the inode representing the lpfcmgmt device
> + * @filep: pointer to the file representing the open lpfcmgmt device
> + *
> + * This routine puts a reference count on the lpfc module whenever the
> + * character device is opened
> + **/
> +static int
> +lpfc_mgmt_open(struct inode *inode, struct file *filep)
> +{
> +	try_module_get(THIS_MODULE);
> +	return 0;
> +}
> +
> +/**
> + * lpfc_mgmt_release - method called when 'lpfcmgmt' is closed in userspace
> + * @inode: pointer to the inode representing the lpfcmgmt device
> + * @filep: pointer to the file representing the open lpfcmgmt device
> + *
> + * This routine removes a reference count from the lpfc module when the
> + * character device is closed
> + **/
> +static int
> +lpfc_mgmt_release(struct inode *inode, struct file *filep)
> +{
> +	module_put(THIS_MODULE);
> +	return 0;
> +}
> +
>  static struct pci_device_id lpfc_id_table[] = {
>  	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_VIPER,
>  		PCI_ANY_ID, PCI_ANY_ID, },
> @@ -10124,6 +10155,17 @@ static struct pci_driver lpfc_driver = {
>  	.err_handler    = &lpfc_err_handler,
>  };
>  
> +static const struct file_operations lpfc_mgmt_fop = {
> +	.open = lpfc_mgmt_open,
> +	.release = lpfc_mgmt_release,
> +};
> +
> +static struct miscdevice lpfc_mgmt_dev = {
> +	.minor = MISC_DYNAMIC_MINOR,
> +	.name = "lpfcmgmt",
> +	.fops = &lpfc_mgmt_fop,
> +};
> +
>  /**
>   * lpfc_init - lpfc module initialization routine
>   *
> @@ -10144,6 +10186,11 @@ lpfc_init(void)
>  	printk(LPFC_MODULE_DESC "\n");
>  	printk(LPFC_COPYRIGHT "\n");
>  
> +	error = misc_register(&lpfc_mgmt_dev);
> +	if (error)
> +		printk(KERN_ERR "Could not register lpfcmgmt device, "
> +			"misc_register returned with status %d", error);
> +
>  	if (lpfc_enable_npiv) {
>  		lpfc_transport_functions.vport_create = lpfc_vport_create;
>  		lpfc_transport_functions.vport_delete = lpfc_vport_delete;
> @@ -10180,6 +10227,7 @@ lpfc_init(void)
>  static void __exit
>  lpfc_exit(void)
>  {
> +	misc_deregister(&lpfc_mgmt_dev);
>  	pci_unregister_driver(&lpfc_driver);
>  	fc_release_transport(lpfc_transport_template);
>  	if (lpfc_enable_npiv)

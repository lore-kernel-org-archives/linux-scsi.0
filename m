From: hch@lst.de
Subject: Re: [PATCH/RFC 1/2] 3ware 9000 SATA-RAID driver
Date: Sun, 23 May 2004 12:59:55 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040523105955.GA10790@lst.de>
References: <HY4O8E00.VE7@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:59542 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262499AbUEWLAB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 May 2004 07:00:01 -0400
Content-Disposition: inline
In-Reply-To: <HY4O8E00.VE7@hadar.amcc.com>
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <aradford@amcc.com>
Cc: linux-scsi@vger.kernel.org

> diff -Naur linux-2.6.6-mm4/drivers/pci/pci.ids linux-2.6.6-mm5/drivers/pci/pci.ids
> --- linux-2.6.6-mm4/drivers/pci/pci.ids	2004-05-21 16:35:20.000000000 -0700
> +++ linux-2.6.6-mm5/drivers/pci/pci.ids	2004-05-21 15:38:58.000000000 -0700
> @@ -5751,7 +5751,7 @@
>  13c1  3ware Inc
>  	1000  3ware ATA-RAID
>  	1001  3ware 7000-series ATA-RAID
> -	1002  3ware ATA-RAID
> +	1002  3ware 9000-series ATA-RAID
>  13c2  Technotrend Systemtechnik GmbH
>  13c3  Janz Computer AG
>  13c4  Phase Metrics

I think this file is managed via pci-ids.sf.net, please submit there.

> +
> +#include <linux/module.h>
> +
> +MODULE_AUTHOR ("AMCC");
> +#ifdef CONFIG_SMP
> +MODULE_DESCRIPTION ("3ware 9000 Storage Controller Linux Driver (SMP)");
> +#else
> +MODULE_DESCRIPTION ("3ware 9000 Storage Controller Linux Driver");
> +#endif
> +MODULE_LICENSE("GPL");

the ifdef SMP is bogus, also please move the MODULE_ macros below all
includes.

> +
> +#include <linux/kernel.h>
> +#include <linux/pci.h>
> +#include <linux/time.h>
> +#include <linux/proc_fs.h>
> +#include <linux/sched.h>
> +#include <linux/ioport.h>
> +#include <linux/blkdev.h>
> +#include <linux/hdreg.h>
> +#include <linux/string.h>
> +#include <linux/delay.h>
> +#include <linux/smp.h>

shouldn't be needed with a modern driver.

> +#include <linux/reboot.h>
> +#include <linux/spinlock.h>
> +#include <linux/interrupt.h>
> +#include <linux/moduleparam.h>
> +
> +#include <asm/errno.h>

never use asm/errno.h but always linux/errno.h

> +#include "scsi.h"
> +#include "hosts.h"

please don't include these anymore, use the headers from include/scsi/*.h,
this also involves some reshuffling like getting rid of the obsolete Scsi_Foo
typedefs and using the DMA_* constants instead of SCSI_DATA_*

> +
> +#include "3w-9xxx.h"
> +
> +/* Notifier block to get a notify on system shutdown/halt/reboot */
> +static struct notifier_block twa_notifier = {
> +	.notifier_call	= twa_halt,
> +	.next		= NULL,
> +	.priority	= 0
> +};

please usethe shutdown method in the pci_driver instead, see the megaraid
driver for an example.

> +/* Globals */
> +char *twa_driver_version="2.26.00.008";
> +TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];

after the changes I'll suggest below this will only be used in the ioctl
code anymore, and by doing the lookup in ->open there and stuffing a pointer
into file->private_data you'll only need this in a slow-path, so a linked
list will be enough.

> +unsigned int twa_device_extension_count = 0;

No need to initialize to 0, .bss will do it for you.

> +static int twa_major = -1;
> +extern struct timezone sys_tz;
> +static int cmds_per_lun;

please mark all symbols in the driver static.

> +/* This function handles open for the character device */
> +static int twa_chrdev_open(struct inode *inode, struct file *file)
> +{
> +	unsigned int minor_number;
> +	int retval = TW_IOCTL_ERROR_OS_ENODEV;
> +
> +	minor_number = MINOR(inode->i_rdev);

2.6 has a nice iminor() helper for this.

> +/* This function handles close for the character device */
> +static int twa_chrdev_release(struct inode *inode, struct file *file)
> +{
> +	return 0;
> +} /* End twa_chrdev_release() */

no need to implement ->release at all if it doesn't do anything.

> +#if BITS_PER_LONG > 32
> +	/* Turn on 64-bit sgl support */
> +	tw_initconnect->features |= 1;
> +#endif

Don't you also need this on 32bit arches with >32bit physical
addressing, e.g. x86 with PAE?

> +/* This funciton returns unit geometry in cylinders/heads/sectors */
> +static int twa_scsi_biosparam(struct scsi_device *sdev, struct block_device *bdev, sector_t capacity, int geom[])
> +{
> +	int heads, sectors, cylinders;
> +	TW_Device_Extension *tw_dev;
> +
> +	tw_dev = (TW_Device_Extension *)sdev->host->hostdata;
> +
> +	heads = 64;
> +	sectors = 32;
> +	cylinders = (unsigned long)capacity / (heads * sectors);

with CONFIG_LBD set capacity will be a 64bit type on 32bit arches,
so you must use sector_div for it.

> +/* This function will find and initialize all cards */
> +static int twa_scsi_detect(Scsi_Host_Template *tw_host)
> +{
> +	int numcards = 0, i;
> +	struct Scsi_Host *host = NULL;
> +	TW_Device_Extension *tw_dev, *tw_dev2;
> +	struct pci_dev *tw_pci_dev=NULL;
> +	u32 mem_addr, mem_len;
> +	u16 device[TW_NUMDEVICES] = { TW_DEVICE_ID_9000 };
> +
> +	printk(KERN_WARNING "3ware 9000 Storage Controller device driver for Linux v%s.\n", twa_driver_version);
> +
> +	for (i = 0; i < TW_NUMDEVICES; i++) {
> +		while ((tw_pci_dev = pci_find_device(TW_VENDOR_ID, device[i], tw_pci_dev))) {

Please redo the probing useing a struct pci_driver and appropinquate
callbacks.  See e.g. megaraid or qla1280 for details.

> +/* This function handles input and output from /proc/scsi/3w-9xxx/x */
> +static int twa_scsi_proc_info(struct Scsi_Host *shost, char *buffer, char **start, off_t offset, int length, int inout)
> +{
> +	TW_Device_Extension *tw_dev = NULL;
> +	TW_Info info;
> +	unsigned int i;
> +	int retval = -EINVAL;
> +
> +	/* Find the correct device extension */
> +	for (i = 0; i < twa_device_extension_count; i++) 
> +		if (twa_device_extension_list[i]->host->host_no == shost->host_no)
> +			tw_dev = twa_device_extension_list[i];

You can simply use shost->private_data to find your device extension
these days.  But we don't want ->proc_info in new drivers anyway, please
use sysfs attributes instead, see 53c700 or the qla2xxx driver for
examples.

> +/* This is the main scsi queue function to handle scsi opcodes */
> +static int twa_scsi_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
> +{
> +	int request_id;
> +	TW_Device_Extension *tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
> +
> +	/* Skip lun and channel probes */
> +	if ((SCpnt->device->lun != 0) || (SCpnt->device->channel != 0)) {
> +		SCpnt->result = (DID_BAD_TARGET << 16);
> +		done(SCpnt);
> +		goto out;
> +	}

If you set max_lun and max_channel right you should need this change.

> +	/* Save done function into Scsi_Cmnd struct */
> +	SCpnt->scsi_done = done;
> +		
> +	/* Get a free request id */
> +	twa_get_request_id(tw_dev, &request_id);
> +
> +	/* Save the scsi command for use by the ISR */
> +	tw_dev->srb[request_id] = SCpnt;
> +
> +	/* Initialize phase to zero */
> +	SCpnt->SCp.phase = 0;
> +
> +	if (twa_scsiop_execute_scsi(tw_dev, request_id, NULL, 0, NULL)) {
> +		tw_dev->state[request_id] = TW_S_COMPLETED;
> +		twa_free_request_id(tw_dev, request_id);
> +		SCpnt->result = (DID_ERROR << 16);
> +		done(SCpnt);

If twa_scsiop_execute_scsi returns a non-fatal error and the request
should be retired you should reurn one of the MLQUEUE*BUSY values
instead.



In addition to these code comments please make sure all lines are
wrapper after 80 characters.

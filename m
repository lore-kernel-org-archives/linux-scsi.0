From: Ruud Linders <rkmp@xs4all.nl>
Subject: Re: [PATCH] 2.6.0-test6 limit mode sense usage
Date: Sat, 04 Oct 2003 14:57:26 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F7EC3B6.70201@xs4all.nl>
References: <20031003162846.A17569@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from node-c-7b4b.a2000.nl ([62.194.123.75]:2432 "EHLO
	wsprwl.xs4all.nl") by vger.kernel.org with ESMTP id S262016AbTJDM52
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Oct 2003 08:57:28 -0400
In-Reply-To: <20031003162846.A17569@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org



I just verified the patch on -test6 using both my USB memory sticks as
well as an external USB disk.
All three work without problems now (for the first time since long
time on 2.[56].x), also on the console they all show
    sdx: assuming drive cache: write through
what would be expected.

_
Ruud Linders


Patrick Mansfield wrote:
> Re-roll of the patch against 2.6.0-test6 to allow overriding or setting of
> mode sense related flags, includes Alan Stern's as95 patch minus his
> scsiglue.c changes.
> 
> Moves scsi_devinfo.h for use outside of drivers/scsi, and adds three new
> devinfo flags:
> 
> 	BLIST_MS_SKIP_PAGE_08
> 	BLIST_MS_SKIP_PAGE_3F
> 	BLIST_USE_10_BYTE_MS
> 
> Adds a per host template flags, and use of it in scsiglue.c. The per host
> value can be overridden by a devinfo entry, the patch does not allow
> scsi_default_dev_flags to override default host values.
> 
> USB mass storage and removable media (for testing mode page 3f use) were
> not tested, if you have a USB storage device that still chokes on mode
> sense 3f please give this a spin.
> 
>  drivers/scsi/scsi_devinfo.c    |   15 +++++++++++----
>  drivers/scsi/scsi_devinfo.h    |   17 -----------------
>  drivers/scsi/scsi_priv.h       |    3 ++-
>  drivers/scsi/scsi_scan.c       |   17 +++++++++++++----
>  drivers/scsi/sd.c              |    9 +++++++++
>  drivers/usb/storage/scsiglue.c |    8 ++++----
>  include/scsi/scsi_device.h     |    2 ++
>  include/scsi/scsi_devinfo.h    |   22 ++++++++++++++++++++++
>  include/scsi/scsi_host.h       |    6 ++++++
>  9 files changed, 69 insertions(+), 30 deletions(-)
> 
> diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/scsi_devinfo.c ms-flags-bl-25/drivers/scsi/scsi_devinfo.c
> --- bl-25/drivers/scsi/scsi_devinfo.c	Mon Sep 22 13:08:53 2003
> +++ ms-flags-bl-25/drivers/scsi/scsi_devinfo.c	Fri Oct  3 14:39:03 2003
> @@ -6,10 +6,11 @@
>  #include <linux/moduleparam.h>
>  #include <linux/proc_fs.h>
>  #include <linux/seq_file.h>
> +#include <scsi/scsi_devinfo.h>
>  
>  #include "scsi.h"
> +#include "hosts.h"
>  #include "scsi_priv.h"
> -#include "scsi_devinfo.h"
>  
>  /*
>   * scsi_dev_info_list: structure to hold black/white listed devices.
> @@ -322,11 +323,17 @@ static int scsi_dev_info_list_add_str(ch
>   * Description:
>   *     Search the scsi_dev_info_list for an entry matching @vendor and
>   *     @model, if found, return the matching flags value, else return
> - *     scsi_default_dev_flags.
> + *     the host or global default settings.
>   **/
> -int scsi_get_device_flags(unsigned char *vendor, unsigned char *model)
> +int scsi_get_device_flags(struct scsi_device *sdev, unsigned char *vendor,
> +			  unsigned char *model)
>  {
>  	struct scsi_dev_info_list *devinfo;
> +	unsigned int bflags;
> +
> +	bflags = sdev->host->hostt->flags;
> +	if (!bflags)
> +		bflags = scsi_default_dev_flags;
>  
>  	list_for_each_entry(devinfo, &scsi_dev_info_list, dev_info_list) {
>  		if (devinfo->compatible) {
> @@ -378,7 +385,7 @@ int scsi_get_device_flags(unsigned char 
>  				return devinfo->flags;
>  		}
>  	}
> -	return scsi_default_dev_flags;
> +	return bflags;
>  }
>  
>  #ifdef CONFIG_SCSI_PROC_FS
> diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/scsi_devinfo.h ms-flags-bl-25/drivers/scsi/scsi_devinfo.h
> --- bl-25/drivers/scsi/scsi_devinfo.h	Mon Sep 22 13:08:53 2003
> +++ ms-flags-bl-25/drivers/scsi/scsi_devinfo.h	Wed Dec 31 16:00:00 1969
> @@ -1,17 +0,0 @@
> -
> -/*
> - * Flags for SCSI devices that need special treatment
> - */
> -#define BLIST_NOLUN     	0x001	/* Only scan LUN 0 */
> -#define BLIST_FORCELUN  	0x002	/* Known to have LUNs, force scanning */
> -#define BLIST_BORKEN    	0x004	/* Flag for broken handshaking */
> -#define BLIST_KEY       	0x008	/* unlock by special command */
> -#define BLIST_SINGLELUN 	0x010	/* Do not use LUNs in parallel */
> -#define BLIST_NOTQ		0x020	/* Buggy Tagged Command Queuing */
> -#define BLIST_SPARSELUN 	0x040	/* Non consecutive LUN numbering */
> -#define BLIST_MAX5LUN		0x080	/* Avoid LUNS >= 5 */
> -#define BLIST_ISROM     	0x100	/* Treat as (removable) CD-ROM */
> -#define BLIST_LARGELUN		0x200	/* LUNs past 7 on a SCSI-2 device */
> -#define BLIST_INQUIRY_36	0x400	/* override additional length field */
> -#define BLIST_INQUIRY_58	0x800	/* ... for broken inquiry responses */
> -#define BLIST_NOSTARTONADD      0x1000  /* do not do automatic start on add */
> diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/scsi_priv.h ms-flags-bl-25/drivers/scsi/scsi_priv.h
> --- bl-25/drivers/scsi/scsi_priv.h	Mon Sep 29 12:21:09 2003
> +++ ms-flags-bl-25/drivers/scsi/scsi_priv.h	Fri Oct  3 11:13:50 2003
> @@ -85,7 +85,8 @@ extern void scsi_init_cmd_from_req(struc
>  extern void __scsi_release_request(struct scsi_request *sreq);
>  
>  /* scsi_devinfo.c */
> -extern int scsi_get_device_flags(unsigned char *vendor, unsigned char *model);
> +extern int scsi_get_device_flags(struct scsi_device *sdev,
> +				 unsigned char *vendor, unsigned char *model);
>  extern int scsi_init_devinfo(void);
>  extern void scsi_exit_devinfo(void);
>  
> diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/scsi_scan.c ms-flags-bl-25/drivers/scsi/scsi_scan.c
> --- bl-25/drivers/scsi/scsi_scan.c	Mon Sep 29 12:21:09 2003
> +++ ms-flags-bl-25/drivers/scsi/scsi_scan.c	Fri Oct  3 11:13:50 2003
> @@ -35,10 +35,10 @@
>  #include "scsi.h"
>  #include "hosts.h"
>  #include <scsi/scsi_driver.h>
> +#include <scsi/scsi_devinfo.h>
>  
>  #include "scsi_priv.h"
>  #include "scsi_logging.h"
> -#include "scsi_devinfo.h"
>  
>  #define ALLOC_FAILURE_MSG	KERN_ERR "%s: Allocation failure during" \
>  	" SCSI scanning, some SCSI devices might not be configured\n"
> @@ -365,7 +365,7 @@ static void scsi_probe_lun(struct scsi_r
>  	 * bit fields in Scsi_Device, so bflags need not be passed as an
>  	 * argument.
>  	 */
> -	*bflags |= scsi_get_device_flags(&inq_result[8], &inq_result[16]);
> +	*bflags |= scsi_get_device_flags(sdev, &inq_result[8], &inq_result[16]);
>  
>  	possible_inq_resp_len = (unsigned char) inq_result[4] + 5;
>  	if (BLIST_INQUIRY_36 & *bflags)
> @@ -625,7 +625,15 @@ static int scsi_add_lun(struct scsi_devi
>  	sdev->max_device_blocked = SCSI_DEFAULT_DEVICE_BLOCKED;
>  
>  	sdev->use_10_for_rw = 1;
> -	sdev->use_10_for_ms = 0;
> +
> +	if (*bflags & BLIST_MS_SKIP_PAGE_08)
> +		sdev->skip_ms_page_8 = 1;
> +
> +	if (*bflags & BLIST_MS_SKIP_PAGE_3F)
> +		sdev->skip_ms_page_3f = 1;
> +
> +	if (*bflags & BLIST_USE_10_BYTE_MS)
> +		sdev->use_10_for_ms = 1;
>  
>  	if(sdev->host->hostt->slave_configure)
>  		sdev->host->hostt->slave_configure(sdev);
> @@ -678,7 +686,8 @@ static int scsi_probe_and_add_lun(struct
>  			if (sdevp)
>  				*sdevp = sdev;
>  			if (bflagsp)
> -				*bflagsp = scsi_get_device_flags(sdev->vendor,
> +				*bflagsp = scsi_get_device_flags(sdev,
> +								 sdev->vendor,
>  								 sdev->model);
>  			return SCSI_SCAN_LUN_PRESENT;
>  		}
> diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/sd.c ms-flags-bl-25/drivers/scsi/sd.c
> --- bl-25/drivers/scsi/sd.c	Mon Sep 29 12:21:09 2003
> +++ ms-flags-bl-25/drivers/scsi/sd.c	Fri Oct  3 14:18:15 2003
> @@ -1057,6 +1057,11 @@ sd_read_write_protect_flag(struct scsi_d
>  	int res;
>  	struct scsi_mode_data data;
>  
> +	if (sdkp->device->skip_ms_page_3f) {
> +		printk(KERN_NOTICE "%s: assuming Write Enabled\n", diskname);
> +		return;
> +	}
> +
>  	/*
>  	 * First attempt: ask for all pages (0x3F), but only 4 bytes.
>  	 * We have to start carefully: some devices hang if we ask
> @@ -1103,6 +1108,8 @@ sd_read_cache_type(struct scsi_disk *sdk
>  	const int modepage = 0x08; /* current values, cache page */
>  	struct scsi_mode_data data;
>  
> +	if (sdkp->device->skip_ms_page_8)
> +		goto defaults;
>  
>  	/* cautiously ask */
>  	res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, 4, &data);
> @@ -1160,6 +1167,8 @@ bad_sense:
>  		printk(KERN_ERR "%s: asking for cache data failed\n",
>  		       diskname);
>  	}
> +
> +defaults:
>  	printk(KERN_ERR "%s: assuming drive cache: write through\n",
>  	       diskname);
>  	sdkp->WCE = 0;
> diff -uprN -X /home/patman/dontdiff bl-25/drivers/usb/storage/scsiglue.c ms-flags-bl-25/drivers/usb/storage/scsiglue.c
> --- bl-25/drivers/usb/storage/scsiglue.c	Mon Sep 22 13:08:56 2003
> +++ ms-flags-bl-25/drivers/usb/storage/scsiglue.c	Fri Oct  3 11:13:50 2003
> @@ -51,6 +51,7 @@
>  
>  #include <linux/slab.h>
>  #include <linux/module.h>
> +#include <scsi/scsi_devinfo.h>
>  
>  
>  /***********************************************************************
> @@ -64,10 +65,6 @@ static const char* host_info(struct Scsi
>  
>  static int slave_configure (struct scsi_device *sdev)
>  {
> -	/* set device to use 10-byte commands where possible */
> -	sdev->use_10_for_ms = 1;
> -	sdev->use_10_for_rw = 1;
> -
>  	/* this is to satisify the compiler, tho I don't think the 
>  	 * return code is ever checked anywhere. */
>  	return 0;
> @@ -324,6 +321,9 @@ struct scsi_host_template usb_stor_host_
>  	/* emulated HBA */
>  	.emulated =			TRUE,
>  
> +	/* modify scsi_device bits on probe */
> +	.flags = (BLIST_MS_SKIP_PAGE_08 | BLIST_USE_10_BYTE_MS),
> +
>  	/* module management */
>  	.module =			THIS_MODULE
>  };
> diff -uprN -X /home/patman/dontdiff bl-25/include/scsi/scsi_device.h ms-flags-bl-25/include/scsi/scsi_device.h
> --- bl-25/include/scsi/scsi_device.h	Mon Sep 29 12:21:10 2003
> +++ ms-flags-bl-25/include/scsi/scsi_device.h	Fri Oct  3 11:13:50 2003
> @@ -86,6 +86,8 @@ struct scsi_device {
>  				     * because we did a bus reset. */
>  	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
>  	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
> +	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
> +	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
>  	unsigned no_start_on_add:1;	/* do not issue start on add */
>  
>  	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
> diff -uprN -X /home/patman/dontdiff bl-25/include/scsi/scsi_devinfo.h ms-flags-bl-25/include/scsi/scsi_devinfo.h
> --- bl-25/include/scsi/scsi_devinfo.h	Wed Dec 31 16:00:00 1969
> +++ ms-flags-bl-25/include/scsi/scsi_devinfo.h	Fri Oct  3 11:17:58 2003
> @@ -0,0 +1,22 @@
> +#ifndef _SCSI_SCSI_DEVINFO_H
> +#define _SCSI_SCSI_DEVINFO_H
> +/*
> + * Flags for SCSI devices that need special treatment
> + */
> +#define BLIST_NOLUN     	0x001	/* Only scan LUN 0 */
> +#define BLIST_FORCELUN  	0x002	/* Known to have LUNs, force scanning */
> +#define BLIST_BORKEN    	0x004	/* Flag for broken handshaking */
> +#define BLIST_KEY       	0x008	/* unlock by special command */
> +#define BLIST_SINGLELUN 	0x010	/* Do not use LUNs in parallel */
> +#define BLIST_NOTQ		0x020	/* Buggy Tagged Command Queuing */
> +#define BLIST_SPARSELUN 	0x040	/* Non consecutive LUN numbering */
> +#define BLIST_MAX5LUN		0x080	/* Avoid LUNS >= 5 */
> +#define BLIST_ISROM     	0x100	/* Treat as (removable) CD-ROM */
> +#define BLIST_LARGELUN		0x200	/* LUNs past 7 on a SCSI-2 device */
> +#define BLIST_INQUIRY_36	0x400	/* override additional length field */
> +#define BLIST_INQUIRY_58	0x800	/* ... for broken inquiry responses */
> +#define BLIST_NOSTARTONADD	0x1000	/* do not do automatic start on add */
> +#define BLIST_MS_SKIP_PAGE_08	0x2000	/* do not send ms page 0x08 */
> +#define BLIST_MS_SKIP_PAGE_3F	0x4000	/* do not send ms page 0x3f */
> +#define BLIST_USE_10_BYTE_MS	0x8000	/* use 10 byte ms before 6 byte ms */
> +#endif
> diff -uprN -X /home/patman/dontdiff bl-25/include/scsi/scsi_host.h ms-flags-bl-25/include/scsi/scsi_host.h
> --- bl-25/include/scsi/scsi_host.h	Mon Sep 29 12:21:10 2003
> +++ ms-flags-bl-25/include/scsi/scsi_host.h	Fri Oct  3 11:19:38 2003
> @@ -344,6 +344,12 @@ struct scsi_host_template {
>  	 * module_init/module_exit.
>  	 */
>  	struct list_head legacy_hosts;
> +
> +	/*
> +	 * Default flags settings, these modify the setting of scsi_device
> +	 * bits.
> +	 */
> +	unsigned int flags;
>  };
>  
>  /*
> 


From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 04/24] scsi: introduce sdev_prefix_printk()
Date: Thu, 2 Oct 2014 18:37:49 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCAB53@G4W3202.americas.hpqcorp.net>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
 <1412144580-72880-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:12052 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaJBSix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 14:38:53 -0400
In-Reply-To: <1412144580-72880-5-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
...
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 4c3ab83..c01dc89 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -103,9 +103,10 @@ static inline struct scsi_disk *scsi_disk(struct gendisk
> *disk)
> 
>  #define sd_printk(prefix, sdsk, fmt, a...)				\
>          (sdsk)->disk ?							\
> -	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\
> -		    (sdsk)->disk->disk_name, ##a) :			\
> -	sdev_printk(prefix, (sdsk)->device, fmt, ##a)
> +	      sdev_prefix_printk(prefix, (sdsk)->device,		\
> +				 (sdsk)->disk->disk_name, fmt, ##a) :	\
> +	      sdev_prefix_printk(prefix, (sdsk)->device,		\
> +				 NULL, fmt, ##a)
> 
>  #define sd_first_printk(prefix, sdsk, fmt, a...)			\
>  	do {								\
...
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 27ecee7..0b18a09 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -244,6 +244,15 @@ struct scsi_dh_data {
>  #define sdev_dbg(sdev, fmt, a...) \
>  	dev_dbg(&(sdev)->sdev_gendev, fmt, ##a)
> 
> +/*
> + * like scmd_printk, but the device name is passed in
> + * as a string pointer
> + */
> +#define sdev_prefix_printk(l, sdev, p, fmt, a...)			\
> +	(p) ?								\
> +	sdev_printk(l, sdev, "[%s] " fmt, p, ##a) :			\
> +	sdev_printk(l, sdev, fmt, ##a)
> +
>  #define scmd_printk(prefix, scmd, fmt, a...)				\
>          (scmd)->request->rq_disk ?					\
>  	sdev_printk(prefix, (scmd)->device, "[%s] " fmt,		\
> --
> 1.8.5.2

This triggers lots of compiler warnings with gcc 4.4.7 like:

drivers/scsi/sd.c: In function 'sd_open':
drivers/scsi/sd.c:1179: warning: reading through null pointer (argument 4)
drivers/scsi/sd.c:1179: warning: format '%s' expects type 'char *', but argument 4 has type 'void *'


That is from:
        SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_open\n"));

Since:
#define NULL ((void *)0)

gcc probably doesn't realize the (p)? prevents the NULL (a void *) 
from being passed to sdev_printk.

Passing "" rather than NULL eliminates the compiler warnings.

There should probably be a () around p in the sdev_printk call, too.


---
Rob Elliott    HP Server Storage




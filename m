From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi_device refcounting and list lockdown
Date: 30 Oct 2003 16:41:01 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067553662.1839.363.camel@mulgrave>
References: <20031027155713.GA28140@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:23812 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262611AbTJ3WlL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 17:41:11 -0500
In-Reply-To: <20031027155713.GA28140@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-10-27 at 09:57, Christoph Hellwig wrote:
> --- 1.44/drivers/scsi/53c700.c	Sat Sep 20 11:35:53 2003
> +++ edited/drivers/scsi/53c700.c	Mon Oct 27 12:01:48 2003
> @@ -1057,15 +1057,18 @@
>  		__u8 lun;
>  		struct NCR_700_command_slot *slot;
>  		__u8 reselection_id = hostdata->reselection_id;
> -		Scsi_Device *SDp;
> +		struct scsi_device *SDp;
> +		unsigned long flags;
>  
>  		lun = hostdata->msgin[0] & 0x1f;
>  
>  		hostdata->reselection_id = 0xff;
>  		DEBUG(("scsi%d: (%d:%d) RESELECTED!\n",
>  		       host->host_no, reselection_id, lun));
> +
>  		/* clear the reselection indicator */
> -		SDp = scsi_find_device(host, 0, reselection_id, lun);
> +		spin_lock_irqsave(host->host_lock, flags);
> +		SDp = __scsi_device_lookup(host, 0, reselection_id, lun);
>  		if(unlikely(SDp == NULL)) {
>  			printk(KERN_ERR "scsi%d: (%d:%d) HAS NO device\n",
>  			       host->host_no, reselection_id, lun);

This is wrong.  The messages are processed in the middle of a SCSI
transaction, so the host lock is already held.

[...]

> ===== drivers/scsi/scsi.h 1.91 vs edited =====
> --- 1.91/drivers/scsi/scsi.h	Sat Sep 20 13:50:50 2003
> +++ edited/drivers/scsi/scsi.h	Mon Oct 27 12:01:41 2003
> @@ -116,12 +116,6 @@
>  #define scsi_to_pci_dma_dir(scsi_dir)	((int)(scsi_dir))
>  #define scsi_to_sbus_dma_dir(scsi_dir)	((int)(scsi_dir))
>  
> -/*
> - * This is the crap from the old error handling code.  We have it in a special
> - * place so that we can more easily delete it later on.
> - */
> -#include "scsi_obsolete.h"
> -
>  /* obsolete typedef junk. */
>  #include "scsi_typedefs.h"


This isn't a bug fix, and removing the obsolete include breaks all of
the drivers relying on its defines (cpqfc, qlogicisp, qlogicfc,
ncr53c8xx etc.)

> ===== drivers/scsi/scsi_error.c 1.65 vs edited =====
> --- 1.65/drivers/scsi/scsi_error.c	Sun Sep 21 19:49:36 2003
> +++ edited/drivers/scsi/scsi_error.c	Mon Oct 27 12:01:49 2003
> @@ -22,11 +22,10 @@
>  #include <linux/kernel.h>
>  #include <linux/interrupt.h>
>  #include <linux/blkdev.h>
> -#include <linux/smp_lock.h>

This is a required include for lock/unlock_kernel() calls used in the
error handler thread.

> ===== include/scsi/scsi_host.h 1.12 vs edited =====
> --- 1.12/include/scsi/scsi_host.h	Thu Oct 16 10:56:58 2003
> +++ edited/include/scsi/scsi_host.h	Mon Oct 27 12:01:50 2003
> @@ -125,15 +125,6 @@
>  	int (* eh_host_reset_handler)(struct scsi_cmnd *);
>  
>  	/*
> -	 * Old EH handlers, no longer used. Make them warn the user of old
> -	 * drivers by using a wrong type
> -	 *
> -	 * Status: MORE THAN OBSOLETE
> -	 */
> -	int (* abort)(int);
> -	int (* reset)(int, int);
> -
> -	/*

This isn't a bugfix either...it will just break unconverted drivers.

James



From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi_debug against lk 2.5.69+mikea
Date: Wed, 7 May 2003 06:45:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030507134523.GA1727@beaverton.ibm.com>
References: <3EB90979.90600@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:11429 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S263186AbTEGNaw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2003 09:30:52 -0400
Content-Disposition: inline
In-Reply-To: <3EB90979.90600@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert [dougg@torque.net] wrote:
> Found a small problem with scsi_debug while
> playing with rescan-scsi-bus.sh . This patch
> is against Mike Anderson's scsi hosts sysfs
> patchset (since that version has my most
> recent scsi_debug changes).
> 
> Doug Gilbert

> --- linux/drivers/scsi/scsi_debug.c	2003-05-05 20:49:16.000000000 +1000
> +++ linux/drivers/scsi/scsi_debug.c2569ma_d1	2003-05-07 12:04:21.000000000 +1000
> @@ -54,7 +54,7 @@
>  
>  #include "scsi_debug.h"
>  
> -static const char * scsi_debug_version_str = "Version: 1.70 (20030416)";
> +static const char * scsi_debug_version_str = "Version: 1.70 (20030507)";
>  
>  /* Additional Sense Code (ASC) used */
>  #define NO_ADDED_SENSE 0x0
> @@ -271,9 +271,10 @@
>  	}
>  
>          if(target == sdebug_driver_template.this_id) {
> -                printk(KERN_WARNING 
> -		       "scsi_debug: initiator's id used as target!\n");
> -		return schedule_resp(SCpnt, NULL, done, 0, 0);
> +                printk(KERN_INFO "scsi_debug: initiator's id used as "
> +		       "target!\n");
> +		return schedule_resp(SCpnt, NULL, done, 
> +				     DID_NO_CONNECT << 16, 0);
>          }
>  
>  	if (SCpnt->device->lun >= scsi_debug_max_luns)
> @@ -866,7 +867,7 @@
>  static void timer_intr_handler(unsigned long indx)
>  {
>  	struct sdebug_queued_cmd * sqcp;
> -	unsigned int iflags;
> +	unsigned long iflags;
>  
>  	if (indx >= SCSI_DEBUG_CANQUEUE) {
>  		printk(KERN_ERR "scsi_debug:timer_intr_handler: indx too "

You may want to resync against James scsi-misc-2.5. The
timer_intr_handler is already taken care of, and with the template
inclusion in the *.c file the offsets are off by a bit. I need to make a
couple of changes at the bottom of the file. I will send the diffs
out to the list later on today.


-andmike
--
Michael Anderson
andmike@us.ibm.com


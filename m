From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] fix for sd removal loop
Date: Fri, 16 Aug 2002 12:23:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020816192312.GD1618@beaverton.ibm.com>
References: <20020816125256.E1216@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from northrelay03.pok.ibm.com (northrelay03.pok.ibm.com [9.56.224.151])
	by e2.ny.us.ibm.com (8.12.2/8.12.2) with ESMTP id g7GJMHha282196
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2002 15:22:17 -0400
Content-Disposition: inline
In-Reply-To: <20020816125256.E1216@austin.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: sullivan <sullivan@austin.ibm.com>
Cc: linux-scsi@vger.kernel.org

Mike S,

While this fix solves the problem it looks odd to have a
signed value for an array size.

What about checking "sd_registered" just after
scsi_unregister_device in exit_sd.

-Mike A
sullivan [sullivan@austin.ibm.com] wrote:
> Attached is a trivial fix for an excessive loop that is encountered in
> removal of the sd module. This case is hit when sd is insmod'ed and rmmod'ed
> without any scsi devices being registered. In this case, within exit_sd(), 
> sd_template.dev_max remains at zero and the N_USED_SD_MAJORS macro yields an 
> incorrect result since it is treating dev_max as an signed number. 
> 
> 

> diff -Nau --exclude='p.*' linux-2.5-devclass/drivers/scsi/hosts.h linux-2.5-devclass-mike/drivers/scsi/hosts.h
> --- linux-2.5-devclass/drivers/scsi/hosts.h	Fri Aug 16 19:42:09 2002
> +++ linux-2.5-devclass-mike/drivers/scsi/hosts.h	Wed Aug 14 23:32:55 2002
> @@ -519,7 +519,7 @@
>      unsigned int max_major;      /* Maximum major in range. */
>      unsigned int nr_dev;	  /* Number currently attached */
>      unsigned int dev_noticed;	  /* Number of devices detected. */
> -    unsigned int dev_max;	  /* Current size of arrays */
> +    signed int dev_max;	  /* Current size of arrays */
>      unsigned blk:1;		  /* 0 if character device */
>      int (*detect)(Scsi_Device *); /* Returns 1 if we can attach this device */
>      int (*init)(void);		  /* Sizes arrays based upon number of devices


-- 
Michael Anderson
andmike@us.ibm.com


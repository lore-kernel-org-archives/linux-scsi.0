From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] async scsi scanning, version 11
Date: Sun, 24 Sep 2006 13:02:53 -0700
Message-ID: <20060924130253.48f90fe5.rdunlap@xenotime.net>
References: <20060924190623.GB2595@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:57269 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1750988AbWIXUBm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Sep 2006 16:01:42 -0400
Received: from midway.site ([71.117.233.155]) by xenotime.net for <linux-scsi@vger.kernel.org>; Sun, 24 Sep 2006 13:01:39 -0700
In-Reply-To: <20060924190623.GB2595@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Sun, 24 Sep 2006 13:06:24 -0600 Matthew Wilcox wrote:

> 
> OK, this is the 11th version of this patch.  Since the FC people don't
> seem to have time to look into why their drivers still take
> forever-and-a-day to initialise, I've dropped all the support for
> non-parallel-scsi from this version of the patch.
> 
> Still outstanding:
> 
>  - The comment at the top of scsi_sysfs_add_devices().  I'd really like
>    someone like James or Christoph to tell me what they prefer.
> 
> Other changes:
>  - I've rejigged how we wait for async scans to complete.  Now we
>    compile scsi_wait_scan in, even for the non-modular case.  Fewer
>    ifdefs, less mucking around in the Makefile, more commonality between
>    the modular and non-modular cases.

Do parts of Documentation/scsi/scsi_low_mid_api.txt need to be
updated also?
or are all of these changes outside of the low_mid realm?


> +/**
> + * scsi_prep_async_scan - prepare for an async scan
> + * @shost: the host which will be scanned
> + * Returns: a cookie to be passed to scsi_finish_async_scan()
> + *
> + * Tells the midlayer this host is going to do an asynchronous scan.
> + * It reserves the host's position in the scanning list and ensures
> + * that other asynchronous scans started after this one won't affect the
> + * ordering of the discovered devices.
> + */
> +struct async_scan_data * scsi_prep_async_scan(struct Scsi_Host *shost)

whitespace violation (*scsi_prep_async_scan)

> +{

and thanks for adding/using kernel-doc.

---
~Randy

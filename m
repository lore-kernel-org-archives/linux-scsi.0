From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] Allow random write for PDT 5 profile 2 Removable Disk
Date: Thu, 12 Feb 2004 12:10:07 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040212111007.GB26397@suse.de>
References: <1076536919.3112.149.camel@lintest.iomegacorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:20956 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266270AbUBLLKg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2004 06:10:36 -0500
Received: from brick.kernel.dk ([62.242.22.158] helo=wiggum.home.kernel.dk)
	by virtualhost.dk with esmtp (Exim 3.36 #1)
	id 1ArEjs-0008Uz-00
	for linux-scsi@vger.kernel.org; Thu, 12 Feb 2004 12:10:36 +0100
Received: from axboe by wiggum.home.kernel.dk with local (Exim 4.22)
	id 1ArEjr-00071r-0a
	for linux-scsi@vger.kernel.org; Thu, 12 Feb 2004 12:10:35 +0100
Content-Disposition: inline
In-Reply-To: <1076536919.3112.149.camel@lintest.iomegacorp.com>
List-Id: linux-scsi@vger.kernel.org
To: John McKell <mckellj@iomega.com>
Cc: linux-scsi-@vger.kernel.org

On Wed, Feb 11 2004, John McKell wrote:
> Jens,
> 
> I see linux-2.6.2 extends the list of writable PDT x05 DVD/CD devices
> to include MRW, not just DVD-RAM and MO.
> 
> With that change in place, this small further patch allows write
> through to PDT 0x05 DVD/CD for profile x0002 Removable Disk:
> 
> a) if feature x0020 "Random Writable" present (no matter if current or
> not) at plug-in time, and...
> 
> b) if feature x0024 "Hardware Defect Management" present (no matter if
> current or not) at plug-in time, and...
> 
> c) if both features "current" at /dev/* open time (e.g., mount time),
> and ...
> 
> d) the device in question is not any of MRW, MRW_W, DVD_RAM, CD_R,
> CD_RW, DVD, DVD_R
> 
> Since 1999 MMC-2, MMC says these tests in combination say this device
> writes at random like DVD-RAM: no load balancing (aka wear leveling)
> required and blocks of the size the x0020 feature reports (64 KiB if
> like CD, 32 KiB if like DVD).
> 
> This composite version of this patch includes the already posted
> patch:
> 
> Subject:[PATCH] DVD-R capability flag set incorrectly, /proc
>                 formatting fix
> http://marc.theaimsgroup.com/?l=linux-scsi&m=107637086904512&w=2
> 
> Please let me know if you'd rather have an incremental patch.

I need an incremental patch, your previous one is already included in
mainline BK tree.

A few small comments, only nitpicks (as the general patch looks fine).
Since you need to rediff it anyways, can you fix these up? Then it can
be submitted. Thanks!

> --- linux-2.6.2/include/linux/cdrom.h	2004-02-03 20:43:06.000000000 -0700
> +++ linux/include/linux/cdrom.h	2004-02-07 15:21:53.000000000 -0700
> @@ -721,7 +721,9 @@ struct request_sense {
>  /*
>   * feature profile
>   */
> -#define CDF_MRW		0x28
> +#define CDF_RWRT	0x0020
> +#define CDF_HWDM	0x0024
> +#define CDF_MRW		0x0028

Tabs

> +	if (!cdrom_is_random_writable(cdi, &ram_write)) {
> +		if (ram_write) {
> +			CDROM_CONFIG_FLAGS(drive)->ram = 1;
> +		}
> +	}

Brace styling

>  	if (cap.lock == 0)
>  		CDROM_CONFIG_FLAGS(drive)->no_doorlock = 1;
>  	if (cap.eject)
> --- linux-2.6.2/drivers/scsi/sr.c	2004-02-03 20:43:19.000000000 -0700
> +++ linux/drivers/scsi/sr.c	2004-02-10 16:39:23.000000000 -0700
> @@ -693,7 +693,7 @@ Enomem:
>  static void get_capabilities(struct scsi_cd *cd)
>  {
>  	unsigned char *buffer;
> -	int rc, n, mrw_write = 0, mrw = 1;
> +	int rc, n, mrw_write = 0, mrw = 1,ram_write=0;
>  	struct scsi_mode_data data;
>  	struct scsi_request *SRpnt;
>  	unsigned char cmd[MAX_COMMAND_SIZE];
> @@ -775,6 +775,12 @@ static void get_capabilities(struct scsi
>  	if (!mrw_write)
>  		cd->cdi.mask |= CDC_MRW_W;
>  
> +	if (cdrom_is_random_writable(&cd->cdi, &ram_write)) {
> +		cd->cdi.mask |= CDC_RAM;
> +	}
> +	if (!ram_write)
> +		cd->cdi.mask |= CDC_RAM;

Brace styling again

> --- linux-2.6.2/drivers/cdrom/cdrom.c	2004-02-05 14:30:46.000000000 -0700
> +++ linux/drivers/cdrom/cdrom.c	2004-02-11 11:14:23.995187637 -0700
> @@ -641,6 +641,80 @@ static int cdrom_mrw_set_lba_space(struc
>  	return 0;
>  }
>  
> +int cdrom_get_random_writable(struct cdrom_device_info *cdi, 
> +			      struct rwrt_feature_desc *rfd)

Little detail - but you have several lines with extra white space at the
end. You can probably make your editor high light these for you.

-- 
Jens Axboe


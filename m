From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Thu, 19 Jun 2008 10:12:58 -0700
Message-ID: <20080619171258.GA819@linux.vnet.ibm.com>
References: <20080619160342.GJ4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49763 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbYFSRND (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jun 2008 13:13:03 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5JHD26U008775
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jun 2008 13:13:02 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5JHD2sC111162
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jun 2008 13:13:02 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5JHD2ej020826
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jun 2008 13:13:02 -0400
Content-Disposition: inline
In-Reply-To: <20080619160342.GJ4392@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox <matthew@wil.cx> wrote:
> Use the noop elevator by default for drives that do not spin
> 
> [Not for applying]
> 
> SSDs do not benefit from the elevator.  It just wastes precious CPU cycles.
> By selecting the noop elevator by default, we can shave a few microseconds
> off each IO.
> 
> I've brazenly stolen sd_vpd_inquiry from mkp's patch here:
> 
> http://marc.info/?l=linux-scsi&m=121264354724277&w=2
> 
> No need to have two copies of that ... but this will conflict with his code.
> 

Why would we want to do this in the kernel instead of a udev rule
similar to how we set timeouts. Since there already exists a sysfs
interface to change the IO scheduler it would seem this would be more
flexible in case someone did not like the kernel policy selected.

You would need some tool to obtain the vpd data from user space that would
always be installed.

There was some past discussion on replacing scsi_id with a better tool
to support more options. url provided below.
http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/5289/focus=5301

> On to the self-criticism:
> 
> I don't intend the final version of this patch to include a printk for
> the RPM or even a printk to say we switched IO elevator.  I think we're
> too verbose in SCSI as it is.
> 
> I think there's an opportunity to improve sd_vpd_inquiry() to remove
> some of the duplicate code between sd_set_elevator() and sd_block_limits,
> but it's not terribly important.
> 
> The switching of the elevators isn't particularly nice.  I assume that
> elevator_init("noop") cannot fail, which isn't true.  It would be nice
> to use the #if 0 block instead, but that causes a null ptr dereference
> inside sysfs -- I suspect something isn't set up correctly.
> 
> Not-signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 01cefbb..1c5a296 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1534,6 +1534,79 @@ defaults:
>  	sdkp->DPOFUA = 0;
>  }
> 
> +static int sd_vpd_inquiry(struct scsi_disk *sdkp, unsigned char *buffer, u8 page, u8 len)
> +{
> +	int result;
> +	unsigned char cmd[16];
> +	struct scsi_sense_hdr sshdr;
> +
> +	memset(cmd, 0, 16);
> +	cmd[0] = INQUIRY;
> +	cmd[1] = 1;		/* EVPD */
> +	cmd[2] = page;		/* VPD page */
> +	cmd[3] = len;
> +	
> +	result = scsi_execute_req(sdkp->device, cmd, DMA_FROM_DEVICE, buffer,
> +				  len, &sshdr, SD_TIMEOUT, SD_MAX_RETRIES);
> +
> +	if (media_not_present(sdkp, &sshdr))
> +		return -EIO;
> +
> +	if (result) {
> +		sd_printk(KERN_ERR, sdkp, "EVPD Inquiry failed\n");
> +		return -EIO;
> +	}
> +
> +	if (buffer[1] != page) {
> +		sd_printk(KERN_ERR, sdkp, "Page code not %2x (%2x)\n", page,
> +			  buffer[1]);
> +		return -EIO;
> +	}
> +
> +	return buffer[3];
> +}
> +
> +static void sd_set_elevator(struct scsi_disk *sdkp, unsigned char *buffer)
> +{
> +	struct scsi_device *sdp = sdkp->device;
> +	int res, i, rotation;
> +
> +	res = sd_vpd_inquiry(sdkp, buffer, 0, 255);
> +	if (res < 0)
> +		return;
> +
> +	for (i = 0; i < buffer[3]; i++)
> +		if (buffer[i + 4] == 0xb1)
> +			goto found;
> +	return;
> +
> + found:
> +	res = sd_vpd_inquiry(sdkp, buffer, 0xb1, 64);
> +	if (res < 0)
> +		return;
> +
> +	rotation = (buffer[4] << 8) | buffer[5];
> +
> +	if (rotation == 0)
> +		return;
> +
> +	if (rotation == 0x0001) {
> +#if 0
> +		res = elv_iosched_store(sdp->request_queue, "noop", 5);
> +		if (res >= 0)
> +			sd_printk(KERN_INFO, sdkp,
> +						"Switched to noop elevator\n");
> +#else
> +		elevator_exit(sdp->request_queue->elevator);
> +		sdp->request_queue->elevator = NULL;
> +		elevator_init(sdp->request_queue, "noop");
> +		sd_printk(KERN_INFO, sdkp, "Switched to noop elevator\n");
> +#endif
> +	} else if (rotation > 0x400) {
> +		sd_printk(KERN_INFO, sdkp, "%u RPM drive", rotation);
> +	}
> +}
> +
>  /**
>   *	sd_revalidate_disk - called the first time a new disk is seen,
>   *	performs disk spin up, read_capacity, etc.
> @@ -1581,6 +1654,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  		sd_read_capacity(sdkp, buffer);
>  		sd_read_write_protect_flag(sdkp, buffer);
>  		sd_read_cache_type(sdkp, buffer);
> +		sd_set_elevator(sdkp, buffer);
>  	}
> 
>  	/*
> -- 
> Intel are signing my paycheques ... these opinions are still mine
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com

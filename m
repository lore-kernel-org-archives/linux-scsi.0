From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] SCSI/sd: Fix NULL dereference in sd_revalidate_disk
Date: Sat, 26 Nov 2011 10:51:46 +0100
Message-ID: <20111126105146.756a122a@stein>
References: <CA+v9cxbk0p_FTDq7TMEc5draOMz4n46H4t=iLe2brkosM=LHVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:47904 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1KZJwk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Nov 2011 04:52:40 -0500
In-Reply-To: <CA+v9cxbk0p_FTDq7TMEc5draOMz4n46H4t=iLe2brkosM=LHVw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Huajun Li <huajun.li.lee@gmail.com>
Cc: JBottomley@Parallels.com, linux-scsi@vger.kernel.org

On Nov 24 Huajun Li wrote:
>   While unplugging usb disk, scsi_disk(disk)->device  may be released
> before sd_revalidate_disk() is called, then there will occur Oops as
> shown below:
[...]
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2354,10 +2354,15 @@ static int sd_try_extended_inquiry(struct
> scsi_device *sdp)
>  static int sd_revalidate_disk(struct gendisk *disk)
>  {
>  	struct scsi_disk *sdkp = scsi_disk(disk);
> -	struct scsi_device *sdp = sdkp->device;
> +	struct scsi_device *sdp;
>  	unsigned char *buffer;
>  	unsigned flush = 0;
> 
> +	if (sdkp)
> +		sdp = sdkp->device;
> +	else
> +		goto out;
> +
>  	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
>  				      "sd_revalidate_disk\n"));
> 

Shouldn't rather the [block -- command-set-driver -- scsi-core -- lld]
stack be structured along the lines that lower-level device instances live
as long as higher levels rely on them?

For about a year now or so, I am seeing patches floating by that add NULL
pointer checks here and there (or patches that clear pointers), and every
time I wonder
  - where else such NULL pointer checks might be needed,
  - in what way (if at all) it is ensured that a function which is made to
    check for a valid pointer at the top does not race with pointer
    invalidation further down the road.
-- 
Stefan Richter
-=====-==-== =-== ==-=-
http://arcgraph.de/sr/

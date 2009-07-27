From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some
	USB Disks
Date: Sun, 26 Jul 2009 20:06:11 -0600
Message-ID: <20090727020611.GC3711@parisc-linux.org>
References: <4A4472DF.1050900@turknet.net.tr> <yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr> <yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr> <yq1fxcmnpqa.fsf@sermon.lab.mkp.net> <4A69D093.8020108@turknet.net.tr> <yq1hbwykj80.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56379 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbZG0CGM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Jul 2009 22:06:12 -0400
Content-Disposition: inline
In-Reply-To: <yq1hbwykj80.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tarkan Erimer <tarkan.erimer@turknet.net.tr>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Jul 26, 2009 at 09:28:15PM -0400, Martin K. Petersen wrote:
> sd: Avoid sending extended inquiry to legacy/broken devices
> 
> Our existing check for VPD page validity does not handle devices that
> refuse to respond to INQUIRY with the EVPD bit set.

But ... why doesn't it?

we do:

        result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
                                  len + 4, NULL, 30 * HZ, 3, NULL);
        if (result)
                return result;

so that should return some error code.  And that's called from here:

        /* Ask for all the pages supported by this device */
        result = scsi_vpd_inquiry(sdev, buf, 0, 255);
        if (result)
                goto fail;

which goes to:

 fail:
        kfree(buf);
        return NULL;

and the sd code seems to check for that.  So what bug are you papering
over here?

> Restrict extended inquiry to devices reporting SBC2/SPC3 or higher.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> ---
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 5616cd7..9b703fd 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1840,6 +1840,13 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
>  	kfree(buffer);
>  }
>  
> +static int sd_try_extended_inquiry(struct scsi_device *sdp)
> +{
> +	if (sdp->scsi_level > SCSI_SPC_2)
> +		return 1;
> +	return 0;
> +}
> +
>  /**
>   *	sd_revalidate_disk - called the first time a new disk is seen,
>   *	performs disk spin up, read_capacity, etc.
> @@ -1877,8 +1884,12 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	 */
>  	if (sdkp->media_present) {
>  		sd_read_capacity(sdkp, buffer);
> -		sd_read_block_limits(sdkp);
> -		sd_read_block_characteristics(sdkp);
> +
> +		if (sd_try_extended_inquiry(sdp)) {
> +			sd_read_block_limits(sdkp);
> +			sd_read_block_characteristics(sdkp);
> +		}
> +
>  		sd_read_write_protect_flag(sdkp, buffer);
>  		sd_read_cache_type(sdkp, buffer);
>  		sd_read_app_tag_own(sdkp, buffer);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

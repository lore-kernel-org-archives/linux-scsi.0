From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH][RFC] scsi: Use W_LUN for scanning
Date: Sat, 6 Apr 2013 09:08:02 +0000
Message-ID: <1365239280.2787.11.camel@dabdike>
References: <1363340771-46925-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:57293 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162828Ab3DFJIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Apr 2013 05:08:04 -0400
In-Reply-To: <1363340771-46925-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <90D333D65BD2AC48AF69A6F2576CAE93@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, George Martin <marting@netapp.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>

On Fri, 2013-03-15 at 10:46 +0100, Hannes Reinecke wrote:
> SAM advertises the use of a Well-known LUN (W_LUN) for scanning.
> As this avoids exposing LUN 0 (which might be a valid LUN) for
> all initiators it is the preferred method for LUN scanning on
> some arrays.
> So we should be using W_LUN for scanning, too. If the W_LUN is
> not supported we'll fall back to use LUN 0.
> For broken W_LUN implementations a new blacklist flag
> 'BLIST_NO_WLUN' is added.

Well, we could do this, but I don't really see the point.  By the time
we get into the report lun code, we've already probed LUN 0, so it's as
good as any for a REPORT LUN scan.

What worries me slightly about the W-LUN is that for the first time
we'll  be assuming a device supports a particular address method
(Extended Logical Unit addressing) rather than treating LUNs as opaque
handles we keep and pass back to the target.  I appreciate you now have
a blacklist for failures, but if we didn't use W-LUNs we wouldn't need
that blacklist.

So could you answer two questions clearly:

     1. What does this buy us over the current LUN0 method?  I don't see
        LUN0 might be a valid LUN being a convincing reason.
     2. What devices have you actually tested this on?

James

> Signed-off-by: Hannes Reinecke <hare@suse.de>
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 3e58b22..f4ccdea 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1312,6 +1312,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
>  	unsigned int num_luns;
>  	unsigned int retries;
>  	int result;
> +	int w_lun = SCSI_W_LUN_REPORT_LUNS;
>  	struct scsi_lun *lunp, *lun_data;
>  	u8 *data;
>  	struct scsi_sense_hdr sshdr;
> @@ -1337,11 +1338,20 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
>  		return 0;
>  	if (starget->no_report_luns)
>  		return 1;
> +	if (bflags & BLIST_NO_WLUN)
> +		w_lun = 0;
>  
> +retry_report_lun_scan:
>  	if (!(sdev = scsi_device_lookup_by_target(starget, 0))) {
> -		sdev = scsi_alloc_sdev(starget, 0, NULL);
> -		if (!sdev)
> -			return 0;
> +		sdev = scsi_alloc_sdev(starget, w_lun, NULL);
> +		if (!sdev) {
> +			if (w_lun != 0) {
> +				w_lun = 0;
> +				sdev = scsi_alloc_sdev(starget, w_lun, NULL);
> +			}
> +			if (!sdev)
> +				return 0;
> +		}
>  		if (scsi_device_get(sdev)) {
>  			__scsi_remove_device(sdev);
>  			return 0;
> @@ -1418,6 +1428,18 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
>  	}
>  
>  	if (result) {
> +		if (w_lun != 0 && scsi_device_created(sdev)) {
> +			/*
> +			 * W_LUN probably not supported, try with LUN 0
> +			 */
> +			SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan:"
> +					"W_LUN not supported, try LUN 0\n"));
> +			kfree(lun_data);
> +			scsi_device_put(sdev);
> +			__scsi_remove_device(sdev);
> +			w_lun = 0;
> +			goto retry_report_lun_scan;
> +		}
>  		/*
>  		 * The device probably does not support a REPORT LUN command
>  		 */
> diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
> index cc1f3e7..ffb42b1 100644
> --- a/include/scsi/scsi_devinfo.h
> +++ b/include/scsi/scsi_devinfo.h
> @@ -31,4 +31,5 @@
>  #define BLIST_MAX_512		0x800000 /* maximum 512 sector cdb length */
>  #define BLIST_ATTACH_PQ3	0x1000000 /* Scan: Attach to PQ3 devices */
>  #define BLIST_NO_DIF		0x2000000 /* Disable T10 PI (DIF) */
> +#define BLIST_NO_WLUN		0x4000000 /* Disable W_LUN scanning */
>  #endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


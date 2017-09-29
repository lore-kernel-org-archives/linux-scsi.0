From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] scsi: sd: Implement blacklist option for WRITE SAME w/
 UNMAP
Date: Fri, 29 Sep 2017 06:02:56 -0400
Message-ID: <1506679376.11960.1.camel@redhat.com>
References: <1506529677.4100.452.camel@localhost.localdomain>
         <20170928013512.1058-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:49801 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750996AbdI2KC7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2017 06:02:59 -0400
Received: by mail-qt0-f169.google.com with SMTP id o3so915010qte.6
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2017 03:02:58 -0700 (PDT)
In-Reply-To: <20170928013512.1058-1-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Wed, 2017-09-27 at 21:35 -0400, Martin K. Petersen wrote:
> SBC-4 states:
> 
>   "A MAXIMUM UNMAP LBA COUNT field set to a non-zero value indicates
> the
>    maximum number of LBAs that may be unmapped by an UNMAP command"
> 
>   "A MAXIMUM WRITE SAME LENGTH field set to a non-zero value
> indicates
>    the maximum number of contiguous logical blocks that the device
> server
>    allows to be unmapped or written in a single WRITE SAME command."
> 
> Despite the spec being clear on the topic, some devices incorrectly
> expect WRITE SAME commands with the UNMAP bit set to be limited to
> the
> value reported in MAXIMUM UNMAP LBA COUNT in the Block Limits VPD.
> 
> Implement a blacklist option that can be used to accommodate devices
> with this behavior.
> 
> Reported-by: Bill Kuzeja <William.Kuzeja@stratus.com>
> Reported-by: Ewan D. Milne <emilne@redhat.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/scsi/scsi_scan.c    |  3 +++
>  drivers/scsi/sd.c           | 16 ++++++++++++----
>  include/scsi/scsi_device.h  |  1 +
>  include/scsi/scsi_devinfo.h |  1 +
>  4 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index e7818afeda2b..15590a063ad9 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -956,6 +956,9 @@ static int scsi_add_lun(struct scsi_device *sdev,
> unsigned char *inq_result,
>  	if (*bflags & BLIST_NO_DIF)
>  		sdev->no_dif = 1;
>  
> +	if (*bflags & BLIST_UNMAP_LIMIT_WS)
> +		sdev->unmap_limit_for_ws = 1;
> +
>  	sdev->eh_timeout = SCSI_DEFAULT_EH_TIMEOUT;
>  
>  	if (*bflags & BLIST_TRY_VPD_PAGES)
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index b18ba3235900..347be7580181 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -715,13 +715,21 @@ static void sd_config_discard(struct scsi_disk
> *sdkp, unsigned int mode)
>  		break;
>  
>  	case SD_LBP_WS16:
> -		max_blocks = min_not_zero(sdkp->max_ws_blocks,
> -					  (u32)SD_MAX_WS16_BLOCKS);
> +		if (sdkp->device->unmap_limit_for_ws)
> +			max_blocks = sdkp->max_unmap_blocks;
> +		else
> +			max_blocks = sdkp->max_ws_blocks;
> +
> +		max_blocks = min_not_zero(max_blocks,
> (u32)SD_MAX_WS16_BLOCKS);
>  		break;
>  
>  	case SD_LBP_WS10:
> -		max_blocks = min_not_zero(sdkp->max_ws_blocks,
> -					  (u32)SD_MAX_WS10_BLOCKS);
> +		if (sdkp->device->unmap_limit_for_ws)
> +			max_blocks = sdkp->max_unmap_blocks;
> +		else
> +			max_blocks = sdkp->max_ws_blocks;
> +
> +		max_blocks = min_not_zero(max_blocks,
> (u32)SD_MAX_WS10_BLOCKS);
>  		break;
>  
>  	case SD_LBP_ZERO:
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 82e93ee94708..67c5a9f223f7 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -192,6 +192,7 @@ struct scsi_device {
>  	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled
> */
>  	unsigned broken_fua:1;		/* Don't set FUA bit
> */
>  	unsigned lun_in_cdb:1;		/* Store LUN bits in
> CDB[1] */
> +	unsigned unmap_limit_for_ws:1;	/* Use the UNMAP limit
> for WRITE SAME */
>  
>  	atomic_t disk_events_disable_depth; /* disable depth for
> disk events */
>  
> diff --git a/include/scsi/scsi_devinfo.h
> b/include/scsi/scsi_devinfo.h
> index 9592570e092a..36b03013d629 100644
> --- a/include/scsi/scsi_devinfo.h
> +++ b/include/scsi/scsi_devinfo.h
> @@ -29,5 +29,6 @@
>  #define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD
> pages */
>  #define BLIST_NO_RSOC		0x20000000 /* don't try to
> issue RSOC */
>  #define BLIST_MAX_1024		0x40000000 /* maximum 1024
> sector cdb length */
> +#define BLIST_UNMAP_LIMIT_WS	0x80000000 /* Use UNMAP limit
> for WRITE SAME */
>  
>  #endif

Hello Martin
I am testing this but its not being picked up so I want to know if I
have the kernel command line wrong here.

scsi_dev_flags=LIO-ORG:thin2:0x80000000

Device is here
[   16.853083] scsi 4:0:0:50: Direct-Access     LIO-
ORG  thin2            4.0  PQ: 0 ANSI: 5

Have a couple of printk's in now to see if I see the flags and they
dont trigger

        case SD_LBP_WS16:
                if (sdkp->device->unmap_limit_for_ws) {
                        max_blocks = sdkp->max_unmap_blocks;
                        printk("RHDEBUG: unmap_limit_for_ws set by
kernel flag for case SD_LBP_WS16\n");
                }
                else
                        max_blocks = sdkp->max_ws_blocks;

                max_blocks = min_not_zero(max_blocks,
(u32)SD_MAX_WS16_BLOCKS);
                break;

        case SD_LBP_WS10:
                if (sdkp->device->unmap_limit_for_ws) {
                        max_blocks = sdkp->max_unmap_blocks;
                        printk("RHDEBUG: unmap_limit_for_ws set by
kernel flag for case SD_LBP_WS10\n");
                }
                else
                        max_blocks = sdkp->max_ws_blocks;

                max_blocks = min_not_zero(max_blocks,
(u32)SD_MAX_WS10_BLOCKS);
                break;

What am I doing wrong to pass the BLIST flags.

Thanks
Laurence

From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 2/4] scsi_debug: use SCSI_W_LUN_REPORT_LUNS instead of
 SAM2_WLUN_REPORT_LUNS;
Date: Mon, 23 Feb 2015 13:20:57 -0500
Message-ID: <54EB6F89.1070308@interlog.com>
References: <1424298699-2581-1-git-send-email-tomas.winkler@intel.com> <1424298699-2581-3-git-send-email-tomas.winkler@intel.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:51863 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbbBWSVN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2015 13:21:13 -0500
In-Reply-To: <1424298699-2581-3-git-send-email-tomas.winkler@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>, "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org

On 15-02-18 05:31 PM, Tomas Winkler wrote:
> use SCSI_W_LUN_REPORT_LUNS from scsi.h instead of localy defined
> SAM2_WLUN_REPORT_LUNS
>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/scsi_debug.c | 13 ++++++-------
>   1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 14e73f27c27f..11774cd1741a 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -204,7 +204,6 @@ static const char *scsi_debug_version_date = "20141022";
>   /* If REPORT LUNS has luns >= 256 it can choose "flat space" (value 1)
>    * or "peripheral device" addressing (value 0) */
>   #define SAM2_LUN_ADDRESS_METHOD 0
> -#define SAM2_WLUN_REPORT_LUNS 0xc101
>
>   /* SCSI_DEBUG_CANQUEUE is the maximum number of commands that can be queued
>    * (for response) at one time. Can be reduced by max_queue option. Command
> @@ -701,7 +700,7 @@ static void sdebug_max_tgts_luns(void)
>   		else
>   			hpnt->max_id = scsi_debug_num_tgts;
>   		/* scsi_debug_max_luns; */
> -		hpnt->max_lun = SAM2_WLUN_REPORT_LUNS;
> +		hpnt->max_lun = SCSI_W_LUN_REPORT_LUNS;
>   	}
>   	spin_unlock(&sdebug_host_list_lock);
>   }
> @@ -1291,7 +1290,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_ATOMIC);
>   	if (! arr)
>   		return DID_REQUEUE << 16;
> -	have_wlun = (scp->device->lun == SAM2_WLUN_REPORT_LUNS);
> +	have_wlun = (scp->device->lun == SCSI_W_LUN_REPORT_LUNS);
>   	if (have_wlun)
>   		pq_pdt = 0x1e;	/* present, wlun */
>   	else if (scsi_debug_no_lun_0 && (0 == devip->lun))
> @@ -3371,8 +3370,8 @@ static int resp_report_luns(struct scsi_cmnd * scp,
>   		one_lun[i].scsi_lun[1] = lun & 0xff;
>   	}
>   	if (want_wlun) {
> -		one_lun[i].scsi_lun[0] = (SAM2_WLUN_REPORT_LUNS >> 8) & 0xff;
> -		one_lun[i].scsi_lun[1] = SAM2_WLUN_REPORT_LUNS & 0xff;
> +		one_lun[i].scsi_lun[0] = (SCSI_W_LUN_REPORT_LUNS >> 8) & 0xff;
> +		one_lun[i].scsi_lun[1] = SCSI_W_LUN_REPORT_LUNS & 0xff;
>   		i++;
>   	}
>   	alloc_len = (unsigned char *)(one_lun + i) - arr;
> @@ -5171,7 +5170,7 @@ scsi_debug_queuecommand(struct scsi_cmnd *scp)
>   		}
>   		sdev_printk(KERN_INFO, sdp, "%s: cmd %s\n", my_name, b);
>   	}
> -	has_wlun_rl = (sdp->lun == SAM2_WLUN_REPORT_LUNS);
> +	has_wlun_rl = (sdp->lun == SCSI_W_LUN_REPORT_LUNS);
>   	if ((sdp->lun >= scsi_debug_max_luns) && !has_wlun_rl)
>   		return schedule_resp(scp, NULL, errsts_no_connect, 0);
>
> @@ -5342,7 +5341,7 @@ static int sdebug_driver_probe(struct device * dev)
>   		hpnt->max_id = scsi_debug_num_tgts + 1;
>   	else
>   		hpnt->max_id = scsi_debug_num_tgts;
> -	hpnt->max_lun = SAM2_WLUN_REPORT_LUNS;	/* = scsi_debug_max_luns; */
> +	hpnt->max_lun = SCSI_W_LUN_REPORT_LUNS;	/* = scsi_debug_max_luns; */
>
>   	host_prot = 0;
>
>


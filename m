From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [scsi 2/2] scsi_debug: fix REPORT LUNS Well Known LU
Date: Mon, 23 Feb 2015 13:28:48 -0500
Message-ID: <54EB7160.50600@interlog.com>
References: <1424690001-2482-1-git-send-email-tomas.winkler@intel.com> <1424690001-2482-2-git-send-email-tomas.winkler@intel.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:51919 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbbBWS3E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2015 13:29:04 -0500
In-Reply-To: <1424690001-2482-2-git-send-email-tomas.winkler@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>, "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org

On 15-02-23 06:13 AM, Tomas Winkler wrote:
> The use case to report 'REPORT LUNS WLUN' described
> in scsi_debug documentation didn't work because:
> scsi_scan_host_selected() checks for:
> 	 lun < shost->max_lun
>
> To fix this we set:
> 	max_lun = SCSI_W_LUN_REPORT_LUNS + 1;
>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/scsi_debug.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index f032aac75997..2c49ddd8d18b 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -700,7 +700,7 @@ static void sdebug_max_tgts_luns(void)
>   		else
>   			hpnt->max_id = scsi_debug_num_tgts;
>   		/* scsi_debug_max_luns; */
> -		hpnt->max_lun = SCSI_W_LUN_REPORT_LUNS;
> +		hpnt->max_lun = SCSI_W_LUN_REPORT_LUNS + 1;
>   	}
>   	spin_unlock(&sdebug_host_list_lock);
>   }
> @@ -5344,7 +5344,8 @@ static int sdebug_driver_probe(struct device * dev)
>   		hpnt->max_id = scsi_debug_num_tgts + 1;
>   	else
>   		hpnt->max_id = scsi_debug_num_tgts;
> -	hpnt->max_lun = SCSI_W_LUN_REPORT_LUNS;	/* = scsi_debug_max_luns; */
> +	/* = scsi_debug_max_luns; */
> +	hpnt->max_lun = SCSI_W_LUN_REPORT_LUNS + 1;
>
>   	host_prot = 0;
>
>


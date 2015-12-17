From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/17] lpfc: Fix FCF Infinite loop in
 lpfc_sli4_fcf_rr_next_index_get.
Date: Thu, 17 Dec 2015 09:02:39 +0100
Message-ID: <56726C1F.1050901@suse.de>
References: <5671efb8.g2wO8LGtpHquAYxc%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbbLQICl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 03:02:41 -0500
In-Reply-To: <5671efb8.g2wO8LGtpHquAYxc%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 12/17/2015 12:11 AM, James Smart wrote:
>
> Fix FCF Infinite loop in lpfc_sli4_fcf_rr_next_index_get.
>
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>   drivers/scsi/lpfc/lpfc_sli.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sl=
i.c
> index f9585cd..6aae828 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -16173,7 +16173,7 @@ fail_fcf_read:
>   }
>
>   /**
> - * lpfc_check_next_fcf_pri
> + * lpfc_check_next_fcf_pri_level
>    * phba pointer to the lpfc_hba struct for this port.
>    * This routine is called from the lpfc_sli4_fcf_rr_next_index_get
>    * routine when the rr_bmask is empty. The FCF indecies are put int=
o the
> @@ -16329,8 +16329,12 @@ next_priority:
>
>   	if (next_fcf_index < LPFC_SLI4_FCF_TBL_INDX_MAX &&
>   		phba->fcf.fcf_pri[next_fcf_index].fcf_rec.flag &
> -		LPFC_FCF_FLOGI_FAILED)
> +		LPFC_FCF_FLOGI_FAILED) {
> +		if (list_is_singular(&phba->fcf.fcf_pri_list))
> +			return LPFC_FCOE_FCF_NEXT_NONE;
> +
>   		goto next_priority;
> +	}
>
>   	lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
>   			"2845 Get next roundrobin failover FCF (x%x)\n",
>
Hehe. I think I've hit that one once.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes

--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH v3 4/8] megaraid_sas: Send SYNCHRONIZE_CACHE for
 non-raid to firmware
Date: Mon, 24 Oct 2016 12:00:13 -0400
Message-ID: <1477324813.17595.6.camel@localhost.localdomain>
References: <1477056816-7058-1-git-send-email-kashyap.desai@broadcom.com>
         <1477056816-7058-5-git-send-email-kashyap.desai@broadcom.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46856 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933767AbcJXQAQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Oct 2016 12:00:16 -0400
In-Reply-To: <1477056816-7058-5-git-send-email-kashyap.desai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, sumit.saxena@broadcom.com, stable@vger.kernel.org

On Fri, 2016-10-21 at 06:33 -0700, Kashyap Desai wrote:
> Commit- " 02b01e0 [SCSI] megaraid_sas: return sync cache call with success"
> added the code in driver to return SYNCHRONIZE_CACHE without sending it to
> firmware back in 2007. Earlier MR was mainly for Virtual Disk,
> so same code continue for JBOD as well whenever JBOD support was added and it introduced bug that
> SYNCHRONIZE_CACHE is not passed to FW for JBOD (non Raid disk).
> 
> But our recent analysis indicates that, From Day-1 MR Firmware always
> expect Driver to forward SYNCHRONIZE_CACHE for JBOD (non Raid disk) to the
> Firmware.
> We have fixed this as part of this patch.
> 
> CC: stable@vger.kernel.org
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index ba57be6..c98d4f9 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1700,16 +1700,13 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
>  		goto out_done;
>  	}
>  
> -	switch (scmd->cmnd[0]) {
> -	case SYNCHRONIZE_CACHE:
> -		/*
> -		 * FW takes care of flush cache on its own
> -		 * No need to send it down
> -		 */
> +	/*
> +	 * FW takes care of flush cache on its own for Virtual Disk.
> +	 * No need to send it down for VD. For JBOD send SYNCHRONIZE_CACHE to FW.
> +	 */
> +	if ((scmd->cmnd[0] == SYNCHRONIZE_CACHE) && MEGASAS_IS_LOGICAL(scmd)) {
>  		scmd->result = DID_OK << 16;
>  		goto out_done;
> -	default:
> -		break;
>  	}
>  
>  	return instance->instancet->build_and_issue_cmd(instance, scmd);

Along with 4/8 in this v3 series...

Reviewed-by: Ewan D. Milne <emilne@redhat.com>



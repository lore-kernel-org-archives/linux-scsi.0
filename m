From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 13/17] lpfc: Correct driver deregistrations with host
 nvme transport
Date: Mon, 20 Nov 2017 14:29:56 +0100
Message-ID: <afc6ebe4-135b-3436-2d3f-dc32ec45db9d@suse.de>
References: <20171110010834.4542-1-jsmart2021@gmail.com>
 <20171110010834.4542-14-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57671 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751086AbdKTN36 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Nov 2017 08:29:58 -0500
In-Reply-To: <20171110010834.4542-14-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 11/10/2017 02:08 AM, James Smart wrote:
> The driver's interaction with the host nvme transport has been
> incorrect for a while. The driver did not wait for the unregister
> callbacks (waited only 5 jiffies). Thus the driver may remove
> objects that may be referenced by subsequent abort commands from
> the transport, and the actual unregister callback was effectively
> a noop. This was especially problematic if the driver was unloaded.
> 
> The driver now waits for the unregister callbacks, as it should,
> before continuing with teardown.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_disc.h |   2 +
>  drivers/scsi/lpfc/lpfc_nvme.c | 113 ++++++++++++++++++++++++++++++++++++++++--
>  drivers/scsi/lpfc/lpfc_nvme.h |   2 +
>  3 files changed, 113 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
> index f9a566eaef04..5a7547f9d8d8 100644
> --- a/drivers/scsi/lpfc/lpfc_disc.h
> +++ b/drivers/scsi/lpfc/lpfc_disc.h
> @@ -134,6 +134,8 @@ struct lpfc_nodelist {
>  	struct lpfc_scsicmd_bkt *lat_data;	/* Latency data */
>  	uint32_t fc4_prli_sent;
>  	uint32_t upcall_flags;
> +#define NLP_WAIT_FOR_UNREG    0x1
> +
>  	uint32_t nvme_fb_size; /* NVME target's supported byte cnt */
>  #define NVME_FB_BIT_SHIFT 9    /* PRLI Rsp first burst in 512B units. */
>  };
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
> index d3ada630b427..12d09a6a4563 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.c
> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
> @@ -154,6 +154,10 @@ lpfc_nvme_localport_delete(struct nvme_fc_local_port *localport)
>  {
>  	struct lpfc_nvme_lport *lport = localport->private;
>  
> +	lpfc_printf_vlog(lport->vport, KERN_INFO, LOG_NVME,
> +			 "6173 localport %p delete complete\n",
> +			 lport);
> +
>  	/* release any threads waiting for the unreg to complete */
>  	complete(&lport->lport_unreg_done);
>  }
> @@ -946,10 +950,19 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
>  	freqpriv->nvme_buf = NULL;
>  
>  	/* NVME targets need completion held off until the abort exchange
> -	 * completes.
> +	 * completes unless the NVME Rport is getting unregistered.
>  	 */
> -	if (!(lpfc_ncmd->flags & LPFC_SBUF_XBUSY))
> +	if (!(lpfc_ncmd->flags & LPFC_SBUF_XBUSY) ||
> +	    ndlp->upcall_flags & NLP_WAIT_FOR_UNREG) {
> +		/* Clear the XBUSY flag to prevent double completions.
> +		 * The nvme rport is getting unregistered and there is
> +		 * no need to defer the IO.
> +		 */
> +		if (lpfc_ncmd->flags & LPFC_SBUF_XBUSY)
> +			lpfc_ncmd->flags &= ~LPFC_SBUF_XBUSY;
> +
>  		nCmd->done(nCmd);
> +	}
>  
>  	spin_lock_irqsave(&phba->hbalock, flags);
>  	lpfc_ncmd->nrport = NULL;
> @@ -2234,6 +2247,47 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
>  	return ret;
>  }
>  
> +/* lpfc_nvme_lport_unreg_wait - Wait for the host to complete an lport unreg.
> + *
> + * The driver has to wait for the host nvme transport to callback
> + * indicating the localport has successfully unregistered all
> + * resources.  Since this is an uninterruptible wait, loop every ten
> + * seconds and print a message indicating no progress.
> + *
> + * An uninterruptible wait is used because of the risk of transport-to-
> + * driver state mismatch.
> + */
> +void
> +lpfc_nvme_lport_unreg_wait(struct lpfc_vport *vport,
> +			   struct lpfc_nvme_lport *lport)
> +{
> +#if (IS_ENABLED(CONFIG_NVME_FC))
> +	u32 wait_tmo;
> +	int ret;
> +
> +	/* Host transport has to clean up and confirm requiring an indefinite
> +	 * wait. Print a message if a 10 second wait expires and renew the
> +	 * wait. This is unexpected.
> +	 */
> +	wait_tmo = msecs_to_jiffies(LPFC_NVME_WAIT_TMO * 1000);
> +	while (true) {
> +		ret = wait_for_completion_timeout(&lport->lport_unreg_done,
> +						  wait_tmo);
> +		if (unlikely(!ret)) {
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_IOERR,
> +					 "6176 Lport %p Localport %p wait "
> +					 "timed out. Renewing.\n",
> +					 lport, vport->localport);
> +			continue;
> +		}
> +		break;
> +	}
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR,
> +			 "6177 Lport %p Localport %p Complete Success\n",
> +			 lport, vport->localport);
> +#endif
> +}
> +
>  /**
>   * lpfc_nvme_destroy_localport - Destroy lpfc_nvme bound to nvme transport.
>   * @pnvme: pointer to lpfc nvme data structure.
> @@ -2268,7 +2322,11 @@ lpfc_nvme_destroy_localport(struct lpfc_vport *vport)
>  	 */
>  	init_completion(&lport->lport_unreg_done);
>  	ret = nvme_fc_unregister_localport(localport);
> -	wait_for_completion_timeout(&lport->lport_unreg_done, 5);
> +
> +	/* Wait for completion.  This either blocks
> +	 * indefinitely or succeeds
> +	 */
> +	lpfc_nvme_lport_unreg_wait(vport, lport);
>  
>  	/* Regardless of the unregister upcall response, clear
>  	 * nvmei_support.  All rports are unregistered and the
> @@ -2424,6 +2482,47 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
>  #endif
>  }
>  
> +/* lpfc_nvme_rport_unreg_wait - Wait for the host to complete an rport unreg.
> + *
> + * The driver has to wait for the host nvme transport to callback
> + * indicating the remoteport has successfully unregistered all
> + * resources.  Since this is an uninterruptible wait, loop every ten
> + * seconds and print a message indicating no progress.
> + *
> + * An uninterruptible wait is used because of the risk of transport-to-
> + * driver state mismatch.
> + */
> +void
> +lpfc_nvme_rport_unreg_wait(struct lpfc_vport *vport,
> +			   struct lpfc_nvme_rport *rport)
> +{
> +#if (IS_ENABLED(CONFIG_NVME_FC))
> +	u32 wait_tmo;
> +	int ret;
> +
> +	/* Host transport has to clean up and confirm requiring an indefinite
> +	 * wait. Print a message if a 10 second wait expires and renew the
> +	 * wait. This is unexpected.
> +	 */
> +	wait_tmo = msecs_to_jiffies(LPFC_NVME_WAIT_TMO * 1000);
> +	while (true) {
> +		ret = wait_for_completion_timeout(&rport->rport_unreg_done,
> +						  wait_tmo);
> +		if (unlikely(!ret)) {
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_IOERR,
> +					 "6174 Rport %p Remoteport %p wait "
> +					 "timed out. Renewing.\n",
> +					 rport, rport->remoteport);
> +			continue;
> +		}
> +		break;
> +	}
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR,
> +			 "6175 Rport %p Remoteport %p Complete Success\n",
> +			 rport, rport->remoteport);
> +#endif
> +}
> +
>  /* lpfc_nvme_unregister_port - unbind the DID and port_role from this rport.
>   *
>   * There is no notion of Devloss or rport recovery from the current
> @@ -2480,14 +2579,20 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
>  		/* No concern about the role change on the nvme remoteport.
>  		 * The transport will update it.
>  		 */
> +		ndlp->upcall_flags |= NLP_WAIT_FOR_UNREG;
>  		ret = nvme_fc_unregister_remoteport(remoteport);
>  		if (ret != 0) {
>  			lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_DISC,
>  					 "6167 NVME unregister failed %d "
>  					 "port_state x%x\n",
>  					 ret, remoteport->port_state);
> +		} else {
> +			/* Wait for completion.  This either blocks
> +			 * indefinitely or succeeds
> +			 */
> +			lpfc_nvme_rport_unreg_wait(vport, rport);
> +			ndlp->upcall_flags &= ~NLP_WAIT_FOR_UNREG;
>  		}
> -
>  	}
>  	return;
>  
Shouldn't the flag be reset in the failure case, too?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

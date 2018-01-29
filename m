From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/19] lpfc: Fix IO failure during hba reset testing with
 nvme io.
Date: Mon, 29 Jan 2018 09:06:58 +0100
Message-ID: <2c17b7b6-a945-b6a6-2769-fdf47d5a9096@suse.de>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
 <20180124224548.9530-8-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39262 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751127AbeA2I7u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 03:59:50 -0500
In-Reply-To: <20180124224548.9530-8-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 01/24/2018 11:45 PM, James Smart wrote:
> A stress test repeatedly resetting the adapter while performing
> io would eventually report I/O failures and missing nvme namespaces.
> 
> The driver was setting the nvmefc_fcp_req->private pointer to NULL
> during the IO completion routine before upcalling done().
> If the transport was also running an abort for that IO, the driver
> would fail the abort with message 6140. Failing the abort is not
> allowed by the nvme-fc transport, as it mandates that the io must be
> returned back to the transport. As that does not happen, the transport
> controller delete has an outstanding reference and can't complete
> teardown.
> 
> Remove the NULL'ing of the private pointer in the nvmefc request.
> The driver simply overwrites this value on each IO start.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_nvme.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
> index 81e3a4f10c3c..92643ffa79c3 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.c
> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
> @@ -804,7 +804,6 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
>  	struct nvme_fc_cmd_iu *cp;
>  	struct lpfc_nvme_rport *rport;
>  	struct lpfc_nodelist *ndlp;
> -	struct lpfc_nvme_fcpreq_priv *freqpriv;
>  	struct lpfc_nvme_lport *lport;
>  	unsigned long flags;
>  	uint32_t code, status;
> @@ -980,8 +979,6 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
>  			phba->cpucheck_cmpl_io[lpfc_ncmd->cpu]++;
>  	}
>  #endif
> -	freqpriv = nCmd->private;
> -	freqpriv->nvme_buf = NULL;
>  
>  	/* NVME targets need completion held off until the abort exchange
>  	 * completes unless the NVME Rport is getting unregistered.
> 
I would avoid that if possible.
By not zeroing the pointers we run into the risk of executing the wrong
callback on stale commands.
Can't you just modify the abort handling to always return 'true' if this
condition is hit?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

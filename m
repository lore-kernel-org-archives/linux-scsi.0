From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: replace init_timer by setup_timer
Date: Fri, 3 Mar 2017 07:20:16 -0800
Message-ID: <c496efea-46cc-b35a-58dc-d75677582281@broadcom.com>
References: <20170303124548.30176-1-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170303124548.30176-1-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, Tomas Jasek <tomsik68@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

looks good

-- james

Signed-off-by:  James Smart <james.smart@broadcom.com>

On 3/3/2017 4:45 AM, Jiri Slaby wrote:
> From: Tomas Jasek <tomsik68@gmail.com>
>
> This patch shortens every init_timer in lpfc module
> followed by function and data assignment using setup_timer.
> This is purely cleanup patch, it does not add new functionality
> nor remove any existing functionality.
>
> An init_timer call in this form:
>
>      init_timer(&vport->fc_disctmo);
>      vport->fc_disctmo.function = lpfc_disc_timeout;
>      vport->fc_disctmo.data = vport;
>
> is shortened to:
>
>      setup_timer(&vport->fc_disctmo, lpfc_disc_timeout, vport);
>
> It increases readability and reduces chances of mistakes done by
> developers.
>
> Signed-off-by: Tomas Jasek <tomsik68@gmail.com>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: James Smart <james.smart@broadcom.com>
> Cc: Dick Kennedy <dick.kennedy@broadcom.com>
> Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: <linux-scsi@vger.kernel.org>
> ---
>   drivers/scsi/lpfc/lpfc_hbadisc.c |  5 ++---
>   drivers/scsi/lpfc/lpfc_init.c    | 47 +++++++++++++++-------------------------
>   2 files changed, 19 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index 194a14d5f8a9..2612dac75186 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -4344,9 +4344,8 @@ lpfc_initialize_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
>   {
>   	INIT_LIST_HEAD(&ndlp->els_retry_evt.evt_listp);
>   	INIT_LIST_HEAD(&ndlp->dev_loss_evt.evt_listp);
> -	init_timer(&ndlp->nlp_delayfunc);
> -	ndlp->nlp_delayfunc.function = lpfc_els_retry_delay;
> -	ndlp->nlp_delayfunc.data = (unsigned long)ndlp;
> +	setup_timer(&ndlp->nlp_delayfunc, lpfc_els_retry_delay,
> +			(unsigned long)ndlp);
>   	ndlp->nlp_DID = did;
>   	ndlp->vport = vport;
>   	ndlp->phba = vport->phba;
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 0ee429d773f3..f395f2e4aa97 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -3734,17 +3734,14 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
>   	INIT_LIST_HEAD(&vport->rcv_buffer_list);
>   	spin_lock_init(&vport->work_port_lock);
>   
> -	init_timer(&vport->fc_disctmo);
> -	vport->fc_disctmo.function = lpfc_disc_timeout;
> -	vport->fc_disctmo.data = (unsigned long)vport;
> +	setup_timer(&vport->fc_disctmo, lpfc_disc_timeout,
> +			(unsigned long)vport);
>   
> -	init_timer(&vport->els_tmofunc);
> -	vport->els_tmofunc.function = lpfc_els_timeout;
> -	vport->els_tmofunc.data = (unsigned long)vport;
> +	setup_timer(&vport->els_tmofunc, lpfc_els_timeout,
> +			(unsigned long)vport);
>   
> -	init_timer(&vport->delayed_disc_tmo);
> -	vport->delayed_disc_tmo.function = lpfc_delayed_disc_tmo;
> -	vport->delayed_disc_tmo.data = (unsigned long)vport;
> +	setup_timer(&vport->delayed_disc_tmo, lpfc_delayed_disc_tmo,
> +			(unsigned long)vport);
>   
>   	error = scsi_add_host_with_dma(shost, dev, &phba->pcidev->dev);
>   	if (error)
> @@ -5406,21 +5403,15 @@ lpfc_setup_driver_resource_phase1(struct lpfc_hba *phba)
>   	INIT_LIST_HEAD(&phba->luns);
>   
>   	/* MBOX heartbeat timer */
> -	init_timer(&psli->mbox_tmo);
> -	psli->mbox_tmo.function = lpfc_mbox_timeout;
> -	psli->mbox_tmo.data = (unsigned long) phba;
> +	setup_timer(&psli->mbox_tmo, lpfc_mbox_timeout, (unsigned long)phba);
>   	/* Fabric block timer */
> -	init_timer(&phba->fabric_block_timer);
> -	phba->fabric_block_timer.function = lpfc_fabric_block_timeout;
> -	phba->fabric_block_timer.data = (unsigned long) phba;
> +	setup_timer(&phba->fabric_block_timer, lpfc_fabric_block_timeout,
> +			(unsigned long)phba);
>   	/* EA polling mode timer */
> -	init_timer(&phba->eratt_poll);
> -	phba->eratt_poll.function = lpfc_poll_eratt;
> -	phba->eratt_poll.data = (unsigned long) phba;
> +	setup_timer(&phba->eratt_poll, lpfc_poll_eratt,
> +			(unsigned long)phba);
>   	/* Heartbeat timer */
> -	init_timer(&phba->hb_tmofunc);
> -	phba->hb_tmofunc.function = lpfc_hb_timeout;
> -	phba->hb_tmofunc.data = (unsigned long)phba;
> +	setup_timer(&phba->hb_tmofunc, lpfc_hb_timeout, (unsigned long)phba);
>   
>   	return 0;
>   }
> @@ -5446,9 +5437,8 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
>   	 */
>   
>   	/* FCP polling mode timer */
> -	init_timer(&phba->fcp_poll_timer);
> -	phba->fcp_poll_timer.function = lpfc_poll_timeout;
> -	phba->fcp_poll_timer.data = (unsigned long) phba;
> +	setup_timer(&phba->fcp_poll_timer, lpfc_poll_timeout,
> +			(unsigned long)phba);
>   
>   	/* Host attention work mask setup */
>   	phba->work_ha_mask = (HA_ERATT | HA_MBATT | HA_LATT);
> @@ -5617,14 +5607,11 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
>   	 * Initialize timers used by driver
>   	 */
>   
> -	init_timer(&phba->rrq_tmr);
> -	phba->rrq_tmr.function = lpfc_rrq_timeout;
> -	phba->rrq_tmr.data = (unsigned long)phba;
> +	setup_timer(&phba->rrq_tmr, lpfc_rrq_timeout, (unsigned long)phba);
>   
>   	/* FCF rediscover timer */
> -	init_timer(&phba->fcf.redisc_wait);
> -	phba->fcf.redisc_wait.function = lpfc_sli4_fcf_redisc_wait_tmo;
> -	phba->fcf.redisc_wait.data = (unsigned long)phba;
> +	setup_timer(&phba->fcf.redisc_wait, lpfc_sli4_fcf_redisc_wait_tmo,
> +			(unsigned long)phba);
>   
>   	/*
>   	 * Control structure for handling external multi-buffer mailbox

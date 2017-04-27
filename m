From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH v2] lpfc: Fix panic on BFS configuration.
Date: Thu, 27 Apr 2017 09:18:19 -0400
Message-ID: <1493299099.9835.52.camel@localhost.localdomain>
References: <20170426191926.6061-1-jsmart2021@gmail.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42574 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751550AbdD0NSV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Apr 2017 09:18:21 -0400
In-Reply-To: <20170426191926.6061-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, jthumshirn@suse.de, linux-nvme@lists.infradead.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Wed, 2017-04-26 at 12:19 -0700, jsmart2021@gmail.com wrote:
> From: James Smart <jsmart2021@gmail.com>
> 
> To select the appropriate shost template, the driver is issuing
> a mailbox command to retrieve the wwn. Turns out the sending of
> the command precedes the reset of the function.  On SLI-4 adapters,
> this is inconsequential as the mailbox command location is specified
> by dma via the BMBX register. However, on SLI-3 adapters, the
> location of the mailbox command submission area changes. When the
> function is first powered on or reset, the cmd is submitted via PCI
> bar memory. Later the driver changes the function config to use
> host memory and DMA. The request to start a mailbox command is the
> same, a simple doorbell write, regardless of submission area.
> So.. if there has not been a boot driver run against the adapter,
> the mailbox command works as defaults are ok. But, if the boot
> driver has configured the card and, and if no platform pci
> function/slot reset occurs as the os starts, the mailbox command
> will fail. The SLI-3 device will use the stale boot driver dma
> location. This can cause PCI eeh errors.
> 
> Fix is to reset the sli-3 function before sending the
> mailbox command, thus synchronizing the function/driver on mailbox
> location.
> 
> This issue was introduced by this patch:
> http://www.spinics.net/lists/linux-scsi/msg105908.html
> which is in the stable pools with commit id:
> 96418b5e2c8867da3279d877f5d1ffabfe460c3d
> 
> This patch was cut against the scsi.git tree, misc branch and should
> be pulled in via the scsi tree.
> 
> This patch needs to be applied to the stable trees where ever the
> introducing patch exists.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/scsi/lpfc/lpfc_crtn.h |  1 +
>  drivers/scsi/lpfc/lpfc_init.c |  7 +++++++
>  drivers/scsi/lpfc/lpfc_sli.c  | 19 ++++++++++++-------
>  3 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
> index 843dd73..4295ef1 100644
> --- a/drivers/scsi/lpfc/lpfc_crtn.h
> +++ b/drivers/scsi/lpfc/lpfc_crtn.h
> @@ -289,6 +289,7 @@ int lpfc_selective_reset(struct lpfc_hba *);
>  void lpfc_reset_barrier(struct lpfc_hba *);
>  int lpfc_sli_brdready(struct lpfc_hba *, uint32_t);
>  int lpfc_sli_brdkill(struct lpfc_hba *);
> +int lpfc_sli_chipset_init(struct lpfc_hba *);
>  int lpfc_sli_brdreset(struct lpfc_hba *);
>  int lpfc_sli_brdrestart(struct lpfc_hba *);
>  int lpfc_sli_hba_setup(struct lpfc_hba *);
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 0ee429d..4b47708 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -1422,6 +1422,13 @@ lpfc_handle_deferred_eratt(struct lpfc_hba *phba)
>  	psli->sli_flag &= ~LPFC_SLI_ACTIVE;
>  	spin_unlock_irq(&phba->hbalock);
>  
> +	if (phba->sli_rev < LPFC_SLI_REV4) {
> +		/* Reset the port first */
> +		lpfc_sli_brdrestart(phba);
> +		rc = lpfc_sli_chipset_init(phba);
> +		if (rc)
> +			return (uint64_t)-1;
> +	}
>  
>  	/*
>  	 * Firmware stops when it triggred erratt. That could cause the I/Os
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index e43e5e2..0296c47 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -4203,13 +4203,16 @@ lpfc_sli_brdreset(struct lpfc_hba *phba)
>  	/* Reset HBA */
>  	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
>  			"0325 Reset HBA Data: x%x x%x\n",
> -			phba->pport->port_state, psli->sli_flag);
> +			(phba->pport) ? phba->pport->port_state : 0,
> +			psli->sli_flag);
>  
>  	/* perform board reset */
>  	phba->fc_eventTag = 0;
>  	phba->link_events = 0;
> -	phba->pport->fc_myDID = 0;
> -	phba->pport->fc_prevDID = 0;
> +	if (phba->pport) {
> +		phba->pport->fc_myDID = 0;
> +		phba->pport->fc_prevDID = 0;
> +	}
>  
>  	/* Turn off parity checking and serr during the physical reset */
>  	pci_read_config_word(phba->pcidev, PCI_COMMAND, &cfg_value);
> @@ -4335,7 +4338,8 @@ lpfc_sli_brdrestart_s3(struct lpfc_hba *phba)
>  	/* Restart HBA */
>  	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
>  			"0337 Restart HBA Data: x%x x%x\n",
> -			phba->pport->port_state, psli->sli_flag);
> +			(phba->pport) ? phba->pport->port_state : 0,
> +			psli->sli_flag);
>  
>  	word0 = 0;
>  	mb = (MAILBOX_t *) &word0;
> @@ -4349,7 +4353,7 @@ lpfc_sli_brdrestart_s3(struct lpfc_hba *phba)
>  	readl(to_slim); /* flush */
>  
>  	/* Only skip post after fc_ffinit is completed */
> -	if (phba->pport->port_state)
> +	if (phba->pport && phba->pport->port_state)
>  		word0 = 1;	/* This is really setting up word1 */
>  	else
>  		word0 = 0;	/* This is really setting up word1 */
> @@ -4358,7 +4362,8 @@ lpfc_sli_brdrestart_s3(struct lpfc_hba *phba)
>  	readl(to_slim); /* flush */
>  
>  	lpfc_sli_brdreset(phba);
> -	phba->pport->stopped = 0;
> +	if (phba->pport)
> +		phba->pport->stopped = 0;
>  	phba->link_state = LPFC_INIT_START;
>  	phba->hba_flag = 0;
>  	spin_unlock_irq(&phba->hbalock);
> @@ -4445,7 +4450,7 @@ lpfc_sli_brdrestart(struct lpfc_hba *phba)
>   * iteration, the function will restart the HBA again. The function returns
>   * zero if HBA successfully restarted else returns negative error code.
>   **/
> -static int
> +int
>  lpfc_sli_chipset_init(struct lpfc_hba *phba)
>  {
>  	uint32_t status, i = 0;

If it was me, I probably would have added the checking for null pport in
the _s4 functions as well, even though the current code only appears to
trip over a null pport in the _s3 case.  It would save a potential crash
in case a SLI4 reset is added in the future and the checks are not added.
You might want to consider doing this at some point.  It's fine for now.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

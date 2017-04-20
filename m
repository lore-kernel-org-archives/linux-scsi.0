From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH-v1 15/22] Fix driver load issues when MRQ=8
Date: Thu, 20 Apr 2017 09:42:10 +0200
Message-ID: <20170420074210.GP6217@linux-x5ow.site>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
 <20170420044641.10657-16-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48888 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S941215AbdDTHmO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Apr 2017 03:42:14 -0400
Content-Disposition: inline
In-Reply-To: <20170420044641.10657-16-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Wed, Apr 19, 2017 at 09:46:34PM -0700, jsmart2021@gmail.com wrote:
> From: James Smart <jsmart2021@gmail.com>
> 
> The symptom is that the driver will fail to login to the fabric.
> The reason is because it is out of iocb resources.
> 
> There is a one to one relationship between MRQs
> (receive buffers for NVMET-FC) and iocbs and the default number of
> IOCBs was not accounting for the number of MRQs that were being created.
> 
> This fix aligns the number of MRQ resources with the total resources so
> that it can handle fabric events when needed.
> 
> Also the initialization of ctxlock to be on FCP commands, NOT LS commands.
> And modified log messages so that the log output can be correlated with
> the analyzer trace.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c  | 12 ++++++++----
>  drivers/scsi/lpfc/lpfc_nvme.c  | 23 ++++++++++++-----------
>  drivers/scsi/lpfc/lpfc_nvmet.c |  6 +++---
>  3 files changed, 23 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index cca7f81..88977b8 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -11061,7 +11061,7 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
>  	struct lpfc_hba   *phba;
>  	struct lpfc_vport *vport = NULL;
>  	struct Scsi_Host  *shost = NULL;
> -	int error;
> +	int error, cnt;
>  	uint32_t cfg_mode, intr_mode;
>  
>  	/* Allocate memory for HBA structure */
> @@ -11095,11 +11095,15 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
>  		goto out_unset_pci_mem_s4;
>  	}
>  
> +	cnt = phba->cfg_iocb_cnt * 1024;
> +	if (phba->nvmet_support)
> +		cnt += (phba->cfg_nvmet_mrq_post * phba->cfg_nvmet_mrq);

Souperflous parenthesis ^

Otherwise,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

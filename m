From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 07/12] be2iscsi: Fix for premature buffer free
Date: Sun, 04 Jul 2010 15:00:52 -0500
Message-ID: <4C30E874.2090200@cs.wisc.edu>
References: <20100630000021.GA20279@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59511 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938Ab0GDT54 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jul 2010 15:57:56 -0400
In-Reply-To: <20100630000021.GA20279@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 06/29/2010 07:00 PM, Jayamohan Kallickal wrote:
>    This patch fixes a bug where the buffer was being freed as soon as submission to HW
> is done.
>
> Signed-off-by: Jayamohan Kallickal<jayamohank@serverengines.com>
> ---
>   drivers/scsi/be2iscsi/be_iscsi.c |   24 ++++++++++++++++++--
>   drivers/scsi/be2iscsi/be_main.c  |   43 +++++++++++++++++++++++++++++++++---
>   drivers/scsi/be2iscsi/be_mgmt.c  |   44 ++++++++++++++++++-------------------
>   drivers/scsi/be2iscsi/be_mgmt.h  |   10 +++++---
>   4 files changed, 87 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
> index 49e3718..7acf351 100644
> --- a/drivers/scsi/be2iscsi/be_iscsi.c
> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
> @@ -488,6 +488,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
>   	struct be_mcc_wrb *wrb;
>   	struct tcp_connect_and_offload_out *ptcpcnct_out;
>   	unsigned short status, extd_status;
> +	struct be_dma_mem nonemb_cmd;
>   	unsigned int tag, wrb_num;
>   	int ret = -1;
>
> @@ -508,7 +509,20 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
>   	}
>
>   	beiscsi_ep->cid_vld = 0;
> -	tag = mgmt_open_connection(phba, dst_addr, beiscsi_ep);
> +
> +	nonemb_cmd.va = pci_alloc_consistent(phba->ctrl.pdev,
> +				sizeof(struct tcp_connect_and_offload_in),
> +				&nonemb_cmd.dma);
> +	if (nonemb_cmd.va == NULL) {
> +		SE_DEBUG(DBG_LVL_1,
> +			 "Failed to allocate memory for mgmt_open_connection"
> +			 "\n");
> +		goto free_ep;
> +	}
> +	nonemb_cmd.size = sizeof(struct tcp_connect_and_offload_in);
> +	memset(nonemb_cmd.va, 0, nonemb_cmd.size);
> +	tag = mgmt_open_connection(phba, dst_addr, beiscsi_ep,&nonemb_cmd);
> +

Don't need extra newline.

>   	if (!tag) {
>   		SE_DEBUG(DBG_LVL_1,
>   			 "mgmt_open_connection Failed for cid=%d\n",
> @@ -525,6 +539,8 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
>   				    " status = %d extd_status = %d\n",
>   				    status, extd_status);
>   		free_mcc_tag(&phba->ctrl, tag);
> +		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
> +			    nonemb_cmd.va, nonemb_cmd.dma);
>   		goto free_ep;
>   	} else {
>   		wrb = queue_get_wrb(mccq, wrb_num);
> @@ -536,6 +552,8 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
>   		beiscsi_ep->cid_vld = 1;
>   		SE_DEBUG(DBG_LVL_8, "mgmt_open_connection Success\n");
>   	}
> +	pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
> +			    nonemb_cmd.va, nonemb_cmd.dma);
>   	return 0;
>
>   free_ep:
> @@ -587,12 +605,12 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
>   	if (beiscsi_open_conn(ep, NULL, dst_addr, non_blocking)) {
>   		SE_DEBUG(DBG_LVL_1, "Failed in beiscsi_open_conn\n");
>   		ret = -ENOMEM;
> -		goto free_ep;
> +		goto dstry_ep;
>   	}
>
>   	return ep;
>
> -free_ep:
> +dstry_ep:
>   	iscsi_destroy_endpoint(ep);
>   	return ERR_PTR(ret);
>   }
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 8f3e4b9..b17897b 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -71,6 +71,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
>   	struct beiscsi_hba *phba;
>   	struct iscsi_session *session;
>   	struct invalidate_command_table *inv_tbl;
> +	struct be_dma_mem nonemb_cmd;
>   	unsigned int cid, tag, num_invalidate;
>
>   	cls_session = starget_to_session(scsi_target(sc->device));
> @@ -101,18 +102,35 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
>   	inv_tbl->cid = cid;
>   	inv_tbl->icd = aborted_io_task->psgl_handle->sgl_index;
>   	num_invalidate = 1;
> -	tag = mgmt_invalidate_icds(phba, inv_tbl, num_invalidate, cid);
> +	nonemb_cmd.va = pci_alloc_consistent(phba->ctrl.pdev,
> +				sizeof(struct invalidate_commands_params_in),
> +				&nonemb_cmd.dma);
> +	if (nonemb_cmd.va == NULL) {
> +		SE_DEBUG(DBG_LVL_1,
> +			 "Failed to allocate memory for"
> +			 "mgmt_invalidate_icds\n");
> +		return -1;


This should be return FAILED.

> +	}
> +	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
> +
> +	tag = mgmt_invalidate_icds(phba, inv_tbl, num_invalidate,
> +				   cid,&nonemb_cmd);
>   	if (!tag) {
>   		shost_printk(KERN_WARNING, phba->shost,
>   			     "mgmt_invalidate_icds could not be"
>   			     " submitted\n");
> +		if (nonemb_cmd.va)


I do not think you need the test. Shouldn't this always be set, or what 
other path could free it?



> +			pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
> +				    nonemb_cmd.va, nonemb_cmd.dma);
> +
>   		return FAILED;
>   	} else {
>   		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
>   					 phba->ctrl.mcc_numtag[tag]);
>   		free_mcc_tag(&phba->ctrl, tag);
>   	}
> -
> +	pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
> +				    nonemb_cmd.va, nonemb_cmd.dma);
>   	return iscsi_eh_abort(sc);
>   }
>
> @@ -126,6 +144,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
>   	struct iscsi_session *session;
>   	struct iscsi_cls_session *cls_session;
>   	struct invalidate_command_table *inv_tbl;
> +	struct be_dma_mem nonemb_cmd;
>   	unsigned int cid, tag, i, num_invalidate;
>   	int rc = FAILED;
>
> @@ -160,18 +179,34 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
>   	spin_unlock_bh(&session->lock);
>   	inv_tbl = phba->inv_tbl;
>
> -	tag = mgmt_invalidate_icds(phba, inv_tbl, num_invalidate, cid);
> +	nonemb_cmd.va = pci_alloc_consistent(phba->ctrl.pdev,
> +				sizeof(struct invalidate_commands_params_in),
> +				&nonemb_cmd.dma);
> +	if (nonemb_cmd.va == NULL) {
> +		SE_DEBUG(DBG_LVL_1,
> +			 "Failed to allocate memory for"
> +			 "mgmt_invalidate_icds\n");
> +		return -1;

return FAILED.

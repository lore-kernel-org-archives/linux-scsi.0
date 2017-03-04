From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH 11/20] lpfc: Fix eh_deadline setting for sli3 adapters.
Date: Sat, 4 Mar 2017 18:51:58 -0500 (EST)
Message-ID: <1212844355.42089348.1488671518567.JavaMail.zimbra@redhat.com>
References: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com> <1488648640-5170-12-git-send-email-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:47937 "EHLO
        mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752391AbdCDXwt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2017 18:52:49 -0500
In-Reply-To: <1488648640-5170-12-git-send-email-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>



----- Original Message -----
> From: jsmart2021@gmail.com
> To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
> Cc: "James Smart" <jsmart2021@gmail.com>, "Dick Kennedy" <dick.kennedy@broadcom.com>, "James Smart"
> <james.smart@broadcom.com>
> Sent: Saturday, March 4, 2017 12:30:31 PM
> Subject: [PATCH 11/20] lpfc: Fix eh_deadline setting for sli3 adapters.
> 
> From: James Smart <jsmart2021@gmail.com>
> 
> A previous change unilaterally removed the hba reset entry point
> from the sli3 host template. This was done to allow tape devices
> being used for back up from being removed. Why was this done ?
> When there was non-responding device on the fabric, the error
> escalation policy would escalate to the reset handler. When the
> reset handler was called, it would reset the adapter, dropping
> link, thus logging out and terminating all i/o's - on any target.
> If there was a tape device on the same adapter that wasn't in
> error, it would kill the tape i/o's, effectively killing the
> tape device state.  With the reset point removed, the adapter
> reset avoided the fabric logout, allowing the other devices to
> continue to operate unaffected. A hack - yes. Hint: we really
> need a transport I_T nexus reset callback added to the eh process
> (in between the SCSI target reset and hba reset points), so a
> fc logout could occur to the one bad target only and stop the error
> escalation process.
> 
> This patch commonizes the approach so it can be used for sli3 and sli4
> adapters, but mandates the admin, via module parameter, specifically
> identify which adapters the resets are to be removed for. Additionally,
> bus_reset, which sends Target Reset TMFs to all targets, is also removed
> from the template as it too has the same effect as the adapter reset.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h      |  1 +
>  drivers/scsi/lpfc/lpfc_attr.c |  6 +++++
>  drivers/scsi/lpfc/lpfc_crtn.h |  4 ++-
>  drivers/scsi/lpfc/lpfc_init.c | 61
>  ++++++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/lpfc/lpfc_scsi.c |  3 +--
>  5 files changed, 69 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
> index de6cd57..763f32d 100644
> --- a/drivers/scsi/lpfc/lpfc.h
> +++ b/drivers/scsi/lpfc/lpfc.h
> @@ -99,6 +99,7 @@ struct lpfc_sli2_slim;
>  #define FC_MAX_ADPTMSG		64
>  
>  #define MAX_HBAEVT	32
> +#define MAX_HBAS_NO_RESET 16
>  
>  /* Number of MSI-X vectors the driver uses */
>  #define LPFC_MSIX_VECTORS	2
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index 4114cf4..b741dcb 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -3010,6 +3010,12 @@ MODULE_PARM_DESC(lpfc_poll, "FCP ring polling mode
> control:"
>  static DEVICE_ATTR(lpfc_poll, S_IRUGO | S_IWUSR,
>  		   lpfc_poll_show, lpfc_poll_store);
>  
> +int lpfc_no_hba_reset_cnt;
> +unsigned long lpfc_no_hba_reset[MAX_HBAS_NO_RESET] = {
> +	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
> +module_param_array(lpfc_no_hba_reset, ulong, &lpfc_no_hba_reset_cnt, 0444);
> +MODULE_PARM_DESC(lpfc_no_hba_reset, "WWPN of HBAs that should not be
> reset");
> +
>  LPFC_ATTR(sli_mode, 0, 0, 3,
>  	"SLI mode selector:"
>  	" 0 - auto (SLI-3 if supported),"
> diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
> index 843dd73..54e6ac4 100644
> --- a/drivers/scsi/lpfc/lpfc_crtn.h
> +++ b/drivers/scsi/lpfc/lpfc_crtn.h
> @@ -384,7 +384,7 @@ void lpfc_free_sysfs_attr(struct lpfc_vport *);
>  extern struct device_attribute *lpfc_hba_attrs[];
>  extern struct device_attribute *lpfc_vport_attrs[];
>  extern struct scsi_host_template lpfc_template;
> -extern struct scsi_host_template lpfc_template_s3;
> +extern struct scsi_host_template lpfc_template_no_hr;
>  extern struct scsi_host_template lpfc_template_nvme;
>  extern struct scsi_host_template lpfc_vport_template;
>  extern struct fc_function_template lpfc_transport_functions;
> @@ -554,3 +554,5 @@ void lpfc_nvme_abort_fcreq_cmpl(struct lpfc_hba *phba,
>  				struct lpfc_wcqe_complete *abts_cmpl);
>  extern int lpfc_enable_nvmet_cnt;
>  extern unsigned long long lpfc_enable_nvmet[];
> +extern int lpfc_no_hba_reset_cnt;
> +extern unsigned long lpfc_no_hba_reset[];
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index b754887..ecb8e1c 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -3555,6 +3555,44 @@ lpfc_sli4_scsi_sgl_update(struct lpfc_hba *phba)
>  	return rc;
>  }
>  
> +static uint64_t
> +lpfc_get_wwpn(struct lpfc_hba *phba)
> +{
> +	uint64_t wwn;
> +	int rc;
> +	LPFC_MBOXQ_t *mboxq;
> +	MAILBOX_t *mb;
> +
> +
> +	mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
> +						GFP_KERNEL);
> +	if (!mboxq)
> +		return (uint64_t)-1;
> +
> +	/* First get WWN of HBA instance */
> +	lpfc_read_nv(phba, mboxq);
> +	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
> +	if (rc != MBX_SUCCESS) {
> +		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
> +				"6019 Mailbox failed , mbxCmd x%x "
> +				"READ_NV, mbxStatus x%x\n",
> +				bf_get(lpfc_mqe_command, &mboxq->u.mqe),
> +				bf_get(lpfc_mqe_status, &mboxq->u.mqe));
> +		mempool_free(mboxq, phba->mbox_mem_pool);
> +		return (uint64_t) -1;
> +	}
> +	mb = &mboxq->u.mb;
> +	memcpy(&wwn, (char *)mb->un.varRDnvp.portname, sizeof(uint64_t));
> +	/* wwn is WWPN of HBA instance */
> +	mempool_free(mboxq, phba->mbox_mem_pool);
> +	if (phba->sli_rev == LPFC_SLI_REV4)
> +		return be64_to_cpu(wwn);
> +	else
> +		return (((wwn & 0xffffffff00000000) >> 32) |
> +			((wwn & 0x00000000ffffffff) << 32));
> +
> +}
> +
>  /**
>   * lpfc_sli4_nvme_sgl_update - update xri-sgl sizing and mapping
>   * @phba: pointer to lpfc hba data structure.
> @@ -3676,17 +3714,32 @@ lpfc_create_port(struct lpfc_hba *phba, int instance,
> struct device *dev)
>  	struct lpfc_vport *vport;
>  	struct Scsi_Host  *shost = NULL;
>  	int error = 0;
> +	int i;
> +	uint64_t wwn;
> +	bool use_no_reset_hba = false;
> +
> +	wwn = lpfc_get_wwpn(phba);
> +
> +	for (i = 0; i < lpfc_no_hba_reset_cnt; i++) {
> +		if (wwn == lpfc_no_hba_reset[i]) {
> +			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
> +					"6020 Setting use_no_reset port=%llx\n",
> +					wwn);
> +			use_no_reset_hba = true;
> +			break;
> +		}
> +	}
>  
>  	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
>  		if (dev != &phba->pcidev->dev) {
>  			shost = scsi_host_alloc(&lpfc_vport_template,
>  						sizeof(struct lpfc_vport));
>  		} else {
> -			if (phba->sli_rev == LPFC_SLI_REV4)
> +			if (!use_no_reset_hba)
>  				shost = scsi_host_alloc(&lpfc_template,
>  						sizeof(struct lpfc_vport));
>  			else
> -				shost = scsi_host_alloc(&lpfc_template_s3,
> +				shost = scsi_host_alloc(&lpfc_template_no_hr,
>  						sizeof(struct lpfc_vport));
>  		}
>  	} else if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
> @@ -5482,7 +5535,8 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
>  
>  	/* Initialize the host templates the configured values. */
>  	lpfc_vport_template.sg_tablesize = phba->cfg_sg_seg_cnt;
> -	lpfc_template_s3.sg_tablesize = phba->cfg_sg_seg_cnt;
> +	lpfc_template_no_hr.sg_tablesize = phba->cfg_sg_seg_cnt;
> +	lpfc_template.sg_tablesize = phba->cfg_sg_seg_cnt;
>  
>  	/* There are going to be 2 reserved BDEs: 1 FCP cmnd + 1 FCP rsp */
>  	if (phba->cfg_enable_bg) {
> @@ -5706,6 +5760,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
>  	/* Initialize the host templates with the updated values. */
>  	lpfc_vport_template.sg_tablesize = phba->cfg_sg_seg_cnt;
>  	lpfc_template.sg_tablesize = phba->cfg_sg_seg_cnt;
> +	lpfc_template_no_hr.sg_tablesize = phba->cfg_sg_seg_cnt;
>  
>  	if (phba->cfg_sg_dma_buf_size  <= LPFC_MIN_SG_SLI4_BUF_SZ)
>  		phba->cfg_sg_dma_buf_size = LPFC_MIN_SG_SLI4_BUF_SZ;
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 9d6384a..bcfd6d6 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -5953,7 +5953,7 @@ struct scsi_host_template lpfc_template_nvme = {
>  	.track_queue_depth	= 0,
>  };
>  
> -struct scsi_host_template lpfc_template_s3 = {
> +struct scsi_host_template lpfc_template_no_hr = {
>  	.module			= THIS_MODULE,
>  	.name			= LPFC_DRIVER_NAME,
>  	.proc_name		= LPFC_DRIVER_NAME,
> @@ -6015,7 +6015,6 @@ struct scsi_host_template lpfc_vport_template = {
>  	.eh_abort_handler	= lpfc_abort_handler,
>  	.eh_device_reset_handler = lpfc_device_reset_handler,
>  	.eh_target_reset_handler = lpfc_target_reset_handler,
> -	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
>  	.slave_alloc		= lpfc_slave_alloc,
>  	.slave_configure	= lpfc_slave_configure,
>  	.slave_destroy		= lpfc_slave_destroy,
> --
> 2.5.0
> 
> 

This patch was implemented and tested in the Red Hat lab and validated for a customer requiring eh_deadline.

Reviewed-by: Laurence Oberman <loberman@redhat.com>
Tested-by:   Laurence Oberman <loberman@redhat.com>

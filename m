From: Sasikumar PC <sasikumar.pc@broadcom.com>
Subject: RE: [PATCH V4 07/11] megaraid_sas: Add the Support for SAS3.5 Generic
 Megaraid Controllers Capabilities
Date: Wed, 14 Dec 2016 16:52:19 -0500
Message-ID: <edea89c4186edd1d9a80583d97154c05@mail.gmail.com>
References: <1481065220-18431-1-git-send-email-sasikumar.pc@broadcom.com>
 <1481065220-18431-8-git-send-email-sasikumar.pc@broadcom.com> <a7dab0c3-bca5-0755-3b90-3a60e269e4c5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a7dab0c3-bca5-0755-3b90-3a60e269e4c5@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, linux-kernel@vger.kernel.org, Christopher Owens <christopher.owens@broadcom.com>, Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Hi Tomas,

Please see my response inline

Thanks
sasi
-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com]
Sent: Friday, December 09, 2016 8:14 AM
To: Sasikumar Chandrasekaran; jejb@kernel.org; hch@infradead.org
Cc: linux-scsi@vger.kernel.org; Sathya.Prakash@broadcom.com;
linux-kernel@vger.kernel.org; christopher.owens@broadcom.com;
kiran-kumar.kasturi@broadcom.com
Subject: Re: [PATCH V4 07/11] megaraid_sas: Add the Support for SAS3.5
Generic Megaraid Controllers Capabilities

On 7.12.2016 00:00, Sasikumar Chandrasekaran wrote:
> The Megaraid driver has to support the SAS3.5 Generic Megaraid
Controllers Firmware functionality.
>
> This patch is depending on patch 6
>
> Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 53
++++++++++++++---------------
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 19 ++++++-----
> drivers/scsi/megaraid/megaraid_sas_fusion.h |  1 +
>  3 files changed, 37 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 3f06b57..8aafb59 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -5057,34 +5057,29 @@ static int megasas_init_fw(struct
> megasas_instance *instance)
>
>  	reg_set = instance->reg_set;
>
> -	switch (instance->pdev->device) {
> -	case PCI_DEVICE_ID_LSI_FUSION:
> -	case PCI_DEVICE_ID_LSI_PLASMA:
> -	case PCI_DEVICE_ID_LSI_INVADER:
> -	case PCI_DEVICE_ID_LSI_FURY:
> -	case PCI_DEVICE_ID_LSI_INTRUDER:
> -	case PCI_DEVICE_ID_LSI_INTRUDER_24:
> -	case PCI_DEVICE_ID_LSI_CUTLASS_52:
> -	case PCI_DEVICE_ID_LSI_CUTLASS_53:
> +	if (fusion)
>  		instance->instancet = &megasas_instance_template_fusion;
> -		break;
> -	case PCI_DEVICE_ID_LSI_SAS1078R:
> -	case PCI_DEVICE_ID_LSI_SAS1078DE:
> -		instance->instancet = &megasas_instance_template_ppc;
> -		break;
> -	case PCI_DEVICE_ID_LSI_SAS1078GEN2:
> -	case PCI_DEVICE_ID_LSI_SAS0079GEN2:
> -		instance->instancet = &megasas_instance_template_gen2;
> -		break;
> -	case PCI_DEVICE_ID_LSI_SAS0073SKINNY:
> -	case PCI_DEVICE_ID_LSI_SAS0071SKINNY:
> -		instance->instancet = &megasas_instance_template_skinny;
> -		break;
> -	case PCI_DEVICE_ID_LSI_SAS1064R:
> -	case PCI_DEVICE_ID_DELL_PERC5:
> -	default:
> -		instance->instancet = &megasas_instance_template_xscale;
> -		break;
> +	else {
> +		switch (instance->pdev->device) {
> +		case PCI_DEVICE_ID_LSI_SAS1078R:
> +		case PCI_DEVICE_ID_LSI_SAS1078DE:
> +			instance->instancet =
&megasas_instance_template_ppc;
> +			break;
> +		case PCI_DEVICE_ID_LSI_SAS1078GEN2:
> +		case PCI_DEVICE_ID_LSI_SAS0079GEN2:
> +			instance->instancet =
&megasas_instance_template_gen2;
> +			break;
> +		case PCI_DEVICE_ID_LSI_SAS0073SKINNY:
> +		case PCI_DEVICE_ID_LSI_SAS0071SKINNY:
> +			instance->instancet =
&megasas_instance_template_skinny;
> +			break;
> +		case PCI_DEVICE_ID_LSI_SAS1064R:
> +		case PCI_DEVICE_ID_DELL_PERC5:
> +		default:
> +			instance->instancet =
&megasas_instance_template_xscale;
> +			instance->pd_list_not_supported = 1;
> +			break;
> +		}
>  	}
>
>  	if (megasas_transition_to_ready(instance, 0)) { @@ -5828,7 +5823,9

> @@ static int megasas_probe_one(struct pci_dev *pdev,
>  		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION)
||
>  			(instance->pdev->device ==
PCI_DEVICE_ID_LSI_PLASMA))
>  			fusion->adapter_type = THUNDERBOLT_SERIES;
> -		else if (!instance->is_ventura)
> +		else if (instance->is_ventura)
> +			fusion->adapter_type = VENTURA_SERIES;
> +		else
>  			fusion->adapter_type = INVADER_SERIES;
>  	}
>  	break;
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 58f86aa..f968a23 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -244,7 +244,10 @@ inline void megasas_return_cmd_fusion(struct
> megasas_instance *instance,
>
>  	reg_set = instance->reg_set;
>
> -	cur_max_fw_cmds =
readl(&instance->reg_set->outbound_scratch_pad_3) & 0x00FFFF;
> +	/* ventura FW does not fill outbound_scratch_pad_3 with queue
depth */
> +	if (!instance->is_ventura)
> +		cur_max_fw_cmds =
> +		readl(&instance->reg_set->outbound_scratch_pad_3) &
0x00FFFF;
>
>  	if (dual_qdepth_disable || !cur_max_fw_cmds)

This test connected with the fact that ventura skips reading
cur_max_fw_cmds makes using ventura equal to "dual_qdepth_disable == 1" so
ldio_threshold is not set.
Is that intentional?

Sasi - Yes , ldio_threshold is not applicable for Ventura

tomash

>  		cur_max_fw_cmds =
instance->instancet->read_fw_status_reg(reg_set)
> & 0x00FFFF; @@ -843,7 +846,7 @@ static int
megasas_create_sg_sense_fusion(struct megasas_instance *instance)
>  	drv_ops = (MFI_CAPABILITIES *) &(init_frame->driver_operations);
>
>  	/* driver support Extended MSIX */
> -	if (fusion->adapter_type == INVADER_SERIES)
> +	if (fusion->adapter_type >= INVADER_SERIES)
>  		drv_ops->mfi_capabilities.support_additional_msix = 1;
>  	/* driver supports HA / Remote LUN over Fast Path interface */
>  	drv_ops->mfi_capabilities.support_fp_remote_lun = 1; @@ -1497,7
> +1500,7 @@ static int megasas_create_sg_sense_fusion(struct
> megasas_instance *instance)
>
>  	fusion = instance->ctrl_context;
>
> -	if (fusion->adapter_type == INVADER_SERIES) {
> +	if (fusion->adapter_type >= INVADER_SERIES) {
>  		struct MPI25_IEEE_SGE_CHAIN64 *sgl_ptr_end = sgl_ptr;
>  		sgl_ptr_end += fusion->max_sge_in_main_msg - 1;
>  		sgl_ptr_end->Flags = 0;
> @@ -1514,7 +1517,7 @@ static int megasas_create_sg_sense_fusion(struct
megasas_instance *instance)
>  		sgl_ptr->Length = cpu_to_le32(sg_dma_len(os_sgl));
>  		sgl_ptr->Address = cpu_to_le64(sg_dma_address(os_sgl));
>  		sgl_ptr->Flags = 0;
> -		if (fusion->adapter_type == INVADER_SERIES)
> +		if (fusion->adapter_type >= INVADER_SERIES)
>  			if (i == sge_count - 1)
>  				sgl_ptr->Flags =
IEEE_SGE_FLAGS_END_OF_LIST;
>  		sgl_ptr++;
> @@ -1525,7 +1528,7 @@ static int megasas_create_sg_sense_fusion(struct
megasas_instance *instance)
>  		    (sge_count > fusion->max_sge_in_main_msg)) {
>
>  			struct MPI25_IEEE_SGE_CHAIN64 *sg_chain;
> -			if (fusion->adapter_type == INVADER_SERIES) {
> +			if (fusion->adapter_type >= INVADER_SERIES) {
>  				if ((le16_to_cpu(cmd->io_request->IoFlags)
&
>
MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH) !=
>
MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH)
> @@ -1541,7 +1544,7 @@ static int megasas_create_sg_sense_fusion(struct
megasas_instance *instance)
>  			sg_chain = sgl_ptr;
>  			/* Prepare chain element */
>  			sg_chain->NextChainOffset = 0;
> -			if (fusion->adapter_type == INVADER_SERIES)
> +			if (fusion->adapter_type >= INVADER_SERIES)
>  				sg_chain->Flags =
IEEE_SGE_FLAGS_CHAIN_ELEMENT;
>  			else
>  				sg_chain->Flags =
> @@ -2292,7 +2295,7 @@ static void megasas_build_ld_nonrw_fusion(struct
megasas_instance *instance,
>  		pRAID_Context->timeout_value =
>  			cpu_to_le16((os_timeout_value > timeout_limit) ?
>  			timeout_limit : os_timeout_value);
> -		if (fusion->adapter_type == INVADER_SERIES)
> +		if (fusion->adapter_type >= INVADER_SERIES)
>  			io_request->IoFlags |=
>
cpu_to_le16(MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH);
>
> @@ -3005,7 +3008,7 @@ irqreturn_t megasas_isr_fusion(int irq, void
> *devp)
>
>  	io_req = cmd->io_request;
>
> -	if (fusion->adapter_type == INVADER_SERIES) {
> +	if (fusion->adapter_type >= INVADER_SERIES) {
>  		struct MPI25_IEEE_SGE_CHAIN64 *sgl_ptr_end =
>  			(struct MPI25_IEEE_SGE_CHAIN64 *)&io_req->SGL;
>  		sgl_ptr_end += fusion->max_sge_in_main_msg - 1; diff --git

> a/drivers/scsi/megaraid/megaraid_sas_fusion.h
> b/drivers/scsi/megaraid/megaraid_sas_fusion.h
> index cb42655..c39c4ed 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
> @@ -107,6 +107,7 @@ enum MR_RAID_FLAGS_IO_SUB_TYPE {  enum
> MR_FUSION_ADAPTER_TYPE {
>  	THUNDERBOLT_SERIES = 0,
>  	INVADER_SERIES = 1,
> +	VENTURA_SERIES = 2,
>  };
>
>  /*

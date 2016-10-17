From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/7] megaraid_sas: Do not set MPI2_TYPE_CUDA for JBOD FP
 path for FW which does not support JBOD sequence map
Date: Mon, 17 Oct 2016 13:37:34 +0200
Message-ID: <aedd7575-05f3-39ab-c72a-d20f7d38aef9@suse.de>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
 <1476699850-25083-8-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1476699850-25083-8-git-send-email-sumit.saxena@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/17/2016 12:24 PM, Sumit Saxena wrote:
> Do not set MPI2_TYPE_CUDA for JBOD fastpath IOs for firmware which does
> not support JBOD sequence map.
> 
> CC: stable@vger.kernel.org
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 8237580..25b7720 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -2003,6 +2003,8 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
>  		io_request->DevHandle = pd_sync->seq[pd_index].devHandle;
>  		pRAID_Context->regLockFlags |=
>  			(MR_RL_FLAGS_SEQ_NUM_ENABLE|MR_RL_FLAGS_GRANT_DESTINATION_CUDA);
> +		pRAID_Context->Type = MPI2_TYPE_CUDA;
> +		pRAID_Context->nseg = 0x1;
>  	} else if (fusion->fast_path_io) {
>  		pRAID_Context->VirtualDiskTgtId = cpu_to_le16(device_id);
>  		pRAID_Context->configSeqNum = 0;
> @@ -2038,12 +2040,10 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
>  		pRAID_Context->timeoutValue =
>  			cpu_to_le16((os_timeout_value > timeout_limit) ?
>  			timeout_limit : os_timeout_value);
> -		if (fusion->adapter_type == INVADER_SERIES) {
> -			pRAID_Context->Type = MPI2_TYPE_CUDA;
> -			pRAID_Context->nseg = 0x1;
> +		if (fusion->adapter_type == INVADER_SERIES)
>  			io_request->IoFlags |=
>  				cpu_to_le16(MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH);
> -		}
> +
>  		cmd->request_desc->SCSIIO.RequestFlags =
>  			(MPI2_REQ_DESCRIPT_FLAGS_FP_IO <<
>  				MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

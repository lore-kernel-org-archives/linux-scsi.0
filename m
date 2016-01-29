From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 07/15] megaraid_sas: Reply Descriptor Post Queue(RDPQ)
 support
Date: Fri, 29 Jan 2016 16:19:28 +0100
Message-ID: <56AB8300.2060207@redhat.com>
References: <1453995276-24955-1-git-send-email-sumit.saxena@avagotech.com>
 <1453995276-24955-8-git-send-email-sumit.saxena@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272AbcA2PTb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jan 2016 10:19:31 -0500
In-Reply-To: <1453995276-24955-8-git-send-email-sumit.saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>, jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com

On 28.1.2016 16:34, Sumit Saxena wrote:
> This patch will create reply queue pool for each MSI-x index and will provide array of all reply queue base address
> instead of single base address of legacy mode. Using this new interface Driver can support higher Queue depth allocating
> more reply queue as scattered DMA pool. 
>
> If array mode is not supported driver will fall back to legacy method of allocation reply pool. 
> This method fall back controller queue depth to 1K max. To enable more than 1K QD, driver expect FW to support Array mode 
> and scratch_pad3 should provide new queue depth value.
>
> Using this method, Firmware should not allow downgrade (OFU) if latest driver and latest FW report 4K QD and Array mode reply queue.
> This type of FW upgrade may cause firmware fault and it should not be supported. Upgrade of FW will work, 
> but queue depth of the controller will be unchanged until reboot/driver reload.
>
> I have accomodated Tomas' comments in this patch- fix few error handling cases inside functions-
> megasas_alloc_cmdlist_fusion() and megasas_alloc_cmds_fusion(), fix typo- disable(old- disbale)
> in rdpq_enable module parameter's description, modify print to reflect RDPQ support statement correctly.
>
>
> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |   6 +-
>  drivers/scsi/megaraid/megaraid_sas_base.c   |   9 +
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 543 ++++++++++++++++------------
>  drivers/scsi/megaraid/megaraid_sas_fusion.h |  12 +-
>  4 files changed, 331 insertions(+), 239 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index 01135be..3b1ed2d 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -152,6 +152,7 @@
>  #define MFI_RESET_FLAGS				MFI_INIT_READY| \
>  						MFI_INIT_MFIMODE| \
>  						MFI_INIT_ABORT
> +#define MPI2_IOCINIT_MSGFLAG_RDPQ_ARRAY_MODE    (0x01)
>  
>  /*
>   * MFI frame flags
> @@ -1416,6 +1417,7 @@ enum DCMD_TIMEOUT_ACTION {
>  #define MR_MAX_REPLY_QUEUES_EXT_OFFSET          0X003FC000
>  #define MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT    14
>  #define MR_MAX_MSIX_REG_ARRAY                   16
> +#define MR_RDPQ_MODE_OFFSET			0X00800000
>  /*
>  * register set for both 1068 and 1078 controllers
>  * structure extended for 1078 registers
> @@ -1455,8 +1457,9 @@ struct megasas_register_set {
>  
>  	u32 	outbound_scratch_pad ;		/*00B0h*/
>  	u32	outbound_scratch_pad_2;         /*00B4h*/
> +	u32	outbound_scratch_pad_3;         /*00B8h*/
>  
> -	u32	reserved_4[2];			/*00B8h*/
> +	u32	reserved_4;			/*00BCh*/
>  
>  	u32 	inbound_low_queue_port ;	/*00C0h*/
>  
> @@ -2117,6 +2120,7 @@ struct megasas_instance {
>  	u8 mask_interrupts;
>  	u16 max_chain_frame_sz;
>  	u8 is_imr;
> +	u8 is_rdpq;
>  	bool dev_handle;
>  };
>  struct MR_LD_VF_MAP {
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index ea3994b..8df58c2 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -92,6 +92,10 @@ int smp_affinity_enable = 1;
>  module_param(smp_affinity_enable, int, S_IRUGO);
>  MODULE_PARM_DESC(smp_affinity_enable, "SMP affinity feature enable/disbale Default: enable(1)");
>  
> +int rdpq_enable = 1;
> +module_param(rdpq_enable, int, S_IRUGO);
> +MODULE_PARM_DESC(rdpq_enable, " Allocate reply queue in chunks for large queue depth enable/disable Default: disable(0)");

Thanks for fixing the typo, but the message still says "Default: disable(0)" - it should be "Default: enabled(1)"
 
A fix in next series if fine for me. Martin has also already added this series to scsi-queue 
so my review tag is not needed.

Cheers,
Tomas


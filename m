From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/10] mpt3sas: Increased/Additional MSIX support for
 SAS35 devices.
Date: Mon, 24 Oct 2016 16:50:27 +0200
Message-ID: <f5e9883a-2244-97dd-7ad4-9f978e39ee83@suse.de>
References: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1476966018-10457-8-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57198 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938937AbcJXOvB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Oct 2016 10:51:01 -0400
In-Reply-To: <1476966018-10457-8-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com

On 10/20/2016 02:20 PM, Suganath Prabu S wrote:
> For SAS35 devices MSIX vectors are inceased to 128 from 96. To support this
> Reply post host index register count is increased to 16. Also variable
> msix96_vector is replaced with combined_reply_queue and variable
> combined_reply_index_count is added to set different values for SAS3 and
> SAS35 devices.
>
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c  | 14 +++++++-------
>  drivers/scsi/mpt3sas/mpt3sas_base.h  |  8 +++++---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 11 +++++++++--
>  3 files changed, 21 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 9ad7f7c..43cdc02 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -1078,7 +1078,7 @@ _base_interrupt(int irq, void *bus_id)
>  	 * new reply host index value in ReplyPostIndex Field and msix_index
>  	 * value in MSIxIndex field.
>  	 */
> -	if (ioc->msix96_vector)
> +	if (ioc->combined_reply_queue)
>  		writel(reply_q->reply_post_host_index | ((msix_index  & 7) <<
>  			MPI2_RPHI_MSIX_INDEX_SHIFT),
>  			ioc->replyPostRegisterIndex[msix_index/8]);
> @@ -2052,7 +2052,7 @@ mpt3sas_base_unmap_resources(struct MPT3SAS_ADAPTER *ioc)
>  	_base_free_irq(ioc);
>  	_base_disable_msix(ioc);
>
> -	if (ioc->msix96_vector) {
> +	if (ioc->combined_reply_queue) {
>  		kfree(ioc->replyPostRegisterIndex);
>  		ioc->replyPostRegisterIndex = NULL;
>  	}
> @@ -2162,7 +2162,7 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
>  	/* Use the Combined reply queue feature only for SAS3 C0 & higher
>  	 * revision HBAs and also only when reply queue count is greater than 8
>  	 */
> -	if (ioc->msix96_vector && ioc->reply_queue_count > 8) {
> +	if (ioc->combined_reply_queue && ioc->reply_queue_count > 8) {
>  		/* Determine the Supplemental Reply Post Host Index Registers
>  		 * Addresse. Supplemental Reply Post Host Index Registers
>  		 * starts at offset MPI25_SUP_REPLY_POST_HOST_INDEX_OFFSET and
> @@ -2170,7 +2170,7 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
>  		 * MPT3_SUP_REPLY_POST_HOST_INDEX_REG_OFFSET from previous one.
>  		 */
>  		ioc->replyPostRegisterIndex = kcalloc(
> -		     MPT3_SUP_REPLY_POST_HOST_INDEX_REG_COUNT,
> +		     ioc->combined_reply_index_count,
>  		     sizeof(resource_size_t *), GFP_KERNEL);
>  		if (!ioc->replyPostRegisterIndex) {
>  			dfailprintk(ioc, printk(MPT3SAS_FMT
> @@ -2180,14 +2180,14 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
>  			goto out_fail;
>  		}
>
> -		for (i = 0; i < MPT3_SUP_REPLY_POST_HOST_INDEX_REG_COUNT; i++) {
> +		for (i = 0; i < ioc->combined_reply_index_count; i++) {
>  			ioc->replyPostRegisterIndex[i] = (resource_size_t *)
>  			     ((u8 *)&ioc->chip->Doorbell +
>  			     MPI25_SUP_REPLY_POST_HOST_INDEX_OFFSET +
>  			     (i * MPT3_SUP_REPLY_POST_HOST_INDEX_REG_OFFSET));
>  		}
>  	} else
> -		ioc->msix96_vector = 0;
> +		ioc->combined_reply_queue = 0;
>
>  	if (ioc->is_warpdrive) {
>  		ioc->reply_post_host_index[0] = (resource_size_t __iomem *)
> @@ -5140,7 +5140,7 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc)
>
>  	/* initialize reply post host index */
>  	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
> -		if (ioc->msix96_vector)
> +		if (ioc->combined_reply_queue)
>  			writel((reply_q->msix_index & 7)<<
>  			   MPI2_RPHI_MSIX_INDEX_SHIFT,
>  			   ioc->replyPostRegisterIndex[reply_q->msix_index/8]);
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index 3d75c57..acb4106 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -300,8 +300,9 @@
>   * There are twelve Supplemental Reply Post Host Index Registers
>   * and each register is at offset 0x10 bytes from the previous one.
>   */
> -#define MPT3_SUP_REPLY_POST_HOST_INDEX_REG_COUNT 12
> -#define MPT3_SUP_REPLY_POST_HOST_INDEX_REG_OFFSET (0x10)
> +#define MPT3_SUP_REPLY_POST_HOST_INDEX_REG_COUNT_G3	12
> +#define MPT3_SUP_REPLY_POST_HOST_INDEX_REG_COUNT_G35	16
> +#define MPT3_SUP_REPLY_POST_HOST_INDEX_REG_OFFSET	(0x10)
>
>  /* OEM Identifiers */
>  #define MFG10_OEM_ID_INVALID                   (0x00000000)
> @@ -1158,7 +1159,8 @@ struct MPT3SAS_ADAPTER {
>  	u8		reply_queue_count;
>  	struct list_head reply_queue_list;
>
> -	u8		msix96_vector;
> +	u8		combined_reply_queue;
> +	u8		combined_reply_index_count;
>  	/* reply post register index */
>  	resource_size_t	**replyPostRegisterIndex;
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 521849d..a1c541d 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -8748,8 +8748,15 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		}
>  		if ((ioc->hba_mpi_version_belonged == MPI25_VERSION &&
>  			pdev->revision >= SAS3_PCI_DEVICE_C0_REVISION) ||
> -			(ioc->hba_mpi_version_belonged == MPI26_VERSION))
> -			ioc->msix96_vector = 1;
> +			(ioc->hba_mpi_version_belonged == MPI26_VERSION)) {
> +			ioc->combined_reply_queue = 1;
> +			if (ioc->is_gen35_ioc)
> +				ioc->combined_reply_index_count =
> +				 MPT3_SUP_REPLY_POST_HOST_INDEX_REG_COUNT_G35;
> +			else
> +				ioc->combined_reply_index_count =
> +				 MPT3_SUP_REPLY_POST_HOST_INDEX_REG_COUNT_G3;
> +		}
>  		break;
>  	default:
>  		return -ENODEV;
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

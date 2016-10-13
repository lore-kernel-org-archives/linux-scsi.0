From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 16/17 v2] lpfc: Fix fw download on SLI-4 FC adapters
Date: Thu, 13 Oct 2016 10:18:54 +0200
Message-ID: <20161013081854.4cupgempbutag34p@linux-x5ow.site>
References: <57fe999b.LkhVzK2phIyu2/YN%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41225 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751529AbcJMIS4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 04:18:56 -0400
Content-Disposition: inline
In-Reply-To: <57fe999b.LkhVzK2phIyu2/YN%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Oct 12, 2016 at 01:14:19PM -0700, James Smart wrote:
> 
> Fix fw download on SLI-4 FC adapters
> 
> Driver performs a quick validation of magic numbers in the fw
> download image. Driver needed to be updated for more recent
> magic numbers.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_hw4.h  |  3 ++-
>  drivers/scsi/lpfc/lpfc_init.c | 15 ++++++++-------
>  2 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
> index bbdcb5a..5646699 100644
> --- a/drivers/scsi/lpfc/lpfc_hw4.h
> +++ b/drivers/scsi/lpfc/lpfc_hw4.h
> @@ -3996,7 +3996,8 @@ union lpfc_wqe128 {
>  	struct gen_req64_wqe gen_req;
>  };
>  
> -#define LPFC_GROUP_OJECT_MAGIC_NUM		0xfeaa0001
> +#define LPFC_GROUP_OJECT_MAGIC_G5		0xfeaa0001
> +#define LPFC_GROUP_OJECT_MAGIC_G6		0xfeaa0003
>  #define LPFC_FILE_TYPE_GROUP			0xf7
>  #define LPFC_FILE_ID_GROUP			0xa2
>  struct lpfc_grp_hdr {
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 53227e5..442bbb8 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -10321,17 +10321,18 @@ lpfc_write_firmware(const struct firmware *fw, void *context)
>  	image = (struct lpfc_grp_hdr *)fw->data;
>  
>  	INIT_LIST_HEAD(&dma_buffer_list);
> -	if ((be32_to_cpu(image->magic_number) != LPFC_GROUP_OJECT_MAGIC_NUM) ||
> -	    (bf_get_be32(lpfc_grp_hdr_file_type, image) !=
> -	     LPFC_FILE_TYPE_GROUP) ||
> -	    (bf_get_be32(lpfc_grp_hdr_id, image) != LPFC_FILE_ID_GROUP) ||
> -	    (be32_to_cpu(image->size) != fw->size)) {
> +	if (((be32_to_cpu(image->magic_number) != LPFC_GROUP_OJECT_MAGIC_G5) &&
> +	     (be32_to_cpu(image->magic_number) != LPFC_GROUP_OJECT_MAGIC_G6)) ||
> +	   (bf_get_be32(lpfc_grp_hdr_file_type, image) !=
> +	    LPFC_FILE_TYPE_GROUP) ||
> +	   (be32_to_cpu(image->size) != fw->size)) {
>  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
>  				"3022 Invalid FW image found. "
> -				"Magic:%x Type:%x ID:%x\n",
> +				"Magic:%x Type:%x ID:%x Size %d %ld\n",
>  				be32_to_cpu(image->magic_number),
>  				bf_get_be32(lpfc_grp_hdr_file_type, image),
> -				bf_get_be32(lpfc_grp_hdr_id, image));
> +				bf_get_be32(lpfc_grp_hdr_id, image),
> +				be32_to_cpu(image->size), fw->size);
>  		rc = -EINVAL;
>  		goto release_out;
>  	}

Maybe:
	u32 magic_number = be32_to_cpu(image->magic_number);
	u32 lpfc_grp_hdr_file_type = bf_get_be32(lpfc_grp_hdr_file_type,
						 image);
	u32 lpfc_grp_hdr_id = bf_get_be32(lpfc_grp_hdr_id, image);
	u32 size = be32_to_cpu(image->size);

	if ((magic_number != LPFC_GROUP_OJECT_MAGIC_G5 &&
	     magic_number != LPFC_GROUP_OJECT_MAGIC_G6) ||
	     lpfc_grp_hdr_file_type != LPFC_FILE_TYPE_GROUP ||
	     size != fw->size) {
	     lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
			     "3022 Invalid FW image found. "
			     "Magic:%x Type:%x ID:%x Size %d %ld\n", 
			     lpfc_grp_hdr_file_type,
			     lpfc_grp_hdr_id, size, fw->size);
	     rc = -EINVAL;
	     goto release_out;
	}


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

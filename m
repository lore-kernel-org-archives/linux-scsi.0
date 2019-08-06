From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] lpfc: Fix Buffer Overflow Error
Date: Tue, 6 Aug 2019 11:25:19 +0200
Message-ID: <a8b38655-018e-4bc7-0dbf-792f72cbc8b6@suse.de>
References: <1562948135-5533-1-git-send-email-kmahlkuc@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1562948135-5533-1-git-send-email-kmahlkuc@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: KyleMahlkuch <kmahlkuc@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 7/12/19 6:15 PM, KyleMahlkuch wrote:
> Power and x86 have different page sizes so rather than allocate the
> buffer based on number of pages we should allocate space by using
> max_sectors. There is also code in lpfc_scsi.c to be sure we don't
> write past the end of this buffer.
> 
> Signed-off-by: KyleMahlkuch <kmahlkuc@linux.vnet.ibm.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 41 +++++++----------------------------------
>  drivers/scsi/lpfc/lpfc_scsi.c | 14 ++++++++++++--
>  2 files changed, 19 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index eaaef68..59b52a0 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -39,6 +39,7 @@
>  #include <linux/msi.h>
>  #include <linux/irq.h>
>  #include <linux/bitops.h>
> +#include <linux/vmalloc.h>
>  
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_device.h>
> @@ -7549,7 +7550,6 @@ struct lpfc_rpi_hdr *
>  	uint32_t old_mask;
>  	uint32_t old_guard;
>  
> -	int pagecnt = 10;
>  	if (phba->cfg_prot_mask && phba->cfg_prot_guard) {
>  		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
>  				"1478 Registering BlockGuard with the "
> @@ -7588,23 +7588,9 @@ struct lpfc_rpi_hdr *
>  	}
>  
>  	if (!_dump_buf_data) {
> -		while (pagecnt) {
> -			spin_lock_init(&_dump_buf_lock);
> -			_dump_buf_data =
> -				(char *) __get_free_pages(GFP_KERNEL, pagecnt);
> -			if (_dump_buf_data) {
> -				lpfc_printf_log(phba, KERN_ERR, LOG_BG,
> -					"9043 BLKGRD: allocated %d pages for "
> -				       "_dump_buf_data at 0x%p\n",
> -				       (1 << pagecnt), _dump_buf_data);
> -				_dump_buf_data_order = pagecnt;
> -				memset(_dump_buf_data, 0,
> -				       ((1 << PAGE_SHIFT) << pagecnt));
> -				break;
> -			} else
> -				--pagecnt;
> -		}
> -		if (!_dump_buf_data_order)
> +		_dump_buf_data = (char *) vmalloc(shost->hostt->max_sectors * 512);
> +		_dump_buf_data_order = get_order(shost->hostt->max_sectors * 512);
> +		if (!_dump_buf_data)
>  			lpfc_printf_log(phba, KERN_ERR, LOG_BG,
>  				"9044 BLKGRD: ERROR unable to allocate "
>  			       "memory for hexdump\n");
> @@ -7613,22 +7599,9 @@ struct lpfc_rpi_hdr *
>  			"9045 BLKGRD: already allocated _dump_buf_data=0x%p"
>  		       "\n", _dump_buf_data);
>  	if (!_dump_buf_dif) {
> -		while (pagecnt) {
> -			_dump_buf_dif =
> -				(char *) __get_free_pages(GFP_KERNEL, pagecnt);
> -			if (_dump_buf_dif) {
> -				lpfc_printf_log(phba, KERN_ERR, LOG_BG,
> -					"9046 BLKGRD: allocated %d pages for "
> -				       "_dump_buf_dif at 0x%p\n",
> -				       (1 << pagecnt), _dump_buf_dif);
> -				_dump_buf_dif_order = pagecnt;
> -				memset(_dump_buf_dif, 0,
> -				       ((1 << PAGE_SHIFT) << pagecnt));
> -				break;
> -			} else
> -				--pagecnt;
> -		}
> -		if (!_dump_buf_dif_order)
> +		_dump_buf_dif = (char *) vmalloc(shost->hostt->max_sectors * 512);
> +		_dump_buf_dif_order = get_order(shost->hostt->max_sectors * 512);
> +		if (!_dump_buf_dif)
>  			lpfc_printf_log(phba, KERN_ERR, LOG_BG,
>  			"9047 BLKGRD: ERROR unable to allocate "
>  			       "memory for hexdump\n");
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index ba996fb..719612d 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -92,7 +92,7 @@ struct scsi_dif_tuple {
>  static void
>  lpfc_debug_save_data(struct lpfc_hba *phba, struct scsi_cmnd *cmnd)
>  {
> -	void *src, *dst;
> +	void *src, *dst, *end;
>  	struct scatterlist *sgde = scsi_sglist(cmnd);
>  
>  	if (!_dump_buf_data) {
> @@ -110,7 +110,12 @@ struct scsi_dif_tuple {
>  	}
>  
>  	dst = (void *) _dump_buf_data;
> +	end = ((char *) dst) + ((1 << PAGE_SHIFT) << _dump_buf_data_order);
>  	while (sgde) {
> +		if (dst + sgde->length >= end) {
> +			printk(KERN_ERR "overflow buffer\n");
> +			break;
> +		}
>  		src = sg_virt(sgde);
>  		memcpy(dst, src, sgde->length);
>  		dst += sgde->length;
> @@ -121,7 +126,7 @@ struct scsi_dif_tuple {
>  static void
>  lpfc_debug_save_dif(struct lpfc_hba *phba, struct scsi_cmnd *cmnd)
>  {
> -	void *src, *dst;
> +	void *src, *dst, *end;
>  	struct scatterlist *sgde = scsi_prot_sglist(cmnd);
>  
>  	if (!_dump_buf_dif) {
> @@ -138,7 +143,12 @@ struct scsi_dif_tuple {
>  	}
>  
>  	dst = _dump_buf_dif;
> +	end = ((char *) dst) + ((1 << PAGE_SHIFT) << _dump_buf_dif_order);
>  	while (sgde) {
> +		if (dst + sgde->length >= end) {
> +			printk(KERN_ERR "overflow buffer\n");
> +			break;
> +		}
>  		src = sg_virt(sgde);
>  		memcpy(dst, src, sgde->length);
>  		dst += sgde->length;
> 
Not sure this is correct.
vmalloc() is not equivalent to __get_pages().

I would rather start off with the fixed buffer size (say, 40k), and
calculate the values like pagecnt etc from there.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)

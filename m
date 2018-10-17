From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH -next] advansys: remove set but not used variable
 'srb_tag' in adv_isr_callback
Date: Wed, 17 Oct 2018 14:49:50 +0200
Message-ID: <4950b4fe-61b5-e1c3-9d16-7643107857a5@suse.de>
References: <20181017123432.18304-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017123432.18304-1-yuehaibing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>, willy@infradead.org, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 17/10/18 14:34, YueHaibing wrote:
> drivers/scsi/advansys.c: In function 'adv_isr_callback':
> drivers/scsi/advansys.c:5952:6: warning:
>  variable 'srb_tag' set but not used [-Wunused-but-set-variable]
> 
> It never used since introduction in
> commit 9c17c62aedb0 ("advansys: use shared host tag map for command lookup")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/scsi/advansys.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 44c9619..223ef6f 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -5949,7 +5949,6 @@ static void adv_async_callback(ADV_DVC_VAR *adv_dvc_varp, uchar code)
>  static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
>  {
>  	struct asc_board *boardp = adv_dvc_varp->drv_ptr;
> -	u32 srb_tag;
>  	adv_req_t *reqp;
>  	adv_sgblk_t *sgblkp;
>  	struct scsi_cmnd *scp;
> @@ -5965,7 +5964,6 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
>  	 * completed. The adv_req_t structure actually contains the
>  	 * completed ADV_SCSI_REQ_Q structure.
>  	 */
> -	srb_tag = le32_to_cpu(scsiqp->srb_tag);
>  	scp = scsi_host_find_tag(boardp->shost, scsiqp->srb_tag);

Shouldn't this be:
	scp = scsi_host_find_tag(boardp->shost,
					le32_to_cpu(scsiqp->srb_tag));


-- 
Johannes Thumshirn                                        SUSE Labs
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 01/14] lpfc: Double WQ element count to keep iops up
Date: Fri, 12 Aug 2016 10:21:44 +0200
Message-ID: <20160812082144.tguxs4wsglycg7yu@c203.arch.suse.de>
References: <57acc584.71VgLPvkdT6sQCgh%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59758 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbcHLIWi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2016 04:22:38 -0400
Content-Disposition: inline
In-Reply-To: <57acc584.71VgLPvkdT6sQCgh%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Aug 11, 2016 at 11:35:48AM -0700, James Smart wrote:
> 
> Double WQ element count to keep iops up
> 
> On embedded io queues, use the default element count, which is twice the
> size of the default large WQE element count.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index adf61b43..64b6313 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -7349,7 +7349,7 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
>  		if (phba->fcp_embed_io) {
>  			qdesc = lpfc_sli4_queue_alloc(phba,
>  						      LPFC_WQE128_SIZE,
> -						      LPFC_WQE128_DEF_COUNT);
> +						      phba->sli4_hba.wq_ecount);
>  		} else {
>  			qdesc = lpfc_sli4_queue_alloc(phba,
>  						      phba->sli4_hba.wq_esize,


Hmm what about:

u32 entry_size;

[...]

if (phba->fc_embed_io)
	entry_size = LPFC_WQE128_DEF_SIZE;
else
	entry_size = phba->sli4_hba.wq_esize;

qdesc = lpfc_sli4_queue_alloc(phba,
			      entry_size,
			      phba->sli4_hba.wq_ecount);


Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

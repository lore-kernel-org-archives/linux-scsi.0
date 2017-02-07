From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 01/18] lpfc: Correct WQ creation for pagesize
Date: Tue, 7 Feb 2017 09:30:25 +0100
Message-ID: <72365ed8-6b4c-2dcf-5a37-ecd5885e1e4f@suse.de>
References: <58990202.ppD+DnSRmfoY41ZK%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46128 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752323AbdBGIa1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Feb 2017 03:30:27 -0500
In-Reply-To: <58990202.ppD+DnSRmfoY41ZK%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 02/07/2017 12:08 AM, James Smart wrote:
> 
> Correct WQ creation for pagesize
> 
> The driver was calculating the adapter command pagesize indicator from
> the system pagesize. However, the buffers the driver allocates are only
> one size (SLI4_PAGE_SIZE), so no calculation was necessary.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
> Note: this patch was not in v1
> 
>  drivers/scsi/lpfc/lpfc_hw4.h | 2 ++
>  drivers/scsi/lpfc/lpfc_sli.c | 9 +++++----
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
> index 5646699..964a1fd 100644
> --- a/drivers/scsi/lpfc/lpfc_hw4.h
> +++ b/drivers/scsi/lpfc/lpfc_hw4.h
> @@ -1186,6 +1186,7 @@ struct lpfc_mbx_wq_create {
>  #define lpfc_mbx_wq_create_page_size_SHIFT	0
>  #define lpfc_mbx_wq_create_page_size_MASK	0x000000FF
>  #define lpfc_mbx_wq_create_page_size_WORD	word1
> +#define LPFC_WQ_PAGE_SIZE_4096	0x1
>  #define lpfc_mbx_wq_create_wqe_size_SHIFT	8
>  #define lpfc_mbx_wq_create_wqe_size_MASK	0x0000000F
>  #define lpfc_mbx_wq_create_wqe_size_WORD	word1
> @@ -1257,6 +1258,7 @@ struct rq_context {
>  #define lpfc_rq_context_page_size_SHIFT	0		/* Version 1 Only */
>  #define lpfc_rq_context_page_size_MASK	0x000000FF
>  #define lpfc_rq_context_page_size_WORD	word0
> +#define	LPFC_RQ_PAGE_SIZE_4096	0x1

I wonder why do we need the two LPFC_RQ_PAGE_SIZE_4096 and
LPFC_WQ_PAGE_SIZE_4096 both being 1? Wouldn't a more global
LPFC_PAGE_SIZE_4096 or LPFC_Q_PAGE_SIZE_4096 be sufficient?

But I don't have a strong opinion on this either.

Otherwise,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

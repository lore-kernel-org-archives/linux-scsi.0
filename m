From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] cxgb3i: fixed programing of the dma page sizes
Date: Fri, 24 Jun 2011 13:46:47 -0500
Message-ID: <4E04DB97.8030101@cs.wisc.edu>
References: <201106172310.p5HNAWQ5028255@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45924 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab1FXSpL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jun 2011 14:45:11 -0400
In-Reply-To: <201106172310.p5HNAWQ5028255@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kxie@chelsio.com
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, James.Bottomley@HansenPartnership.com

On 06/17/2011 06:10 PM, kxie@chelsio.com wrote:
> [PATCH] cxgb3i: fixed programing of the dma page sizes
> 
> From: Karen Xie <kxie@chelsio.com>
> 
> Fixed missing programming of the pages sizes for DMA. 
> 
> Signed-off-by: Karen Xie <kxie@chelsio.com>
> ---
>  drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> index fc2cdb6..ffb9eea 100644
> --- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> +++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> @@ -1245,7 +1245,7 @@ static int cxgb3i_ddp_init(struct cxgbi_device *cdev)
>  	struct cxgbi_ddp_info *ddp = tdev->ulp_iscsi;
>  	struct ulp_iscsi_info uinfo;
>  	unsigned int pgsz_factor[4];
> -	int err;
> +	int i, err;
>  
>  	if (ddp) {
>  		kref_get(&ddp->refcnt);
> @@ -1271,6 +1271,8 @@ static int cxgb3i_ddp_init(struct cxgbi_device *cdev)
>  
>  	uinfo.tagmask = ddp->idx_mask << PPOD_IDX_SHIFT;
>  	cxgbi_ddp_page_size_factor(pgsz_factor);
> +	for (i = 0; i < 4; i++)
> +		uinfo.pgsz_factor[i] = pgsz_factor[i];
>  	uinfo.ulimit = uinfo.llimit + (ddp->nppods << PPOD_SIZE_SHIFT);
>  
>  	err = tdev->ctl(tdev, ULP_ISCSI_SET_PARAMS, &uinfo);

Looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

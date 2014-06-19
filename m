From: Eddie Wai <eddie.wai@broadcom.com>
Subject: Re: [PATCH] bnx2fc: do not scan uninitialized lists in case of
 error.
Date: Thu, 19 Jun 2014 09:56:05 -0700
Message-ID: <1403196965.31848.7.camel@lbirv-waie-lx2.broadcom.com>
References: <1403183100-15011-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:47959 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232AbaFSRBo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2014 13:01:44 -0400
In-Reply-To: <1403183100-15011-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: linux-scsi@vger.kernel.org, hch@lst.de, James.Bottomley@HansenPartnership.com

On Thu, 2014-06-19 at 15:05 +0200, Maurizio Lombardi wrote:
> In case of of error, the bnx2fc_cmd_mgr_alloc() function will call
> the bnx2fc_cmd_mgr_free() to perform the cleanup.
> The problem is that in one case the latter may try to scan
> some not-yet initialized lists, resulting in a kernel panic.
> 
> This patch prevents this from happening by freeing the lists
> before calling bnx2fc_cmd_mgr_free().
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_io.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 32a5e0a..7bc47fc 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -282,6 +282,8 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
>  				       arr_sz, GFP_KERNEL);
>  	if (!cmgr->free_list_lock) {
>  		printk(KERN_ERR PFX "failed to alloc free_list_lock\n");
> +		kfree(cmgr->free_list);
> +		cmgr->free_list = NULL;
>  		goto mem_err;
>  	}
>  
Agreed.  Thanks for fixing this, Maurizio.

Acked-by: Eddie Wai <eddie.wai@broadcom.com>



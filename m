From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvscsi: avoid unnecessary use of kzalloc_pool
Date: Mon, 03 Aug 2009 16:19:48 -0500
Message-ID: <4A775474.8000705@linux.vnet.ibm.com>
References: <1249332888-13440-1-git-send-email-sage@newdream.net> <1249332888-13440-2-git-send-email-sage@newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753922AbZHCVTv@vger.kernel.org>
In-Reply-To: <1249332888-13440-2-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

Acked-by: Brian King <brking@linux.vnet.ibm.com>

Sage Weil wrote:
> The allocated struct is manually zeroed after allocation, so avoid using
> the (broken) kzalloc mempool (which does not re-zero previously used items
> when they are returned to the pool).
> 
> CC: linux-scsi@vger.kernel.org
> CC: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 166d964..bb2c696 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -4217,7 +4217,7 @@ static int ibmvfc_alloc_mem(struct ibmvfc_host *vhost)
>  	if (!vhost->trace)
>  		goto free_disc_buffer;
> 
> -	vhost->tgt_pool = mempool_create_kzalloc_pool(IBMVFC_TGT_MEMPOOL_SZ,
> +	vhost->tgt_pool = mempool_create_kmalloc_pool(IBMVFC_TGT_MEMPOOL_SZ,
>  						      sizeof(struct ibmvfc_target));
> 
>  	if (!vhost->tgt_pool) {


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center

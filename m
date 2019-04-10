From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH][V2] scsi: cxgbi: remove redundant __kfree_skb call on
 skb and free cst->atid
Date: Wed, 10 Apr 2019 22:52:15 +0300
Message-ID: <20190410195215.GH6095@kadam>
References: <20190410155431.10045-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190410155431.10045-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Karen Xie <kxie@chelsio.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 10, 2019 at 04:54:31PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The error return path via label rel_resource checks for a non-null
> skb before free'ing it.  However, skb is always null at this exit
> path, so the null check and the free are redundant and can be removed.
> Removing this allows the original goto's to rel_resource to be cleaned
> up; the first can be replaced by a return of -EINVAL, the second can
> be replaced by a more appropriate -ENOMEM return and fix a memory
> leak by freeing csk->atid
> 
> Addresses-Coverity: ("Logically Dead Code")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
> 
> V2: Ensure cst->atid is free'd to fix memory leak, thanks to
>     Walter Harms for spotting this mistake in V1.
> ---
>  drivers/scsi/cxgbi/cxgb3i/cxgb3i.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> index 75e1273a44b3..15a48c2ac536 100644
> --- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> +++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> @@ -979,14 +979,16 @@ static int init_act_open(struct cxgbi_sock *csk)
>  	csk->atid = cxgb3_alloc_atid(t3dev, &t3_client, csk);
>  	if (csk->atid < 0) {
>  		pr_err("NO atid available.\n");
> -		goto rel_resource;
> +		return -EINVAL;
>  	}
>  	cxgbi_sock_set_flag(csk, CTPF_HAS_ATID);
>  	cxgbi_sock_get(csk);
        ^^^^^^^^^^^^^^^^^^^
Don't we need to a put for this as well?

>  
>  	skb = alloc_wr(sizeof(struct cpl_act_open_req), 0, GFP_KERNEL);
> -	if (!skb)
> -		goto rel_resource;
> +	if (!skb) {
> +		cxgb3_free_atid(t3dev, csk->atid);
> +		return -ENOMEM;
> +	}


regards,
dan carpenter

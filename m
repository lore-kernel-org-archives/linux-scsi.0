From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH][V2] scsi: cxgb3i: remove redundant null check and kfree
 on skb
Date: Tue, 14 Mar 2017 12:34:31 +0100
Message-ID: <20170314113431.GC4015@linux-x5ow.site>
References: <20170314104843.1358-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170314104843.1358-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Karen Xie <kxie@chelsio.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 14, 2017 at 10:48:43AM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> On the error exit path, skb is always null, so the non-null check
> and __kfree_skb call are redundant.  Remove the redundant code and
> just directly return with the appropriate error return code.
> 
> Detected by CoverityScan, CID#114328 ("Logically Dead Code")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/cxgbi/cxgb3i/cxgb3i.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> index 1880eb6..3c9f8cf2 100644
> --- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> +++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> @@ -979,14 +979,14 @@ static int init_act_open(struct cxgbi_sock *csk)
>  	csk->atid = cxgb3_alloc_atid(t3dev, &t3_client, csk);
>  	if (csk->atid < 0) {
>  		pr_err("NO atid available.\n");
> -		goto rel_resource;
> +		return -EINVAL;
>  	}
>  	cxgbi_sock_set_flag(csk, CTPF_HAS_ATID);
>  	cxgbi_sock_get(csk);
>  
>  	skb = alloc_wr(sizeof(struct cpl_act_open_req), 0, GFP_KERNEL);
>  	if (!skb)
> -		goto rel_resource;
> +		return -ENOMEM;

I don't think that's correct, not that it was before. cxgbi_sock_get(csk) does a
kref_get(&csk->refcnt), so this will at lease leak a kref. It will also "leak"
the atids_in_use in cxgb3_alloc_atid() as there's a call to cxgb3_free_atid()
missing. Looks like the complete cleanup path is worng here.

But I'd prefer having Karen or someone else at Chelsio confirm my assumptions.

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

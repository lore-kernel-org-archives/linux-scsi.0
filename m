From: Tyrel Datwyler <turtle.in.the.kernel@gmail.com>
Subject: Re: [PATCH] scsi: ibmvfc: don't check for failure from
 mempool_alloc()
Date: Mon, 17 Apr 2017 12:03:09 -0700
Message-ID: <6b896452-e653-bc96-3c26-1deeae995890@gmail.com>
References: <878tn9xb2m.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878tn9xb2m.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/09/2017 07:15 PM, NeilBrown wrote:
> 
> mempool_alloc() cannot fail when passed GFP_NOIO or any
> other gfp setting that is permitted to sleep.
> So remove this pointless code.
> 
> Signed-off-by: NeilBrown <neilb@suse.com>

Acked-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 2c92dabb55f6..26cd3c28186a 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -3910,12 +3910,6 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *vhost, u64 scsi_id)
>  	spin_unlock_irqrestore(vhost->host->host_lock, flags);
>  
>  	tgt = mempool_alloc(vhost->tgt_pool, GFP_NOIO);
> -	if (!tgt) {
> -		dev_err(vhost->dev, "Target allocation failure for scsi id %08llx\n",
> -			scsi_id);
> -		return -ENOMEM;
> -	}
> -
>  	memset(tgt, 0, sizeof(*tgt));
>  	tgt->scsi_id = scsi_id;
>  	tgt->new_scsi_id = scsi_id;
> 

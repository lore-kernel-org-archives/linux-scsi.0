From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvscsi: use GFP_KERNEL with dma_alloc_coherent in
 initialize_event_pool
Date: Thu, 10 Jan 2019 08:56:56 -0600
Message-ID: <fd33df0e-012b-e437-c6e9-29cd0883808d@linux.vnet.ibm.com>
References: <1547089149-20577-1-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1547089149-20577-1-git-send-email-tyreld@linux.vnet.ibm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, james.bottomley@hansenpartnership.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On 01/09/2019 08:59 PM, Tyrel Datwyler wrote:
> During driver probe we allocate a dma region for our event pool.
> Currently, zero is passed for the gfp_flags parameter. Driver probe
> callbacks run in process context and we hold no locks so we can sleep
> here if necessary.
> 
> Fix by passing GFP_KERNEL explicitly to dma_alloc_coherent().
> 
> Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index cb8535e..10d5e77 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -465,7 +465,7 @@ static int initialize_event_pool(struct event_pool *pool,
>  	pool->iu_storage =
>  	    dma_alloc_coherent(hostdata->dev,
>  			       pool->size * sizeof(*pool->iu_storage),
> -			       &pool->iu_token, 0);
> +			       &pool->iu_token, GFP_KERNEL);
>  	if (!pool->iu_storage) {
>  		kfree(pool->events);
>  		return -ENOMEM;
> 

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

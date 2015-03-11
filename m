From: Steffen Maier <maier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [patch] mm, mempool: do not allow atomic resizing
Date: Wed, 11 Mar 2015 13:41:36 +0100
Message-ID: <55003800.4020503@linux.vnet.ibm.com>
References: <alpine.DEB.2.10.1503071918080.8406@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1503071918080.8406-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

for the zfcp part:
Acked-by: Steffen Maier <maier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

On 03/08/2015 04:19 AM, David Rientjes wrote:
> Allocating a large number of elements in atomic context could quickly
> deplete memory reserves, so just disallow atomic resizing entirely.
>
> Nothing currently uses mempool_resize() with anything other than
> GFP_KERNEL, so convert existing callers to drop the gfp_mask.
>
> Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/s390/scsi/zfcp_erp.c | 4 ++--
>   fs/cifs/connect.c            | 6 ++----
>   include/linux/mempool.h      | 2 +-
>   mm/mempool.c                 | 9 +++++----
>   4 files changed, 10 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_er=
p.c
> --- a/drivers/s390/scsi/zfcp_erp.c
> +++ b/drivers/s390/scsi/zfcp_erp.c
> @@ -738,11 +738,11 @@ static int zfcp_erp_adapter_strategy_open_fsf(s=
truct zfcp_erp_action *act)
>   		return ZFCP_ERP_FAILED;
>
>   	if (mempool_resize(act->adapter->pool.sr_data,
> -			   act->adapter->stat_read_buf_num, GFP_KERNEL))
> +			   act->adapter->stat_read_buf_num))
>   		return ZFCP_ERP_FAILED;
>
>   	if (mempool_resize(act->adapter->pool.status_read_req,
> -			   act->adapter->stat_read_buf_num, GFP_KERNEL))
> +			   act->adapter->stat_read_buf_num))
>   		return ZFCP_ERP_FAILED;
>
>   	atomic_set(&act->adapter->stat_miss, act->adapter->stat_read_buf_n=
um);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -773,8 +773,7 @@ static void clean_demultiplex_info(struct TCP_Ser=
ver_Info *server)
>
>   	length =3D atomic_dec_return(&tcpSesAllocCount);
>   	if (length > 0)
> -		mempool_resize(cifs_req_poolp, length + cifs_min_rcv,
> -				GFP_KERNEL);
> +		mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
>   }
>
>   static int
> @@ -848,8 +847,7 @@ cifs_demultiplex_thread(void *p)
>
>   	length =3D atomic_inc_return(&tcpSesAllocCount);
>   	if (length > 1)
> -		mempool_resize(cifs_req_poolp, length + cifs_min_rcv,
> -				GFP_KERNEL);
> +		mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
>
>   	set_freezable();
>   	while (server->tcpStatus !=3D CifsExiting) {
> diff --git a/include/linux/mempool.h b/include/linux/mempool.h
> --- a/include/linux/mempool.h
> +++ b/include/linux/mempool.h
> @@ -29,7 +29,7 @@ extern mempool_t *mempool_create_node(int min_nr, m=
empool_alloc_t *alloc_fn,
>   			mempool_free_t *free_fn, void *pool_data,
>   			gfp_t gfp_mask, int nid);
>
> -extern int mempool_resize(mempool_t *pool, int new_min_nr, gfp_t gfp=
_mask);
> +extern int mempool_resize(mempool_t *pool, int new_min_nr);
>   extern void mempool_destroy(mempool_t *pool);
>   extern void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask);
>   extern void mempool_free(void *element, mempool_t *pool);
> diff --git a/mm/mempool.c b/mm/mempool.c
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -113,23 +113,24 @@ EXPORT_SYMBOL(mempool_create_node);
>    *              mempool_create().
>    * @new_min_nr: the new minimum number of elements guaranteed to be
>    *              allocated for this pool.
> - * @gfp_mask:   the usual allocation bitmask.
>    *
>    * This function shrinks/grows the pool. In the case of growing,
>    * it cannot be guaranteed that the pool will be grown to the new
>    * size immediately, but new mempool_free() calls will refill it.
> + * This function may sleep.
>    *
>    * Note, the caller must guarantee that no mempool_destroy is calle=
d
>    * while this function is running. mempool_alloc() & mempool_free()
>    * might be called (eg. from IRQ contexts) while this function exec=
utes.
>    */
> -int mempool_resize(mempool_t *pool, int new_min_nr, gfp_t gfp_mask)
> +int mempool_resize(mempool_t *pool, int new_min_nr)
>   {
>   	void *element;
>   	void **new_elements;
>   	unsigned long flags;
>
>   	BUG_ON(new_min_nr <=3D 0);
> +	might_sleep();
>
>   	spin_lock_irqsave(&pool->lock, flags);
>   	if (new_min_nr <=3D pool->min_nr) {
> @@ -145,7 +146,7 @@ int mempool_resize(mempool_t *pool, int new_min_n=
r, gfp_t gfp_mask)
>   	spin_unlock_irqrestore(&pool->lock, flags);
>
>   	/* Grow the pool */
> -	new_elements =3D kmalloc(new_min_nr * sizeof(*new_elements), gfp_ma=
sk);
> +	new_elements =3D kmalloc(new_min_nr * sizeof(*new_elements), GFP_KE=
RNEL);
>   	if (!new_elements)
>   		return -ENOMEM;
>
> @@ -164,7 +165,7 @@ int mempool_resize(mempool_t *pool, int new_min_n=
r, gfp_t gfp_mask)
>
>   	while (pool->curr_nr < pool->min_nr) {
>   		spin_unlock_irqrestore(&pool->lock, flags);
> -		element =3D pool->alloc(gfp_mask, pool->pool_data);
> +		element =3D pool->alloc(GFP_KERNEL, pool->pool_data);
>   		if (!element)
>   			goto out;
>   		spin_lock_irqsave(&pool->lock, flags);
>

--=20
Mit freundlichen Gr=FC=DFen / Kind regards
Steffen Maier

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

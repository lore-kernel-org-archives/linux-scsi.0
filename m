From: Vasu Dev <vasu.dev-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] libfs: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Date: Thu, 25 Sep 2014 15:01:11 -0700
Message-ID: <1411682471.2856.3.camel@vfc0>
References: <20140818145622.GA14281@ada>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <20140818145622.GA14281@ada>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Andreea-Cristina Bernat <bernat.ada-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2014-08-18 at 17:56 +0300, Andreea-Cristina Bernat wrote:
> The uses of "rcu_assign_pointer()" are NULLing out the pointers.
> According to RCU_INIT_POINTER()'s block comment:
> "1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
> it is better to use it instead of rcu_assign_pointer() because it has a
> smaller overhead.
> 
> The following Coccinelle semantic patch was used:
> @@
> @@
> 
> - rcu_assign_pointer
> + RCU_INIT_POINTER
>   (..., NULL)
> 
> Signed-off-by: Andreea-Cristina Bernat <bernat.ada-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/scsi/libfc/fc_libfc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libfc/fc_libfc.c b/drivers/scsi/libfc/fc_libfc.c
> index 8d65a51a..c11a638 100644
> --- a/drivers/scsi/libfc/fc_libfc.c
> +++ b/drivers/scsi/libfc/fc_libfc.c
> @@ -296,9 +296,9 @@ void fc_fc4_deregister_provider(enum fc_fh_type type, struct fc4_prov *prov)
>  	BUG_ON(type >= FC_FC4_PROV_SIZE);
>  	mutex_lock(&fc_prov_mutex);
>  	if (prov->recv)
> -		rcu_assign_pointer(fc_passive_prov[type], NULL);
> +		RCU_INIT_POINTER(fc_passive_prov[type], NULL);
>  	else
> -		rcu_assign_pointer(fc_active_prov[type], NULL);
> +		RCU_INIT_POINTER(fc_active_prov[type], NULL);
>  	mutex_unlock(&fc_prov_mutex);
>  	synchronize_rcu();
>  }

Looks like patch is not yet applied.

Acked-by: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

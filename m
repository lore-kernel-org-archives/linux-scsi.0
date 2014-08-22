From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcm_fc: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Date: Fri, 22 Aug 2014 14:10:38 -0700
Message-ID: <1408741838.24496.15.camel@haakon3.risingtidesystems.com>
References: <20140818120537.GA19578@ada>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140818120537.GA19578@ada>
Sender: target-devel-owner@vger.kernel.org
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Cc: agrover@redhat.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

Hi Andreea-Cristina,

On Mon, 2014-08-18 at 15:05 +0300, Andreea-Cristina Bernat wrote:
> The use of "rcu_assign_pointer()" is NULLing out the pointer.
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
> Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
> ---
>  drivers/target/tcm_fc/tfc_sess.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
> index 21ce508..ccee7e3 100644
> --- a/drivers/target/tcm_fc/tfc_sess.c
> +++ b/drivers/target/tcm_fc/tfc_sess.c
> @@ -98,7 +98,7 @@ static void ft_tport_delete(struct ft_tport *tport)
>  	ft_sess_delete_all(tport);
>  	lport = tport->lport;
>  	BUG_ON(tport != lport->prov[FC_TYPE_FCP]);
> -	rcu_assign_pointer(lport->prov[FC_TYPE_FCP], NULL);
> +	RCU_INIT_POINTER(lport->prov[FC_TYPE_FCP], NULL);
>  
>  	tpg = tport->tpg;
>  	if (tpg) {

Applied to target-pending.git.

Thanks!

--nab

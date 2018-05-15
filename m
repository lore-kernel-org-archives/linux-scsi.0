From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] Convert target drivers to use sbitmap
Date: Tue, 15 May 2018 10:11:15 -0600
Message-ID: <3a56027b-47bc-dcb8-a465-3670031572f1@kernel.dk>
References: <20180515160043.27044-1-willy@infradead.org>
 <20180515160043.27044-2-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180515160043.27044-2-willy@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-usb@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, Juergen Gross <jgross@suse.com>, qla2xxx-upstream@qlogic.com, Kent Overstreet <kent.overstreet@gmail.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On 5/15/18 10:00 AM, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> The sbitmap and the percpu_ida perform essentially the same task,
> allocating tags for commands.  Since the sbitmap is more used than
> the percpu_ida, convert the percpu_ida users to the sbitmap API.

It should also be the same performance as percpu_ida in light use, and
performs much better at > 50% utilization of the tag space. I think
that's better justification than "more used than".

> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> index 4435bf374d2d..28bcffae609f 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -17,7 +17,7 @@
>   ******************************************************************************/
>  
>  #include <linux/list.h>
> -#include <linux/percpu_ida.h>
> +#include <linux/sched/signal.h>
>  #include <net/ipv6.h>         /* ipv6_addr_equal() */
>  #include <scsi/scsi_tcq.h>
>  #include <scsi/iscsi_proto.h>
> @@ -147,6 +147,28 @@ void iscsit_free_r2ts_from_list(struct iscsi_cmd *cmd)
>  	spin_unlock_bh(&cmd->r2t_lock);
>  }
>  
> +int iscsit_wait_for_tag(struct se_session *se_sess, int state, int *cpup)
> +{
> +	int tag = -1;
> +	DEFINE_WAIT(wait);
> +	struct sbq_wait_state *ws;
> +
> +	if (state == TASK_RUNNING)
> +		return tag;
> +
> +	ws = &se_sess->sess_tag_pool.ws[0];
> +	for (;;) {
> +		prepare_to_wait_exclusive(&ws->wait, &wait, state);
> +		if (signal_pending_state(state, current))
> +			break;
> +		schedule();
> +		tag = sbitmap_queue_get(&se_sess->sess_tag_pool, cpup);
> +	}
> +
> +	finish_wait(&ws->wait, &wait);
> +	return tag;
> +}

Seems like that should be:


	ws = &se_sess->sess_tag_pool.ws[0];
	for (;;) {
		prepare_to_wait_exclusive(&ws->wait, &wait, state);
		if (signal_pending_state(state, current))
			break;
		tag = sbitmap_queue_get(&se_sess->sess_tag_pool, cpup);
		if (tag != -1)
			break;
		schedule();
	}

	finish_wait(&ws->wait, &wait);
	return tag;

>  /*
>   * May be called from software interrupt (timer) context for allocating
>   * iSCSI NopINs.
> @@ -155,9 +177,11 @@ struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, int state)
>  {
>  	struct iscsi_cmd *cmd;
>  	struct se_session *se_sess = conn->sess->se_sess;
> -	int size, tag;
> +	int size, tag, cpu;
>  
> -	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, state);
> +	tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
> +	if (tag < 0)
> +		tag = iscsit_wait_for_tag(se_sess, state, &cpu);
>  	if (tag < 0)
>  		return NULL;

Might make sense to just roll the whole thing into iscsi_get_tag(), that
would be cleaner.

sbitmap should provide a helper for that, but we can do that cleanup
later. That would encapsulate things like the per-cpu caching hint too,
for instance.

Rest looks fine to me.

-- 
Jens Axboe

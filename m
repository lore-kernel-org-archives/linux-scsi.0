From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/2] Convert target drivers to use sbitmap
Date: Tue, 12 Jun 2018 15:22:42 +0000
Message-ID: <da5220a5ed4bed210c31a7517389e787a3b1a01f.camel@wdc.com>
References: <20180515160043.27044-1-willy@infradead.org>
	<20180515160043.27044-2-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20180515160043.27044-2-willy@infradead.org>
Content-Language: en-US
Content-ID: <4C063782DCBCAE4EAAD78091E6B6DBE4@namprd04.prod.outlook.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "willy@infradead.org" <willy@infradead.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>, "linux1394-devel@lists.sourceforge.net" <linux1394-devel@lists.sourceforge.net>, "jgross@suse.com" <jgross@suse.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "qla2xxx-upstream@qlogic.com" <qla2xxx-upstream@qlogic.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: "mawilcox@microsoft.com" <mawilcox@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2018-05-15 at 09:00 -0700, Matthew Wilcox wrote:
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 025dc2d3f3de..cdf671c2af61 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -3719,7 +3719,8 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
>  		return;
>  	}
>  	cmd->jiffies_at_free = get_jiffies_64();
> -	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
> +	sbitmap_queue_clear(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag,
> +			cmd->se_cmd.map_cpu);
>  }
>  EXPORT_SYMBOL(qlt_free_cmd);

Please introduce functions in the target core for allocating and freeing a tag
instead of spreading the knowledge of how to allocate and free tags over all
target drivers.
 
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

This looks weird to me. Shouldn't target code ignore signals instead of causing
tag allocation to fail if a signal is received?

> +		schedule();
> +		tag = sbitmap_queue_get(&se_sess->sess_tag_pool, cpup);
> +	}
> +
> +	finish_wait(&ws->wait, &wait);
> +	return tag;
> +}

Thanks,

Bart.

From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [dm-devel] [PATCH 19/32] block: add helper to get
 data dir from op
Date: Wed, 4 Nov 2015 14:44:03 -0800
Message-ID: <563A8A33.3000002@sandisk.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
	<1446674909-5371-20-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <1446674909-5371-20-git-send-email-mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Cc: Mike Christie <mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 11/04/2015 02:08 PM, mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> From: Mike Christie <mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> In later patches the op will no longer be a bitmap, so we will
> not have REQ_WRITE set for all non reads like discard, flush,
> and write same. Drivers will still want to treat them as writes
> for accounting reasons, so this patch adds a helper to translate
> a op to a data direction.
>
> Signed-off-by: Mike Christie <mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>   include/linux/blkdev.h | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 19c2e94..cf5f518 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -586,6 +586,18 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
>
>   #define list_entry_rq(ptr)	list_entry((ptr), struct request, queuelist)
>
> +/*
> + * Non REQ_OP_WRITE requests like discard, write same, etc, are
> + * considered WRITEs.
> + */
> +static inline int op_to_data_dir(int op)
> +{
> +	if (op == REQ_OP_READ)
> +		return READ;
> +	else
> +		return WRITE;
> +}
> +
>   #define rq_data_dir(rq)		((int)((rq)->cmd_flags & 1))
>
>   /*
>

How about introducing two functions - op_is_write() and op_is_read() ? I 
think that approach will result in shorter and easier to read code in 
the contexts where these functions are used.

Bart.

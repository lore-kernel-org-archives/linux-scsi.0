From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 0/2] sd: Fix a deadlock between event checking and device removal
Date: Fri, 17 Nov 2017 18:10:56 +0100
Message-ID: <CAD+HZHXUd2TwfX9WSQad1edmfXfmRNYgQ6N=_3Ny3JyH=q8QXQ@mail.gmail.com>
References: <a8f0ee8f-7b40-2375-47a4-52f78af29d8d@sandisk.com>
 <1479016028.17624.16.camel@linux.vnet.ibm.com> <9500e9b2-2d34-099d-aa90-d38fb3feb02e@sandisk.com>
 <CAD+HZHUVsaDYO7yL2Ct868kdK=dE3PuRmy-Jfp2d2zmEBJPwFg@mail.gmail.com>
 <1510680828.2280.16.camel@sandisk.com> <CAD+HZHWAUPRxHyG0VRcfTmBs2KbUX30wsa7=HGGApQ94sEj26g@mail.gmail.com>
 <1510938082.2846.23.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:44436 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752133AbdKQRK6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Nov 2017 12:10:58 -0500
Received: by mail-wr0-f195.google.com with SMTP id l22so2679939wrc.11
        for <linux-scsi@vger.kernel.org>; Fri, 17 Nov 2017 09:10:57 -0800 (PST)
In-Reply-To: <1510938082.2846.23.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "snitzer@redhat.com" <snitzer@redhat.com>

2017-11-17 18:01 GMT+01:00 Bart Van Assche <Bart.VanAssche@wdc.com>:
> On Fri, 2017-11-17 at 16:14 +0100, Jack Wang wrote:
>> I suspect could be missing run queue or lost IO, IMHO it's unlikely
>> below disk probing fix the bug.
>
> If the system is still in this state or if you can reproduce this issue,
> please collect and analyze the information under /sys/kernel/debug/block.
> That's the only way I know of to verify whether or not a lockup has been
> caused by a missing queue run. If the following command resolves the lockup
> then the root cause is definitely a missing queue run:

It's production server, I was too late to gather more information.
kernel is 4.4.36/4.4.50
Request mode for both multipath and scsi, no multiqueue involvement.

I found thread back to 2012, you also report this problem in 3.2..
https://lkml.org/lkml/2012/1/3/163

I might be a very old bug.

I will try harder to reproduce.

Thanks,
Jack


>
> for f in /sys/kernel/debug/block/*; do echo kick >$f/state; done
>
> When analyzing queue lockups it's important to also have information about
> requests that have been queued but that have not yet been started. I'm using
> the following patch locally (will split this patch and submit it properly when
> I have the time):
>
> diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
> index 29e8451931ff..3c9d64793865 100644
> --- a/block/blk-mq-debugfs.c
> +++ b/block/blk-mq-debugfs.c
> @@ -408,8 +408,7 @@ static void hctx_show_busy_rq(struct request *rq, void *data, bool reserved)
>  {
>         const struct show_busy_params *params = data;
>
> -       if (blk_mq_map_queue(rq->q, rq->mq_ctx->cpu) == params->hctx &&
> -           test_bit(REQ_ATOM_STARTED, &rq->atomic_flags))
> +       if (blk_mq_map_queue(rq->q, rq->mq_ctx->cpu) == params->hctx)
>                 __blk_mq_debugfs_rq_show(params->m,
>                                          list_entry_rq(&rq->queuelist));
>  }
> diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
> index 01f08c03f2c1..41d1e3a01786 100644
> --- a/drivers/scsi/scsi_debugfs.c
> +++ b/drivers/scsi/scsi_debugfs.c
> @@ -7,10 +7,14 @@
>  void scsi_show_rq(struct seq_file *m, struct request *rq)
>  {
>         struct scsi_cmnd *cmd = container_of(scsi_req(rq), typeof(*cmd), req);
> -       int msecs = jiffies_to_msecs(jiffies - cmd->jiffies_at_alloc);
> -       char buf[80];
> +       int alloc_ms = jiffies_to_msecs(jiffies - cmd->jiffies_at_alloc);
> +       int timeout_ms = jiffies_to_msecs(rq->timeout);
> +       const u8 *const cdb = READ_ONCE(cmd->cmnd);
> +       char buf[80] = "(?)";
>
> -       __scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);
> -       seq_printf(m, ", .cmd=%s, .retries=%d, allocated %d.%03d s ago", buf,
> -                  cmd->retries, msecs / 1000, msecs % 1000);
> +       if ((cmd->flags & SCMD_INITIALIZED) && cdb)
> +               __scsi_format_command(buf, sizeof(buf), cdb, cmd->cmd_len);
> +       seq_printf(m, ", .cmd=%s, .retries=%d, .timeout=%d.%03d, allocated %d.%03d s ago",
> +                  buf, cmd->retries, timeout_ms / 1000, timeout_ms % 1000,
> +                  alloc_ms / 1000, alloc_ms % 1000);
>  }

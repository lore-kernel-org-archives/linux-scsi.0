From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 3/9] IB: add a helper to safely drain a QP
Date: Mon, 16 Nov 2015 10:38:19 -0600
Message-ID: <564A067B.8030504@opengridcomputing.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-4-git-send-email-hch@lst.de>
 <564851BB.1020004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564851BB.1020004-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 11/15/2015 3:34 AM, Sagi Grimberg wrote:
>
>> +
>> +struct ib_stop_cqe {
>> +    struct ib_cqe    cqe;
>> +    struct completion done;
>> +};
>> +
>> +static void ib_stop_done(struct ib_cq *cq, struct ib_wc *wc)
>> +{
>> +    struct ib_stop_cqe *stop =
>> +        container_of(wc->wr_cqe, struct ib_stop_cqe, cqe);
>> +
>> +    complete(&stop->done);
>> +}
>> +
>> +/*
>> + * Change a queue pair into the error state and wait until all receive
>> + * completions have been processed before destroying it. This avoids 
>> that
>> + * the receive completion handler can access the queue pair while it is
>> + * being destroyed.
>> + */
>> +void ib_drain_qp(struct ib_qp *qp)
>> +{
>> +    struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
>> +    struct ib_stop_cqe stop = { };
>> +    struct ib_recv_wr wr, *bad_wr;
>> +    int ret;
>> +
>> +    wr.wr_cqe = &stop.cqe;
>> +    stop.cqe.done = ib_stop_done;
>> +    init_completion(&stop.done);
>> +
>> +    ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
>> +    if (ret) {
>> +        WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
>> +        return;
>> +    }
>> +
>> +    ret = ib_post_recv(qp, &wr, &bad_wr);
>> +    if (ret) {
>> +        WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
>> +        return;
>> +    }
>> +
>> +    wait_for_completion(&stop.done);
>> +}
>
> This is taken from srp, and srp drains using a recv wr due to a race
> causing a use-after-free condition in srp which re-posts a recv buffer
> in the recv completion handler. srp does not really care if there are
> pending send flushes.
>
> I'm not sure if there are ordering rules for send/recv queues in
> terms of flush completions, meaning that even if all recv flushes
> were consumed maybe there are send flushes still pending.
>
> I think that for a general drain helper it would be useful to
> make sure that both the recv _and_ send flushes were drained.
>
> So, something like:
>
> void ib_drain_qp(struct ib_qp *qp)
> {
>     struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
>     struct ib_stop_cqe rstop, sstop;
>     struct ib_recv_wr rwr = {}, *bad_rwr;
>     struct ib_send_wr swr = {}, *bad_swr;
>     int ret;
>
>     rwr.wr_cqe = &rstop.cqe;
>     rstop.cqe.done = ib_stop_done;
>     init_completion(&rstop.done);
>
>     swr.wr_cqe = &sstop.cqe;
>     sstop.cqe.done = ib_stop_done;
>     init_completion(&sstop.done);
>
>     ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
>     if (ret) {
>         WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
>         return;
>     }
>
>     ret = ib_post_recv(qp, &rwr, &bad_rwr);
>     if (ret) {
>         WARN_ONCE(ret, "failed to drain recv queue: %d\n", ret);
>         return;
>     }
>
>     ret = ib_post_send(qp, &swr, &bad_swr);
>     if (ret) {
>         WARN_ONCE(ret, "failed to drain send queue: %d\n", ret);
>         return;
>     }
>
>     wait_for_completion(&rstop.done);
>     wait_for_completion(&sstop.done);
> }
>
> Thoughts?

This won't work for iWARP as per my previous email.  But I will code 
something up that will.

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

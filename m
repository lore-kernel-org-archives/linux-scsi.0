From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 3/9] IB: add a helper to safely drain a QP
Date: Sun, 15 Nov 2015 11:34:51 +0200
Message-ID: <564851BB.1020004@dev.mellanox.co.il>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447422410-20891-4-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


> +
> +struct ib_stop_cqe {
> +	struct ib_cqe	cqe;
> +	struct completion done;
> +};
> +
> +static void ib_stop_done(struct ib_cq *cq, struct ib_wc *wc)
> +{
> +	struct ib_stop_cqe *stop =
> +		container_of(wc->wr_cqe, struct ib_stop_cqe, cqe);
> +
> +	complete(&stop->done);
> +}
> +
> +/*
> + * Change a queue pair into the error state and wait until all receive
> + * completions have been processed before destroying it. This avoids that
> + * the receive completion handler can access the queue pair while it is
> + * being destroyed.
> + */
> +void ib_drain_qp(struct ib_qp *qp)
> +{
> +	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
> +	struct ib_stop_cqe stop = { };
> +	struct ib_recv_wr wr, *bad_wr;
> +	int ret;
> +
> +	wr.wr_cqe = &stop.cqe;
> +	stop.cqe.done = ib_stop_done;
> +	init_completion(&stop.done);
> +
> +	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
> +	if (ret) {
> +		WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
> +		return;
> +	}
> +
> +	ret = ib_post_recv(qp, &wr, &bad_wr);
> +	if (ret) {
> +		WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
> +		return;
> +	}
> +
> +	wait_for_completion(&stop.done);
> +}

This is taken from srp, and srp drains using a recv wr due to a race
causing a use-after-free condition in srp which re-posts a recv buffer
in the recv completion handler. srp does not really care if there are
pending send flushes.

I'm not sure if there are ordering rules for send/recv queues in
terms of flush completions, meaning that even if all recv flushes
were consumed maybe there are send flushes still pending.

I think that for a general drain helper it would be useful to
make sure that both the recv _and_ send flushes were drained.

So, something like:

void ib_drain_qp(struct ib_qp *qp)
{
	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
	struct ib_stop_cqe rstop, sstop;
	struct ib_recv_wr rwr = {}, *bad_rwr;
	struct ib_send_wr swr = {}, *bad_swr;
	int ret;

	rwr.wr_cqe = &rstop.cqe;
	rstop.cqe.done = ib_stop_done;
	init_completion(&rstop.done);

	swr.wr_cqe = &sstop.cqe;
	sstop.cqe.done = ib_stop_done;
	init_completion(&sstop.done);

	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
	if (ret) {
		WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
		return;
	}

	ret = ib_post_recv(qp, &rwr, &bad_rwr);
	if (ret) {
		WARN_ONCE(ret, "failed to drain recv queue: %d\n", ret);
		return;
	}

	ret = ib_post_send(qp, &swr, &bad_swr);
	if (ret) {
		WARN_ONCE(ret, "failed to drain send queue: %d\n", ret);
		return;
	}

	wait_for_completion(&rstop.done);
	wait_for_completion(&sstop.done);
}

Thoughts?

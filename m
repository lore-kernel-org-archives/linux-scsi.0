From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 10/13] IB/srp: use the new CQ API
Date: Thu, 10 Dec 2015 10:42:50 -0800
Message-ID: <5669C7AA.4080206@sandisk.com>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
 <1449521512-22921-11-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449521512-22921-11-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/07/2015 12:51 PM, Christoph Hellwig wrote:
> +static void srp_send_done(struct ib_cq *cq, struct ib_wc *wc)
> +{
> +	struct srp_iu *iu = container_of(wc->wr_cqe, struct srp_iu, cqe);
> +	struct srp_rdma_ch *ch = cq->cq_context;
> +
> +	if (likely(wc->status != IB_WC_SUCCESS)) {
> +		srp_handle_qp_err(cq, wc, "SEND");
> +		return;
> +	}
> +
> +	list_add(&iu->list, &ch->free_tx);
> +}

Please change likely() in the above code into unlikely().

Thanks,

Bart.

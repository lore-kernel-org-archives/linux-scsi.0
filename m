From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 0/7] hisi_sas: Misc bugfixes and an optimisation patch
Date: Fri, 12 Oct 2018 21:30:20 +0800
Message-ID: <20181012133019.GA5361@ming.t460p>
References: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
 <yq18t354532.fsf@oracle.com>
 <20181011063603.GA3456@infradead.org>
 <118d01db-05f4-a85b-850c-c4e5a5616a16@huawei.com>
 <20181011101534.GA31802@infradead.org>
 <e2f35903-e28f-0fb5-7c61-47aa7f1a6926@huawei.com>
 <20181011133159.GA31355@ming.t460p>
 <519812c7-970a-976c-7db5-a035bf4f4e24@huawei.com>
 <20181011233633.GA30271@ming.t460p>
 <3322d066-d118-320f-eb99-0fb03d530c67@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3322d066-d118-320f-eb99-0fb03d530c67@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@linux.vnet.ibm.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang <chenxiang66@hisilicon.com>, Kashyap Desai <kashyap.desai@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 12, 2018 at 10:02:57AM +0100, John Garry wrote:
> Hi Ming,
> 
> > In theory, you still may generate and manage the IPTT in the LLDD by
> > simply ignoring rq->tag, meantime enabling SCSI_MQ with 16 hw queues.
> > 
> 
> Well at the moment we can't expose all 16 hw queues to upper layer anyway,
> due to ordering restiction imposed by HW on LLDD. We have a plan to solve
> it.
> 
> Regardless, we still found performance better by using rq tag instead of
> exposing all 16 queues.
> 
> > However, not sure how much this way may improve performance, and it may
> > degrade IO perf. If 16 hw queues are exposed to blk-mq, 16*.can_queue
> > requests may be queued to the driver, and allocation & free on the single
> > IPTT pool will become a bottleneck.
> 
> Right, this IPTT management doesn't scale (especially for our host with 2
> sockets @ 48/64 cores each). So if upper layer is already generating a tag
> which we can use, good to use it.
> 
> > 
> > Per my experiment on host tagset, it might be a good tradeoff to allocate
> > one hw queue for each node to avoid the remote access on dispatch
> > data/requests structure for this case, but your IPTT pool is still
> > shared all CPUs, maybe you can try the smart sbitmap.
> > 
> > https://www.spinics.net/lists/linux-scsi/msg117920.html
> 
> I don't understand this about allocating a hw queue per node. Surely having
> and using all available queues in an intelligent way means less queue
> contention, right?

Yes.

> 
> Looking at this change:
> @@ -5761,6 +5762,11 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
>  static int hpsa_scsi_add_host(struct ctlr_info *h)
>  {
>  	int rv;
> +	/* 256 tags should be high enough to saturate device */
> +	int max_queues = DIV_ROUND_UP(h->scsi_host->can_queue, 256);
> +
> +	/* per NUMA node hw queue */
> +	h->scsi_host->nr_hw_queues = min_t(int, nr_node_ids, max_queues);
> 
> I assume h->scsi_host->nr_hw_queues was zero-init previously, so we're now
> using > 1 queue, but why limit?

>From my test on null_blk/scsi_debug, per-node hw queue improves iops
much more obviously.

Also you may manage IPTT in LLD, and contention on the single IPTT pool
shouldn't be very serious, given there are less NUMA nodes usually.



Thanks,
Ming

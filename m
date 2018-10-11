From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 0/7] hisi_sas: Misc bugfixes and an optimisation patch
Date: Fri, 12 Oct 2018 07:36:34 +0800
Message-ID: <20181011233633.GA30271@ming.t460p>
References: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
 <yq18t354532.fsf@oracle.com>
 <20181011063603.GA3456@infradead.org>
 <118d01db-05f4-a85b-850c-c4e5a5616a16@huawei.com>
 <20181011101534.GA31802@infradead.org>
 <e2f35903-e28f-0fb5-7c61-47aa7f1a6926@huawei.com>
 <20181011133159.GA31355@ming.t460p>
 <519812c7-970a-976c-7db5-a035bf4f4e24@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <519812c7-970a-976c-7db5-a035bf4f4e24@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@linux.vnet.ibm.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang <chenxiang66@hisilicon.com>, Kashyap Desai <kashyap.desai@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 11, 2018 at 03:07:33PM +0100, John Garry wrote:
> On 11/10/2018 14:32, Ming Lei wrote:
> > On Thu, Oct 11, 2018 at 02:12:11PM +0100, John Garry wrote:
> > > On 11/10/2018 11:15, Christoph Hellwig wrote:
> > > > On Thu, Oct 11, 2018 at 10:59:11AM +0100, John Garry wrote:
> > > > > 
> > > > > > blk-mq tags are always per-host (which has actually caused problems for
> > > > > > ATA, which is now using its own per-device tags).
> > > > > > 
> > > > > 
> > > > > So, for example, if Scsi_host.can_queue = 2048 and Scsi_host.nr_hw_queues =
> > > > > 16, then rq tags are still in range [0, 2048) for that HBA, i.e. invariant
> > > > > on queue count?
> > > > 
> > > > Yes, if can_queue is 2048 you will gets tags from 0..2047.
> > > > 
> > > 
> > > I should be clear about some things before discussing this further. Our
> > > device has 16 hw queues. And each command we send to any queue in the device
> > > must have a unique tag across all hw queues for that device, and should be
> > > in the range [0, 2048) - it's called an IPTT. So Scsi_host.can_queue = 2048.
> > 
> > Could you describe a bit about IPTT?
> > 
> 
> IPTT is an "Initiator Tag". It is a tag to map to the context of a hw queue
> command. It is related to SAS protocol Initiator Port tag. I think that most
> SAS HBAs have a similar concept.
> 
> IPTTs are limited, and must be recycled when an IO completes. Our hw
> supports upto 2048. So we have a limit of 2048 commands issued at any point
> in time.
> 
> Previously we had been managing IPTT in LLDD, but found rq tag can be used
> as IPTT (as in 6/7), to gave a good performance boost.
> 
> > Looks like the 16 hw queues are like reply queues in other drivers,
> > such as megara_sas, but given all the 16 reply queues share one tagset,
> > so the hw queue number has to be 1 from blk-mq's view.
> > 
> > > 
> > > However today we only expose a single queue to upper layer (for unrelated
> > > LLDD error handling restriction). We hope to expose all 16 queues in future,
> > > which is what I meant by "enabling SCSI MQ in the driver". However, with
> > > 6/7, this creates a problem, below.
> > 
> > If the tag of each request from all hw queues has to be unique, you
> > can't expose all 16 queues.
> 
> Well we can if we generate and manage the IPTT in the LLDD, as we had been
> doing. If we want to use the rq tag - which 6/7 is for - then we can't.

In theory, you still may generate and manage the IPTT in the LLDD by
simply ignoring rq->tag, meantime enabling SCSI_MQ with 16 hw queues.

However, not sure how much this way may improve performance, and it may
degrade IO perf. If 16 hw queues are exposed to blk-mq, 16*.can_queue
requests may be queued to the driver, and allocation & free on the single
IPTT pool will become a bottleneck.

Per my experiment on host tagset, it might be a good tradeoff to allocate
one hw queue for each node to avoid the remote access on dispatch
data/requests structure for this case, but your IPTT pool is still
shared all CPUs, maybe you can try the smart sbitmap.

https://www.spinics.net/lists/linux-scsi/msg117920.html


> 
> > 
> > > 
> > > > IFF you device needs different tags for different queues it can use
> > > > the blk_mq_unique_tag heper to generate unique global tag.
> > > 
> > > So this helper can't help, as fundamentially the issue is "the tag field in
> > > struct request is unique per hardware queue but not all all hw queues".
> > > Indeed blk_mq_unique_tag() does give a unique global tag, but cannot be used
> > > for the IPTT.
> > > 
> > > OTOH, We could expose 16 queues to upper layer, and drop 6/7, but we found
> > > it performs worse.
> > 
> > We discussed this issue before, but not found a good solution yet for
> > exposing multiple hw queues to blk-mq.
> 
> I just think that it's unfortunate that enabling blk-mq means that the LLDD
> loses this unique tag across all queues in range [0, Scsi_host.can_queue),
> so much so that we found performance better by not exposing multiple queues
> and continuing to use single rq tag...

It isn't a new problem, we discussed it a lot on megaraid_sas which has
same situation with yours, you may find it in block list.

Kashyap Desai did lots of test on this case.

> 
> > 
> > However, we still get good performance in case of none scheduler by the
> > following patches:
> > 
> > 8824f62246be blk-mq: fail the request in case issue failure
> > 6ce3dd6eec11 blk-mq: issue directly if hw queue isn't busy in case of 'none'
> > 
> 
> I think that these patches would have been included in our testing. I need
> to check.

Please switch to none io sched in your test, and it is observed that IO
perf becomes good on megaraid_sas.

Thanks,
Ming

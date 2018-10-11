From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 0/7] hisi_sas: Misc bugfixes and an optimisation patch
Date: Thu, 11 Oct 2018 21:32:00 +0800
Message-ID: <20181011133159.GA31355@ming.t460p>
References: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
 <yq18t354532.fsf@oracle.com>
 <20181011063603.GA3456@infradead.org>
 <118d01db-05f4-a85b-850c-c4e5a5616a16@huawei.com>
 <20181011101534.GA31802@infradead.org>
 <e2f35903-e28f-0fb5-7c61-47aa7f1a6926@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e2f35903-e28f-0fb5-7c61-47aa7f1a6926@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@linux.vnet.ibm.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 11, 2018 at 02:12:11PM +0100, John Garry wrote:
> On 11/10/2018 11:15, Christoph Hellwig wrote:
> > On Thu, Oct 11, 2018 at 10:59:11AM +0100, John Garry wrote:
> > > 
> > > > blk-mq tags are always per-host (which has actually caused problems for
> > > > ATA, which is now using its own per-device tags).
> > > > 
> > > 
> > > So, for example, if Scsi_host.can_queue = 2048 and Scsi_host.nr_hw_queues =
> > > 16, then rq tags are still in range [0, 2048) for that HBA, i.e. invariant
> > > on queue count?
> > 
> > Yes, if can_queue is 2048 you will gets tags from 0..2047.
> > 
> 
> I should be clear about some things before discussing this further. Our
> device has 16 hw queues. And each command we send to any queue in the device
> must have a unique tag across all hw queues for that device, and should be
> in the range [0, 2048) - it's called an IPTT. So Scsi_host.can_queue = 2048.

Could you describe a bit about IPTT?

Looks like the 16 hw queues are like reply queues in other drivers,
such as megara_sas, but given all the 16 reply queues share one tagset,
so the hw queue number has to be 1 from blk-mq's view.

> 
> However today we only expose a single queue to upper layer (for unrelated
> LLDD error handling restriction). We hope to expose all 16 queues in future,
> which is what I meant by "enabling SCSI MQ in the driver". However, with
> 6/7, this creates a problem, below.

If the tag of each request from all hw queues has to be unique, you
can't expose all 16 queues.

> 
> > IFF you device needs different tags for different queues it can use
> > the blk_mq_unique_tag heper to generate unique global tag.
> 
> So this helper can't help, as fundamentially the issue is "the tag field in
> struct request is unique per hardware queue but not all all hw queues".
> Indeed blk_mq_unique_tag() does give a unique global tag, but cannot be used
> for the IPTT.
> 
> OTOH, We could expose 16 queues to upper layer, and drop 6/7, but we found
> it performs worse.

We discussed this issue before, but not found a good solution yet for
exposing multiple hw queues to blk-mq.

However, we still get good performance in case of none scheduler by the
following patches:

8824f62246be blk-mq: fail the request in case issue failure
6ce3dd6eec11 blk-mq: issue directly if hw queue isn't busy in case of 'none'


Thanks,
Ming

From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] hisi_sas: Misc bugfixes and an optimisation patch
Date: Thu, 11 Oct 2018 03:15:34 -0700
Message-ID: <20181011101534.GA31802@infradead.org>
References: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
 <yq18t354532.fsf@oracle.com>
 <20181011063603.GA3456@infradead.org>
 <118d01db-05f4-a85b-850c-c4e5a5616a16@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <118d01db-05f4-a85b-850c-c4e5a5616a16@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@linux.vnet.ibm.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, chenxiang <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 11, 2018 at 10:59:11AM +0100, John Garry wrote:
> 
> > blk-mq tags are always per-host (which has actually caused problems for
> > ATA, which is now using its own per-device tags).
> > 
> 
> So, for example, if Scsi_host.can_queue = 2048 and Scsi_host.nr_hw_queues =
> 16, then rq tags are still in range [0, 2048) for that HBA, i.e. invariant
> on queue count?

Yes, if can_queue is 2048 you will gets tags from 0..2047.

IFF you device needs different tags for different queues it can use
the blk_mq_unique_tag heper to generate unique global tag.

But unless you actuall have multiple hardware queues that latter part
is rather irrelevant to start with.

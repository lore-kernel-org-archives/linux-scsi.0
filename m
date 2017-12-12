From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v2 1/3] scsi: Fix a scsi_show_rq() NULL pointer
 dereference
Date: Tue, 12 Dec 2017 11:28:34 +0800
Message-ID: <20171212032832.GA28256@ming.t460p>
References: <20171206005753.28734-1-bart.vanassche@wdc.com>
 <20171206005753.28734-2-bart.vanassche@wdc.com>
 <20171208014528.GD21488@ming.t460p>
 <yq1374muebm.fsf@oracle.com>
 <20171208084455.GF21488@ming.t460p>
 <20171208104410.GA10667@ming.t460p>
 <yq1vahcprmm.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1vahcprmm.fsf@oracle.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 11, 2017 at 10:11:29PM -0500, Martin K. Petersen wrote:
> 
> Hi Ming,
> 
> > This patch allocates one array for T10_PI_TYPE2_PROTECTION command,
> > size of each element is SD_EXT_CDB_SIZE, and the length is
> > host->can_queue, then we can retrieve one command buffer runtime
> > via rq->tag.
> >
> > So we can avoid to allocate the command buffer runtime, also the
> > recent use-after-free report[1] in scsi_show_rq() can be fixed too.
> 
> I'm still mulling over the pros and cons of this one for 4.16+...

Hi Martin,

This patch can't work in case of real multiple hw queues, but can be
fixed without much work.

Even we can convert the big allocation into page by page allocation
if there is case of huge tag space.

Anyway if you think this approach is good, please let me know, and I
am happy to cook V2 for review.


Thanks,
Ming

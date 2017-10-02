From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V7 3/6] block: pass flags to blk_queue_enter()
Date: Mon, 2 Oct 2017 06:40:32 -0700
Message-ID: <20171002134032.GC19119@infradead.org>
References: <20170930061214.10622-1-ming.lei@redhat.com>
 <20170930061214.10622-4-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170930061214.10622-4-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Sep 30, 2017 at 02:12:11PM +0800, Ming Lei wrote:
> We need to pass PREEMPT flags to blk_queue_enter()
> for allocating request with RQF_PREEMPT in the
> following patch.

I don't like having another name space for flags.  It seems like
we should simply pass ops on, and then map the nowait allocations
to RQF_PREEMPT to REQ_PREEMPT as done in the series from Bart.

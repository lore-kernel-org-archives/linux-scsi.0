From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] RDMA/srp: Rework SCSI device reset handling
Date: Sat, 19 Jan 2019 02:04:52 -0800
Message-ID: <20190119100452.GC24246@infradead.org>
References: <20190117002717.84686-1-bvanassche@acm.org>
 <20190117002717.84686-3-bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190117002717.84686-3-bvanassche@acm.org>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Sergey Gorenko <sergeygo@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> +	/* Check whether all requests have finished. */
> +	blk_freeze_queue_start(q);
> +	time_left = blk_mq_freeze_queue_wait_timeout(q, 1 * HZ);
> +	blk_mq_unfreeze_queue(q);
>  
> +	return time_left > 0 ? SUCCESS : FAILED;

This is entirely generic SCSI/block evel functionality.  I'd rather have
a new WAIT_FOR_FREEZE return value from ->eh_device_reset_handler and
handle this in the SCSI midlayer.

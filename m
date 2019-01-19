From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] RDMA/srp: Avoid calling mutex_lock() from inside
 scsi_queue_rq()
Date: Sat, 19 Jan 2019 02:03:04 -0800
Message-ID: <20190119100304.GB24246@infradead.org>
References: <20190117002717.84686-1-bvanassche@acm.org>
 <20190117002717.84686-2-bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190117002717.84686-2-bvanassche@acm.org>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Sergey Gorenko <sergeygo@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 16, 2019 at 04:27:16PM -0800, Bart Van Assche wrote:
> In scsi-mq mode it is not allowed to sleep inside srp_queuecommand()
> since the flag BLK_MQ_F_BLOCKING has not been set. Since setting the
> request queue flag BLK_MQ_F_BLOCKING would slow down the hot path, make
> srp_queuecommand() skip the mutex_lock() and mutex_unlock() calls when
> called from inside scsi_queue_rq() from the SCSI EH thread.
> 
> This patch avoids that the following appears in the kernel log:

I think we need to get rid of the taking a sleeping lock in
->queuecomand entirely.  These checks are way to fragile.

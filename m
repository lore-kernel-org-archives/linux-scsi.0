From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v3 04/11] blk-mq: Introduce blk_mq_quiesce_queue()
Date: Wed, 19 Oct 2016 14:04:17 -0700
Message-ID: <0718ec72-d525-2e75-a123-3bf9ea129319@sandisk.com>
References: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com>
 <e42a952c-f245-eb39-d0a1-0336035573f9@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <e42a952c-f245-eb39-d0a1-0336035573f9@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lei <tom.leiming@gmail.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 10/18/2016 02:50 PM, Bart Van Assche wrote:
> blk_mq_quiesce_queue() waits until ongoing .queue_rq() invocations
> have finished. This function does *not* wait until all outstanding
> requests have finished (this means invocation of request.end_io()).

(replying to my own e-mail)

The zero-day kernel test infrastructure reported to me that this patch 
causes a build failure with CONFIG_SRCU=n. Should I add "select SRCU" to 
block/Kconfig (excludes TINY_RCU) or should I rather modify this patch 
such that a mutex or rwsem is used instead of SRCU?

Thanks,

Bart.


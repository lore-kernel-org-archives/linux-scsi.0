From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH V2] SCSI: fix queue cleanup race before queue
 initialization is done
Date: Wed, 14 Nov 2018 07:02:28 -0800
Message-ID: <1542207748.192870.14.camel@acm.org>
References: <20181114082551.12141-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181114082551.12141-1-ming.lei@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Andrew Jones <drjones@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, stable <stable@vger.kernel.org>, "jianchao . wang" <jianchao.w.wang@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2018-11-14 at 16:25 +-0800, Ming Lei wrote:
+AD4 --- a/drivers/scsi/scsi+AF8-lib.c
+AD4 +-+-+- b/drivers/scsi/scsi+AF8-lib.c
+AD4 +AEAAQA -697,6 +-697,12 +AEAAQA static bool scsi+AF8-end+AF8-request(struct request +ACo-req,
+AD4 blk+AF8-status+AF8-t error,
+AD4  		 +ACo-/
+AD4  		scsi+AF8-mq+AF8-uninit+AF8-cmd(cmd)+ADs
+AD4  
+AD4 +-		/+ACo
+AD4 +-		 +ACo queue is still alive, so grab the ref for preventing it
+AD4 +-		 +ACo from being cleaned up during running queue.
+AD4 +-		 +ACo-/
+AD4 +-		percpu+AF8-ref+AF8-get(+ACY-q-+AD4-q+AF8-usage+AF8-counter)+ADs
+AD4 +-

I think the above comment is misleading. In the block layer a queue is called
alive if the +ACI-dying+ACI flag has not been set. When the above call to
percpu+AF8-ref+AF8-get() occurs it is not guaranteed that that flag has not yet been
set. But it is guaranteed that q-+AD4-q+AF8-usage+AF8-counter is not zero. I would prefer
if the comment would be modified.

What's not clear to me is why this patch only protects the blk-mq path but
not the legacy path. Does the legacy path need similar protection? It also
triggers a queue run after having finished a request.

Otherwise this patch looks fine to me.

Bart.

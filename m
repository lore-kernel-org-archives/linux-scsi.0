From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 10/14] blk-mq: initial support for multiple queue maps
Date: Mon, 29 Oct 2018 13:00:50 -0700
Message-ID: <1540843250.196084.93.camel@acm.org>
References: <20181029163738.10172-1-axboe@kernel.dk>
         <20181029163738.10172-11-axboe@kernel.dk>
         <1540842034.196084.89.camel@acm.org>
         <ac755067-1432-54ce-6a4f-c7383f1ecc9d@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ac755067-1432-54ce-6a4f-c7383f1ecc9d@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-10-29 at 13:53 -0600, Jens Axboe wrote:
+AD4 On 10/29/18 1:40 PM, Bart Van Assche wrote:
+AD4 +AD4 On Mon, 2018-10-29 at 10:37 -0600, Jens Axboe wrote:
+AD4 +AD4 +AD4 -static int cpu+AF8-to+AF8-queue+AF8-index(unsigned int nr+AF8-queues, const int cpu)
+AD4 +AD4 +AD4 +-static int cpu+AF8-to+AF8-queue+AF8-index(struct blk+AF8-mq+AF8-queue+AF8-map +ACo-qmap,
+AD4 +AD4 +AD4 +-			      unsigned int nr+AF8-queues, const int cpu)
+AD4 +AD4 +AD4  +AHs
+AD4 +AD4 +AD4 -	return cpu +ACU nr+AF8-queues+ADs
+AD4 +AD4 +AD4 +-	return qmap-+AD4-queue+AF8-offset +- (cpu +ACU nr+AF8-queues)+ADs
+AD4 +AD4 +AD4  +AH0
+AD4 +AD4 +AD4 
+AD4 +AD4 +AD4 +AFs ... +AF0
+AD4 +AD4 +AD4  
+AD4 +AD4 +AD4 --- a/include/linux/blk-mq.h
+AD4 +AD4 +AD4 +-+-+- b/include/linux/blk-mq.h
+AD4 +AD4 +AD4 +AEAAQA -78,10 +-78,11 +AEAAQA struct blk+AF8-mq+AF8-hw+AF8-ctx +AHs
+AD4 +AD4 +AD4  struct blk+AF8-mq+AF8-queue+AF8-map +AHs
+AD4 +AD4 +AD4  	unsigned int +ACo-mq+AF8-map+ADs
+AD4 +AD4 +AD4  	unsigned int nr+AF8-queues+ADs
+AD4 +AD4 +AD4 +-	unsigned int queue+AF8-offset+ADs
+AD4 +AD4 +AD4  +AH0AOw
+AD4 +AD4 
+AD4 +AD4 I think it's unfortunate that the blk-mq core uses the .queue+AF8-offset member but
+AD4 +AD4 that mapping functions in block drivers are responsible for setting that member.
+AD4 +AD4 Since the block driver mapping functions have to set blk+AF8-mq+AF8-queue+AF8-map.nr+AF8-queues,
+AD4 +AD4 how about adding a loop in blk+AF8-mq+AF8-update+AF8-queue+AF8-map() that derives .queue+AF8-offset
+AD4 +AD4 from .nr+AF8-queues from previous array entries?
+AD4 
+AD4 It's not a simple increment, so the driver has to be the one setting it. If
+AD4 we end up sharing queues, for instance, then the driver will need to set
+AD4 it to the start offset of that set. If you go two patches forward you
+AD4 can see that exact construct.
+AD4 
+AD4 IOW, it's the driver that controls the offset, not the core.

If sharing of hardware queues between hardware queue types is supported,
what should hctx-+AD4-type be set to? Additionally, patch 5 adds code that uses
hctx-+AD4-type as an array index. How can that code work if a single hardware
queue can be shared by multiple hardware queue types?

Thanks,

Bart.

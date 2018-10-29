From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 10/14] blk-mq: initial support for multiple queue maps
Date: Mon, 29 Oct 2018 12:40:34 -0700
Message-ID: <1540842034.196084.89.camel@acm.org>
References: <20181029163738.10172-1-axboe@kernel.dk>
         <20181029163738.10172-11-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029163738.10172-11-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-10-29 at 10:37 -0600, Jens Axboe wrote:
+AD4 -static int cpu+AF8-to+AF8-queue+AF8-index(unsigned int nr+AF8-queues, const int cpu)
+AD4 +-static int cpu+AF8-to+AF8-queue+AF8-index(struct blk+AF8-mq+AF8-queue+AF8-map +ACo-qmap,
+AD4 +-			      unsigned int nr+AF8-queues, const int cpu)
+AD4  +AHs
+AD4 -	return cpu +ACU nr+AF8-queues+ADs
+AD4 +-	return qmap-+AD4-queue+AF8-offset +- (cpu +ACU nr+AF8-queues)+ADs
+AD4  +AH0
+AD4 
+AD4 +AFs ... +AF0
+AD4  
+AD4 --- a/include/linux/blk-mq.h
+AD4 +-+-+- b/include/linux/blk-mq.h
+AD4 +AEAAQA -78,10 +-78,11 +AEAAQA struct blk+AF8-mq+AF8-hw+AF8-ctx +AHs
+AD4  struct blk+AF8-mq+AF8-queue+AF8-map +AHs
+AD4  	unsigned int +ACo-mq+AF8-map+ADs
+AD4  	unsigned int nr+AF8-queues+ADs
+AD4 +-	unsigned int queue+AF8-offset+ADs
+AD4  +AH0AOw

I think it's unfortunate that the blk-mq core uses the .queue+AF8-offset member but
that mapping functions in block drivers are responsible for setting that member.
Since the block driver mapping functions have to set blk+AF8-mq+AF8-queue+AF8-map.nr+AF8-queues,
how about adding a loop in blk+AF8-mq+AF8-update+AF8-queue+AF8-map() that derives .queue+AF8-offset
from .nr+AF8-queues from previous array entries?

Thanks,

Bart.

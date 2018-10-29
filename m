From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 07/14] blk-mq: support multiple hctx maps
Date: Mon, 29 Oct 2018 11:15:03 -0700
Message-ID: <1540836903.196084.70.camel@acm.org>
References: <20181029163738.10172-1-axboe@kernel.dk>
         <20181029163738.10172-8-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029163738.10172-8-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-10-29 at 10:37 -0600, Jens Axboe wrote:
+AD4 -static inline struct blk+AF8-mq+AF8-hw+AF8-ctx +ACo-blk+AF8-mq+AF8-map+AF8-queue(struct request+AF8-queue +ACo-q,
+AD4 -						     unsigned int flags,
+AD4 -						     int cpu)
+AD4 +-static inline struct blk+AF8-mq+AF8-hw+AF8-ctx +ACo-blk+AF8-mq+AF8-map+AF8-queue+AF8-type(struct request+AF8-queue +ACo-q,
+AD4 +-							  int type, int cpu)
+AD4  +AHs
+AD4  	struct blk+AF8-mq+AF8-tag+AF8-set +ACo-set +AD0 q-+AD4-tag+AF8-set+ADs
+AD4  
+AD4 -	return q-+AD4-queue+AF8-hw+AF8-ctx+AFs-set-+AD4-map+AFs-0+AF0.mq+AF8-map+AFs-cpu+AF0AXQA7
+AD4 +-	return q-+AD4-queue+AF8-hw+AF8-ctx+AFs-set-+AD4-map+AFs-type+AF0.mq+AF8-map+AFs-cpu+AF0AXQA7
+AD4  +AH0
+AD4  
+AD4 -static inline struct blk+AF8-mq+AF8-hw+AF8-ctx +ACo-blk+AF8-mq+AF8-map+AF8-queue+AF8-type(struct request+AF8-queue +ACo-q,
+AD4 -							  int type, int cpu)
+AD4 +-static inline struct blk+AF8-mq+AF8-hw+AF8-ctx +ACo-blk+AF8-mq+AF8-map+AF8-queue(struct request+AF8-queue +ACo-q,
+AD4 +-						     unsigned int flags,
+AD4 +-						     int cpu)
+AD4  +AHs
+AD4 -	return blk+AF8-mq+AF8-map+AF8-queue(q, type, cpu)+ADs
+AD4 +-	int type +AD0 0+ADs
+AD4 +-
+AD4 +-	if (q-+AD4-mq+AF8-ops-+AD4-flags+AF8-to+AF8-type)
+AD4 +-		type +AD0 q-+AD4-mq+AF8-ops-+AD4-flags+AF8-to+AF8-type(q, flags)+ADs
+AD4 +-
+AD4 +-	return blk+AF8-mq+AF8-map+AF8-queue+AF8-type(q, type, cpu)+ADs
+AD4  +AH0

How about adding a comment above both these functions that explains their
purpose? Since blk+AF8-mq+AF8-map+AF8-queue() maps rq-+AD4-cmd+AF8-flags and the cpu index to
a hardware context, how about renaming blk+AF8-mq+AF8-map+AF8-queue() into
blk+AF8-mq+AF8-map+AF8-cmd+AF8-flags()?

+AD4  /+ACo
+AD4 diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
+AD4 index f9e19962a22f..837087cf07cc 100644
+AD4 --- a/include/linux/blk-mq.h
+AD4 +-+-+- b/include/linux/blk-mq.h
+AD4 +AEAAQA -86,6 +-86,7 +AEAAQA enum +AHs
+AD4  
+AD4  struct blk+AF8-mq+AF8-tag+AF8-set +AHs
+AD4  	struct blk+AF8-mq+AF8-queue+AF8-map	map+AFs-HCTX+AF8-MAX+AF8-TYPES+AF0AOw
+AD4 +-	unsigned int		nr+AF8-maps+ADs
+AD4  	const struct blk+AF8-mq+AF8-ops	+ACo-ops+ADs
+AD4  	unsigned int		nr+AF8-hw+AF8-queues+ADs
+AD4  	unsigned int		queue+AF8-depth+ADs	/+ACo max hw supported +ACo-/
+AD4 +AEAAQA -109,6 +-110,7 +AEAAQA struct blk+AF8-mq+AF8-queue+AF8-data +AHs
+AD4  
+AD4  typedef blk+AF8-status+AF8-t (queue+AF8-rq+AF8-fn)(struct blk+AF8-mq+AF8-hw+AF8-ctx +ACo,
+AD4  		const struct blk+AF8-mq+AF8-queue+AF8-data +ACo)+ADs
+AD4 +-typedef int (flags+AF8-to+AF8-type+AF8-fn)(struct request+AF8-queue +ACo, unsigned int)+ADs

How about adding a comment that the format of the second argument of
flags+AF8-to+AF8-type+AF8-fn is the same as that of rq-+AD4-cmd+AF8-flags?

Thanks,

Bart.

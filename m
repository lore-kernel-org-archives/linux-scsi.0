From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 09/14] blk-mq: ensure that plug lists don't straddle
 hardware queues
Date: Mon, 29 Oct 2018 12:27:58 -0700
Message-ID: <1540841278.196084.84.camel@acm.org>
References: <20181029163738.10172-1-axboe@kernel.dk>
         <20181029163738.10172-10-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029163738.10172-10-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-10-29 at 10:37 -0600, Jens Axboe wrote:
+AD4  void blk+AF8-mq+AF8-flush+AF8-plug+AF8-list(struct blk+AF8-plug +ACo-plug, bool from+AF8-schedule)
+AD4  +AHs
+AD4  	struct blk+AF8-mq+AF8-ctx +ACo-this+AF8-ctx+ADs
+AD4 +AEAAQA -1628,7 +-1649,7 +AEAAQA void blk+AF8-mq+AF8-flush+AF8-plug+AF8-list(struct blk+AF8-plug +ACo-plug, bool from+AF8-schedule)
+AD4  	struct request +ACo-rq+ADs
+AD4  	LIST+AF8-HEAD(list)+ADs
+AD4  	LIST+AF8-HEAD(ctx+AF8-list)+ADs
+AD4 -	unsigned int depth+ADs
+AD4 +-	unsigned int depth, this+AF8-flags+ADs
+AD4  
+AD4  	list+AF8-splice+AF8-init(+ACY-plug-+AD4-mq+AF8-list, +ACY-list)+ADs
+AD4  
+AD4 +AEAAQA -1636,13 +-1657,14 +AEAAQA void blk+AF8-mq+AF8-flush+AF8-plug+AF8-list(struct blk+AF8-plug +ACo-plug, bool from+AF8-schedule)
+AD4  
+AD4  	this+AF8-q +AD0 NULL+ADs
+AD4  	this+AF8-ctx +AD0 NULL+ADs
+AD4 +-	this+AF8-flags +AD0 0+ADs
+AD4  	depth +AD0 0+ADs
+AD4  
+AD4  	while (+ACE-list+AF8-empty(+ACY-list)) +AHs
+AD4  		rq +AD0 list+AF8-entry+AF8-rq(list.next)+ADs
+AD4  		list+AF8-del+AF8-init(+ACY-rq-+AD4-queuelist)+ADs
+AD4  		BUG+AF8-ON(+ACE-rq-+AD4-q)+ADs
+AD4 -		if (rq-+AD4-mq+AF8-ctx +ACEAPQ this+AF8-ctx) +AHs
+AD4 +-		if (+ACE-ctx+AF8-match(rq, this+AF8-ctx, this+AF8-flags)) +AHs
+AD4  			if (this+AF8-ctx) +AHs
+AD4  				trace+AF8-block+AF8-unplug(this+AF8-q, depth, +ACE-from+AF8-schedule)+ADs
+AD4  				blk+AF8-mq+AF8-sched+AF8-insert+AF8-requests(this+AF8-q, this+AF8-ctx,
+AD4 +AEAAQA -1650,6 +-1672,7 +AEAAQA void blk+AF8-mq+AF8-flush+AF8-plug+AF8-list(struct blk+AF8-plug +ACo-plug, bool from+AF8-schedule)
+AD4  								from+AF8-schedule)+ADs
+AD4  			+AH0
+AD4  
+AD4 +-			this+AF8-flags +AD0 rq-+AD4-cmd+AF8-flags+ADs
+AD4  			this+AF8-ctx +AD0 rq-+AD4-mq+AF8-ctx+ADs
+AD4  			this+AF8-q +AD0 rq-+AD4-q+ADs
+AD4  			depth +AD0 0+ADs

This patch will cause the function stored in the flags+AF8-to+AF8-type pointer to be
called 2 +ACo (n - 1) times where n is the number of elements in 'list' when
blk+AF8-mq+AF8-sched+AF8-insert+AF8-requests() is called. Have you considered to rearrange
the code such that that number of calls is reduced to n?

Thanks,

Bart.

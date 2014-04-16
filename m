From: Christoph Hellwig <hch@lst.de>
Subject: next round of blk-mq updates
Date: Wed, 16 Apr 2014 09:44:51 +0200
Message-ID: <1397634299-7466-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Jens,

these are the final blk-mq changes for a fully working SCSI midlayer
using blk-mq.

Summary of the changes:

 - a new split I/O completion handler that allow the driver to free
   ressources when it knows a request will be fully completed, but
   before it has been freed
 - support for bidirectional requests, which is very trivial when
   used with the above split I/O completion handler.
 - support to requeue a request that already entered the driver,
   which is needed by the SCSI midlayer to support partial completions
   as well as various error conditions.
 - a couple of new ways to poke a queue:
	- an equivalent to blk_delay_queue to wake a stopped
	  queue after a delay
	- a new function to kick a queue that might be stopped or not
	- a parameter to blk_mq_start_stopped_hw_queues so that it can
	  be called from (soft)irq context

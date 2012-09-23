From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2 v2] Make blk_cleanup_queue() finish after request_fn
Date: Sun, 23 Sep 2012 18:16:09 +0200
Message-ID: <505F35C9.6070509@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [178.239.52.149] ([178.239.52.149]:51474 "EHLO wimaserver10.be"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754080Ab2IWQQ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Sep 2012 12:16:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Chanho Min <chanho.min@lge.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>

Request processing functions like scsi_request_fn() that unlock the
queue lock internally may cause blk_cleanup_queue() to finish while
the request_fn is in progress. This two-patch series makes sure that
blk_cleanup_queue() can't finish before all active request_fn calls
have finished.

Changes compared to v1:
- Included a patch to rename QUEUE_FLAG_DEAD.
- Refined the descriptions of the __blk_run_queue_uncond() and
  blk_cleanup_queue() functions.

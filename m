From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: 2.5.x why a conditional call to blkdev_dequeue_request?
Date: 07 Apr 2003 23:13:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1049775188.1749.82.camel@mulgrave>
References: <20030407204005.A4219@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:17159 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263927AbTDHEBi (for <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Apr 2003 00:01:38 -0400
In-Reply-To: <20030407204005.A4219@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-04-07 at 22:40, Patrick Mansfield wrote:
> Why do we conditionally call blkdev_dequeue_request, and yet run the same
> code even if a request is not dequeued? 
> 
> Should we always call blkdev_dequeue_request, and handle
> blk_queue_start_tag() returning != 0 as a bug or a resource limitation?
> 
> In 2.5 scsi_lib.c scsi_request_fn right now we have:
> 
> 	if (!(blk_queue_tagged(q) && (blk_queue_start_tag(q, req) == 0)))
> 		blkdev_dequeue_request(req);
> 
> 	/* then handle the request whether it was dequeued or not */
> 

blk_queue_start_tag dequeues for you.  It's for IDE and other block code
where the request is left in the queue while being processed.  In SCSI
we dequeue regardless of whether we're tagged or not.

James



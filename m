From: Patrick Mansfield <patmans@us.ibm.com>
Subject: 2.5.x why a conditional call to blkdev_dequeue_request?
Date: Mon, 7 Apr 2003 20:40:05 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030407204005.A4219@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:30353 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S263912AbTDHDcQ (for <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Apr 2003 23:32:16 -0400
Received: from westrelay04.boulder.ibm.com (westrelay04.boulder.ibm.com [9.17.193.32])
	by e35.co.us.ibm.com (8.12.9/8.12.2) with ESMTP id h383hms5092238
	for <linux-scsi@vger.kernel.org>; Mon, 7 Apr 2003 23:43:48 -0400
Received: from localhost.localdomain (d03av02.boulder.ibm.com [9.17.193.82])
	by westrelay04.boulder.ibm.com (8.12.8/NCO/VER6.5) with ESMTP id h383hkRT209730
	for <linux-scsi@vger.kernel.org>; Mon, 7 Apr 2003 21:43:47 -0600
Received: (from patman@localhost)
	by localhost.localdomain (8.11.2/8.11.6) id h383e5I04369
	for linux-scsi@vger.kernel.org; Mon, 7 Apr 2003 20:40:05 -0700
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Why do we conditionally call blkdev_dequeue_request, and yet run the same
code even if a request is not dequeued? 

Should we always call blkdev_dequeue_request, and handle
blk_queue_start_tag() returning != 0 as a bug or a resource limitation?

In 2.5 scsi_lib.c scsi_request_fn right now we have:

	if (!(blk_queue_tagged(q) && (blk_queue_start_tag(q, req) == 0)))
		blkdev_dequeue_request(req);

	/* then handle the request whether it was dequeued or not */

-- Patrick Mansfield

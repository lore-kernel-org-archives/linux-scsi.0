From: malahal@us.ibm.com
Subject: Re: blk request timeout handler against 2.6.26
Date: Mon, 12 May 2008 20:20:12 -0700
Message-ID: <20080513032012.GC9511@us.ibm.com>
References: <20080503020000.GU14976@parisc-linux.org> <20080507074357.GP329@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:51981 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbYEMDUO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 May 2008 23:20:14 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4D3KDG5018438
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2008 23:20:13 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4D3KDsk171454
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2008 21:20:13 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4D3KDtH010173
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2008 21:20:13 -0600
Content-Disposition: inline
In-Reply-To: <20080507074357.GP329@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

Add missing queue lock in blk_complete_request(). Ran disktest for few
hours and it works fine with this patch.

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>

diff -r c06b3eb1f516 block/blk-core.c
--- a/block/blk-core.c	Wed May 07 20:07:12 2008 -0700
+++ b/block/blk-core.c	Wed May 07 20:17:03 2008 -0700
@@ -1856,6 +1856,10 @@
  */
 void blk_complete_request(struct request *req)
 {
+	unsigned long flags;
+	struct request_queue *q = req->q;
+	int rc;
+
 	/*
 	 * We don't have to worry about this one timing out any more.
 	 * If we are unable to remove the timer, then the command
@@ -1864,7 +1868,10 @@
 	 * that function could really be.  It might be on another processor,
 	 * etc, etc.
 	 */
-	if (!blk_delete_timer(req))
+	spin_lock_irqsave(q->queue_lock, flags);
+	rc = blk_delete_timer(req);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+	if (!rc)
 		return;
 
 	__blk_complete_request(req);

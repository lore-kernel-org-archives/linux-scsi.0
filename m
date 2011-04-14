From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 2.6.39-rc3-git3 crashs after booting
Date: Thu, 14 Apr 2011 12:53:39 -0500
Message-ID: <1302803619.9800.4.camel@mulgrave.site>
References: <web-504663160@zbackend1.aha.ru>
	 <20110414104039.c0e655bd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54082 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932925Ab1DNRxn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2011 13:53:43 -0400
In-Reply-To: <20110414104039.c0e655bd.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: werner <w.landgraf@ru.ru>, gregkh@suse.de, mingo@elte.hu, tj@kernel.org, randy.dunlap@oracle.com, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On Thu, 2011-04-14 at 10:40 -0700, Andrew Morton wrote:
> (cc's added.  Please retain them)
> 
> The crash appears to be due to either the scsi or block code.
> 
> On Thu, 14 Apr 2011 04:17:51 -0400 "werner" <w.landgraf@ru.ru> wrote:
> 
> > The problem with the crashs after booting which started 
> > with 2.6.39-rc1 continues with 2.6.39-rc3-git3
> > 
> > Pls see enclosed a screen foto

It's a bit hard to tell from the jpg, but it looks like it could be
another instance of the steve whitehouse crash that was discovered a day
or so ago.  We're still preparing the final fix, but this is what we
have as an interim if you could try it out.

James

---
diff --git a/block/blk.h b/block/blk.h
index c8db371..11d0d25 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -62,7 +62,8 @@ static inline struct request *__elv_next_request(struct request_queue *q)
 			return rq;
 		}
 
-		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
+		if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags) ||
+		    !q->elevator->ops->elevator_dispatch_fn(q, 0))
 			return NULL;
 	}
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index e44ff64..5aa4246 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -322,14 +322,9 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 		kfree(evt);
 	}
 
-	if (sdev->request_queue) {
-		sdev->request_queue->queuedata = NULL;
-		/* user context needed to free queue */
-		scsi_free_queue(sdev->request_queue);
-		/* temporary expedient, try to catch use of queue lock
-		 * after free of sdev */
-		sdev->request_queue = NULL;
-	}
+	/* temporary expedient, try to catch use of queue lock after
+	 * free of sdev */
+	sdev->request_queue = NULL;
 
 	scsi_target_reap(scsi_target(sdev));
 
@@ -937,6 +932,11 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
+	/* Setting this to NULL causes the request function to reject
+	 * any I/O requests */
+	sdev->request_queue->queuedata = NULL;
+	/* Freeing the queue signals to block that we're done */
+	scsi_free_queue(sdev->request_queue);
 	put_device(dev);
 }
 



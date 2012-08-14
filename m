From: Chanho Min <chanho0207@gmail.com>
Subject: [PATCH RESEND] remove the queue unlock in scsi_requset_fn
Date: Tue, 14 Aug 2012 18:48:02 +0900
Message-ID: <CAOAMb1Dp=E6fjMhdh6ze6Hq48qUixTpsqHZf3z742AUAqhU5Ug@mail.gmail.com>
References: <CAOAMb1Dd5_KWQme+EzXdpnABk=A50+vXuLMoS+r5et6=o0605g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOAMb1Dd5_KWQme+EzXdpnABk=A50+vXuLMoS+r5et6=o0605g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <JBottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

We don't need to unlock the queue before put_device in scsi_request_fn()
If we trigger the ->remove() function, It occur a oops from the caller.
So sdev reference count should not be dropped to zero here.
Also It was added before scsi_device_dev_release() was moved
to user context, so it is outdated.

Signed-off-by: Chanho Min <chanho.min@lge.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ffd7773..cb2185a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1626,11 +1626,7 @@ out_delay:
 	if (sdev->device_busy == 0)
 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
 out:
-	/* must be careful here...if we trigger the ->remove() function
-	 * we cannot be holding the q lock */
-	spin_unlock_irq(q->queue_lock);
 	put_device(&sdev->sdev_gendev);
-	spin_lock_irq(q->queue_lock);
 }

 u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
-- 
1.7.0.4

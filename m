From: Chanho Min <chanho0207@gmail.com>
Subject: Re: [PATCH] fix NULL-pointer dereference on scsi_run_queue
Date: Tue, 7 Aug 2012 17:53:49 +0900
Message-ID: <CAOAMb1BWWzYPSode-6Y9+O5eNhMc-bYofCNwMRmzeC9-nhRb4g@mail.gmail.com>
References: <CAOAMb1D+g0zzKGKjMPPp7V-XEwKB5AYGMDvUUbXNaHaz8ieTVg@mail.gmail.com>
	<501CE4E5.20604@acm.org>
	<501D51D1.2010806@cs.wisc.edu>
	<501D83A1.7040900@acm.org>
	<501DA3F0.4090009@cs.wisc.edu>
	<50200561.4020100@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50200561.4020100@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 7, 2012 at 2:56 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> Indeed. How about the patch below ? Scsi devices are removed from
> starved_list after blk_cleanup_queue() and before put_device(). That
> guarantees that inside scsi_run_queue() get_device() under host lock
> will succeed.
Thanks, IMHO, it's harmless and the simple way to solve this issue.
But, I think the second half of your patches are not required, extra
referecne is might suffice?

In addition, Is it ironic that we are careful to use put_device at
scsi_request_fn?. If we trigger the ->remove(),
It occur a oops. What about the removal of unlock/lock as patch bellow?

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4037fd5..8d9eccd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1608,11 +1608,7 @@ out_delay:
        if (sdev->device_busy == 0)
                blk_delay_queue(q, SCSI_QUEUE_DELAY);
 out:
-       /* must be careful here...if we trigger the ->remove() function
-        * we cannot be holding the q lock */
-       spin_unlock_irq(q->queue_lock);
        put_device(&sdev->sdev_gendev);
-       spin_lock_irq(q->queue_lock);
 }

 u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)

From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] fix NULL-pointer dereference on scsi_run_queue
Date: Tue, 07 Aug 2012 09:43:16 +0000
Message-ID: <5020E334.4070809@acm.org>
References: <CAOAMb1D+g0zzKGKjMPPp7V-XEwKB5AYGMDvUUbXNaHaz8ieTVg@mail.gmail.com> <501CE4E5.20604@acm.org> <501D51D1.2010806@cs.wisc.edu> <501D83A1.7040900@acm.org> <501DA3F0.4090009@cs.wisc.edu> <50200561.4020100@acm.org> <CAOAMb1BWWzYPSode-6Y9+O5eNhMc-bYofCNwMRmzeC9-nhRb4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:41930 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab2HGJnV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2012 05:43:21 -0400
In-Reply-To: <CAOAMb1BWWzYPSode-6Y9+O5eNhMc-bYofCNwMRmzeC9-nhRb4g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chanho Min <chanho0207@gmail.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>

On 08/07/12 08:53, Chanho Min wrote:
> In addition, Is it ironic that we are careful to use put_device at
> scsi_request_fn?. If we trigger the ->remove(),
> It occur a oops. What about the removal of unlock/lock as patch bellow?
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 4037fd5..8d9eccd 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1608,11 +1608,7 @@ out_delay:
>         if (sdev->device_busy == 0)
>                 blk_delay_queue(q, SCSI_QUEUE_DELAY);
>  out:
> -       /* must be careful here...if we trigger the ->remove() function
> -        * we cannot be holding the q lock */
> -       spin_unlock_irq(q->queue_lock);
>         put_device(&sdev->sdev_gendev);
> -       spin_lock_irq(q->queue_lock);
>  }

As far as I can see the comment in the above code was added before
scsi_device_dev_release() was moved to user context, so it might be
outdated. See also
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=65110b2168950a19cc78b5027ed18cb811fbdae8.

Bart.

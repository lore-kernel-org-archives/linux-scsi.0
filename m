From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Wed, 27 Jul 2016 16:09:40 -0400
Message-ID: <20160727200939.GA82654@redhat.com>
References: <4ed669ed-beae-76a8-b806-a284565b327a@sandisk.com>
 <20160720140815.GA19045@redhat.com>
 <20160720142727.GA57399@redhat.com>
 <1ca6d31d-f175-9daa-9ddd-17d653851ceb@sandisk.com>
 <20160720183321.GA20223@redhat.com>
 <84d9dc64-0c10-ed1a-7bc1-e656874853a5@sandisk.com>
 <20160725175344.GA23000@redhat.com>
 <20160725212325.GA23961@redhat.com>
 <1490356d-2c0e-d94a-7a88-5e8bc89953ef@sandisk.com>
 <20160726011607.GA77078@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756830AbcG0UJQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2016 16:09:16 -0400
Content-Disposition: inline
In-Reply-To: <20160726011607.GA77078@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Jul 25 2016 at  9:16pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:
 
> Hi Bart,
> 
> Please try this patch to see if it fixes your issue, thanks.
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 52baf8a..287caa7 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -433,10 +433,17 @@ failed:
>   */
>  static int must_push_back(struct multipath *m)
>  {
> -	return (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) ||
> -		((test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) !=
> -		  test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags)) &&
> -		 dm_noflush_suspending(m->ti)));
> +	bool r;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&m->lock, flags);
> +	r = (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) ||
> +	     ((test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) !=
> +	       test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags)) &&
> +	      dm_noflush_suspending(m->ti)));
> +	spin_unlock_irqrestore(&m->lock, flags);
> +
> +	return r;
>  }
>  
>  /*

In addition to the above patch, please apply this patch and retest your
4.7 kernel:

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 287caa7..16583c1 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1416,12 +1416,14 @@ static void multipath_postsuspend(struct dm_target *ti)
 static void multipath_resume(struct dm_target *ti)
 {
 	struct multipath *m = ti->private;
+	unsigned long flags;
 
+	spin_lock_irqsave(&m->lock, flags);
 	if (test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags))
 		set_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
 	else
 		clear_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
-	smp_mb__after_atomic();
+	spin_unlock_irqrestore(&m->lock, flags);
 }
 
 /*

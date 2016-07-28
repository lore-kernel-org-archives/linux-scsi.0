From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Thu, 28 Jul 2016 09:33:46 -0400
Message-ID: <20160728133346.GA12272@redhat.com>
References: <20160720142727.GA57399@redhat.com>
 <1ca6d31d-f175-9daa-9ddd-17d653851ceb@sandisk.com>
 <20160720183321.GA20223@redhat.com>
 <84d9dc64-0c10-ed1a-7bc1-e656874853a5@sandisk.com>
 <20160725175344.GA23000@redhat.com>
 <20160725212325.GA23961@redhat.com>
 <1490356d-2c0e-d94a-7a88-5e8bc89953ef@sandisk.com>
 <20160726011607.GA77078@redhat.com>
 <20160727200939.GA82654@redhat.com>
 <dd513a39-eb62-cc3c-d214-e4eca5e65a4e@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757264AbcG1Nds (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jul 2016 09:33:48 -0400
Content-Disposition: inline
In-Reply-To: <dd513a39-eb62-cc3c-d214-e4eca5e65a4e@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Jul 27 2016 at  7:05pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 07/27/2016 01:09 PM, Mike Snitzer wrote:
> > In addition to the above patch, please apply this patch and retest your
> >4.7 kernel:
> >
> >diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> >index 287caa7..16583c1 100644
> >--- a/drivers/md/dm-mpath.c
> >+++ b/drivers/md/dm-mpath.c
> >@@ -1416,12 +1416,14 @@ static void multipath_postsuspend(struct dm_target *ti)
> > static void multipath_resume(struct dm_target *ti)
> > {
> > 	struct multipath *m = ti->private;
> >+	unsigned long flags;
> >
> >+	spin_lock_irqsave(&m->lock, flags);
> > 	if (test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags))
> > 		set_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
> > 	else
> > 		clear_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
> >-	smp_mb__after_atomic();
> >+	spin_unlock_irqrestore(&m->lock, flags);
> > }
> >
> > /*
> 
> Hello Mike,
> 
> Thanks again for having made this patch available. I will test it as
> soon as I have the time. BTW, in the meantime I ran a few tests with
> DM_MQ_DEFAULT=n since until now I ran all tests with
> DM_MQ_DEFAULT=y. The result of these tests is as follows:
> * v4.6.0, v4.6.5 and v4.7.0 with DM_MQ_DEFAULT=y: first simulated
> path removal triggers I/O errors.
> * v4.6.4, v4.6.5 and v4.7.0 with DM_MQ_DEFAULT=n: test passes more
> than 100 iterations.

I think this may point to an SRP issue then.  Is the synthetic "cable
pull" (by writing to /sys/class/srp_remote_ports/port-*/delete)
representitive of what actually happens if a cable is physically pulled?

Or is yur synthetic method hitting the device way harder than would
happen with an actual production fault?

Again, there hasn't been any report of failures (EIO or otherwise) with
extensive scsi-mq and dm-mq testing on a larger FC testbed.

> I have not yet run any tests with kernel v4.5.x because in the test
> I ran the ib_srp and ib_srpt drivers are loaded on the same system
> and because I need five v4.7 LIO patches to run this test pass but
> unfortunately these patches do not apply cleanly on the v4.5.x code
> base.
> 
> Please let me know if you need more information.

Can the target core be made to use SRP in loopback (local test machine)
mode?  The mptest harness currently defaults to using tcmloop.  Would be
great if I could somehow exercise the SRP code without needing a
fullblown IB setup.

But if there isn't a way to achieve that test coverage I can
probably/hopefully get access to a subset of a larger IB/SRP testbed.

Please advise, thanks.
Mike

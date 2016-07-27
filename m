From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Wed, 27 Jul 2016 10:08:28 -0400
Message-ID: <20160727140828.GA5692@redhat.com>
References: <20160720140815.GA19045@redhat.com>
 <20160720142727.GA57399@redhat.com>
 <1ca6d31d-f175-9daa-9ddd-17d653851ceb@sandisk.com>
 <20160720183321.GA20223@redhat.com>
 <84d9dc64-0c10-ed1a-7bc1-e656874853a5@sandisk.com>
 <20160725175344.GA23000@redhat.com>
 <20160725212325.GA23961@redhat.com>
 <1490356d-2c0e-d94a-7a88-5e8bc89953ef@sandisk.com>
 <20160726011607.GA77078@redhat.com>
 <577bc6d5-9c78-b6d3-10f7-10626c0da516@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903AbcG0OIa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2016 10:08:30 -0400
Content-Disposition: inline
In-Reply-To: <577bc6d5-9c78-b6d3-10f7-10626c0da516@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Jul 26 2016 at  6:51pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 07/25/2016 06:15 PM, Mike Snitzer wrote:
> > Please try this patch to see if it fixes your issue, thanks.
> > 
> > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > index 52baf8a..287caa7 100644
> > --- a/drivers/md/dm-mpath.c
> > +++ b/drivers/md/dm-mpath.c
> > @@ -433,10 +433,17 @@ failed:
> >   */
> >  static int must_push_back(struct multipath *m)
> >  {
> > -	return (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) ||
> > -		((test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) !=
> > -		  test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags)) &&
> > -		 dm_noflush_suspending(m->ti)));
> > +	bool r;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&m->lock, flags);
> > +	r = (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) ||
> > +	     ((test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) !=
> > +	       test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags)) &&
> > +	      dm_noflush_suspending(m->ti)));
> > +	spin_unlock_irqrestore(&m->lock, flags);
> > +
> > +	return r;
> >  }
> >  
> >  /*
>  
> Hello Mike,
> 
> Thank you for having made this patch available. Unfortunately even
> with this patch applied I still see fio reporting I/O errors and the
> following text still appears in the system log immediately before the
> I/O errors are reported (due to debug statements I added in the device
> mapper; mpath 254:0 and mpathbe refer to the same dm device):
> 
> Jul 26 15:40:37 ion-dev-ib-ini kernel: mpath 254:0: queue_if_no_path 0 -> 1
> Jul 26 15:40:37 ion-dev-ib-ini kernel: executing DM ioctl DEV_SUSPEND on mpathbe
> Jul 26 15:40:37 ion-dev-ib-ini kernel: mpath 254:0: queue_if_no_path 1 -> 0

This is all as expected.  Only question I have: is
dm_noflush_suspending() false? -- I assume so given must_push_back() is
returning false.

I'm struggling to appreciate why must_push_back() is only true if
noflush is used.  Regardless of which type, if there are no paths and
queue_if_no_path was configured (implied by current != saved) then we
shouldn't be returning -EIO back up the stack.

> BTW, I have not yet been able to determine which user space code
> triggers the DEV_SUSPEND ioctl. A condlog() call I had added just
> above dm_simplecmd_flush(DM_DEVICE_SUSPEND, mapname, 0) call in
> multipathd did not produce any output.

I need to dig into the multipath-tools userspace code more to be able to
answer.  But I've cc'd Ben Marzinski explicitly to get his insight.

Curious if multipath-tools _always_ use the noflush variant of suspend?
If not then we're setting ourselves up to return -EIO when we shouldn't.

Mike

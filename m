From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 1/2] lld busy status exporting interface
Date: Fri, 19 Sep 2008 19:11:22 -0400 (EDT)
Message-ID: <20080919.191122.102582872.k-ueda@ct.jp.nec.com>
References: <20080919.104756.41628866.k-ueda@ct.jp.nec.com>
	<20080919.104854.71084447.k-ueda@ct.jp.nec.com>
	<20080919143344.44d1a83e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37142 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYISXaN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Sep 2008 19:30:13 -0400
In-Reply-To: <20080919143344.44d1a83e.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

Hi Andrew,

On Fri, 19 Sep 2008 14:33:44 -0700, Andrew Morton wrote:
> On Fri, 19 Sep 2008 10:48:54 -0400 (EDT)
> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> 
> > This patch adds an interface to check lld's busy status
> > from the block layer.
> > This resolves a performance problem on request stacking devices below.
> > 
> > 
> > Some drivers like scsi mid layer stop dispatching request when
> > they detect busy state on its low-level device like host/bus/device.
> > It allows other requests to stay in the I/O scheduler's queue
> > for a chance of merging.
> > 
> > Request stacking drivers like request-based dm should follow
> > the same logic.
> > However, there is no generic interface for the stacked device
> > to check if the underlying device(s) are busy.
> > If the request stacking driver dispatches and submits requests to
> > the busy underlying device, the requests will stay in
> > the underlying device's queue without a chance of merging.
> > This causes performance problem on burst I/O load.
> > 
> > With this patch, busy state of the underlying device is exported
> > via the state flag of queue's backing_dev_info.  So the request
> > stacking driver can check it and stop dispatching requests if busy.
> > 
> > The underlying device driver must set/clear the flag appropriately:
> >    ON:  when the device driver can't process requests immediately.
> >    OFF: when the device driver can process requests immediately,
> >         including abnormal situations where the device driver needs
> >         to kill all requests.
> > 
> > 
> > Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> > Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> > ---
> >  include/linux/backing-dev.h |    8 ++++++++
> >  mm/backing-dev.c            |   12 ++++++++++++
> >  2 files changed, 20 insertions(+)
> > 
> > Index: scsi-misc-2.6/include/linux/backing-dev.h
> > ===================================================================
> > --- scsi-misc-2.6.orig/include/linux/backing-dev.h
> > +++ scsi-misc-2.6/include/linux/backing-dev.h
> > @@ -26,6 +26,7 @@ enum bdi_state {
> >  	BDI_pdflush,		/* A pdflush thread is working this device */
> >  	BDI_write_congested,	/* The write queue is getting full */
> >  	BDI_read_congested,	/* The read queue is getting full */
> > +	BDI_lld_congested,	/* The device/host is busy */
> >  	BDI_unused,		/* Available bits start here */
> >  };
> >  
> > @@ -226,8 +227,15 @@ static inline int bdi_rw_congested(struc
> >  				  (1 << BDI_write_congested));
> >  }
> >  
> > +static inline int bdi_lld_congested(struct backing_dev_info *bdi)
> > +{
> > +	return bdi_congested(bdi, 1 << BDI_lld_congested);
> > +}
> > +
> >  void clear_bdi_congested(struct backing_dev_info *bdi, int rw);
> >  void set_bdi_congested(struct backing_dev_info *bdi, int rw);
> > +void clear_bdi_lld_congested(struct backing_dev_info *bdi);
> > +void set_bdi_lld_congested(struct backing_dev_info *bdi);
> >  long congestion_wait(int rw, long timeout);
> >  
> >  
> > Index: scsi-misc-2.6/mm/backing-dev.c
> > ===================================================================
> > --- scsi-misc-2.6.orig/mm/backing-dev.c
> > +++ scsi-misc-2.6/mm/backing-dev.c
> > @@ -279,6 +279,18 @@ void set_bdi_congested(struct backing_de
> >  }
> >  EXPORT_SYMBOL(set_bdi_congested);
> >  
> > +void clear_bdi_lld_congested(struct backing_dev_info *bdi)
> > +{
> > +	clear_bit(BDI_lld_congested, &bdi->state);
> > +}
> > +EXPORT_SYMBOL_GPL(clear_bdi_lld_congested);
> > +
> > +void set_bdi_lld_congested(struct backing_dev_info *bdi)
> > +{
> > +	set_bit(BDI_lld_congested, &bdi->state);
> > +}
> > +EXPORT_SYMBOL_GPL(set_bdi_lld_congested);
> > +
> >  /**
> >   * congestion_wait - wait for a backing_dev to become uncongested
> >   * @rw: READ or WRITE
> 
> Is this really the right way to do it?

I think so, but I may not understand what you mean correctly.
So please elaborate your concern if my explanation below doesn't
satisfy what you want to know.


> Back in the days when we first did the backing_dev_info.congested_fn()
> logic it was decided that there basically was no single place in which
> the congested state could be stored.
> 
> So we ended up deciding that whenever a caller wants to know a
> backing_dev's congested status, it has to call in to the
> ->congested_fn() and that congested_fn would then call down into all
> the constituent low-level drivers/queues/etc asking each one if it is
> congested.

bdi_lld_congested() also does that using bdi_congested(), which calls
->congested_fn().
And only real device drivers (e.g. scsi, ide) set/clear the flag.
Stacking drivers like request-based dm don't.
So stacking drivers always check the BDI_lld_congested flag of
the bottom device of the device stack.

BDI_[write|read]_congested flags have been using for queue's
congestion, so that I/O queueing/merging can be proceeded even if
the lld is congested.  So I added a new flag.


> I mean, as a simple example which is probably wrong - what happens if a
> single backing_dev is implemented via two different disks and
> controllers, and they both become congested and then one of them comes
> uncongested.  Is there no way in which the above implemention can
> incorrectly flag the backing_dev as being uncongested?

Do you mean that "a single backing_dev via two disks/controllers" is
a dm device (e.g. a dm-multipath device having 2 paths, a dm-mirror
device having 2 disks)?

If so, dm doesn't set/clear the flag, and the decision, whether
the dm device itself is congested or not, depends on dm's target driver.

For example of dm-multipath,
  o call bdi_lld_congested() for each path.
  o if one of the paths are uncongested, dm-multipath will decide
    the dm device is uncongested and dispatch incoming I/Os to
    the uncongested path.

For example of dm-mirror,
  o call bdi_lld_congested() for each disk.
  o if the incoming I/O is READ, same logic as dm-multipath above.
    if the incoming I/O is WRITE, dm-mirror will decide the dm device
    is uncongested only when all disks are uncongested.

Thanks,
Kiyoshi Ueda

From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 1/1] scsi: export busy state via
	q->lld_busy_fn()
Date: Fri, 03 Oct 2008 16:06:23 -0400 (EDT)
Message-ID: <20081003.160623.48532879.k-ueda@ct.jp.nec.com>
References: <20081001.145039.39152159.k-ueda@ct.jp.nec.com>
	<1223057696.3230.38.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1223057696.3230.38.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James.Bottomley@HansenPartnership.com
Cc: k-ueda@ct.jp.nec.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Hi James,

On Fri, 03 Oct 2008 13:14:56 -0500, James Bottomley wrote:
> On Wed, 2008-10-01 at 14:50 -0400, Kiyoshi Ueda wrote:
> > Hi James,
> > 
> > I hope the previous RFC patch(*) would be no problem, since I haven't
> > gotten any negative comment.
> >     (*) http://lkml.org/lkml/2008/9/25/262
> > 
> > So could you take this patch for 2.6.28 additionally?
> > This patch implements a new interface of the block layer for
> > request stacking drivers.
> > There should be no effect on existing drivers' behavior.
> > 
> > This patch was created on top of the commit below of scsi-post-merge-2.6.
> > ---------------------------------------------------------------------
> > commit e49f03f37104c0e7cae7c455480069bada00932f
> > Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Date:   Fri Sep 12 16:46:51 2008 -0500
> > 
> >     [SCSI] scsi_error: fix target reset handling
> > ---------------------------------------------------------------------
> > 
> > And this patch depends on the following block layer patch, which
> > is in Jens' for-2.6.28 of linux-2.6-block.
> >     http://lkml.org/lkml/2008/9/29/142
> > 
> > Thanks,
> > Kiyoshi Ueda
> > 
> > 
> > Subject: [PATCH 1/1] scsi: export busy state via q->lld_busy_fn()
> > 
> > This patch implements q->lld_busy_fn() for scsi mid layer to export
> > its busy state.
> > 
> > Please note that it checks the cached information (sdev->lld_busy)
> > for efficiency, instead of checking the actual state of
> > sdev/starget/shost everytime.
> > 
> > So the care must be taken not to leave sdev->lld_busy = 1 for
> > the following cases:
> >     - when there is no request in the sdev queue
> >     - when scsi can't dispatch I/Os anymore and needs to kill I/Os
> > Otherwise, request stacking drivers may not submit any request,
> > and then, nobody sets back lld_busy = 0 and that causes deadlock.
> > 
> > OTOH, it has no major problem in setting sdev->lld_busy = 0 even when
> > the starget/shost is actually busy, because newly submitted request
> > will soon turn it to 1 in scsi_request_fn().
> > 
> > 
> > Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> > Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Mike Christie <michaelc@cs.wisc.edu>
> > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> > ---
> >  drivers/scsi/scsi.c        |    4 ++--
> >  drivers/scsi/scsi_lib.c    |   20 +++++++++++++++++++-
> >  include/scsi/scsi_device.h |   13 +++++++++++++
> >  3 files changed, 34 insertions(+), 3 deletions(-)
> > 
> > Index: scsi-post-merge-2.6/drivers/scsi/scsi_lib.c
> > ===================================================================
> > --- scsi-post-merge-2.6.orig/drivers/scsi/scsi_lib.c
> > +++ scsi-post-merge-2.6/drivers/scsi/scsi_lib.c
> > @@ -480,6 +480,8 @@ void scsi_device_unbusy(struct scsi_devi
> >  	spin_unlock(shost->host_lock);
> >  	spin_lock(sdev->request_queue->queue_lock);
> >  	sdev->device_busy--;
> > +	if (sdev->device_busy < sdev->queue_depth && !sdev->device_blocked)
> > +		sdev->lld_busy = 0;
> >  	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> >  }
> >  
> > @@ -1535,6 +1537,13 @@ static void scsi_softirq_done(struct req
> >  	}
> >  }
> >  
> > +static int scsi_lld_busy(struct request_queue *q)
> > +{
> > +	struct scsi_device *sdev = q->queuedata;
> > +
> > +	return sdev ? sdev->lld_busy : 0;
> > +}
> 
> Since you've moved to a functional approach, why is this lld_busy flag
> still necessary?  Surely this function can just check the three blocked
> conditions and the two overqueue ones at this point without ever having
> to reach into any of the SCSI internals?

This flag is not necessary for the functionality, it's for efficiency.
I could take the "everytime checking" approach above, but I think
caching the busy state into the flag is more efficient, since:

  - The check function will be called from request stacking drivers
    frequently (e.g. request-based dm calls it everytime before
    an request is dispatched from the dm device.)

  - The scsi busy state checking needs queue lock and host lock
    even while the scsi busy state doesn't changed from the previous
    checking.

Actually, I don't get any performance problem by some simple testings
of the "everytime checking" approach.
Do you prefer the "everytime checking" approach to simplify the patch?

Thanks,
Kiyoshi Ueda

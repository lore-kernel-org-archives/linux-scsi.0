From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] Restart list search after unlock in
 scsi_remove_target
Date: Wed, 04 Nov 2015 14:44:32 -0800
Message-ID: <1446677072.2216.30.camel@HansenPartnership.com>
References: <5633E9F2.5080209@sandisk.com> <5633EA98.8050604@sandisk.com>
	 <563A883C.9060501@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54044 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031007AbbKDWoe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 17:44:34 -0500
In-Reply-To: <563A883C.9060501@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2015-11-04 at 14:35 -0800, Bart Van Assche wrote:
> On 10/30/2015 03:09 PM, Bart Van Assche wrote:
> > When dropping a lock while iterating a list we must restart the search
> > as other threads could have manipulated the list under us. Without this
> > we can get stuck in an endless loop.
> >
> > This is a slightly modified version of a patch from Christoph Hellwig
> > (see also https://www.spinics.net/lists/linux-scsi/msg89416.html).
> >
> > Reported-by: Johannes Thumshirn <jthumshirn@suse.de>
> > Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> > Cc: Johannes Thumshirn <jthumshirn@suse.de>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: stable <stable@vger.kernel.org>
> > ---
> >   drivers/scsi/scsi_sysfs.c | 16 ++++------------
> >   1 file changed, 4 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > index b9fb61a..5a183d1 100644
> > --- a/drivers/scsi/scsi_sysfs.c
> > +++ b/drivers/scsi/scsi_sysfs.c
> > @@ -1158,32 +1158,24 @@ static void __scsi_remove_target(struct scsi_target *starget)
> >   void scsi_remove_target(struct device *dev)
> >   {
> >   	struct Scsi_Host *shost = dev_to_shost(dev->parent);
> > -	struct scsi_target *starget, *last = NULL;
> > +	struct scsi_target *starget;
> >   	unsigned long flags;
> >
> > -	/* remove targets being careful to lookup next entry before
> > -	 * deleting the last
> > -	 */
> > +restart:
> >   	spin_lock_irqsave(shost->host_lock, flags);
> >   	list_for_each_entry(starget, &shost->__targets, siblings) {
> >   		if (starget->reaped)
> >   			continue;
> >   		if (starget->dev.parent == dev || &starget->dev == dev) {
> > -			/* assuming new targets arrive at the end */
> >   			kref_get(&starget->reap_ref);
> >   			starget->reaped = true;
> >   			spin_unlock_irqrestore(shost->host_lock, flags);
> > -			if (last)
> > -				scsi_target_reap(last);
> > -			last = starget;
> >   			__scsi_remove_target(starget);
> > -			spin_lock_irqsave(shost->host_lock, flags);
> > +			scsi_target_reap(starget);
> > +			goto restart;
> >   		}
> >   	}
> >   	spin_unlock_irqrestore(shost->host_lock, flags);
> > -
> > -	if (last)
> > -		scsi_target_reap(last);
> >   }
> >   EXPORT_SYMBOL(scsi_remove_target);
> 
> (replying to my own e-mail)
> 
> Hello Christoph,
> 
> Is it OK for you if I mention you as author of this e-mail ?

Could you just both co-operate, especially since there's not much
difference between the patches.

The fundamental problem with this is how have the conditions that caused
us to move away from list restart:

commit bc3f02a795d3b4faa99d37390174be2a75d091bd
Author: Dan Williams <djbw@fb.com>
Date:   Tue Aug 28 22:12:10 2012 -0700

    [SCSI] scsi_remove_target: fix softlockup regression on hot remove

Which was triggered by this bug report

http://thread.gmane.org/gmane.linux.kernel/1348679

been mitigated?

James



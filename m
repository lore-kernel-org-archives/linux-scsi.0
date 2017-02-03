From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCHv3 3/6] sg: protect accesses to 'reserved' page array
Date: Fri, 03 Feb 2017 10:21:24 -0800
Message-ID: <1486146084.2431.36.camel@HansenPartnership.com>
References: <1486127531-13716-1-git-send-email-hare@suse.de>
         <1486127531-13716-4-git-send-email-hare@suse.de>
         <20170203133140.GC646@lst.de>
         <b75d63b6-ae38-6c69-ec16-430e2bd351f7@suse.de>
         <20170203161910.GA4339@lst.de>
         <1d212ffc-d1c2-f743-151d-b8f48ea94f30@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59370 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751141AbdBCSVc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2017 13:21:32 -0500
In-Reply-To: <1d212ffc-d1c2-f743-151d-b8f48ea94f30@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, 2017-02-03 at 19:06 +0100, Johannes Thumshirn wrote:
> 
> On 02/03/2017 05:19 PM, Christoph Hellwig wrote:
> > On Fri, Feb 03, 2017 at 02:38:35PM +0100, Hannes Reinecke wrote:
> > > On 02/03/2017 02:31 PM, Christoph Hellwig wrote:
> > > > > -		if (sg_res_in_use(sfp)) {
> > > > > +		mutex_lock(&sfp->f_mutex);
> > > > > +		if (sfp->res_in_use) {
> > > > > +			mutex_unlock(&sfp->f_mutex);
> > > > >   			sg_remove_request(sfp, srp);
> > > > >   			return -EBUSY;	/* reserve
> > > > > buffer already being used */
> > > > >   		}
> > > > > +		mutex_unlock(&sfp->f_mutex);
> > > > Holding a mutex over a the check of a single scalar doesn't
> > > > make sense.
> > > > 
> > > It's adds a synchronisation point, doesn't it?
> > It does, but it doesn't actually protect anything..
> 
> But all the other mutex_{un,}locks() do (for instance guarding 
> sg_build_indirect()) and this one provides a synchronization point.
> 
> Sorry but I really don't get your point here.
> 
> The sole purpose is to guard the reserved list from being altered 
> while blk_rq_map_* or similar functions are in progess (that's what 
> the syzcaller reproducer was doing).

What he means is that naturally aligned reads are always atomic, so
adding further synchronisation gains nothing (you already atomically
get either the prior or next value) and only causes an unnecessary
pipeline stall.  From a reviewer's perspective, the sequence

lock
read
unlock

is always a red flag because it means the writer may not understand how
locking works.  Usually because the writer thinks there's some other
synchronization they need that this sequence doesn't give.

James

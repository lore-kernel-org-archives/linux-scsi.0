From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH / RFC] scsi_set_host_offline
Date: Wed, 5 Mar 2003 14:35:04 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030305223504.GB4014@beaverton.ibm.com>
References: <20030303221532.GB1587@beaverton.ibm.com> <200303050012.35309.oliver@neukum.name> <1046883135.1784.23.camel@mulgrave> <200303052049.16538.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200303052049.16538.oliver@neukum.name>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>

Oliver Neukum [oliver@neukum.name] wrote:
> Am Mittwoch, 5. M?rz 2003 17:52 schrieben Sie:
> > On Tue, 2003-03-04 at 17:12, Oliver Neukum wrote:
> > > It seems to me that there's a race with scan_scsis() and
> > > scan_scsis_single() which cannot be closed with failing queuecommand, as
> > > there's a window where the INQUIRY has succeeded but has not yet been
> > > evaluated by the SCSI layer.
> >
> > Consider the offline function as a work in progress.  I think the model
> 
> I do. But problems have to be pointed out and fixes proposed.
> 
> > we'll ultimately move to is to use the sysfs refcounting, so we could
> > call the offline function, have the device refuse all incoming requests,
> > but still process pending ones (which, if this is a forced remove should
> > fail).  Then call a remove hook when the outstanding command count drops
> > to zero.
> 
> What exactly is a refcount supposed to do? It doesn't help the main problem.
> You must prevent new references arising. This requires locking and flags.
> 

Refcounting is need for proper freeing so it needs to be part of the
solution. We need to have the refcounting implementation prevent gets
post "offline"

Yes, currently the kobject_get does not contain any support for
preventing the incrementing of the ref count. This needs to be wrapped
by the implementor (I believe as I do not see the object state support
being implemented in the core code).

> > > I am not quite sure how slave_alloc() is involved into this, but IMHO
> > > it's wrong to force LLDDs to know about devices if they are hotpluggable.
> > > Could you clarify?
> >
> > By design LLDs need to know about configured devices because they may
> > (although not all do) need to allocate resources to process them.  The
> > slave configure/alloc/destroy is the interface for communicating this
> > information:
> 
> Very well, but that system should not be overloaded with hotplugging issues.
> IMHO we must not require drivers to support this interface just because they
> are hotpluggable.

It is not required, but lack of any online state in a driver will
possibly cause extended time to cancel the IO. We would not want
excessive checking in the main IO path so there will be code that races
with "offline" and makes it to queuecommand.

-andmike
--
Michael Anderson
andmike@us.ibm.com


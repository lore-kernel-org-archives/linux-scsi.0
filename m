From: James.Smart@Emulex.Com
Subject: RE: [Announce] Emulex lpfcdriver v8.0.20 available
Date: Thu, 20 Jan 2005 10:27:54 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F307@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:25807 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S262157AbVATP2I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2005 10:28:08 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org

> What console messages do you see?  Looks like we'd have to add another
> allowed state transition from BLOCKED?

At one point we were seeing 
   Synchronizing SCSI cache for disk sdc:
    FAILED
      status = 0, message = 00, host = 1, driver = 00
      <5>
messages. However, at this point, the sequencing in the driver for unload,
scsi_host_removal, and datastructure teardown is such that we are avoiding
this condition and removals are clean.

No changes are needed.

> Yes, the allocation would need to be changed a little.  But 
> hey, I don't
> think we should block merging the driver on this one.  We'll probably
> introduce it soon and I'll sign you up for testing that patch on the
> lpfc drivewr when it's ready.

Reasonable.

> > >  o what about lpfc_target->rport?  This should probably 
> better be in
> > >    the fc_target structure, no?
> > 
> > Anything in lpfc_target would go into the scsi_target hostdata
> > (not fc_target).
> 
> I meant fc_target_attrs actually, which is scsi_target transport-data.
> 
> The point here is that the rport is a transport-class transport object
> that every driver fully converted to fc_transport needs, so 
> it's better
> in transport data as well.

If I understand you - it's the recommendation that the remote port be
part of the fc_target transport data.  I disagree. If anything, it would
be the other way around. The port exists before any scsi target (thus it
can't be part of the target allocation). The port can also exist without
being a scsi target, so there's no scsi target structure at all.

> 
> Now looking at lpfc_target given that the rport goes away we only
> have the I/O counters left and the nodlist pointer.  The I/O counters
> aren't really a driver thing and should probably move to the midlayer
> which only leaves the nodelist as private data in the scsi_device.
> 
> Sounds like the way to go?

Nope. The counters are a scsi-thing (not fc-thing), so they make sense
to go into the scsi_target. If you want to make them more general for
all drivers, we can do this. Right now, I wouldn't bother.

-- james s

From: James.Smart@Emulex.Com
Subject: RE: [RFC] adding per scsi-host workqueues for defered processing
Date: Wed, 9 Mar 2005 00:19:19 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12ED0C@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from emulex.emulex.com ([138.239.112.1]:49605 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261264AbVCIFTc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2005 00:19:32 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: luben_tuikov@adaptec.com, andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org

So, is there a reason we aren't just starting the workq thread
upon the first call to queue something to it ?

-- james s

> -----Original Message-----
> From: Luben Tuikov [mailto:luben_tuikov@adaptec.com]
> Sent: Tuesday, March 08, 2005 8:12 AM
> To: Andrew Vasquez
> Cc: Smart, James; linux-scsi@vger.kernel.org
> Subject: Re: [RFC] adding per scsi-host workqueues for defered
> processing
> 
> 
> On 03/08/05 02:00, Andrew Vasquez wrote:
> > There were some background tasks I shelved until the remote-ports
> > stuff settled down which I thought could use the deferred processing
> > thread:
> > 
> > * Initiate LIP -- several customers have asked for this ability as
> >   several topological configurations isolate disruptive FC events.
> > * Initiate LLDD rescan (i.e. ports (fibre channel), devices (iSCSI),
> >   etc.)
> > 
> > I had originally envisioned these functions residing in the 
> transport.
> 
> Yes, I agree.  Domain (target, topology, etc) discovery should be
> "part" of the transport class.
> 
> What I'm thinking of is that the LLDD would register a known
> trasport class with the SCSI Core at/after registering a host
> template and then would call something with a name like
> "start_scsi" which would do whatever necessary for the domain
> (SAS, FC, iSCSI, etc) before scanning for targets.  Of course
> for some domains no additional work is needed.
> 
> 	Luben
> 

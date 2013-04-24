From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: T10 WCE interpretation in Linux & device level access
Date: Wed, 24 Apr 2013 08:27:09 -0400
Message-ID: <20130424122709.GA12155@redhat.com>
References: <5176E3E8.3000809@redhat.com>
 <1366747622.1939.6.camel@dabdike>
 <5177BF53.3040305@redhat.com>
 <5177CAF5.6060506@suse.de>
 <5177CB23.5090802@redhat.com>
 <5177CC31.7090700@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758388Ab3DXM1f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Apr 2013 08:27:35 -0400
Content-Disposition: inline
In-Reply-To: <5177CC31.7090700@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Ric Wheeler <rwheeler@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>

On Wed, Apr 24 2013 at  8:12am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 04/24/2013 02:08 PM, Paolo Bonzini wrote:
> > Il 24/04/2013 14:07, Hannes Reinecke ha scritto:
> >> On 04/24/2013 01:17 PM, Paolo Bonzini wrote:
> >>> Il 23/04/2013 22:07, James Bottomley ha scritto:
> >>>> On Tue, 2013-04-23 at 15:41 -0400, Ric Wheeler wrote:
> >>>>> For many years, we have used WCE as an indication that a device has a volatile 
> >>>>> write cache (not just a write cache) and used this as a trigger to send down 
> >>>>> SYNCHRONIZE_CACHE commands as needed.
> >>>>>
> >>>>> Some arrays with non-volatile cache seem to have WCE set and simply ignore the 
> >>>>> command.
> >>>>
> >>>> I bet they don't; they probably obey the spec.  There's a SYNC_NV bit
> >>>> which if unset (which it is in our implementation) means only sync your
> >>>> non-NV cache.  For a device with all NV, that equates to nop.
> >>>
> >>> Isn't it the other way round?
> >>>
> >>> SYNC_NV = 0 means "sync all your caches to the medium", and it's what we do.
> >>>
> >>> SYNC_NV = 1 means "sync volatile to non-volatile", and it's what Ric wants.
> >>>
> >>> So we should set SYNC_NV=1 if NV_SUP is set, perhaps only if the medium
> >>> is non-removable just to err on the safe side.
> >>
> >> Or use 'WRITE_AND_VERIFY' here; that's guaranteed to hit the disk.
> >> Plus it even has a guarantee about data consistency on the disk,
> >> which the normal WRITE command has not.
> > 
> > The point is to _avoid_ hitting the disk. :)
> > 
> Ah. Really?
> 
> Why do we discuss SYNCHRONIZE CACHE then?
> I was under the impression that we're talking various 'barriers'
> (or rather 'flush' nowadays) implementations.
> Which require that some data needs to be written to disk before
> continuing.
> 
> Or did I somehow misread the thread?

This thread was motivated by the fact that the storage is reporting
WCE=1 and OracleDB (with ASM) is issuing SYNCHRONIZE CACHE (via
REQ_FLUSH) which the array in question handles _very_ slowly (even
though it is battery backed).

So the question Ric had is: should we expose a new knob that allows
admins to impose WCE=0 behavior (avoiding the SYNCHRONIZE CACHE).

I'm concerned such a knob will be abused for the benefit of speed and
all data integrity caution will get thrown to the wind (much like the
nobarrier FS mount option).

Mike

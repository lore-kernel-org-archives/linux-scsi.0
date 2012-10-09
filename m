From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: standards revisions
Date: Tue, 09 Oct 2012 11:55:17 -0700
Message-ID: <1349808917.3776.54.camel@haakon2.linux-iscsi.org>
References: <20121007014900.GA30316@infradead.org>
	 <1349590310.9312.163.camel@haakon2.linux-iscsi.org>
	 <20121007145154.GA30586@infradead.org>
	 <1349631097.13843.5.camel@haakon2.linux-iscsi.org>
	 <20121008034448.GA6919@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20121008034448.GA6919@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Roland Dreier <roland@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2012-10-07 at 23:44 -0400, Christoph Hellwig wrote:
> On Sun, Oct 07, 2012 at 10:31:37AM -0700, Nicholas A. Bellinger wrote:
> > Regardless of if an virtual backend reports a SPC-3 version (0x05) in
> > INQUIRY response, an initiator is still allowed to fall back to using
> > legacy SCSI-2 reservations instead of SPC-3 persistent reservations.  I
> > can think of at least one mainstream SCSI initiator that does this.
> 
> Yes, but we have a different code path for the mixed SCSI-2/SPC-3
> reservations from the pure SCSI-2 mode, based on the function pointers
> set up in core_setup_reservations().  As far as I can see we could
> only reach the SCSI-2 path there for a pscsi device that has the
> emulate_reservations flag set, and even then we would never actually hit
> the code the function pointers point to as we don't actually support
> emulated reservations for pscsi.

Ok, I see what your getting now wrt to dead code during ALUA/PR init..

So yes, the two SPC2_ALUA_DISABLED and SPC2_RESERVATIONS cases are not
ever reached, and where originally intended to disable this emulation
for virtual backends based upon se_subsystem_api->get_device_rev()

> 
> > Also, I think your mistaken about ALUA and SCSI-2 compatibility.  ALUA
> > is an SPC-3 and above specific feature.
> 
> What I mean is that int core_setup_alua again has a special code path
> for < SCSI-3 levels, which has the same reachability issues as for the
> reservations above.
> 
> > pSCSI has always NOP'ed the reservation + ALUA function pointers within
> > core_setup_reservations() and core_setup_alua().
> 
> Unless the emulate_reservations or emulate_alua flags are set, in which
> case we will set the other functions pointers.  That being said I can't
> see why the function pointers are even needed, as the non-noop versions
> are careful enough to do the right thing for pscsi as we'll never have
> registrations set.  I'll send a series of patches to clean all this up.
> 

<nod>

Thanks Christoph !

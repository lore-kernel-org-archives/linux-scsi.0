From: Christoph Hellwig <hch@infradead.org>
Subject: Re: standards revisions
Date: Sun, 7 Oct 2012 23:44:48 -0400
Message-ID: <20121008034448.GA6919@infradead.org>
References: <20121007014900.GA30316@infradead.org>
 <1349590310.9312.163.camel@haakon2.linux-iscsi.org>
 <20121007145154.GA30586@infradead.org>
 <1349631097.13843.5.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1349631097.13843.5.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Roland Dreier <roland@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Oct 07, 2012 at 10:31:37AM -0700, Nicholas A. Bellinger wrote:
> Regardless of if an virtual backend reports a SPC-3 version (0x05) in
> INQUIRY response, an initiator is still allowed to fall back to using
> legacy SCSI-2 reservations instead of SPC-3 persistent reservations.  I
> can think of at least one mainstream SCSI initiator that does this.

Yes, but we have a different code path for the mixed SCSI-2/SPC-3
reservations from the pure SCSI-2 mode, based on the function pointers
set up in core_setup_reservations().  As far as I can see we could
only reach the SCSI-2 path there for a pscsi device that has the
emulate_reservations flag set, and even then we would never actually hit
the code the function pointers point to as we don't actually support
emulated reservations for pscsi.

> Also, I think your mistaken about ALUA and SCSI-2 compatibility.  ALUA
> is an SPC-3 and above specific feature.

What I mean is that int core_setup_alua again has a special code path
for < SCSI-3 levels, which has the same reachability issues as for the
reservations above.

> pSCSI has always NOP'ed the reservation + ALUA function pointers within
> core_setup_reservations() and core_setup_alua().

Unless the emulate_reservations or emulate_alua flags are set, in which
case we will set the other functions pointers.  That being said I can't
see why the function pointers are even needed, as the non-noop versions
are careful enough to do the right thing for pscsi as we'll never have
registrations set.  I'll send a series of patches to clean all this up.

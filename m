From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Tue, 14 Jan 2003 17:19:30 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF17AF196C.AE6043CD-ONC1256CAE.00549A53@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: patmans@us.ibm.com, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org



Luben Tuikov <luben@splentec.com>@vger.kernel.org on 01/13/2003 10:30:05 PM

Sent by:    linux-scsi-owner@vger.kernel.org


To:    patmans@us.ltcfwd.linux.ibm.com
cc:    Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org
Subject:    Re: [PATCH] SCSI Core patches


Luben Tuitkov wrote:
> Patrick Mansfield wrote:
> >
> > This is _not_ just for multi-path. The current scsi code does not
properly
> > size the target and lun based on the transport. For SPI the target and
lun
> > need only be one byte; for FCP they are 4 and 8 bytes; for iSCSI I
don't
> > know what. (Our current four byte host-ordered lun does not match
anything
> > in any SCSI spec.)
>
> I brought this up last year sometime, either privately or here (search
> the archives if anyone is interested) and the idea of using a 64-bit LUN
> was shot down as in ``we don't need so many bits''.

I've been pleading for 64 bit values, too.
The FCP driver for zSeries I am maintaining for 2.4 uses a mapping
between 64 bit and 32 bit values. This is ugly and I'd like to get
rid of it in its 2.5 port if possible.

Such a change would raise an issue related to device discovery.
A sparsely populated name space for SCSI ID and LUN makes SCSI
device detection harder. For LUN, this should be fixed by the usage
of REPORT_LUNS. Additionally, lldd's could specify the size or
range of SCSI IDs and LUNs which apply to them in order to reduce
discovery overhead.

Furthermore, does anybody know what the largest IDs are which are
defined by any SCSI transport?

I think, the SCSI ID for FCP should also be 64 bit in size and
ought to be comprised of the World-Wide Port Name (WWPN) rather
than the more volatile 24 bit Destination ID (D_ID).

> > The problem is that due to its hierarchical structure all 64 bits are
> > used. If SPI wants to use 5 bits, let it use 5 bits, if iSCSI wants
> > to use 64, we've got this covered too.

Yes.

> > Having a scsi_nexus or such that is host adapter specific (something
like
> > Mike A. posted about) possibly with common transport code (for FCP,
SPI,
> > and iSCSI) would be useful, and would make it easier to add
multi-pathing
> > or support for future transports. The scsi_device current_tag, sdtr,
wdtr,
> > and ppr would be moved to a scsi_nexus since they are SPI specific.

Although the 2.5 stack has much improved, it is still too SPI-centric.
Changes to SCSI ID and SCSI LUN might evolve into such helper functions
concerned with transport specifics. Code for other characteristics
might be moved by degrees then too.


Martin Peschke


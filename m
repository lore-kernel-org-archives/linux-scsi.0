From: Douglas Gilbert <dougg@torque.net>
Subject: Re: request sense
Date: Fri, 25 Feb 2005 14:02:20 +1000
Message-ID: <421EA34C.1060002@torque.net>
References: <20050224231901.GT28741@parcelfarce.linux.theplanet.co.uk>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from borg.st.net.au ([65.23.158.22]:57534 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261758AbVBYEBf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Feb 2005 23:01:35 -0500
In-Reply-To: <20050224231901.GT28741@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> Found a funny in the sym2 driver I'm not sure how to resolve:
> 
>                 cp->sensecmd[0]         = REQUEST_SENSE;
>                 cp->sensecmd[1]         = 0;
>                 if (tp->tinfo.curr.scsi_version <= 2 && cp->lun <= 7)
>                         cp->sensecmd[1] = cp->lun << 5;
> 
> Thing is, we don't set scsi_version anywhere, so I'm sure sym2 currently
> does The Wrong Thing for SCSI-2 drives.  Pulling up the (draft) specs,
> this does seem to be something that changed between SCSI-2 and SPC3r15.
> Polling some of the other scsi drivers for a solution:
> 
> 3w-9xxx		Never fills in LUN
> 53c700		Always fills in LUN
> BusLogic	Doesn't send REQUEST_SENSE
> aic7xxx		Same as sym2 (except it sets its equivalent of scsi_version)
> dc395x		Always fills in LUN
> gdth		Doesn't send REQUEST_SENSE
> ipr		Never fills in LUN
> ips		Doesn't send REQUEST_SENSE
> ncr53c8xx	Doesn't send REQUEST_SENSE
> qla1280		Doesn't send REQUEST_SENSE
> sym53c416	Doesn't send REQUEST_SENSE
> tmscsim		Always fills in LUN
> 
> In other words, the only driver I've found that gets this *right* is
> aic7xxx (and 79xx).  Even scsi_error.c doesn't fill in the LUN.  What's
> going on here?

Matthew,
Back in SCSI-2 (final t10 draft in 1993, standard in 1994) all
SCSI commands (I believe) used the top 3 bits of byte 1 of a cdb
for the logical unit number (lun). In those days SCSI had only
one transport (now called SPI) and luns were limited to 8 (3 bits)
for each target.

By SPC (part of the original "SCSI-3") those 3 bits were reserved
and luns had increased to 32 bits and were conveyed across the
SCSI transport by soem other mechanism (i.e. not the cdb). SPC was
standardized in 1997 and the final draft is dated almost 8 years
ago.

Now SPC-3 is in the process of being voted on. Those top 3 bits
in byte 1 of each cdb are now being re-used by some commands.
For example, there is now something called "protection information"
which adds an extra 8 bytes to each block. If a disk supports it
(PROTECT bit set in an INQUIRY response), then an application
can format a disk with it by setting byte 1, bit 7 of the
FORMAT UNIT cdb. 11 years ago that bit would have been part of
the lun number. Even READ and WRITE cdbs now use the former lun
bits.

So unless a LLD knows that it is using such an old version
of SPI that it has no other mechanism for conveying a lun
_and_ the mid level structure indicates a lun > 0 (and
lun < 8) then it should not overwrite those bits, IMO.

The LLD obviously knows the version of SPI that a target
supports and the "version" field in an INQUIRY response
indicates which SCSI command set generation the device claims
to support (SPC-3 rev 21d, table 81 on page 145). As has been
discussed elsewhere, one should not necessary believe the
value a device puts in the version field (especially if
an LLD hacks it).

As for REQUEST SENSE, that was used before the days of auto
sense to retrieve the sense data when a CHECK CONDITION status
was reported by a command. Now auto sense is mandatory and
REQUEST SENSE almost fell out of use. Prior to auto-sense,
the mid level (or perhaps the LLD) build REQUEST SENSE cdbs
and in SCSI-2 then had to worry about the lun. The good
news is that the top 3 bits of byte 1 of the REQUEST SENSE
cdb are still reserved. Only an extremely pedantic SCSI
command interpreter would complain if they were set (IMO).

Aside: REQUEST SENSE has now made a comeback. It is used
to report the power condition of a device. It is also used
to convey a progress indication for long duration commands
like FORMAT UNIT that are executed with the IMMED bit set
(i.e. start the command then return a GOOD status). This
progress indication role used to be performed by TEST UNIT
READY (and still is in disks that I have tested).


Basically it's a moving target, albeit a very slow one :-)

Doug Gilbert


From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Tue, 14 Jan 2003 13:27:17 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030114132717.A25881@beaverton.ibm.com>
References: <OF358BAE57.18B0715E-ONC1256CAE.006B6533@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OF358BAE57.18B0715E-ONC1256CAE.006B6533@de.ibm.com>; from MPESCHKE@de.ibm.com on Tue, Jan 14, 2003 at 09:37:13PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: Luben Tuikov <luben@splentec.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Martin -

On Tue, Jan 14, 2003 at 09:37:13PM +0100, Martin Peschke3 wrote:
> > and has a 64 bit to 32 bit
> > converter (scsi 64 bit lun to linux sdev->lun, the sdev->lun is host byte
> > ordered)
> 
> What is the reasoning behind that? Why does it exchange bytes 0+1 and
> bytes 2+3?

I wanted the low two bytes to be the same as we would see for sequential
scans, so no adapter driver code had to change. As you noted, if someone
wanted to use the other two bytes, they would have to convert them. The
qlogicfc.c driver has this code to ensure big endian byte order:

	cmd->expanded_lun = cpu_to_le16(Cmnd->lun);

> > look at scsi_scan.c::scsilun_to_int. scsilun_to_int (it doesn't
> > handle the address method in the first two bits of the LUN, probably a
> bug
> > for some targets).
> 
> It is a bug, I think.

Yes, I'm not sure how to fix it other than to shove the address method in
there, and handle the "Extended logical unit addressing method" (11b)
address mode properly. Someone with affected hardware will have to patch
and test it.

> When sending SCSI commands, an FCP device expects me to provide exactly
> that 8 byte LUN that is reported by REPORT_LUNS. How is it possible
> for an HBA driver that needs a working 8 byte LUN to revert all these
> modifications done by scsilun_to_int?

> Ok, it would be easy to exchange bytes again. But it is impossible to
> recover from the loss of 4 bytes and the 2 most significant bits.
> The scsilun_to_int routine does not make sense to me.
> We have to go with the actual LUNs retrieved by means of
> the REPORT_LUNS command.

It's not possible for all cases, if the scsi_report_lun_scan function
finds a LUN value out of range it should output a warning.  This really
depends on the target device, and possibly the adapter. If the target only
uses the upper four bytes of the scsi lun (or the first and second levels
of the address), and the addressing mode is "Peripheral device addressing
method" (00b), you can convert that back to an 8 byte lun zero filling the
other four bytes.

> > I would rather the SCSI target ID be like an address rather than an
> > identifier (such as might be in a scsi_nexus), right now we have a
> > sdev->name that currently holds a device id.
> 
> How persistent is a SCSI ID expected to be?
> Do SCSI applications in a Linux 2.5 environment, e.g. your favourite
> burning
> software, depend on persistent SCSI ID's in order to address the right
> device?
> Or, are all issues related to persistency solved by the combination of
> sysfs
> and hotplug, especially when considering SCSI support?

(Assuming you mean what we put into sdev->name right now not a target ID.)

There was discussion about this last week or so, generally we aren't using
it now, and we can't rely on the ID, we need a white list, gregkh is
planning to work on sysfs hotplug device naming like support:

http://marc.theaimsgroup.com/?t=104189838600004&r=1&w=2

-- Patrick Mansfield

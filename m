From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Tue, 14 Jan 2003 21:37:13 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF358BAE57.18B0715E-ONC1256CAE.006B6533@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: Luben Tuikov <luben@splentec.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org


Patrick,

> The current 2.5 scsi code uses REPORT LUNS,

ok, I've been aware of that

> and has a 64 bit to 32 bit
> converter (scsi 64 bit lun to linux sdev->lun, the sdev->lun is host byte
> ordered)

What is the reasoning behind that? Why does it exchange bytes 0+1 and
bytes 2+3?

> look at scsi_scan.c::scsilun_to_int. scsilun_to_int (it doesn't
> handle the address method in the first two bits of the LUN, probably a
bug
> for some targets).

It is a bug, I think.
When sending SCSI commands, an FCP device expects me to provide exactly
that 8 byte LUN that is reported by REPORT_LUNS. How is it possible
for an HBA driver that needs a working 8 byte LUN to revert all these
modifications done by scsilun_to_int?
Ok, it would be easy to exchange bytes again. But it is impossible to
recover from the loss of 4 bytes and the 2 most significant bits.
The scsilun_to_int routine does not make sense to me.
We have to go with the actual LUNs retrieved by means of
the REPORT_LUNS command.

> > I think, the SCSI ID for FCP should also be 64 bit in size and
> > ought to be comprised of the World-Wide Port Name (WWPN) rather
> > than the more volatile 24 bit Destination ID (D_ID).
>
> I would rather the SCSI target ID be like an address rather than an
> identifier (such as might be in a scsi_nexus), right now we have a
> sdev->name that currently holds a device id.

How persistent is a SCSI ID expected to be?
Do SCSI applications in a Linux 2.5 environment, e.g. your favourite
burning
software, depend on persistent SCSI ID's in order to address the right
device?
Or, are all issues related to persistency solved by the combination of
sysfs
and hotplug, especially when considering SCSI support?

Thanks advance for your answers. They might be helpfull for me
when trying to solve the 32 bit vs. 64 bit issue in our HBA driver.


Martin Peschke


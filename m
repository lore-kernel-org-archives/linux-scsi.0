From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Tue, 14 Jan 2003 10:56:17 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030114105617.B24400@beaverton.ibm.com>
References: <OF17AF196C.AE6043CD-ONC1256CAE.00549A53@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OF17AF196C.AE6043CD-ONC1256CAE.00549A53@de.ibm.com>; from MPESCHKE@de.ibm.com on Tue, Jan 14, 2003 at 05:19:30PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: Luben Tuikov <luben@splentec.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Tue, Jan 14, 2003 at 05:19:30PM +0100, Martin Peschke3 wrote:
> 
> I've been pleading for 64 bit values, too.
> The FCP driver for zSeries I am maintaining for 2.4 uses a mapping
> between 64 bit and 32 bit values. This is ugly and I'd like to get
> rid of it in its 2.5 port if possible.
> 
> Such a change would raise an issue related to device discovery.
> A sparsely populated name space for SCSI ID and LUN makes SCSI
> device detection harder. For LUN, this should be fixed by the usage
> of REPORT_LUNS. Additionally, lldd's could specify the size or
> range of SCSI IDs and LUNs which apply to them in order to reduce
> discovery overhead.

Martin -

The current 2.5 scsi code uses REPORT LUNS, and has a 64 bit to 32 bit
converter (scsi 64 bit lun to linux sdev->lun, the sdev->lun is host byte
ordered), look at scsi_scan.c::scsilun_to_int. scsilun_to_int (it doesn't
handle the address method in the first two bits of the LUN, probably a bug
for some targets).

You can set the shost->max_id and shost->max_lun, and as an ugly hack set
them before the scsi scan occurrs (after scsi_register, before returning
from the detect or before calling the new for 2.5 scsi_add_host).

> I think, the SCSI ID for FCP should also be 64 bit in size and
> ought to be comprised of the World-Wide Port Name (WWPN) rather
> than the more volatile 24 bit Destination ID (D_ID).

I would rather the SCSI target ID be like an address rather than an
identifier (such as might be in a scsi_nexus), right now we have a
sdev->name that currently holds a device id.

-- Patrick Mansfield

From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Tue, 14 Jan 2003 12:17:55 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030114121755.A25535@beaverton.ibm.com>
References: <OF05415A5A.7D53015A-ONC1256CAE.00687CAC@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OF05415A5A.7D53015A-ONC1256CAE.00687CAC@de.ibm.com>; from MPESCHKE@de.ibm.com on Tue, Jan 14, 2003 at 09:01:36PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: Luben Tuikov <luben@splentec.com>, linux-scsi@vger.kernel.org

On Tue, Jan 14, 2003 at 09:01:36PM +0100, Martin Peschke3 wrote:
> 
> Patrick,
> 
> > With the current scsi code, going to a 64-bit lun means changing
> sdev->lun
> > and conditionally changing references to it to use a 64-bit struct
> > scsilun, or (mainly in the lldd) to call a conversion function if you
> must
> > use less than 64-bits.
> 
> Why would a conversion function be required?

Because a lot of conversions are done via truncation via int -> char
conversions done by the compiler, or explicit use of an int assuming that
it is a host ordered integer, and that won't work for a 64-bit scsilun.
You cannot pull one byte (at a fixed location) out of the 64-bit of the
scsilun, mainly AFAICT because of the addressing modes. Maybe we could
have a char *lun in scsi_device, and point to somewhere in the 64-bit lun,
but this would still require code changes.

> Have we a conversion function for our current 32 bit LUNS which is larger
> than required by our Parallel SCSI HBA drivers?

Not an explicit one, just what the C code does for us.

> What would chang for those drivers if we go to 64 bit LUNs?

So they would have to use a function or a pointer to lun, if that would
really work, but I prefer a function.

> >(Currently, no open source FCP adapters use an 8
> > byte lun to talk to the host adapter hardware, not even the qlogic
> > adapter.)
> 
> Here you are under a misapprehension
> http://www-124.ibm.com/developerworks/opensource/linux390
> /current2_4_19-may2002.shtml#kernel20021125

Sorry :)

> Using 8 byte LUNs for FCP is not a question of driver-to-HBA communication
> but is required by FCP.

Yes, so the driver-to-HBA interface does not have to be use 8 byte LUNs
(not that I agree with that approach), but FCP must use 8 bytes.

> ftp://ftp.t11.org/t10/drafts/fcp2/fcp2r07a.pdf
> An HBA dd has to put an 8 byte LUN into the control block used for
> SCSI command transfer (FCP_CMND IU), for example.
> I am wondering how those drivers make up an 8 byte LUN
> from a 32 bit LUN.

The qlogic uses a 2 byte lun for host -> adapter communication, even
though it sends an 8 byte lun to the target. For most targets, just using
the upper two bytes is OK, I don't know what they do for the different
scsi addressing modes.

PS: My (ibm's?) linux-scsi feed seems slow or dead (again).

-- Patrick Mansfield

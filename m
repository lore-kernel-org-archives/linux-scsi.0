From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Tue, 14 Jan 2003 14:16:00 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030114141600.A26321@beaverton.ibm.com>
References: <OF9F3B7202.124F5C84-ONC1256CAE.00739F33@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OF9F3B7202.124F5C84-ONC1256CAE.00739F33@de.ibm.com>; from MPESCHKE@de.ibm.com on Tue, Jan 14, 2003 at 10:29:16PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: Luben Tuikov <luben@splentec.com>, linux-scsi@vger.kernel.org

On Tue, Jan 14, 2003 at 10:29:16PM +0100, Martin Peschke3 wrote:
> 
> Patrick,
> 
> > Yes, so the driver-to-HBA interface does not have to be use 8 byte LUNs
> > (not that I agree with that approach), but FCP must use 8 bytes.
> 
> No. This is a contradiction in terms.
> Still, I can't see how to have a valid 8 byte LUN at hand for SCSI
> devices using 8 byte LUNs if we apply a lossy compression to LUNs
> in the SCSI stack.

As long as the truncated values are to be zero, it is not a problem.

> > The qlogic uses a 2 byte lun for host -> adapter communication, even
> > though it sends an 8 byte lun to the target. For most targets, just using
> > the upper two bytes is OK, I don't know what they do for the different
> > scsi addressing modes.
> 
> However this is done in detail, it is guessing in place of reliable
> addressing.
> 
> I would like to come to an agreement that the method of scsilun_to_int
> is wrong and that we have to care for 64 bit LUNs in the SCSI core,
> i.e. store LUNs as they are provided by the REPORT_LUNs response and
> passing them unchanged to HBA drivers.

I agree with that, I'm not planning on creating a patch for it. Someone
with the proper adapter and storage should probably work on a patch, and
there is currently (AFAIK!) only one open source driver that can handle an
8 byte lun :)
 
> The discussion about the implementation should be done after that as
> the second step.

I'd rather see a patch that has been tested with actual hardware.

Doug Gilbert has pointed out that we could have dual support for short
(current style) and long luns, and not bother fixing adapters that do not
or cannot support an 8 byte lun (all of SPI, and the current qlogic ones).

-- Patrick Mansfield

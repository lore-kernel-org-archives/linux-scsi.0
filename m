From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Tue, 14 Jan 2003 22:29:16 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF9F3B7202.124F5C84-ONC1256CAE.00739F33@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: Luben Tuikov <luben@splentec.com>, linux-scsi@vger.kernel.org


Patrick,

> Yes, so the driver-to-HBA interface does not have to be use 8 byte LUNs
> (not that I agree with that approach), but FCP must use 8 bytes.

No. This is a contradiction in terms.
Still, I can't see how to have a valid 8 byte LUN at hand for SCSI
devices using 8 byte LUNs if we apply a lossy compression to LUNs
in the SCSI stack.

> The qlogic uses a 2 byte lun for host -> adapter communication, even
> though it sends an 8 byte lun to the target. For most targets, just using
> the upper two bytes is OK, I don't know what they do for the different
> scsi addressing modes.

However this is done in detail, it is guessing in place of reliable
addressing.

I would like to come to an agreement that the method of scsilun_to_int
is wrong and that we have to care for 64 bit LUNs in the SCSI core,
i.e. store LUNs as they are provided by the REPORT_LUNs response and
passing them unchanged to HBA drivers.

The discussion about the implementation should be done after that as
the second step.


Martin Peschke


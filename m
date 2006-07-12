From: Eric Moore <eric.moore@lsil.com>
Subject: RE: [PATCH 1/10] mptfusion : Transport Layer Retry support
Date: Wed, 12 Jul 2006 09:15:10 -0600
Message-ID: <20060712151510.GA9900@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:36284 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751416AbWGLP2Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jul 2006 11:28:16 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, dougg@torque.net

-- Tuesday, July 11, 2006 7:21 PM, Douglas Gilbert wrote:

> 
> Eric Moore wrote:
> > Transport Layer Retry support for SAS Tapes.
> > Detects whether firmware supports TLR, then
> > issues special scsi opcode to enable TLR in
> > the end device.
> 
> Eric,
> The "protocol specific logical unit mode page for SAS
> SSP - short format" has a 'transport layer retries'
> bit. I thought that SAS tape drives would implement
> that mode page (0x18,0x0) and allow that bit to be
> changeable.
> 
> The "special scsi opcode to enable TLR" seems to imply
> another technique.
> 


Yes.  The direction we got from HP was do issue this oem
specific opcode.  The original plan was the reading
and writing mode pages, but for some reason they encountered
issues. Here is the email with the direction from HP:

Email follows:

---

Due to numerous technical issues with the original plan to enable TLR via host drivers, HP has changed direction and implemented a vendor-unique command to do the enable.  This command completes immediately (not blocked waiting for the drive to become ready) and does not clear unit attentions.  Here's the whole description again, modified for this new vendor unique command (changes in Red):

* * * * *
Steps to turn on TLR for HP tape drives:

For SAS devices only:

1) Check IOCFacts->IOCCapabilities for F/W support of TLR (bit 11 set).
	(#define MPI_IOCFACTS_CAPABILITY_TLR  (0x800))
    NOTE: This bit is available only in 07.09 or later F/W.

2) Snoop completed Inquiry commands to detect an HP SAS tape drive (returned Inquiry data):
    - Check flag (see below) to see if TLR enabling has already been done on this device.  If not,
	- Inquiry vendor field = "HP      "  (HP + 6 spacess)
	- Byte 0 (peripheral device type and qualifier) = 0x01 (Sequential access device)
    NOTE: Tape drives can have multiple LUNs, and the "sequential access device" LUN may not be LUN 0.

If HP SAS tape drive and flag not already set:

3) Note target ID and LUN

4) Issue an HP vendor-unique command to this target ID/LUN:
	- CDB = 0xC2, 0x01, 0x00, 0x00, 0x00, 0x00 (the 0x01 is enabling TLR)
	- Data buffer will be 0 bytes in length (no data transfer)
	- If command doesn't complete successfully, retry only 1 time
	- In the Windows driver, if TLR enabling fails an error is logged to the Event Log

5) A successful completion of the vendor-unique command indicates that TLR is enabled
    - No further commands or checking is necessary.

Despite any failures or success, always set a flag associated with the target that TLR enabling has been done.
This is needed so the host driver will do the above actions only once (during initial bus scan, or rescan after
a SAS tape drive is powered on or added).

When a SAS tape drive is removed from the SAS domain (SAS device removal event) clear the TLR enable flag.

From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Good SAS adapters for 6 Gb/s SATA SSD's (with TRIM)?
Date: Thu, 11 Aug 2011 15:59:32 -0400
Message-ID: <4E4434A4.7010808@interlog.com>
References: <4E43F2C3.9000808@computerix.info>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56054 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495Ab1HKT7l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2011 15:59:41 -0400
In-Reply-To: <4E43F2C3.9000808@computerix.info>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prof. Dr. Klaus Kusche" <klaus.kusche@computerix.info>
Cc: linux-scsi@vger.kernel.org

On 11-08-11 11:18 AM, Prof. Dr. Klaus Kusche wrote:
> I'm looking for ways to hook up fast 6 Gb/s SATA SSD's (non-RAID!)
> to (server or i-X58) mainboards which do not have native 6 Gb/s SATA.
>
>  From the reviews I've read so far, two things became obvious:
> * The SSD's I'm looking at really want a working SATA TRIM command.
> * All the onboard Marvell 88SE9128 (or ASmedia) solutions
> seriuosly lack performance, as do PCIe cards based on those chips.
>
> So basically, there seem to be two choices:
> 1.) LSI 2008
> 2.) Marvell 9485
>
> 1.) seems to be fast, reliable and well-supported,
> but as far as I can tell, it doesn't support TRIM at all:
> It neither maps SCSI unmap to SATA TRIM,
> nor accepts TRIM as a SATA passthrough command.
>
> Is that true?

What counts in Linux for "trim" support on a SSD (SATA,
SAS or FC) is correctly processing the SCSI WRITE SAME (16)
with the UNMAP bit set. In the case of a SATA SSD, a SCSI
to ATA Translation Layer (SATL) should map that SCSI WRITE
SAME (16) with the UNMAP bit set to the ATA DATA SET
MANAGEMENT command with the TRIM attribute set.

Many Linux SATA low level drivers use libata which
implements the above mapping. However some SAS HBAs
(e.g. LSI MPT Fusion 3 and 6 Gbps) implement the SATL
in their own HBA firmware.

I tested a LSI SAS 9212-4i4e HBA running its most recent
firmware (9.0 from Feb 26, 2011) with a Intel SSDSA2M080
which does support trim. I used my ddpt utility and the
SCSI WRITE SAME (16) with the UNMAP bit set was rejected
as an "illegal request". With the UNMAP bit clear it
accepted the command. I also checked the SCSI UNMAP
command and it was also rejected.

LSI have some more work to do on their firmware.

Doug Gilbert


> I didn't find much about 2.)
> * The only cards based on this chip are the HighPoint 27xx,
> or did I miss something?
> * Running a 27xx with the mvsas driver was reported to have stability
> problems or random errors. Are these problems solved?
> * Is the 27xx fast (with SATA SSD's & mvsas driver),
> i.e. significantly faster than onboard SATA 3 Gb/s ports?
> * Does the 27xx+mvsas support TRIM when connected to SATA drives?
>
> Are there any other solutions?

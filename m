From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Good SAS adapters for 6 Gb/s SATA SSD's (with TRIM)?
Date: Thu, 11 Aug 2011 23:19:13 -0400
Message-ID: <4E449BB1.3060300@interlog.com>
References: <4E43F2C3.9000808@computerix.info> <4E4434A4.7010808@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:47019 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab1HLDTW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2011 23:19:22 -0400
In-Reply-To: <4E4434A4.7010808@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prof. Dr. Klaus Kusche" <klaus.kusche@computerix.info>
Cc: linux-scsi@vger.kernel.org

On 11-08-11 03:59 PM, Douglas Gilbert wrote:
> On 11-08-11 11:18 AM, Prof. Dr. Klaus Kusche wrote:
>> I'm looking for ways to hook up fast 6 Gb/s SATA SSD's (non-RAID!)
>> to (server or i-X58) mainboards which do not have native 6 Gb/s SATA.
>>
>> From the reviews I've read so far, two things became obvious:
>> * The SSD's I'm looking at really want a working SATA TRIM command.
>> * All the onboard Marvell 88SE9128 (or ASmedia) solutions
>> seriuosly lack performance, as do PCIe cards based on those chips.
>>
>> So basically, there seem to be two choices:
>> 1.) LSI 2008
>> 2.) Marvell 9485
>>
>> 1.) seems to be fast, reliable and well-supported,
>> but as far as I can tell, it doesn't support TRIM at all:
>> It neither maps SCSI unmap to SATA TRIM,
>> nor accepts TRIM as a SATA passthrough command.
>>
>> Is that true?
>
> What counts in Linux for "trim" support on a SSD (SATA,
> SAS or FC) is correctly processing the SCSI WRITE SAME (16)
> with the UNMAP bit set. In the case of a SATA SSD, a SCSI
> to ATA Translation Layer (SATL) should map that SCSI WRITE
> SAME (16) with the UNMAP bit set to the ATA DATA SET
> MANAGEMENT command with the TRIM attribute set.
>
> Many Linux SATA low level drivers use libata which
> implements the above mapping. However some SAS HBAs
> (e.g. LSI MPT Fusion 3 and 6 Gbps) implement the SATL
> in their own HBA firmware.
>
> I tested a LSI SAS 9212-4i4e HBA running its most recent
> firmware (9.0 from Feb 26, 2011) with a Intel SSDSA2M080
> which does support trim. I used my ddpt utility and the
> SCSI WRITE SAME (16) with the UNMAP bit set was rejected
> as an "illegal request". With the UNMAP bit clear it
> accepted the command. I also checked the SCSI UNMAP
> command and it was also rejected.
>
> LSI have some more work to do on their firmware.

I did check the LSI support page for my HBA just before sending
my original reply. And the version 9 firmware was showing at the
top of the list. Alas, that page had been alpha sorted on the
file names so that version 10 of the firmware (May 2011) was
hiding further down the page :-)

So I installed the newest firmware and redid the above tests.
Now the SCSI WRITE SAME (16) with the UNMAP bit set works on
that SSD. The SCSI UNMAP command was rejected and I did not
test sending the ATA DATA SET MANAGEMENT command through
the pass-through (but I expect that would work).

So Linux file systems will be able "discard" (="unmap"(SCSI);
="trim"(ATA)) data using LSI HBAs based the LSI 2008 chip
which are running recent firmware.

Doug Gilbert

>> I didn't find much about 2.)
>> * The only cards based on this chip are the HighPoint 27xx,
>> or did I miss something?
>> * Running a 27xx with the mvsas driver was reported to have stability
>> problems or random errors. Are these problems solved?
>> * Is the 27xx fast (with SATA SSD's & mvsas driver),
>> i.e. significantly faster than onboard SATA 3 Gb/s ports?
>> * Does the 27xx+mvsas support TRIM when connected to SATA drives?
>>
>> Are there any other solutions?


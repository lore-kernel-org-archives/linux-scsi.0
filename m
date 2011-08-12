From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Good SAS adapters for 6 Gb/s SATA SSD's (with TRIM)?
Date: Fri, 12 Aug 2011 09:42:31 -0400
Message-ID: <4E452DC7.7060004@interlog.com>
References: <4E43F2C3.9000808@computerix.info> <4E4434A4.7010808@interlog.com> <4E449BB1.3060300@interlog.com> <4E44D348.30003@stud.tu-ilmenau.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:44058 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab1HLNmj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2011 09:42:39 -0400
In-Reply-To: <4E44D348.30003@stud.tu-ilmenau.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stefan.huebner@stud.tu-ilmenau.de
Cc: "Prof. Dr. Klaus Kusche" <klaus.kusche@computerix.info>, linux-scsi@vger.kernel.org

Stefan,
My test was done with IT firmware.

Actually I switched from IR (initiator raid?) to IT
(initiator target) firmware in the process of upgrading
from 9 to 10. [Wouldn't it be great if someone would
hookup these controllers in target mode to the Linux
kernel's new target infrastructure.]

As far as I have seen, most LSI SAS HBAs come with IR
firmware on them. Switching IR to IT firmware with
their sas2flash tool is a bit of a pain. First sas2flash
didn't work on a AMD 64 bit platform (DOS to the rescue),
then it refuses to load IT over IR firmware. The latter
problem is solved by clearing the flash ("-o -e 6" was
the magic for the clear (in the past when I did
"-o -e 7" I had to program the controller's SAS address
back in by hand)).

Doug Gilbert


On 11-08-12 03:16 AM, Stefan /*St0fF*/ H=FCbner wrote:
> Douglas,
>
> have you double-checked to use the IT (Initiator Mode) Firmware from
> LSI?  I mean we build up systems based on the X8SI6-F mainboard from
> Supermicro which has a LSI SAS2008 with 8 Lanes on-board.  If using
> HW-RAID (Modes 0, 1, 1E, ...) on those, we have to flash the "IR"
> firmware.  If using the chip as HBA for Linux software RAID, we flash
> the "IT" firmware, and if the customer needs HW-RAID5-Support, they g=
et
> an extra chip onto the board and we have to flash "iMR" firmware...
>
> So you have 3 different firmware versions.  IT would be the way to go
> here...
>
> Greets,
> Stefan
>
> Am 12.08.2011 05:19, schrieb Douglas Gilbert:
>> On 11-08-11 03:59 PM, Douglas Gilbert wrote:
>>> On 11-08-11 11:18 AM, Prof. Dr. Klaus Kusche wrote:
>>>> I'm looking for ways to hook up fast 6 Gb/s SATA SSD's (non-RAID!)
>>>> to (server or i-X58) mainboards which do not have native 6 Gb/s SA=
TA.
>>>>
>>>>  From the reviews I've read so far, two things became obvious:
>>>> * The SSD's I'm looking at really want a working SATA TRIM command=
=2E
>>>> * All the onboard Marvell 88SE9128 (or ASmedia) solutions
>>>> seriuosly lack performance, as do PCIe cards based on those chips.
>>>>
>>>> So basically, there seem to be two choices:
>>>> 1.) LSI 2008
>>>> 2.) Marvell 9485
>>>>
>>>> 1.) seems to be fast, reliable and well-supported,
>>>> but as far as I can tell, it doesn't support TRIM at all:
>>>> It neither maps SCSI unmap to SATA TRIM,
>>>> nor accepts TRIM as a SATA passthrough command.
>>>>
>>>> Is that true?
>>>
>>> What counts in Linux for "trim" support on a SSD (SATA,
>>> SAS or FC) is correctly processing the SCSI WRITE SAME (16)
>>> with the UNMAP bit set. In the case of a SATA SSD, a SCSI
>>> to ATA Translation Layer (SATL) should map that SCSI WRITE
>>> SAME (16) with the UNMAP bit set to the ATA DATA SET
>>> MANAGEMENT command with the TRIM attribute set.
>>>
>>> Many Linux SATA low level drivers use libata which
>>> implements the above mapping. However some SAS HBAs
>>> (e.g. LSI MPT Fusion 3 and 6 Gbps) implement the SATL
>>> in their own HBA firmware.
>>>
>>> I tested a LSI SAS 9212-4i4e HBA running its most recent
>>> firmware (9.0 from Feb 26, 2011) with a Intel SSDSA2M080
>>> which does support trim. I used my ddpt utility and the
>>> SCSI WRITE SAME (16) with the UNMAP bit set was rejected
>>> as an "illegal request". With the UNMAP bit clear it
>>> accepted the command. I also checked the SCSI UNMAP
>>> command and it was also rejected.
>>>
>>> LSI have some more work to do on their firmware.
>>
>> I did check the LSI support page for my HBA just before sending
>> my original reply. And the version 9 firmware was showing at the
>> top of the list. Alas, that page had been alpha sorted on the
>> file names so that version 10 of the firmware (May 2011) was
>> hiding further down the page :-)
>>
>> So I installed the newest firmware and redid the above tests.
>> Now the SCSI WRITE SAME (16) with the UNMAP bit set works on
>> that SSD. The SCSI UNMAP command was rejected and I did not
>> test sending the ATA DATA SET MANAGEMENT command through
>> the pass-through (but I expect that would work).
>>
>> So Linux file systems will be able "discard" (=3D"unmap"(SCSI);
>> =3D"trim"(ATA)) data using LSI HBAs based the LSI 2008 chip
>> which are running recent firmware.
>>
>> Doug Gilbert
>>
>>>> I didn't find much about 2.)
>>>> * The only cards based on this chip are the HighPoint 27xx,
>>>> or did I miss something?
>>>> * Running a 27xx with the mvsas driver was reported to have stabil=
ity
>>>> problems or random errors. Are these problems solved?
>>>> * Is the 27xx fast (with SATA SSD's&  mvsas driver),
>>>> i.e. significantly faster than onboard SATA 3 Gb/s ports?
>>>> * Does the 27xx+mvsas support TRIM when connected to SATA drives?
>>>>
>>>> Are there any other solutions?
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

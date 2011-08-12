From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: Good SAS adapters for 6 Gb/s SATA SSD's (with TRIM)?
Date: Fri, 12 Aug 2011 10:01:40 +0100
Message-ID: <4E44EBF4.8050801@gmail.com>
References: <4E43F2C3.9000808@computerix.info> <4E4434A4.7010808@interlog.com> <4E449BB1.3060300@interlog.com> <4E44DE8E.3070809@computerix.info> <4E44E13B.2050503@gmail.com> <4E44E8E5.4040707@computerix.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50476 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1HLJBq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2011 05:01:46 -0400
Received: by qyk38 with SMTP id 38so211690qyk.19
        for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2011 02:01:45 -0700 (PDT)
In-Reply-To: <4E44E8E5.4040707@computerix.info>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prof. Dr. Klaus Kusche" <klaus.kusche@computerix.info>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, Mark Lord <mlord@pobox.com>

On 08/12/2011 09:48 AM, Prof. Dr. Klaus Kusche wrote:
> On 2011-08-12 10:15, Ric Wheeler wrote:
>> On 08/12/2011 09:04 AM, Prof. Dr. Klaus Kusche wrote:
>>> On 2011-08-12 05:19, Douglas Gilbert wrote:
>>>> On 11-08-11 03:59 PM, Douglas Gilbert wrote:
>>>>> On 11-08-11 11:18 AM, Prof. Dr. Klaus Kusche wrote:
>>>>>> I'm looking for ways to hook up fast 6 Gb/s SATA SSD's (non-RAID!)
>>>>>> to (server or i-X58) mainboards which do not have native 6 Gb/s SATA.
>>>>>>
>>>>>> From the reviews I've read so far, two things became obvious:
>>>>>> * The SSD's I'm looking at really want a working SATA TRIM command.
>>>>>> * All the onboard Marvell 88SE9128 (or ASmedia) solutions
>>>>>> seriuosly lack performance, as do PCIe cards based on those chips.
>>>>>>
>>>>>> So basically, there seem to be two choices:
>>>>>> 1.) LSI 2008
>>>>>> 2.) Marvell 9485
>>>>>>
>>>>>> 1.) seems to be fast, reliable and well-supported,
>>>>>> but as far as I can tell, it doesn't support TRIM at all:
>>>>>> It neither maps SCSI unmap to SATA TRIM,
>>>>>> nor accepts TRIM as a SATA passthrough command.
>>>>>>
>>>>>> Is that true?
>>>>>
>>>>> What counts in Linux for "trim" support on a SSD (SATA,
>>>>> SAS or FC) is correctly processing the SCSI WRITE SAME (16)
>>>>> with the UNMAP bit set. In the case of a SATA SSD, a SCSI
>>>>> to ATA Translation Layer (SATL) should map that SCSI WRITE
>>>>> SAME (16) with the UNMAP bit set to the ATA DATA SET
>>>>> MANAGEMENT command with the TRIM attribute set.
>>>>>
>>>>> Many Linux SATA low level drivers use libata which
>>>>> implements the above mapping. However some SAS HBAs
>>>>> (e.g. LSI MPT Fusion 3 and 6 Gbps) implement the SATL
>>>>> in their own HBA firmware.
>>>>>
>>>>> I tested a LSI SAS 9212-4i4e HBA running its most recent
>>>>> firmware (9.0 from Feb 26, 2011) with a Intel SSDSA2M080
>>>>> which does support trim. I used my ddpt utility and the
>>>>> SCSI WRITE SAME (16) with the UNMAP bit set was rejected
>>>>> as an "illegal request". With the UNMAP bit clear it
>>>>> accepted the command. I also checked the SCSI UNMAP
>>>>> command and it was also rejected.
>>>>>
>>>>> LSI have some more work to do on their firmware.
>>>>
>>>> I did check the LSI support page for my HBA just before sending
>>>> my original reply. And the version 9 firmware was showing at the
>>>> top of the list. Alas, that page had been alpha sorted on the
>>>> file names so that version 10 of the firmware (May 2011) was
>>>> hiding further down the page :-)
>>>>
>>>> So I installed the newest firmware and redid the above tests.
>>>> Now the SCSI WRITE SAME (16) with the UNMAP bit set works on
>>>> that SSD. The SCSI UNMAP command was rejected and I did not
>>>> test sending the ATA DATA SET MANAGEMENT command through
>>>> the pass-through (but I expect that would work).
>>>>
>>>> So Linux file systems will be able "discard" (="unmap"(SCSI);
>>>> ="trim"(ATA)) data using LSI HBAs based the LSI 2008 chip
>>>> which are running recent firmware.
>>>
>>> Was that with the RAID or the non-RAID firmware?
>>>
>>> I've asked LSI sales/support about UNMAP/TRIM being supported.
>>> They've opened a case, but I got zero response up to now.
>>> So it doesn't seem to be on the official feature list,
>>> and it seems to be unknown at least in the Munich LSI office.
>>>
>>> Am I correct that this would support online trimming (mount discard),
>>> but not batch trimming with wiper.sh or similar tools/scripts,
>>> because they issue TRIM or UNMAP directly, not WRITE SAME UNMAP?
>>> (what's the SCSI equivalent to the wiper.sh script?)
>>>
>>> Nobody having any info's about Marvell / mvsas?
>>>
>>> Klaus.
>>>
>>
>> Discard issues the same SCSI command regardless of the online versus
>> batch operation. If one works, the other should work as well.
>
> I don't think so. wiper.sh/hdparm issue an ATA DSM TRIM as a
> passthrough command in believe, not a WRITE SAME UNMAP.
> And I've seen scripts doing the same as wiper.sh for SCSI
> by calling the sg_unmap utility, which results in UNMAP,
> not WRITE SAME UNMAP.
>
> Klaus.
>

wiper.sh is not the tool I was talking about, that came from Mark Lord and you 
are right, it is ATA specific.  Not sure if Mark can/wants to make it more 
generic, but that might be worth doing.

Lukas has a more generic bulk tool that should do the job and has the advantage 
that it does not have to fill the file system first (it can lock regions and do 
its work).

Note that discard is not just for physical devices like SCSI or ATA, it is also 
useful for "software" stacks like various device mapper targets, virtual block 
devices, etc so we should be keeping the abstraction at a high level for our 
tooling.

Ric


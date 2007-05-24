From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: Re: SMART support for SATA drives in SAS enclosures
Date: Thu, 24 May 2007 13:17:03 +0200
Message-ID: <4655742F.8010202@macroscoop.nl>
References: <46488711.9020903@macroscoop.nl> <46549AC3.4090105@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mondriaan.macroscoop.nl ([82.94.9.2]:3948 "EHLO
	mondriaan.macroscoop.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519AbXEXLRN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 May 2007 07:17:13 -0400
In-Reply-To: <46549AC3.4090105@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Doug,

/dev/sdc is indeed a physical SATA disk.
sg_sat_identify says: "ATA PASS-THROUGH (16) not supported"

I'll look into a firmware update.

Thanks,
Pim



Douglas Gilbert wrote:
> Pim Zandbergen wrote:
>   
>> Is SMART support available for SATA drives in SAS enclosures?
>>
>> I'm testing this setup
>>
>> LSI Logic SAS3800X PCI-X SAS controller (mptsas driver)
>> Promise V-Trak J300S SAS/SATA enclosure/expander
>> 12x Seagate ST3500630NS
>> Linux kernel 2.6.21.1 x86_64
>> smartmontools-5.37-1.1.fc6 from Fedora Core 6
>>
>> "smartctl -i -d sat /dev/sdc" gives me
>>
>> Smartctl: Device Read Identity Failed
>>     
>
> I presume /dev/sdc is an actual disk rather than a
> RAID device made up of several disks. The SAT standard
> (and smartmontools) don't have a general way of
> addressing individual disks behind RAID infrastructure.
>
> For recent versions of smartmontools version 5.37 and
> MPT Fusion SAS HBAs this should work if /dev/sdc is
> a SATA disk. Your HBA may need a firmware upgrade.
>
>
> You might fetch sg3_utils version 1.24 and try:
>   sg_sat_identify /dev/sdc
> That needs to work before smartctl has a hope.
>
>   
>> Same with "-d ata".
>>
>> If I treat the disk as SCSI ("-d scsi"), the command
>> will not fail, but wil only retrieve the serial number.
>>     
>
> With MPT Fusion SAS hardware (that I have seen) the SAT
> layer is in the HBA firmware. Only later versions of the
> firmware support the SCSI ATA PASS-THROUGH command.
>
> Doug Gilbert
>
>   


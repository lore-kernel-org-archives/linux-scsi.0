From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: mptsas, msi and the dl585 g2
Date: Thu, 09 Jul 2009 12:48:32 -0700
Message-ID: <4A564990.3060202@kernel.org>
References: <20090630180300.GA9971@ldl.fc.hp.com> <4A4A5B01.9040200@kernel.org> <20090703225708.GA30664@ldl.fc.hp.com> <4A4FADDC.30606@kernel.org> <20090709185945.GG2613@ldl.fc.hp.com> <4A564263.5010305@kernel.org> <4A564634.1020708@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:48955 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbZGITsy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jul 2009 15:48:54 -0400
In-Reply-To: <4A564634.1020708@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dann frazier <dannf@hp.com>
Cc: linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Yinghai Lu wrote:
> Yinghai Lu wrote:
>> dann frazier wrote:
>>>   --------------------------------------------------------------------
>>>   commit 30a18d6c3f1e774de656ebd8ff219d53e2ba4029
>>>   Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
>>>   Date:   Tue Feb 19 03:21:20 2008 -0800
>>>
>>>       x86: multi pci root bus with different io resource range, on
>>>       64-bit
>>>   --------------------------------------------------------------------
>>>
>>> This appears to be the commit that actually introduced the issue.
>>> I've attached dmesg w/ PCI DEBUG enabled from both sides of this
>>> changeset, as well as a diff w/o printk timestamps.
>>>
>>> Also note that #ifdef'ing out x86_pci_root_bus_res_quirks() in
>>> amd_bus.c seems to avoid the problem as well.
>> your BIOS didn't allocate io resources to some device under HT chain on node1/link2
>> aka under peer root bus.
>>
>> Kernel try to allocate resource to them.
>>
>> and the patch did right thing according to range 
>> bus: 40 index 1 mmio: [d9f00000, dfefffff]
>>
>> YH
>>
>>
>> +bus: [00,3f] on node 0 link 1
>> +bus: 00 index 0 io port: [0, 2fff]
>> +bus: 00 index 1 mmio: [80000000, d9efffff]
>> +bus: 00 index 2 mmio: [dff00000, e3ffffff]
>> +bus: 00 index 3 mmio: [a0000, bffff]
>> +bus: 00 index 4 mmio: [e8000000, ffffffff]
>> +bus: 00 index 5 mmio: [480000000, fbffffffff]
>> +bus: [40,7f] on node 1 link 2
>> +bus: 40 index 0 io port: [3000, ffff]
>> +bus: 40 index 1 mmio: [d9f00000, dfefffff]
>> +bus: 40 index 2 mmio: [e4000000, e7ffffff]
>>  ACPI: bus type pci registered
>>  PCI: Using configuration type 1 for base access
>>  ACPI: EC: Look up EC in DSDT
>> @@ -646,18 +659,18 @@
>>    IO window: disabled.
>>    MEM window: disabled.
>>    PREFETCH window: disabled.
>> -  got res [88000000:8801ffff] bus [88000000:8801ffff] flags 27200 for BAR 6 of 0000:41:01.0
>> -  got res [88020000:8803ffff] bus [88020000:8803ffff] flags 27200 for BAR 6 of 0000:41:02.0
>> +  got res [d9f00000:d9f1ffff] bus [d9f00000:d9f1ffff] flags 27200 for BAR 6 of 0000:41:01.0
>> +  got res [d9f20000:d9f3ffff] bus [d9f20000:d9f3ffff] flags 27200 for BAR 6 of 0000:41:02.0
>>  PCI: Bridge: 0000:40:10.0
>>    IO window: disabled.
>>    MEM window: 0xda000000-0xddffffff
>> -  PREFETCH window: 0x0000000088000000-0x00000000880fffff
>> -  got res [88200000:883fffff] bus [88200000:883fffff] flags 27200 for BAR 6 of 0000:42:01.0
>> -  got res [88100000:8813ffff] bus [88100000:8813ffff] flags 27200 for BAR 6 of 0000:42:02.0
>> +  PREFETCH window: 0x00000000d9f00000-0x00000000d9ffffff
>> +  got res [de000000:de1fffff] bus [de000000:de1fffff] flags 27200 for BAR 6 of 0000:42:01.0
>> +  got res [de200000:de23ffff] bus [de200000:de23ffff] flags 27200 for BAR 6 of 0000:42:02.0
>>  PCI: Bridge: 0000:40:11.0
>>    IO window: 3000-3fff
>>    MEM window: 0xdfe00000-0xdfefffff
>> -  PREFETCH window: 0x0000000088100000-0x00000000883fffff
>> +  PREFETCH window: 0x00000000de000000-0x00000000de2fffff
>>
>>
> 
> 
> and those range are not overlapping with IOAPIC BAR allocating
> [    0.000000] ACPI: IOAPIC (id[0x08] address[0xd9cf0000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 8, version 0, address 0xd9cf0000, GSI 0-23
> [    0.000000] ACPI: IOAPIC (id[0x09] address[0xd9fd0000] gsi_base[24])
> [    0.000000] IOAPIC[1]: apic_id 9, version 0, address 0xd9fd0000, GSI 24-30
> [    0.000000] ACPI: IOAPIC (id[0x0a] address[0xd9fe0000] gsi_base[31])
> [    0.000000] IOAPIC[2]: apic_id 10, version 0, address 0xd9fe0000, GSI 31-37
> [    0.000000] ACPI: IOAPIC (id[0x0b] address[0xd9ff0000] gsi_base[38])
> [    0.000000] IOAPIC[3]: apic_id 11, version 0, address 0xd9ff0000, GSI 38-61
> 

with the new allocation:
[    4.279139]   got res [d9f00000:d9f1ffff] bus [d9f00000:d9f1ffff] flags 27200 for BAR 6 of 0000:41:01.0
[    4.279142]   got res [d9f20000:d9f3ffff] bus [d9f20000:d9f3ffff] flags 27200 for BAR 6 of 0000:41:02.0
[    4.279144] PCI: Bridge: 0000:40:10.0
[    4.299135]   IO window: disabled.
[    4.319148]   MEM window: 0xda000000-0xddffffff
[    4.333140]   PREFETCH window: 0x00000000d9f00000-0x00000000d9ffffff
[    4.370170]   got res [de000000:de1fffff] bus [de000000:de1fffff] flags 27200 for BAR 6 of 0000:42:01.0
[    4.370173]   got res [de200000:de23ffff] bus [de200000:de23ffff] flags 27200 for BAR 6 of 0000:42:02.0
[    4.370175] PCI: Bridge: 0000:40:11.0
[    4.390143]   IO window: 3000-3fff
[    4.410177]   MEM window: 0xdfe00000-0xdfefffff
[    4.435157]   PREFETCH window: 0x00000000de000000-0x00000000de2fffff


[    4.333140]   PREFETCH window: 0x00000000d9f00000-0x00000000d9ffffff
are all directed to one 8132 PCI-X bridge.

the the IOAPIC for 9, 10, 11... falling that range...

we need one better to allocate range for that pci-x bridge to aovide ioapic BAR allocated...

anyway your BIOS sucks.

YH



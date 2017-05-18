From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 09/22] scsi: hisi_sas: retrieve SAS address for pci-based
 controller
Date: Thu, 18 May 2017 10:09:02 +0100
Message-ID: <10ad7e70-b0c4-8ee6-c5e8-74ee6511f171@huawei.com>
References: <1495018197-120535-1-git-send-email-john.garry@huawei.com>
 <1495018197-120535-10-git-send-email-john.garry@huawei.com>
 <CAK8P3a0RxVq6Y0OpQWikDKBSvu0z42TCAEVRmrFD0CJwmh3SXw@mail.gmail.com>
 <e01dac0a-69a9-b625-76c1-f30fe5663890@huawei.com>
 <CAK8P3a0bo7L07X18_0e2vswLmCb+cu4CrzSoGKb0jk-yrKxTbQ@mail.gmail.com>
 <dd20a241-b137-6779-63c9-6b881fc393c7@huawei.com>
 <CAK8P3a0obfJYviU4kZ+KtfbrEpjOaJJazJQbV0_xJ24+YYMD_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a0obfJYviU4kZ+KtfbrEpjOaJJazJQbV0_xJ24+YYMD_A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry2@mail.dcu.ie>, linuxarm@huawei.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>> Hi Arnd,
>>
>> Currently there is no pci device listed in the ACPI tables.
>>
>> What I am doing is declaring a fake device in the root of the System bus
>> tree of the ACPI tables, and in the kernel driver finding it by matching the
>> name. It is not the ACPI companion for the pci device.
>>
>> So I think that we can define the pci device under the pci bus in the ACPI
>> tables, and define the ADR and DSD. Then we would have an ACPI companion for
>> the device, and from that get the SAS address.
>
> Yes, that would be much better, and allow us to use the device properties
> interface directly. An additional advantage is that the property definition
> can be exactly the same as for the v1/v2 platform_device properties
> for anything that might be needed across all versions.  sas-addr already
> fits in there, and there might be additional properties you need in the
> future.
>

Hi Arnd,

OK, we'll try this.

As for other properties, phy and queue count are common to all versions.

However, I need to consider more if I should add these - maybe it is ok. 
The reason we did not hardcode these for v1/v2 was that these were 
variable for controllers inter and intra SoC.

hip08 only has 1 controller, and I have been told that each controller 
will have a unique pci device id that for future SoCs, so it's viable to 
hardcode.

>> An alternative to this ACPI device method is for UEFI to write the SAS
>> address to a defined free location in device's pci config space, which the
>> driver can read.
>
> That sounds ok as well, it would be nice to not rely on firmware data here,
> but I'd have to see how the implementation ends up: IIRC you should
> not just put the data at a fixed location in the config space but instead use
> the 'extended capabilities' infrastructure to find the data.
> PCI_EXT_CAP_ID_VNDR might be the right one here, but I don't
> know enough about this, so please consult with someone who does
> (or the PCIe specification).
>

Right, we'll keep ACPI table description as plan A.

>       Arnd
>

Much appreciated,
John

> .
>

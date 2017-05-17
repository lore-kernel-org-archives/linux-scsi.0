From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 09/22] scsi: hisi_sas: retrieve SAS address for pci-based
 controller
Date: Wed, 17 May 2017 17:45:05 +0100
Message-ID: <dd20a241-b137-6779-63c9-6b881fc393c7@huawei.com>
References: <1495018197-120535-1-git-send-email-john.garry@huawei.com>
 <1495018197-120535-10-git-send-email-john.garry@huawei.com>
 <CAK8P3a0RxVq6Y0OpQWikDKBSvu0z42TCAEVRmrFD0CJwmh3SXw@mail.gmail.com>
 <e01dac0a-69a9-b625-76c1-f30fe5663890@huawei.com>
 <CAK8P3a0bo7L07X18_0e2vswLmCb+cu4CrzSoGKb0jk-yrKxTbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a0bo7L07X18_0e2vswLmCb+cu4CrzSoGKb0jk-yrKxTbQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry2@mail.dcu.ie>, linuxarm@huawei.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 17/05/2017 15:13, Arnd Bergmann wrote:
> On Wed, May 17, 2017 at 3:37 PM, John Garry <john.garry@huawei.com> wrote:
>> On 17/05/2017 13:37, Arnd Bergmann wrote:
>
>>> Since this uses the _DSD information that was introduced for compatibility
>>> between device tree and ACPI based data, why not write the code so that
>>> it can work for both?
>>>
>>> Ideally this should just look up the property for pci_dev->fwnode, but I'm
>>> not entirely sure if this works the same way on ACPI and DT today.
>>>
>>
>> Hi Arnd,
>>
>> There is no relation at all between the pci device and the ACPI DSDT, apart
>> from the fact that the device node name is known by the driver, that being
>> "SAS0". I am not 100% comfortable with this, as we are introducing some sort
>> of device indexing in the driver.
>>
>> Please note that Cavium did something similar on their thunderx network
>> driver:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/cavium/thunder/thunder_bgx.c?h=v4.12-rc1#n1162
>>
>> As for your suggestion, in theory it could be ok to have a pci_dev->fwnode,
>> and this would work for Unified Device Properties Interface (if that is
>> indeed what you mean). But how to create/match this fwnode?
>
> pci_scan_device sets the dev->of_node field for DT based probing, we
> could add a trivial patch to set the fwnode field as well if that isn't
> already done elsewhere.
>
>>From what I can tell, the ACPI code sets up a 'companion' device for
> any PCI device that is listed in the ACPI tables, at least it refers to
> that later on, but I could not figure out where it actually gets set.
>

Hi Arnd,

Currently there is no pci device listed in the ACPI tables.

What I am doing is declaring a fake device in the root of the System bus 
tree of the ACPI tables, and in the kernel driver finding it by matching 
the name. It is not the ACPI companion for the pci device.

So I think that we can define the pci device under the pci bus in the 
ACPI tables, and define the ADR and DSD. Then we would have an ACPI 
companion for the device, and from that get the SAS address.

An alternative to this ACPI device method is for UEFI to write the SAS 
address to a defined free location in device's pci config space, which 
the driver can read.

Much appreciated,
John

>         Arnd
>
> .
>

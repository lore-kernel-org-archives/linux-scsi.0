From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 09/22] scsi: hisi_sas: retrieve SAS address for pci-based controller
Date: Wed, 17 May 2017 16:13:02 +0200
Message-ID: <CAK8P3a0bo7L07X18_0e2vswLmCb+cu4CrzSoGKb0jk-yrKxTbQ@mail.gmail.com>
References: <1495018197-120535-1-git-send-email-john.garry@huawei.com>
 <1495018197-120535-10-git-send-email-john.garry@huawei.com>
 <CAK8P3a0RxVq6Y0OpQWikDKBSvu0z42TCAEVRmrFD0CJwmh3SXw@mail.gmail.com> <e01dac0a-69a9-b625-76c1-f30fe5663890@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e01dac0a-69a9-b625-76c1-f30fe5663890@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry2@mail.dcu.ie>, linuxarm@huawei.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 17, 2017 at 3:37 PM, John Garry <john.garry@huawei.com> wrote:
> On 17/05/2017 13:37, Arnd Bergmann wrote:

>> Since this uses the _DSD information that was introduced for compatibility
>> between device tree and ACPI based data, why not write the code so that
>> it can work for both?
>>
>> Ideally this should just look up the property for pci_dev->fwnode, but I'm
>> not entirely sure if this works the same way on ACPI and DT today.
>>
>
> Hi Arnd,
>
> There is no relation at all between the pci device and the ACPI DSDT, apart
> from the fact that the device node name is known by the driver, that being
> "SAS0". I am not 100% comfortable with this, as we are introducing some sort
> of device indexing in the driver.
>
> Please note that Cavium did something similar on their thunderx network
> driver:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/cavium/thunder/thunder_bgx.c?h=v4.12-rc1#n1162
>
> As for your suggestion, in theory it could be ok to have a pci_dev->fwnode,
> and this would work for Unified Device Properties Interface (if that is
> indeed what you mean). But how to create/match this fwnode?

pci_scan_device sets the dev->of_node field for DT based probing, we
could add a trivial patch to set the fwnode field as well if that isn't
already done elsewhere.

>From what I can tell, the ACPI code sets up a 'companion' device for
any PCI device that is listed in the ACPI tables, at least it refers to
that later on, but I could not figure out where it actually gets set.

        Arnd

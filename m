From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 09/22] scsi: hisi_sas: retrieve SAS address for pci-based
 controller
Date: Wed, 17 May 2017 14:37:23 +0100
Message-ID: <e01dac0a-69a9-b625-76c1-f30fe5663890@huawei.com>
References: <1495018197-120535-1-git-send-email-john.garry@huawei.com>
 <1495018197-120535-10-git-send-email-john.garry@huawei.com>
 <CAK8P3a0RxVq6Y0OpQWikDKBSvu0z42TCAEVRmrFD0CJwmh3SXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a0RxVq6Y0OpQWikDKBSvu0z42TCAEVRmrFD0CJwmh3SXw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry2@mail.dcu.ie>, linuxarm@huawei.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 17/05/2017 13:37, Arnd Bergmann wrote:
> On Wed, May 17, 2017 at 12:49 PM, John Garry <john.garry@huawei.com> wrote:
>> > For a pci-based controller, retrieve the SAS address from the
>> > ACPI tables.
>> >
>> > The retrieval is based on the ACPI device node name. Sample is
>> > as follows:
>> > Scope(_SB)
>> > {
>> >     Device(SAS0) {
>> >                 Name(_HID, "HISI0163")
>> >                 Name (_DSD, Package () {
>> >               ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>> >               Package () {
>> >                                 Package (2) {"sas-addr", Package() {0x50, 0x01, 0x88, 0x20, 0x16, 00, 00, 0x00}},
>> >               }
>> >           })
>> >         }
>> > }
>> >
>> > If the ACPI node or node property is not available, then we fall
>> > back on a default address.
>> >
>> > Signed-off-by: John Garry <john.garry@huawei.com>
> Since this uses the _DSD information that was introduced for compatibility
> between device tree and ACPI based data, why not write the code so that
> it can work for both?
>
> Ideally this should just look up the property for pci_dev->fwnode, but I'm
> not entirely sure if this works the same way on ACPI and DT today.
>

Hi Arnd,

There is no relation at all between the pci device and the ACPI DSDT, 
apart from the fact that the device node name is known by the driver, 
that being "SAS0". I am not 100% comfortable with this, as we are 
introducing some sort of device indexing in the driver.

Please note that Cavium did something similar on their thunderx network 
driver:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/cavium/thunder/thunder_bgx.c?h=v4.12-rc1#n1162

As for your suggestion, in theory it could be ok to have a 
pci_dev->fwnode, and this would work for Unified Device Properties 
Interface (if that is indeed what you mean). But how to create/match 
this fwnode?

Thanks,
John

>          Arnd

From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 09/22] scsi: hisi_sas: retrieve SAS address for pci-based controller
Date: Wed, 17 May 2017 21:23:25 +0200
Message-ID: <CAK8P3a0obfJYviU4kZ+KtfbrEpjOaJJazJQbV0_xJ24+YYMD_A@mail.gmail.com>
References: <1495018197-120535-1-git-send-email-john.garry@huawei.com>
 <1495018197-120535-10-git-send-email-john.garry@huawei.com>
 <CAK8P3a0RxVq6Y0OpQWikDKBSvu0z42TCAEVRmrFD0CJwmh3SXw@mail.gmail.com>
 <e01dac0a-69a9-b625-76c1-f30fe5663890@huawei.com> <CAK8P3a0bo7L07X18_0e2vswLmCb+cu4CrzSoGKb0jk-yrKxTbQ@mail.gmail.com>
 <dd20a241-b137-6779-63c9-6b881fc393c7@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33474 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbdEQTX0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2017 15:23:26 -0400
In-Reply-To: <dd20a241-b137-6779-63c9-6b881fc393c7@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry2@mail.dcu.ie>, linuxarm@huawei.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Wed, May 17, 2017 at 6:45 PM, John Garry <john.garry@huawei.com> wrote:
> On 17/05/2017 15:13, Arnd Bergmann wrote:
>> On Wed, May 17, 2017 at 3:37 PM, John Garry <john.garry@huawei.com> wrote:
>>> On 17/05/2017 13:37, Arnd Bergmann wrote:
>>> As for your suggestion, in theory it could be ok to have a
>>> pci_dev->fwnode,
>>> and this would work for Unified Device Properties Interface (if that is
>>> indeed what you mean). But how to create/match this fwnode?
>>
>>
>> pci_scan_device sets the dev->of_node field for DT based probing, we
>> could add a trivial patch to set the fwnode field as well if that isn't
>> already done elsewhere.
>>
>>> From what I can tell, the ACPI code sets up a 'companion' device for
>>
>> any PCI device that is listed in the ACPI tables, at least it refers to
>> that later on, but I could not figure out where it actually gets set.
>>
>
> Hi Arnd,
>
> Currently there is no pci device listed in the ACPI tables.
>
> What I am doing is declaring a fake device in the root of the System bus
> tree of the ACPI tables, and in the kernel driver finding it by matching the
> name. It is not the ACPI companion for the pci device.
>
> So I think that we can define the pci device under the pci bus in the ACPI
> tables, and define the ADR and DSD. Then we would have an ACPI companion for
> the device, and from that get the SAS address.

Yes, that would be much better, and allow us to use the device properties
interface directly. An additional advantage is that the property definition
can be exactly the same as for the v1/v2 platform_device properties
for anything that might be needed across all versions.  sas-addr already
fits in there, and there might be additional properties you need in the
future.

> An alternative to this ACPI device method is for UEFI to write the SAS
> address to a defined free location in device's pci config space, which the
> driver can read.

That sounds ok as well, it would be nice to not rely on firmware data here,
but I'd have to see how the implementation ends up: IIRC you should
not just put the data at a fixed location in the config space but instead use
the 'extended capabilities' infrastructure to find the data.
PCI_EXT_CAP_ID_VNDR might be the right one here, but I don't
know enough about this, so please consult with someone who does
(or the PCIe specification).

      Arnd

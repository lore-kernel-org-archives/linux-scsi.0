From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [ANNOUNCE]: Broadcom (Emulex) FC Target driver - efct
Date: Tue, 13 Jun 2017 11:34:42 -0400
Message-ID: <yq137b3yk8d.fsf@oracle.com>
References: <ced2ff0a-05ee-b85e-b41a-f912cab9e267@gmail.com>
        <1488485325.5580.9.camel@haakon3.risingtidesystems.com>
        <20170305173528.00006b41@gmx.de>
        <CAL1RGDVBvgzaQTRfWS14=S1M1DuzKGPYzAPWWeQyAASDQ=05Rw@mail.gmail.com>
        <55205e7e-e1c6-5f09-8dd3-338492728dfe@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <55205e7e-e1c6-5f09-8dd3-338492728dfe@broadcom.com> (James
        Smart's message of "Mon, 12 Jun 2017 16:08:24 -0700")
Sender: target-devel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: Roland Dreier <roland@purestorage.com>, Sebastian Herbszt <herbszt@gmx.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, jsmart2021@gmail.com, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


James,

> To start this effort, I'd like a bcmlpfc directory to be made within
> the drivers staging tree. The directory would be populated with the
> efct driver and a copy of the existing lpfc driver.  Work can then
> commence on refactoring lpfc and creating the libraries and
> integrating the libraries into both drivers.  As lpfc is updated in
> the main tree, patches would be posted to the staging version of lpfc
> to keep them on par.

Sounds good to me.

> a) How best to deal with overlapping pci id's ?  E.g. if we do (1) and
> we have an initiator and target driver, there is a lot of adapters
> that are fully functional for target operation, but were sold as
> primarily an initiator adapter. How could we manage target mode
> enablement without code mod or hard pci id partitioning ?  I know
> individual pci unbind/bind could work, but its been frowned upon as a
> long term option. Same thing goes for module parameters to select
> which ports do what role.

I don't have a problem with the binding approach. A bit easier for the
sysadmin to script and manage compared to PCI ID-specific module
parameters that may come with initramfs rebuilds or grub tweaks and
reboots.

I also think the binding approach eases that pain for systems that want,
say, initiator for root fs on one port and target on the other. And
gives you the flexibility to use the WWN or sysfs attributes other than
the PCI ID to locate the ports whose affiliation you want to change.

> b) Assuming we have the lpfc copy in the bcmlpfc directory in the
> staging tree: are there any issues with having a version of lpfc in the
> main tree and another in the staging tree ?     For many reasons, I'd
> like to keep the name lpfc on the initiator driver in the staging
> tree. But is that possible ? I assume we would need to develop in the
> staging tree as a new name and pci id space separate from the base
> driver, and we can rename the staging driver to the lpfc name when it
> merges into the main kernel and replaces the existing driver.

I'm with Christoph in terms of avoiding staging. It's better to do out
of tree. And as far as naming is concerned, you have some flexibility in
terms of string prefixes for printk's, module aliases, etc. And then a
final tweak to get things shuffled into place before merging into
mainline.

-- 
Martin K. Petersen	Oracle Linux Engineering

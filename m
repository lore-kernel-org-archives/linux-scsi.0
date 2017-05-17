From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 09/22] scsi: hisi_sas: retrieve SAS address for pci-based controller
Date: Wed, 17 May 2017 14:37:52 +0200
Message-ID: <CAK8P3a0RxVq6Y0OpQWikDKBSvu0z42TCAEVRmrFD0CJwmh3SXw@mail.gmail.com>
References: <1495018197-120535-1-git-send-email-john.garry@huawei.com> <1495018197-120535-10-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33135 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbdEQMhx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2017 08:37:53 -0400
In-Reply-To: <1495018197-120535-10-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry2@mail.dcu.ie>, linuxarm@huawei.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Wed, May 17, 2017 at 12:49 PM, John Garry <john.garry@huawei.com> wrote:
> For a pci-based controller, retrieve the SAS address from the
> ACPI tables.
>
> The retrieval is based on the ACPI device node name. Sample is
> as follows:
> Scope(_SB)
> {
>     Device(SAS0) {
>                 Name(_HID, "HISI0163")
>                 Name (_DSD, Package () {
>               ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>               Package () {
>                                 Package (2) {"sas-addr", Package() {0x50, 0x01, 0x88, 0x20, 0x16, 00, 00, 0x00}},
>               }
>           })
>         }
> }
>
> If the ACPI node or node property is not available, then we fall
> back on a default address.
>
> Signed-off-by: John Garry <john.garry@huawei.com>

Since this uses the _DSD information that was introduced for compatibility
between device tree and ACPI based data, why not write the code so that
it can work for both?

Ideally this should just look up the property for pci_dev->fwnode, but I'm
not entirely sure if this works the same way on ACPI and DT today.

         Arnd

From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: Why are MegaRAID drivers mutually exclusive?
Date: Wed, 10 Nov 2004 16:25:14 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570562C174@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:8917 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262133AbUKJVZ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2004 16:25:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Matt Domsch' <Matt_Domsch@dell.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: 'Chris Adams' <cmadams@hiwaay.net>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

> There are three issues here that need to be addressed.
> 1) megaraid_mbox doesn't currently handle all of Chris's hardware.
>    It's missing some PCI IDs which it should be able to handle.
>    101e:1960 101e:0475, aka PCI_VENDOR_ID_AMI, 
> PCI_DEVICE_ID_AMI_MEGARAID3
> 			    PCI_DEVICE_ID_AMI, PCI_SUBSYS_ID_PERC3_SC 

Initial idea was to support only the newest U320 controllers on the 2.20
stack because these controllers are heavily tested in LSI labs with the 2.20
driver. For older controllers, we recommended to use legacy drivers.  We
agreed to add the Dell's branded PERC3s since there is a lot of value in
that generation of controllers. We agree to add the support for AMI branded
475/493/471 as well now. There should be patch from Sreenivas soon for this.

> 
> 2) megaraid_mbox doesn't handle other sets of hardware it should be
>    able to handle (Dell PERC2/{SC,DC}).  I am not sure why.

Same reason. The bottom-line for any controllers to be supported on this
stack was, it should be actively tested in LSI labs. Other main reason not
to support these controller is their lack of capability to do 64-bit DMA.

> 
> 3) no megaraid_ioport driver has ever been produced, which was the
>    original reason for splitting megaraid_mm and megaraid_mbox.  This
>    driver is necessary for Chris's other older hardware.
>    PCI 101e:9010, aka PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_MEGARAID
> 
This is not entirely correct. We initially planned to have SAS RAID drivers
under the 2.20 umbrella, not IO based controllers.

Now coming back to the original question of non-flexibility of having both
drivers:

We do not want to have someone configure both drivers to load since legacy
megaraid not only supports the older controllers, it _can_ take ownership of
the newer ones as well, causing 2.20 to fail to load for those controllers.
Also, management applications are written with a view of only one driver
concept. These cannot interface with 2 drivers. So, in order to force one
driver - Kconfig is written in this particular way.

Now, this can be easily changed, and we are definitely flexible to let user
compile both drivers. This should work as long as user makes sure to load
-_only one_ of these at any time. (suggestions?)

Thanks
-Atul Mukker

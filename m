From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: How to add/drop SCSI drives from within the driver?
Date: Wed, 15 Dec 2004 14:42:21 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57057A2156@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:5373 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262476AbULOTuT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Dec 2004 14:50:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Matt Domsch' <Matt_Domsch@dell.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: "'Salyzyn, Mark'" <mark_salyzyn@adaptec.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, "'brking@us.ibm.com'" <brking@us.ibm.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, 'Andrew Morton' <akpm@osdl.org>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>

> 
> Your management apps currently issue a private ioctl 
> MEGAIOC_QNADAP which returns the number of 
> megaraid_mm-handled adapters in the system.  How do you map a 
> megaraid adapter number to a struct Scsi_Host device, to be 
> sure you're acting on the controller you think you are?
Megaraid_mm module maintains all the controllers on a list
(mraid_mm_get_adapter), and each of the adapter maintains a pointer to the
host object.

> 
> SCSI LLDDs don't show up in sysfs under /sys/bus/scsi/drivers 
> at present, which is where, I think, you would want to put 
> megaraid_mm with links to show the scsi_host and pci_dev 
> associated with this adapter.  Something like this:
> 
> /sys
> |-- bus
> |   `-- drivers
> |       `-- scsi
> |           `-- megaraid_mm
> |               `-- adapter0
> |                   |-- pci_dev -> 
> ../../../../../devices/pci0000:03/0000:03:06.0
> |                   `-- scsi_host -> 
> |../../../../../class/scsi/scsi_host/host0
> |-- class
> |   `-- scsi
> |       `-- scsi_host
> |           `-- host0
> `-- devices
>     `-- pci0000:03
>         `-- 0000:03:06.0
Megaraid_mm is not a 'scsi' driver but only a conduit to pass the commands
from application to the megaraid_mbox scsi module. 

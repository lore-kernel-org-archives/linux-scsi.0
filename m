From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: How to add/drop SCSI drives from within the driver?
Date: Wed, 15 Dec 2004 10:48:51 -0600
Message-ID: <20041215164851.GC31494@lists.us.dell.com>
References: <60807403EABEB443939A5A7AA8A7458B7F5071@otce2k01.adaptec.com> <1102536081.4218.0.camel@localhost.localdomain> <20041215072453.GB17274@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lists.us.dell.com ([143.166.224.162]:63430 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S262383AbULOQuO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Dec 2004 11:50:14 -0500
Content-Disposition: inline
In-Reply-To: <20041215072453.GB17274@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, brking@us.ibm.com, linux-kernel@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, bunk@fs.tum.de, Andrew Morton <akpm@osdl.org>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>

On Wed, Dec 15, 2004 at 01:24:53AM -0600, Matt Domsch wrote:
> /sys/class/scsi_host
>  |-- host0
>  |   |-- add_logical_drive
>  |   |-- remove_logical_drive
>  |   `-- rescan_logical_drive

Atul, Sreenivas:

Your management apps currently issue a private ioctl MEGAIOC_QNADAP
which returns the number of megaraid_mm-handled adapters in the
system.  How do you map a megaraid adapter number to a struct
Scsi_Host device, to be sure you're acting on the controller you think
you are?

SCSI LLDDs don't show up in sysfs under /sys/bus/scsi/drivers at
present, which is where, I think, you would want to put megaraid_mm
with links to show the scsi_host and pci_dev associated with this
adapter.  Something like this:

/sys
|-- bus
|   `-- drivers
|       `-- scsi
|           `-- megaraid_mm
|               `-- adapter0
|                   |-- pci_dev -> ../../../../../devices/pci0000:03/0000:03:06.0
|                   `-- scsi_host -> ../../../../../class/scsi/scsi_host/host0
|-- class
|   `-- scsi
|       `-- scsi_host
|           `-- host0
`-- devices
    `-- pci0000:03
        `-- 0000:03:06.0

Thoughts?
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: How to add/drop SCSI drives from within the driver?
Date: Wed, 15 Dec 2004 13:55:29 -0500
Message-ID: <1103136929.5232.8.camel@mulgrave>
References: <60807403EABEB443939A5A7AA8A7458B7F5071@otce2k01.adaptec.com>
	 <1102536081.4218.0.camel@localhost.localdomain>
	 <20041215072453.GB17274@lists.us.dell.com>
	 <20041215164851.GC31494@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:4770 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262441AbULOUfm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Dec 2004 15:35:42 -0500
In-Reply-To: <20041215164851.GC31494@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@Dell.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, brking@us.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, bunk@fs.tum.de, Andrew Morton <akpm@osdl.org>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>

On Wed, 2004-12-15 at 10:48 -0600, Matt Domsch wrote:
> SCSI LLDDs don't show up in sysfs under /sys/bus/scsi/drivers at
> present, which is where, I think, you would want to put megaraid_mm
> with links to show the scsi_host and pci_dev associated with this
> adapter.  Something like this:
> 
> /sys
> |-- bus
> |   `-- drivers
> |       `-- scsi
> |           `-- megaraid_mm
> |               `-- adapter0
> |                   |-- pci_dev -> ../../../../../devices/pci0000:03/0000:03:06.0

Actually, there is a reason why this doesn't happen:  The drivers
directory shows only drivers belonging to a bus.  The megaraid_mm driver
is actually a PCI driver, and thus belongs to the PCI bus.  So, you'll
see this under

/sys/bus/pci/drivers/megaraid_mm/<pci_id>/host<n>

That should be sufficient to obtain all instances.  Note: the instances
aren't numerically indexed under this scheme (unlike your adapter<n>)
they'd be indexed by a unique pci_id.

So it looks like all the information is accessible today (if you look
for it in a slightly different way).  Is there anything currently
missing?

James



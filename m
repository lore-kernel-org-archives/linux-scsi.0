From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: pulling failover out of qla2xxx
Date: Fri, 16 Jan 2004 15:24:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40084860.90902@pobox.com>
References: <B179AE41C1147041AA1121F44614F0B0598E34@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:16274 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265752AbUAPUYO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 15:24:14 -0500
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598E34@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjanv@redhat.com>

Andrew Vasquez wrote:
> I'll open up a request-for-response from the rest of the listers in
> asking if parceling out qlaAB00.ko modules based on firmware types is
> both practical and sensible from a user standpoint.  Especially
> considering that many users aren't really concerned with the ISP chip
> type on their QLAXXXX or OEM-BRANDED ABC host bus adapter.


Speaking from a generic driver / distro standpoint, module dependencies 
and PCI tables (i.e. pci_device_id and MODULE_DEVICE_TABLE) all things 
to magically Just Work :)

I heartily encourage the creation of "library modules", which are loaded 
automatically as dependencies when one issues a 'modprobe qla2345' 
Distributions have tools that will notice PCI id tables in the 
small/firmware modules, and will load qla2345.ko.  But the tools will 
also notice the dependent module qla2xxx.ko (or whatever the generic one 
is).  Heck, if there is HBA-chip-specific code in qla2xxx, move that out 
to the specific driver's module too.

	Jeff




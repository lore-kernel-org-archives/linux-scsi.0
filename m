From: "'hch@infradead.org'" <hch@infradead.org>
Subject: [hch@infradead.org: Re: ANNOUNCE: megaraid driver version 2.10.1]
Date: Sun, 1 Feb 2004 15:49:00 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040201154900.A15764@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:12299 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265350AbUBAPtJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Feb 2004 10:49:09 -0500
Received: from hch by phoenix.infradead.org with local (Exim 4.30 #5 (Red Hat Linux))
	id 1AnJqG-00046Z-Qr
	for linux-scsi@vger.kernel.org; Sun, 01 Feb 2004 15:49:00 +0000
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

sorry, forgot to Cc the list when replying.

----- Forwarded message from "'hch@infradead.org'" <hch@infradead.org> -----

Date: Sun, 1 Feb 2004 15:46:11 +0000
From: "'hch@infradead.org'" <hch@infradead.org>
Subject: Re: ANNOUNCE: megaraid driver version 2.10.1
To: "Mukker, Atul" <Atulm@lsil.com>

On Fri, Jan 30, 2004 at 10:03:00AM -0500, Mukker, Atul wrote:
> Hello Christoph,
> 
> I am in process of testing the next version of the megaraid driver. I faced
> an issue while doing the insmod-rmmod sequence. Your patch for PCI hotplug
> does "pci_disable_device" when the driver is unloaded.

Yupp.

> The insmod-rmmod-insmod fails the first time unless you do an explicit
> pci_set_master at driver load time, since pci_enable_device does not seem to
> enable bus mastering, which is disabled by pci_disable_device.

Right, we need the pci_set_master anyway because it's not guaranteed to be
enabled even when loading the first time.  (although it usually is on PC
hardware).  I'll send a patch to jejb to fix it ASAP, but you should add it
to the 2.4 driver aswell.

> Even with pci_set_master, insmod stalls the CPU after about 2-3 hours of
> insmod-rmmod sequence. So I took out the pci_disable_device altogether to
> find out it takes only longer, about 9 hours, but CPU stalls at the exact
> location again with a NMI watchdog. It happens when the driver issues the
> first command to the FW, which is never received by it and driver gets stuck
> in a forever cpu_relax loop waiting for the command to complete

Well, you're not supposed to unload/reload all the time because for example
the scsi host number is never incremented.  I can really explain the hang,
though.  Maybe you'll get the host number of a HBA driven by another driver
because we don't have overflow checking?  I need to fix that anyway..

> The kernel is a genre of 2.4.21

Huh?  I don't see how the PCI hotplugging changes work with a 2.4 scsi
midlayer..


----- End forwarded message -----

-- 
Christoph Hellwig <hch@lst.de>		-	Freelance Hacker
Contact me for driver hacking and kernel development consulting

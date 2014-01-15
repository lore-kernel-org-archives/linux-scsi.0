From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 0/9] PCI: Eliminate race conditions between hotplug and
 sysfs rescan/remove (Was: Re: [PATCH v2 04/10] PCI: Destroy pci dev only
 once)
Date: Wed, 15 Jan 2014 11:02:15 -0700
Message-ID: <20140115180215.GA31386@google.com>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
 <CAErSpo6edmz5nkSYogbYk1FFYsCCwNV_-rir2jGP2JBnvOx+iw@mail.gmail.com>
 <1992931.Zv6xBcN8V4@vostro.rjw.lan>
 <20440867.YaQfKrcfsQ@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:38856 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbaAOSCT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 13:02:19 -0500
Received: by mail-ig0-f179.google.com with SMTP id c10so5240811igq.0
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jan 2014 10:02:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20440867.YaQfKrcfsQ@vostro.rjw.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mika Westerberg <mika.westerberg@linux.intel.com>, Myron Stowe <myron.stowe@gmail.com>, Benjamin Herrenschmidt <benh@au1.ibm.com>, linux-scsi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

On Fri, Jan 10, 2014 at 03:20:44PM +0100, Rafael J. Wysocki wrote:
> [Cc: adding linux-scsi for the MPT changes, Ben for powerpc, Matthew for
>  platform/x86 and Konrad for Xen]
> 
> On Friday, December 06, 2013 02:21:50 AM Rafael J. Wysocki wrote:
> 
> [...]
> 
> > 
> > OK
> > 
> > To be a bit more constructive, as the next step I'd try to use
> > pci_remove_rescan_mutex to serialize all PCI hotplug operations (as I said
> > above) without making the other changes made by my patch.  Does that sound
> > reasonable?
> 
> Well, no answer here, so as a followup, a series implementing that idea
> follows.
> 
> I *hope* I found all of the places that need to be synchronized vs the bus
> rescan and device removal that can be triggered via sysfs, but I might overlook
> something.  Also in some cases I wasn't quite sure how much stuff to put under
> the lock, because said stuff is not exactly straightforward.

I applied this series to my pci/locking branch for v3.14.  It should appear
in -next tomorrow.

Note that this touches some areas that are not strictly PCI, so speak
up if I'm treading on your toes:

 arch/powerpc/kernel/eeh_driver.c       |   19 ++++++++++++--
 drivers/acpi/pci_root.c                |    6 ++++
 drivers/message/fusion/mptbase.c       |    2 -
 drivers/pci/hotplug/acpiphp.h          |    5 +++
 drivers/pci/hotplug/acpiphp_core.c     |    2 -
 drivers/pci/hotplug/acpiphp_glue.c     |   43 +++++++++++++++++++++++++++++----
 drivers/pci/hotplug/cpci_hotplug_pci.c |   14 +++++++++-
 drivers/pci/hotplug/cpqphp_pci.c       |    8 +++++-
 drivers/pci/hotplug/ibmphp_core.c      |   13 ++++++++-
 drivers/pci/hotplug/pciehp_pci.c       |   17 +++++++++----
 drivers/pci/hotplug/rpadlpar_core.c    |   19 ++++++++++----
 drivers/pci/hotplug/rpaphp_core.c      |    4 +++
 drivers/pci/hotplug/s390_pci_hpc.c     |    4 ++-
 drivers/pci/hotplug/sgi_hotplug.c      |    5 +++
 drivers/pci/hotplug/shpchp_pci.c       |   18 ++++++++++---
 drivers/pci/pci-sysfs.c                |   19 +++++---------
 drivers/pci/probe.c                    |   18 +++++++++++++
 drivers/pci/remove.c                   |   11 ++++++++
 drivers/pci/xen-pcifront.c             |    8 ++++++
 drivers/pcmcia/cardbus.c               |    7 +++++
 drivers/platform/x86/asus-wmi.c        |    2 +
 drivers/platform/x86/eeepc-laptop.c    |    2 +
 drivers/scsi/mpt2sas/mpt2sas_base.c    |    2 -
 drivers/scsi/mpt3sas/mpt3sas_base.c    |    2 -
 include/linux/pci.h                    |    3 ++


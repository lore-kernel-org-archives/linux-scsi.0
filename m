From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: pulling failover out of qla2xxx
Date: Sat, 17 Jan 2004 13:52:03 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040117215203.GA9041@praka.local.home>
References: <B179AE41C1147041AA1121F44614F0B0598E34@AVEXCH02.qlogic.org> <40084860.90902@pobox.com> <20040117205230.GB8301@praka.local.home> <1074373727.4429.4.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:18402 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S265840AbUAQWDp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Jan 2004 17:03:45 -0500
Received: from praka.san.rr.com (66-75-130-8.san.rr.com [66.75.130.8])
	by ms-smtp-02-eri0.socal.rr.com (8.12.10/8.12.7) with ESMTP id i0HM3fNR029651
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2004 14:03:42 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1074373727.4429.4.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI <linux-scsi@vger.kernel.org>

On Sat, 17 Jan 2004, Arjan van de Ven wrote:

> On Sat, 2004-01-17 at 21:52, Andrew Vasquez wrote:
> > I certainly hope this to be the case.  Perhaps I'm still viewing this
> > with an eye as an external module maintainer.  When a user compiles
> > the qla2xxx driver she's given the following options:
> > 
> > 	...
> >         [ ] QLogic ISP2100 host adapter family support
> >         [ ] QLogic ISP2200 host adapter family support
> >         [ ] QLogic ISP2300 host adapter family support
> >         [ ] QLogic ISP2322 host adapter family support
> >         [ ] QLogic ISP6312 host adapter family support
> >         [ ] QLogic ISP6322 host adapter family support
> > 	...
> > 
> > how will she know which option to select for her QLA2362 HBA?  
> 
> fwiw there is no rule to have a Kconfig line for each driver; you could
> just have one "QLogic fiber channel drivers" question, maybe with a
> subquestion about "enable all chipsets" with a pull down thingy for
> selected ones if the user wants to pick and choose. There is also help
> text for more info.

Funny, that's how the Kconfig format was laid out in earlier drivers
8.00.00b7):

	config SCSI_QLA2XXX
		bool "QLogic ISP2xxx PCI/PCI-X Fibre Channel HBA Support"
		depends on PCI && SCSI
		---help---
		These drivers support the QLogic 2xxx host adapter family of
		SCSI FCP HBAs.

	config SCSI_QLA21XX
		tristate "ISP2100 host adapter family support"
		depends on SCSI_QLA2XXX
		---help---
		This driver supports the QLogic 21xx (ISP2100) host adapter
		family.

	config SCSI_QLA22XX
		tristate "ISP2200 host adapter family support"
		depends on SCSI_QLA2XXX

	...

There seemed to be some resistence to that and in the end it was
changed to the current form.

> (and most people who have qlogic fiber adapters will just say "m" to
> all, as will distros)

I'll just throw this out, if in fact as you say request_firmware()
won't work with the current initrd's used by the distros then perhaps
we could simply build the firmware images as modules (minus the
per-firmware loader) and have a generic qlafc.ko (or whatever the name
you'd like) loader that the user would modprobe. The qlafc driver
would then register the pci_device_id tables for all ISP chips and
wait for the pci_driver callback to signify which firmwares modules to
load.  Load the firmware, call probe(), then move on.  

Nothing fancy or genuine, but perhaps a smooth transition to when in
fact request_firmware() will do.

--
Andrew

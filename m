From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 1/3]  qla2xxx: Add full firmware(-request) hotplug support for all ISPs.
Date: Thu, 10 Nov 2005 16:47:18 -0800
Message-ID: <20051111004718.GP5678@andrew-vasquezs-powerbook-g4-15.local>
References: <20051109234846.4868.25487.sendpatchset@andrew-vasquezs-powerbook-g4-15.local> <20051109234901.4868.27256.sendpatchset@andrew-vasquezs-powerbook-g4-15.local> <20051110105846.GA9222@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:702 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S932292AbVKKArY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Nov 2005 19:47:24 -0500
Content-Disposition: inline
In-Reply-To: <20051110105846.GA9222@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 10 Nov 2005, Christoph Hellwig wrote:

> this patchkit looks good.  one thing we discussed and should go in ontop is a
> scsi-wide option the firmware depends on, with
> a clear deprecation date for the builtin firmware.  that way we can enforce
> that all new drivers support request_firmware, but can have in-kernel firmware
> for until that deprecation date.

Sure, sounds reasonable -- perhaps we can get some consensus from the
list and come up with the date (arbitrary as it may be), at least it
would motivate those affected (QLogic)...

> > +config SCSI_QLA21XX
> > +	tristate "  Build QLogic ISP2100 firmware-module"
> > +	depends on SCSI_QLA2XXX_EMBEDDED_FIRMWARE
> >  	---help---
> >  	This driver supports the QLogic 21xx (ISP2100) host adapter family.
> 
> don't the help-text need some update?

I'm inclined to drop the help-text entirely for the firmware-module
entries, as I'm not sure one needs more info than the menu-item:

	[ ] Build QLogic ISP2100 firmware-module

already states.  What were you looking for?

> > +#if defined(CONFIG_SCSI_QLA2XXX_EMBEDDED_FIRMWARE)
> >  #if defined(CONFIG_SCSI_QLA21XX) || defined(CONFIG_SCSI_QLA21XX_MODULE)
> >  #define IS_QLA2100(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2100)
> >  #else
> > @@ -79,9 +81,23 @@
> >  #define IS_QLA2522(ha)	0
> >  #endif
> >  
> > +#else	/* !defined(CONFIG_SCSI_QLA2XXX_EMBEDDED_FIRMWARE) */
> > +
> > +#define IS_QLA2100(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2100)
> 
> I'd say just use this else clause unconditionally.  no need to optimize for
> the 1% users using the deprecated builtin-firmware and compile just for
> a subsystet of the supported cards.

As this patchset looks to be more 2.6.16 material, I'll redo the
patches with this change along with any additional feedback and a few
minor bits.

James, would you like me to resubmit now for staging in scsi-misc-2.6
for 2.6.16?

--
av

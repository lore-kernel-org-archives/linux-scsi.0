From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ACPI] Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Thu, 08 Dec 2005 14:30:57 +0000
Message-ID: <1134052257.17102.13.camel@localhost.localdomain>
References: <20051208030242.GA19923@srcf.ucam.org>
	 <20051208091542.GA9538@infradead.org>
	 <20051208132657.GA21529@srcf.ucam.org>
	 <20051208133308.GA13267@infradead.org>
	 <20051208133945.GA21633@srcf.ucam.org>
	 <20051208135225.GA13122@havoc.gtf.org>
	 <1134050863.17102.5.camel@localhost.localdomain>
	 <43983FC6.6050108@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932087AbVLHOc1@vger.kernel.org>
In-Reply-To: <43983FC6.6050108@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Christoph Hellwig <hch@infradead.org>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Iau, 2005-12-08 at 09:14 -0500, Jeff Garzik wrote:
> These are only for PATA.  We don't care about _GTM/_STM on SATA.

Even your piix driver supports PATA. Put the foaming (justified ;))
hatred for ACPI aside for a moment and take a look at the real world as
it unfortunately is right now.

> Further, SATA completely resets and re-initializes the device as if from 
> a hardware reset (except on ata_piix, which doesn't support COMRESET, 
> and PATA).  This makes _GTF uninteresting, as well.

You don't know what the sequences the resume method is concerned about
actually are.

> suspend/resume works just fine with Jens' out-of-tree patch.

Only on some systems.

> > If you don't run the resume methods your disk subsystem status after a
> > resume is simply undefined and unsafe.
> 
> I initialize the hardware to a defined state.

Sure, but sometimes the *wrong* defined state. The BIOS ACPI methods
include things like unlocking drive passwords on restore with some
systems. You don't handle that at all.

Having said that I still think ACPI awareness doesn't belong in libata
or scsi because we'd then have awareness of every pm scheme in the wrong
layer and a dozen pm systems all with scsi hooks. Gak...

SCSI/libata can go easily from ata channel to pci device to device. The
rest of the logic belongs outside of scsi/libata.

Alan

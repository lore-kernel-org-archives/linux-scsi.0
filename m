From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Thu, 08 Dec 2005 14:01:38 +0000
Message-ID: <1134050498.17102.2.camel@localhost.localdomain>
References: <20051208030242.GA19923@srcf.ucam.org>
	 <20051208091542.GA9538@infradead.org>
	 <20051208132657.GA21529@srcf.ucam.org>
	 <20051208133308.GA13267@infradead.org>
	 <20051208133945.GA21633@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from clock-tower.bc.nu ([81.2.110.250]:23173 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP id S932112AbVLHODC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Dec 2005 09:03:02 -0500
In-Reply-To: <20051208133945.GA21633@srcf.ucam.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Christoph Hellwig <hch@infradead.org>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net

On Iau, 2005-12-08 at 13:39 +0000, Matthew Garrett wrote:
> On Thu, Dec 08, 2005 at 01:33:08PM +0000, Christoph Hellwig wrote:
> 
> > Don't do it at all.  We don't need to fuck up every layer and driver for
> > intels braindamage.
> 
> Doing SATA suspend/resume properly on x86 depends on knowing the ACPI 
> object that corresponds to a host or target. It's also the only way to 
> support hotswap on this hardware[1], since there's no way for userspace 
> to know which device a notification refers to.
> 
> [1] ie, most laptops sold nowadays

Actually "most PC systems"

Nevertheless Christoph has a point even if its hidden behind a George
Bush approach to diplomacy. The scsi core directly shouldn't need to
know about ACPI or other arch specific PM systems. 

Something like  "pci_to_acpi(struct pcidev *)" belongs in arch specific
code even if we do add a generic "void * pm_device" type pointer to
struct pci_dev or struct device for such a purpose.

Alan


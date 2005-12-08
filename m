From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ACPI] Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Thu, 08 Dec 2005 14:07:43 +0000
Message-ID: <1134050863.17102.5.camel@localhost.localdomain>
References: <20051208030242.GA19923@srcf.ucam.org>
	 <20051208091542.GA9538@infradead.org>
	 <20051208132657.GA21529@srcf.ucam.org>
	 <20051208133308.GA13267@infradead.org>
	 <20051208133945.GA21633@srcf.ucam.org>
	 <20051208135225.GA13122@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from clock-tower.bc.nu ([81.2.110.250]:43223 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S1750741AbVLHOJM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Dec 2005 09:09:12 -0500
In-Reply-To: <20051208135225.GA13122@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Christoph Hellwig <hch@infradead.org>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net

On Iau, 2005-12-08 at 08:52 -0500, Jeff Garzik wrote:
> On Thu, Dec 08, 2005 at 01:39:45PM +0000, Matthew Garrett wrote:
> > On Thu, Dec 08, 2005 at 01:33:08PM +0000, Christoph Hellwig wrote:
> > 
> > > Don't do it at all.  We don't need to fuck up every layer and driver for
> > > intels braindamage.
> > 
> > Doing SATA suspend/resume properly on x86 depends on knowing the ACPI 
> > object that corresponds to a host or target.
> 
> Not true.


Actually he is right. You have to know the ACPI object in order to run
the _GTM/_STM etc functions. If you don't run those your suspend/resume
may not work, may corrupt and so on. The only safe alternative is to
disable acpi which, while it would have been a good idea before the spec
ever got out, is a bit late now.

If you don't run the resume methods your disk subsystem status after a
resume is simply undefined and unsafe.

Alan


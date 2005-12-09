From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Fri, 9 Dec 2005 11:52:36 +0000
Message-ID: <20051209115235.GB25771@srcf.ucam.org>
References: <20051208132657.GA21529@srcf.ucam.org> <20051208133308.GA13267@infradead.org> <20051208133945.GA21633@srcf.ucam.org> <1134050498.17102.2.camel@localhost.localdomain> <20051208141811.GB21715@srcf.ucam.org> <1134052433.17102.17.camel@localhost.localdomain> <20051208145257.GB21946@srcf.ucam.org> <20051208171901.GA22451@srcf.ucam.org> <20051209114246.GB16945@infradead.org> <20051209114944.GA1068@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([217.147.92.49]:7088 "EHLO
	vavatch.codon.org.uk") by vger.kernel.org with ESMTP
	id S1751321AbVLILww (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Dec 2005 06:52:52 -0500
Content-Disposition: inline
In-Reply-To: <20051209114944.GA1068@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net

On Fri, Dec 09, 2005 at 06:49:44AM -0500, Jeff Garzik wrote:

> If this is just for libata, it's still at the wrong level.
> 
> libata will eventually make the SCSI simulator optional, which means
> any acpi_scsi_init() or whatnot won't work for libata.

It depends on notification whenever a device is added to the scsi bus 
class, so it needs access to scsi_bus_type. While that could be put in 
the libata layer, it seems cleaner to leave it in scsi and then add 
another callback for libata when it moves to its own bus class.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

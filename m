From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Fri, 9 Dec 2005 11:50:09 +0000
Message-ID: <20051209115009.GA25771@srcf.ucam.org>
References: <20051208091542.GA9538@infradead.org> <20051208132657.GA21529@srcf.ucam.org> <20051208133308.GA13267@infradead.org> <20051208133945.GA21633@srcf.ucam.org> <1134050498.17102.2.camel@localhost.localdomain> <20051208141811.GB21715@srcf.ucam.org> <1134052433.17102.17.camel@localhost.localdomain> <20051208145257.GB21946@srcf.ucam.org> <20051208171901.GA22451@srcf.ucam.org> <20051209114246.GB16945@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([217.147.92.49]:43213 "EHLO
	vavatch.codon.org.uk") by vger.kernel.org with ESMTP
	id S1750846AbVLILuc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Dec 2005 06:50:32 -0500
Content-Disposition: inline
In-Reply-To: <20051209114246.GB16945@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net

On Fri, Dec 09, 2005 at 11:42:46AM +0000, Christoph Hellwig wrote:

> As a concept it's _much_ better.  Although it should be platform_scsi_init
> and every architecture would provide an, in most cases noop, implementation.

How about

if (platform_scsi_init)
	platform_scsi_init(&scsi_bus_type);

? This is similar to how the platform_notify callback code is handled. 
Making it per-arch isn't quite ideal, since x86 can be ACPI or APM and 
kernels need support for both. On the other hand, I can't think of any 
way that APM could do anything useful with the information, so per-arch 
may be reasonable.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

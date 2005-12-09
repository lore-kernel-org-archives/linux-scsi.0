From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Fri, 9 Dec 2005 11:55:22 +0000
Message-ID: <20051209115522.GA17504@infradead.org>
References: <20051208132657.GA21529@srcf.ucam.org> <20051208133308.GA13267@infradead.org> <20051208133945.GA21633@srcf.ucam.org> <1134050498.17102.2.camel@localhost.localdomain> <20051208141811.GB21715@srcf.ucam.org> <1134052433.17102.17.camel@localhost.localdomain> <20051208145257.GB21946@srcf.ucam.org> <20051208171901.GA22451@srcf.ucam.org> <20051209114246.GB16945@infradead.org> <20051209115009.GA25771@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:24555 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751083AbVLILzX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Dec 2005 06:55:23 -0500
Content-Disposition: inline
In-Reply-To: <20051209115009.GA25771@srcf.ucam.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net

On Fri, Dec 09, 2005 at 11:50:09AM +0000, Matthew Garrett wrote:
> On Fri, Dec 09, 2005 at 11:42:46AM +0000, Christoph Hellwig wrote:
> 
> > As a concept it's _much_ better.  Although it should be platform_scsi_init
> > and every architecture would provide an, in most cases noop, implementation.
> 
> How about
> 
> if (platform_scsi_init)
> 	platform_scsi_init(&scsi_bus_type);
> 
> ? This is similar to how the platform_notify callback code is handled. 
> Making it per-arch isn't quite ideal, since x86 can be ACPI or APM and 
> kernels need support for both. On the other hand, I can't think of any 
> way that APM could do anything useful with the information, so per-arch 
> may be reasonable.

I think a per-arch hook is better, if an architecture needs different
backend implementations it can dispatch internally.  And the above won't
work unless platform_scsi_init is a function pointer which would be quite
ugly.

From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 2.6.7-mm3] ipr: minor fixes and assorted nit
Date: 30 Jun 2004 10:52:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1088610767.1904.13.camel@mulgrave>
References: <20040628140721.GA10393@devserv.devel.redhat.com>
	<40E05F43.7040602@us.ibm.com>
	<20040629235940.A6183@electric-eye.fr.zoreil.com>
	<40E2D66F.9060900@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:37269 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266703AbUF3Pw7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2004 11:52:59 -0400
In-Reply-To: <40E2D66F.9060900@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: Francois Romieu <romieu@fr.zoreil.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-06-30 at 10:04, Brian King wrote:
> Is there any downside to requesting all the memory regions on the 
> adapter? Some of these adapters have very large BAR windows that are not 
> needed by the device driver. This is the reason I wrote the code the way 
> I did, in the thought that I was conserving pci address space.

Yes, there is.  There's a particular quad tulip card that seems to have
256k of boot rom for each of it's IO processors, but which only seems to
get 1MB of BAR space for its bridge, so obviously, when it allocates ROM
bars, they don't fit.

However, check out what happens for this adapter.  I believe
pci_request_regions() is now more selective about which BARs it maps.

> > - ipr_alloc_mem() can not simply issue a call to ipr_free_mem() when
> >   something goes wrong as it would lead to pci_free_consistent() of
> >   unset data. Let ipr_alloc_mem() carefully release whatever it has
> >   allocated instead;
> 
> pci_free_consistent specifically checks for NULL, just like kfree. I 
> figured it was cleaner code to rely on the ability to call kfree on NULL 
> and pci_free_consistent on NULL. Is this frowned upon?

The API doesn't say that.  It works on x86 because dma_free_coherent()
calls free_pages(), which checks for NULLs, but I think you'll find it
will produce a panic or warning on other platforms (arm seems to dump
stack at least).

James



From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] [scsi] Remove __GFP_DMA
Date: Wed, 23 May 2007 20:38:46 +0100
Message-ID: <20070523203846.41ac5011@the-village.bc.nu>
References: <20070521151525.GA581@suse.de>
	<Pine.LNX.4.64.0705221443030.16285@schroedinger.engr.sgi.com>
	<6d6a94c50705221941y63f4db7bj174a2265d9eaa61a@mail.gmail.com>
	<1179933494.3700.16.camel@mulgrave.il.steeleye.com>
	<AE4F746F2AECFC4DA4AADD66A1DFEF019E1BDA@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35777 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754956AbXEWTfH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 15:35:07 -0400
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1BDA@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Aubrey Li <aubreylee@gmail.com>, Christoph Lameter <clameter@sgi.com>, Bernhard Walle <bwalle@suse.de>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org

On Wed, 23 May 2007 15:17:08 -0400
"Salyzyn, Mark" <mark_salyzyn@adaptec.com> wrote:

> The 31 bit limit for some of these cards is a problem, we currently only
> do __GFP_DMA for bounce buffer sg elements allocated for user supplied
> references in ioctls.
> 
> I figure we should be using pci_alloc_consistent calls for these
> allocations to more accurately acquire memory within the 31 bit limit if
> necessary, we could switch to these to remove the need for the __GFP_DMA
> flag in the aacraid driver?

That didn't used to work right on the AMD boards when I tried it last as
we ended up with a buffer that was mapped by the IOMMU for some reason
and that was not below 2GB.


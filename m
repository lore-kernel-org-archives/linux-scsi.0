From: Alan Cox <alan@redhat.com>
Subject: Re: PATCH: Further aacraid work
Date: Thu, 17 Jun 2004 10:02:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040617140229.GB10138@devserv.devel.redhat.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FD23FF9@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:22716 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S266497AbUFQOCw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 10:02:52 -0400
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189FD23FF9@otce2k03.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Alan Cox <alan@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Jun 17, 2004 at 08:53:36AM -0400, Salyzyn, Mark wrote:
> available. Since the scsi layer has a propensity to provide sequentially
> decreasing pages (sequentially increasing would permit coalescing of SG
> elements) for the SG elements, we find that there is an average SG
> element size of 4K.

That ought to be a case of flipping the way the kernel hands out pages.
I've always wondered why we get them often in reverse order but never
sat down and worked it out

> more than 4G of memory; however we *are* having troubles specifically
> with AMD64 systems with more than 4G of memory in 2.6 kernels (the issue
> does not occur on 2.4 kernels). I have yet to investigate why this
> specific problem exists.

The AMD64 is a little unusual in that it has an IO MMU, so requests for
mappings that are physically high memory, not easy to merge, etc can
be made to appear in a convenient order lower down in memory. Thus
asking to map memory at virtual addresses above 4Gb probably hands back
a PCI address around 3.5Gb. That mapping will also vanish (gone forever
and the PCI address will show other data instead) when you unmap it.



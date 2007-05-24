From: Christoph Lameter <clameter@sgi.com>
Subject: RE: [PATCH] [scsi] Remove __GFP_DMA
Date: Thu, 24 May 2007 10:22:24 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0705241020040.29126@schroedinger.engr.sgi.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1CAA@otce2k301.adaptec.com>
 <1180018752.3692.16.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0705240959310.28086@schroedinger.engr.sgi.com>
 <1180026917.3692.47.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34318 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750837AbXEXRWZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 May 2007 13:22:25 -0400
In-Reply-To: <1180026917.3692.47.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Aubrey Li <aubreylee@gmail.com>, Bernhard Walle <bwalle@suse.de>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>

On Thu, 24 May 2007, James Bottomley wrote:

> The idea was basically to match an allocation to a device mask.  I was
> going to do a generic implementation (which would probably kmalloc,
> check the physaddr and fall back to GFP_DMA if we were unlucky) but
> allow the architectures to override.

Hmmmm... We could actually implement something like it in the slab 
allocators. The mask parameter would lead the allocator to check if the 
objects are in a satisfactory range. If not it could examine its partial 
lists for slabs that satisfy the range. If that does not work then it 
would eventually go to the page allocator to ask for a page in a fitting 
range.

That wont be fast though. How performance sensitive are the allocations?


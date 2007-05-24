From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] [scsi] Remove __GFP_DMA
Date: Thu, 24 May 2007 12:15:17 -0500
Message-ID: <1180026917.3692.47.camel@mulgrave.il.steeleye.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1CAA@otce2k301.adaptec.com>
	 <1180018752.3692.16.camel@mulgrave.il.steeleye.com>
	 <Pine.LNX.4.64.0705240959310.28086@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752098AbXEXRPh@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705240959310.28086@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Lameter <clameter@sgi.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Aubrey Li <aubreylee@gmail.com>, Bernhard Walle <bwalle@suse.de>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2007-05-24 at 10:00 -0700, Christoph Lameter wrote:
> On Thu, 24 May 2007, James Bottomley wrote:
> 
> > > Going to ensure that we have a 31 bit (not 32 bit) physical address?
> > 
> > No, unfortunately.  Implementing kmalloc_mask() and kmalloc_dev() was
> > something I said I'd do ... about two years ago.
> 
> Tell me more about these ideas. 

Oh, it was this Kernel Summit presentation which discussed it

http://licensing.steeleye.com/support/papers/kernel_summit_iommu.pdf

The writeup of the session is here:

http://lwn.net/Articles/144100/

The idea was basically to match an allocation to a device mask.  I was
going to do a generic implementation (which would probably kmalloc,
check the physaddr and fall back to GFP_DMA if we were unlucky) but
allow the architectures to override.

However, the majority of need (except for the aacraid like devices) was
solved by GFP_DMA32

James

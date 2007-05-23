From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] [scsi] Remove __GFP_DMA
Date: Wed, 23 May 2007 10:18:14 -0500
Message-ID: <1179933494.3700.16.camel@mulgrave.il.steeleye.com>
References: <20070521151525.GA581@suse.de>
	 <Pine.LNX.4.64.0705221443030.16285@schroedinger.engr.sgi.com>
	 <6d6a94c50705221941y63f4db7bj174a2265d9eaa61a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34132 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756366AbXEWPSR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 11:18:17 -0400
In-Reply-To: <6d6a94c50705221941y63f4db7bj174a2265d9eaa61a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aubrey Li <aubreylee@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>, Bernhard Walle <bwalle@suse.de>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 10:41 +0800, Aubrey Li wrote:
> On 5/23/07, Christoph Lameter <clameter@sgi.com> wrote:
> > On Mon, 21 May 2007, Bernhard Walle wrote:
> >
> > > [PATCH] [scsi] Remove __GFP_DMA
> > >
> > > After 821de3a27bf33f11ec878562577c586cd5f83c64, it's not necessary to alloate a
> > > DMA buffer any more in sd.c.
> > >
> > > Signed-off-by: Bernhard Walle <bwalle@suse.de>
> >
> > Great that avoids a DMA kmalloc slab. Any other GFP_DMAs left in the scsi
> > layer?
> >
> > Acked-by: Christoph Lameter <clameter@sgi.com>
> 
> Yes, here is another patch

I'll defer to Mark on this one.  However, please remember that you can't
just blindly remove GFP_DMA ... there are some cards which require it.

Aacraid is one example ... it has a set of cards that can only DMA to 31
bits.  For them, the GFP_DMA is necessary:  The allocation in question
is a scatterlist, which must be within the device DMA mask.

James



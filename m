From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] mpt2sas: Fall back to 64 bit coherent mask if 64 bit DMA / 32 bit coherent mask not supported
Date: Wed, 13 May 2015 15:31:09 +0200
Message-ID: <10045033.4fV0qQU90u@wuerfel>
References: <555279A8.6060906@linux.vnet.ibm.com> <2214146.EzgWBA6g23@wuerfel> <5553505D.50102@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:60051 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932597AbbEMNbc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2015 09:31:32 -0400
In-Reply-To: <5553505D.50102@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Daniel Kreling <kreling@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>

On Wednesday 13 May 2015 08:23:41 Brian King wrote:
> On 05/13/2015 03:10 AM, Arnd Bergmann wrote:
> > On Tuesday 12 May 2015 18:24:43 Brian King wrote:
> >>
> >> Commit 5fb1bf8aaa832e1e9ca3198de7bbecb8eff7db9c broke 64 bit DMA for mpt2sas on Power.
> >> That commit changed the sequence for setting up the DMA and coherent DMA masks so
> >> that during initialization the driver requests a 64 bit DMA mask and a 32 bit consistent
> >> DMA mask, then later requests a 64 bit consistent DMA mask. The Power architecture does
> >> not currently support this, which results in always falling back to a 32 bit DMA window,
> >> which has a negative impact on performance. Tweak this algorithm slightly so that
> >> if requesting a 32 bit consistent mask fails after we've successfully set a 64 bit
> >> DMA mask, just try to get a 64 bit consistent mask. This should preserve existing
> >> behavior on platforms that support mixed mask setting and restore previous functionality
> >> to those that do not.
> >>
> >> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> > 
> > I believe the way the API is designed, it should guarantee that after dma_set_mask()
> > succeeds for a device, dma_set_coherent_mask() with the same mask will also succeed.
> > 
> > Could you just call dma_set_mask_and_coherent() here to avoid that complex logic?
> 
> I don't think that would work. The mpt2sas driver wants to set the dma mask to 64bits
> but set the coherent mask to 32 bits, then my change is to set the coherent mask to
> 64bits if setting it to 32bit fails. I'm not seeing how using dma_set_mask_and_coherent
> would simplify anything here.

My question was more about why the driver would ask for a 32-bit coherent
mask to start with. Is this a limitation in the mpt2sas device that can
only have descriptors at low addresses, or is it trying to work around some
bug in a particular host system?

	Arnd

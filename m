From: "David S. Miller" <davem@redhat.com>
Subject: Re: [BUG] x86_64 pci_map_sg modifies sg list - fails multiple
 map/unmaps
Date: Mon, 5 Jan 2004 13:01:18 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040105130118.0cb404b8.davem@redhat.com>
References: <200401051929.i05JTsM0000014248@mudpuddle.cs.wustl.edu.suse.lists.linux.kernel>
	<20040105112800.7a9f240b.davem@redhat.com.suse.lists.linux.kernel>
	<p73brpi1544.fsf@verdi.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pizda.ninka.net ([216.101.162.242]:61581 "EHLO pizda.ninka.net")
	by vger.kernel.org with ESMTP id S265697AbUAEVG4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2004 16:06:56 -0500
In-Reply-To: <p73brpi1544.fsf@verdi.suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gibbs@scsiguy.com

On 05 Jan 2004 22:02:19 +0100
Andi Kleen <ak@suse.de> wrote:

> It sets length to zero to terminate the list when entries were merged.
> It doesn't have a dma_length.

I understand, and you are defining dma_length to just use the
normal sg->length field, and I'm trying to explain to you that this
is not allowed.  If you want to modify the length field to zero terminate
the DMA chunks, you must have a seperate dma_length field in your
platforms scatterlist structure.

Again, for the 3rd time, see what sparc64 is doing here.

> It tripping over remapped lists is an side effect, but an useful one 
> because remapping is not supported (merging destroys information that
> cannot be reconstructed). If the bug didn't exist you would get data
> corruption.

You should not be modifying any portion of the non-DMA fields.
Therefore, if the SG is unmapped, then passed into your IOMMU code for
a future map call, it should just work.


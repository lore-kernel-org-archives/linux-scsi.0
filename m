From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: SCSI breakage on non-cache coherent architectures
Date: Mon, 19 Nov 2007 16:35:23 +1100
Message-ID: <1195450523.7022.37.camel@pasglop>
Reply-To: benh@kernel.crashing.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:37660 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbXKSFgB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 00:36:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Russell King <rmk@arm.linux.org.uk>

Hi James !

(Please CC me on replies as I'm not subscribed to linux-scsi)

I've been debugging various issues on the PowerPC 44x embedded
architecture which happens to have non-coherent PCI DMA.

One of the problem I'm hitting is that one really need to enforce
kmalloc alignement to cache lines or bad things will happen (among
others with USB), for some reasons, powerpc failed to do so, I fixed it.

The other one I'm hitting now is that the SCSI layer nowadays embeds the
sense_buffer inside the scsi_cmnd structure without any kind of
alignment whatsoever. I've been hitting irregulary is a crash on SCSI command
completion that seems to be related to corruption of the "request"
pointer in struct scsi_cmnd and I think it might be the cause.
I'm now trying to setup a proper repro-case.

The sense buffer is something that is written to by the device, thus it
gets cache invalidated when the DMA happens, potentially losing whatever
was sharing the cache line, which includes, among other things, that
"request" pointer field.

There are other issues as well if any of the fields sharing the cache
line happens to be read while the DMA is in progress, it would
populate the cache with memory content prior to the DMA being completed.

It's fairly important on such architectures not to share cache lines
between objects being DMA'd to/from and the rest of the system. If the
DMA is strictly outgoing, it's generally ok, but not if the DMA is
bidirectional or the device is writing to memory.

I'm not sure what is the best way to fix that. Internally, I've done
some test whacking some ____cacheline_aligned in the scsi_cmnd data
structure to verify I no longer get random SLAB corruption when using my
USB but that significantly bloats the size of the structure on archs
such as ppc64 that don't need it and have a large cache line size.

Unfortunately, I don't think there's any existing Kconfig symbol or arch
provided #define to tell us that we are on a non-coherent arch afaik
that could be used to make that conditional.

Another option would be to kmalloc the buffer (wasn't it the case before
btw ?) but I suppose some people will scream at the idea due to how the
command pools are done...

What do you suggest ?

Cheers,
Ben.



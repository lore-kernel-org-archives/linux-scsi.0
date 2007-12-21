From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/2] scsi: Use new __dma_buffer to align sense buffer in
 scsi_cmnd
Date: Fri, 21 Dec 2007 10:33:26 +0000
Message-ID: <20071221103326.7ce1bc4f@the-village.bc.nu>
References: <20071221023011.4C4BADDDFA@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49641 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751393AbXLUKn1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Dec 2007 05:43:27 -0500
In-Reply-To: <20071221023011.4C4BADDDFA@ozlabs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, rdreier@cisco.com, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk, davem@davemloft.net, james.bottomley@steeleye.com, ralf@linux-mips.org

On Fri, 21 Dec 2007 13:30:08 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> The sense buffer ins scsi_cmnd can nowadays be DMA'ed into directly
> by some low level drivers (that typically happens with USB mass
> storage).

Should that not be fixed in USB storage by using pci_alloc_coherent on the
PCI device of the hub not peeing directly into kernel space ?

It's also incomplete as a fix because I don't see what guarantees the
buffer size will always exceed cache line size

Alan

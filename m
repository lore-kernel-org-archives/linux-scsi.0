From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
Date: Mon, 9 Jun 2008 18:36:29 +0900
Message-ID: <20080609184052Z.fujita.tomonori@lab.ntt.co.jp>
References: <20080606213659.GC15085@il.ibm.com>
	<da824cf30806061451p4005a4ecoa9af8687e3ec51e5@mail.gmail.com>
	<87lk1fqayg.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:43095 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758288AbYFIJkT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2008 05:40:19 -0400
In-Reply-To: <87lk1fqayg.fsf@basil.nowhere.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andi@firstfloor.org
Cc: grundler@google.com, muli@il.ibm.com, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mgross@linux.intel.com, linux-scsi@vger.kernel.org

On Mon, 09 Jun 2008 10:17:11 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> "Grant Grundler" <grundler@google.com> writes:
> >
> > The historical DMA mapping "failure mode" is a kernel panic.  Resizing or
> 
> Hasn't been for a long time, except in some extreme cases.  All drivers
> are expected to check return values for a long time now.

Agreed, but I think that lots of network drivers still assume that DMA
mapping always succeeds (they don't check return values).

Most of the SCSI drivers were fixed in this regard. Very old HBA
drivers (that are unlikely to be used with an IOMMU) just
crashes. Recent HBA drivers can handle the dma mapping failure (as far
as I know, the only exception is cciss.

Old IOMMU code has "failure mode" but new IOMMU code like VT-d doesn't
crash on the failure. Now drivers need to handle the dma mapping
failure properly.

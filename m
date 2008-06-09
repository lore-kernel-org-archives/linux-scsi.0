From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
Date: Mon, 9 Jun 2008 12:20:25 +0200
Message-ID: <20080609102025.GB21661@one.firstfloor.org>
References: <20080606213659.GC15085@il.ibm.com> <da824cf30806061451p4005a4ecoa9af8687e3ec51e5@mail.gmail.com> <87lk1fqayg.fsf@basil.nowhere.org> <20080609184052Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:41331 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760106AbYFIKKc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2008 06:10:32 -0400
Content-Disposition: inline
In-Reply-To: <20080609184052Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: andi@firstfloor.org, grundler@google.com, muli@il.ibm.com, linux-kernel@vger.kernel.org, mgross@linux.intel.com, linux-scsi@vger.kernel.org

On Mon, Jun 09, 2008 at 06:36:29PM +0900, FUJITA Tomonori wrote:
> On Mon, 09 Jun 2008 10:17:11 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > "Grant Grundler" <grundler@google.com> writes:
> > >
> > > The historical DMA mapping "failure mode" is a kernel panic.  Resizing or
> > 
> > Hasn't been for a long time, except in some extreme cases.  All drivers
> > are expected to check return values for a long time now.
> 
> Agreed, but I think that lots of network drivers still assume that DMA
> mapping always succeeds (they don't check return values).

Those should be just fixed. 

You're right. I reviewed some new drivers and was surprised that they
even got that wrong (code reviewers were supposed to flag this in the
first place)

I would guess in practice the main offender would be tg3.c/bnx2.c.
On the other hand Intel IOMMU systems should usually use e1000e which
checks.

-Andi

From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
Date: Sat, 7 Jun 2008 00:36:59 +0300
Message-ID: <20080606213659.GC15085@il.ibm.com>
References: <20080604235053K.fujita.tomonori@lab.ntt.co.jp> <da824cf30806041106p1de2355fg38594fcb9dcbf203@mail.gmail.com> <20080606202119.GQ15085@il.ibm.com> <da824cf30806061428t4b7ed816i74d961946d77c88b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:32452 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbYFFViK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 17:38:10 -0400
Content-Disposition: inline
In-Reply-To: <da824cf30806061428t4b7ed816i74d961946d77c88b@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, mgross@linux.intel.com, linux-scsi@vger.kernel.org

On Fri, Jun 06, 2008 at 02:28:36PM -0700, Grant Grundler wrote:

> Historically the IOMMUs needed physically contiguous memory and
> resizing essentially meant quiescing all DMA, moving the IO Pdir
> data to the new bigger location, allocating a new bitmap and cloning
> the state into that as well, and then resuming DMA operations. The
> DMA quiesce requirement effectively meant a reboot. My understanding
> of Vt-d is the ranges can be added range at a time and thus can be
> easily resized.

VT-d uses a multi-level page-table, so there would be no problem
resizing.

> But it will mean more complex logic in the IOMMU bitmap handling for
> a domain which owns multiple bitmaps and thus a slightly higher CPU
> utilization cost. At least that's my guess. I'm not working on any
> IOMMU code lately...

The logic seems pretty simple to me, all we need to do is keep track
of how many entries are currently allocated in the bitmap vs. the size
of the bitmap. Once we get to the half-way point, double the size of
the bitmap. Having said that, I'm not sure it's worth it, and have no
plans to implement it :-)

Cheers,
Muli

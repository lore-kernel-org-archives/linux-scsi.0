From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
 blk_recalc_rq_segments about VMERGE
Date: Wed, 16 Jul 2008 09:34:36 +0900
Message-ID: <20080716093456J.fujita.tomonori@lab.ntt.co.jp>
References: <Pine.LNX.4.64.0807151033040.25390@devserv.devel.redhat.com>
	<20080716003047P.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.0807151143050.29803@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46518 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbYGPAfG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2008 20:35:06 -0400
In-Reply-To: <Pine.LNX.4.64.0807151143050.29803@devserv.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mpatocka@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, davem@davemloft.net, linux-parisc@vger.kernel.org

On Tue, 15 Jul 2008 11:46:46 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> >> Even if we fix it now, the question is: how long it will stay fixed? Until
> >> someone makes another change to struct device that restricts boundaries on
> >> some wacky hardware.
> >
> > I'm not sure how the boundary restriction of a device can break
> > the VMERGE accounting.
> 
> Because block layer code doesn't know anything about the device, pci 
> access restrictions and so on.

Not true, the block layer knows about the device restrictions like DMA
boundary.

But it's not the point here because the boundary restriction doesn't
matter for the VMERGE accounting. An IOMMU just returns an error if it
can't allocate an I/O space fit for the device restrictions.


Please give me an example how the boundary restriction of a device can
break the VMERGE accounting and an IOMMU if you aren't still sure.

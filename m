From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: PATCH: Further aacraid work
Date: Fri, 18 Jun 2004 10:17:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087571840.8207.270.camel@gaston>
References: <286GI-5y3-11@gated-at.bofh.it> <286Qp-5EU-19@gated-at.bofh.it>
	 <m3smcut2z0.fsf@averell.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:4741 "EHLO gate.crashing.org")
	by vger.kernel.org with ESMTP id S265255AbUFRPVR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2004 11:21:17 -0400
In-Reply-To: <m3smcut2z0.fsf@averell.firstfloor.org>
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: Anton Blanchard <anton@samba.org>, mark_salyzyn@adaptec.com, Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@redhat.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org


> The AMD64 IOMMU could do it too (and the code to do it exists in
> 2.6). But the problem is that the current IO layer doesn't provide a
> sufficient fallback path when this fails. You have to promise in
> advance that you can merge and then later it's too late to change your
> mind without signalling an IO error.

Well, the way I do it on ppc64 works with failure cases too. The IO
layer is given my phusical limitations, that is it provides me with an
SG list that will always fit. If I can do merging, great, that will
improve, but I don't enforce merging.

You could do exactly the same.

The problem I agree is that this forces the IO layer to give you small
enough requests, it would be nice to have a "try big and retry smaller"
path but that require invasive changes.

> I had a chat with James about this at last year's OLS. The Consensus
> was iirc that it needs driver interface changes at least.

Ben.


From: Alan Cox <alan@redhat.com>
Subject: Re: PATCH: Further aacraid work
Date: Thu, 17 Jun 2004 16:54:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040617205414.GE8705@devserv.devel.redhat.com>
References: <286GI-5y3-11@gated-at.bofh.it> <286Qp-5EU-19@gated-at.bofh.it> <m3smcut2z0.fsf@averell.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:31442 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S263147AbUFQUyv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 16:54:51 -0400
Content-Disposition: inline
In-Reply-To: <m3smcut2z0.fsf@averell.firstfloor.org>
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: Anton Blanchard <anton@samba.org>, mark_salyzyn@adaptec.com, Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Jun 17, 2004 at 09:10:43PM +0200, Andi Kleen wrote:
> The AMD64 IOMMU could do it too (and the code to do it exists in
> 2.6). But the problem is that the current IO layer doesn't provide a
> sufficient fallback path when this fails. You have to promise in
> advance that you can merge and then later it's too late to change your
> mind without signalling an IO error.

I would rather see it below the I/O layer for things like AMD64. The
reason I say this is that many drivers would suffer from iommu merging not
gain, and others may have limits.

Something like

	new_sglist = sg_squash(old_sglist, [target max segments], [max per seg])

could be used by drivers when appropriate to hand back a better sg list
(or if not possible the existing one). That would put control rather closer
to the driver. 

Alan


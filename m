From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] Separate target visibility from reaped state
	information
Date: Thu, 5 Nov 2015 09:50:23 +0100
Message-ID: <20151105085023.GA20249@lst.de>
References: <5633E9F2.5080209@sandisk.com> <5633EA4C.10608@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37210 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030329AbbKEIuZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Nov 2015 03:50:25 -0500
Content-Disposition: inline
In-Reply-To: <5633EA4C.10608@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jbottomley@parallels.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

A few things I noticed when looking over this and the previous iterations,
which are more notes for future work than an actual comment on this patch:

 - what lock protects ->visible and ->reaped (or previously ->state)?
   It seems like the synchronization rules in this code are a little
   fragile.
 - why don't we make the target visible as soon as we allocated it?
   We can still tear it down without a whole more effort even if it is
   visible.

From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Date: Wed, 17 Oct 2007 01:33:25 -0700 (PDT)
Message-ID: <20071017.013325.74747630.davem@davemloft.net>
References: <20071017140747Q.fujita.tomonori@lab.ntt.co.jp>
	<20071017072149.GC5041@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33066
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752450AbXJQIdO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 04:33:14 -0400
In-Reply-To: <20071017072149.GC5041@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Wed, 17 Oct 2007 09:21:49 +0200

> On Wed, Oct 17 2007, FUJITA Tomonori wrote:
> > Commit 2c941a204070ab32d92d40318a3196a7fb994c00 looks incomplete. The
> > helper functions like prepare_sg() need to support sg chaining too.
> 
> Thanks Tomo, applied. I'll get this pushed out later today with any
> other sg chaining fallout we may see.

I'm still debugging crashes on sparc64 early on boot even with this
latest fix applied.

I think there are still problems in functions like fill_sg().

There is a lot of confusion involving loop termination.  sg_next()
gives you a NULL after the last entry, but tests have been changed
to compare against sg_last() which is likely not what we want for
those checks.

I'll try to figure it out, just a heads up...

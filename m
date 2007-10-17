From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Date: Wed, 17 Oct 2007 02:13:05 -0700 (PDT)
Message-ID: <20071017.021305.74746838.davem@davemloft.net>
References: <20071017.013325.74747630.davem@davemloft.net>
	<20071017.014211.41637735.davem@davemloft.net>
	<20071017084528.GI5043@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55384
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754918AbXJQJMz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 05:12:55 -0400
In-Reply-To: <20071017084528.GI5043@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Wed, 17 Oct 2007 10:45:28 +0200

> Righto, it's invalid to call sg_next() on the last entry!

Unfortunately, that's what the sparc64 code wanted to do, this
transformation in the sparc64 sg chaining patch is not equilavent:

-	struct scatterlist *sg_end = sg + nelems;
+	struct scatterlist *sg_end = sg_last(sg, nelems);
 ...
-			while (sg < sg_end &&
+			while (sg != sg_end &&

No, that's not what the code was doing.  The while loop
has to process the last entry in the list,

We really needed "sg_end" to be "one past the last element",
rather than "the last element".

Since you say that sg_next() on the last entry is illegal,
and that's what this code would have done to try and reach
loop termination (it doesn't actually derefrence that
"end plus one" scatterlist entry) I'll try to code this up
some other way.

Besides, sg_last() is so absurdly expensive, it has to walk the entire
chain in the chaining case.  So better to implement this without it.

I would suggest that other sg_last() uses be audited for the same bug.

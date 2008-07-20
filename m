From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
 blk_recalc_rq_segments about VMERGE
Date: Sun, 20 Jul 2008 10:23:02 -0700 (PDT)
Message-ID: <20080720.102302.137955996.davem@davemloft.net>
References: <1216520228.3376.33.camel@localhost.localdomain>
	<20080719.210737.197246608.davem@davemloft.net>
	<1216565545.4199.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56508
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757572AbYGTRXD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jul 2008 13:23:03 -0400
In-Reply-To: <1216565545.4199.10.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: mpatocka@redhat.com, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sun, 20 Jul 2008 09:52:25 -0500

> Since we're using it successfully in parisc, I don't want the block code
> removed, but I don't see a reason to force other architectures to use
> it.
> 
> However, it has two use cases.  One is the legacy one of making rather
> dumb I/O cards perform better (which is the primary on on parisc), but
> there is a current one making huge transfers go through SCSI using using
> the sg_table code.  That latter is pretty vital to me since I have to
> keep the code working, but I don't really have any SCSI cards that can
> take advantage of it without virtual merging.  As a slight irony, IBM is
> trying to persuade me that a ppc would be better than a parisc for big
> endian I/O testing ... so I might just be seeing if I can make virtual
> merging work on power too.

All of this is gibberish, we've been over this a few times already
in this thread.

For a dumb I/O card, you advertise SG_ALL capabilities, the IOMMU
is going to merge things as it would have anyways, and you have
code in the driver to advance SG entries after each "dumb I/O".

There is zero value to the vmerge code, the real gains are being
realized already.

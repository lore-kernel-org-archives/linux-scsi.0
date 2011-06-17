From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] target: Add transport_handle_cdb_direct
	optimization
Date: Fri, 17 Jun 2011 14:01:39 +0200
Message-ID: <20110617120139.GA28409@lst.de>
References: <1307167290-24832-1-git-send-email-nab@linux-iscsi.org> <1307167290-24832-2-git-send-email-nab@linux-iscsi.org> <20110604140308.GB13359@lst.de> <4DFA55D6.8090101@redhat.com> <20110616192256.GA14124@lst.de> <4DFA83CA.60600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49227 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757868Ab1FQMBk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2011 08:01:40 -0400
Content-Disposition: inline
In-Reply-To: <4DFA83CA.60600@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Jun 16, 2011 at 03:29:30PM -0700, Andy Grover wrote:
> I don't think we should be making it easy on the core, I think we should
> be making it easy on the *fabrics*, if for no other reason that there
> are >1 of them, but only one core. Less code duplicated.

The userspace offload really is just a call to the workqueue code.  I
can't see how it can be made easier by moving it into the core, but if
there's a way to make it easier and I'm certainly not against it.

> Furthermore, many commands can be handled and generate a response
> without submitting a read/write request to the backstores, which is the
> only part that may need to sleep. If we decide all fabric calls to the
> core must be from a thread, then all fabrics that could've gotten a
> response to a command without context switching would then be the ones
> taking unneeded context switches.

There's actually a lot of those commands, but all of them are in the
slow path, that is discovery, error recovery, fail over, misc administration.
All the data path commands, and thas includes cache flushes and discards in
addition to reads and writes in various forms, actually need to do I/O and
allocations.

> It's not clear to me yet what the barriers to fabrics calling core APIs
> from interrupt are at this point. Do we just need to avoid GFP_KERNEL
> allocs? The architecture as-is may be pretty close to doing this, and
> then we'd be close to a reasonable framework.

It jut means a lot of irqsave locking, GFP_ATOMIC or conditional allocations
and generally a lot of pain.  If it would actually help with performance
that might be a worthwile tradeoff, but in the end we do require the process
context for all data path commands anyway.  Adding a new special case for
slow path commands doesn't seem like a worthwhile tradeoff to me.


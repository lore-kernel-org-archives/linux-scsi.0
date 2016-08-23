From: Keith Busch <keith.busch@intel.com>
Subject: Re: Oops when completing request on the wrong queue
Date: Tue, 23 Aug 2016 18:49:45 -0400
Message-ID: <20160823224945.GB11049@localhost.localdomain>
References: <87a8gltgks.fsf@linux.vnet.ibm.com>
 <871t1kq455.fsf@linux.vnet.ibm.com>
 <bb6f8757-4c3d-8f49-8aff-aa0fdb8bae89@kernel.dk>
 <8fc9ae38-9488-ef52-f620-08499edebffa@kernel.dk>
 <87shu0hfye.fsf@linux.vnet.ibm.com>
 <87a8g39pg4.fsf@linux.vnet.ibm.com>
 <43693064-dd37-92ce-7753-2a8edb43eab5@kernel.dk>
 <164a4c63-065b-b766-36f3-bcef4aa46a38@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:18326 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753563AbcHWWjW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Aug 2016 18:39:22 -0400
Content-Disposition: inline
In-Reply-To: <164a4c63-065b-b766-36f3-bcef4aa46a38@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org, Brian King <brking@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Aug 23, 2016 at 03:14:23PM -0600, Jens Axboe wrote:
> On 08/23/2016 03:11 PM, Jens Axboe wrote:
> >My workload looks similar to yours, in that it's high depth and with a
> >lot of jobs to keep most CPUs loaded. My bash script is different than
> >yours, I'll try that and see if it helps here.
> 
> Actually, I take that back. You're not using O_DIRECT, hence all your
> jobs are running at QD=1, not the 256 specified. That looks odd, but
> I'll try, maybe it'll hit something different.

I haven't recreated this either, but I think I can logically see why
this failure is happening.

I sent an nvme driver patch earlier on this thread to exit the hardware
context, which I thought would do the trick if the hctx's tags were
being moved. That turns out to be wrong for a couple reasons.

First, we can't release the nvmeq->tags when a hctx exits because
that nvmeq may be used by other namespaces that need to point to
the device's tag set.

The other reason is that blk-mq doesn't exit or init hardware contexts
when remapping for a CPU event, leaving the nvme driver unaware a hardware
context points to a different tag set.

So I think I see why this test would fail; don't know about a fix yet.
Maybe the nvme driver needs some indirection instead of pointing
directly to the tagset after init_hctx.

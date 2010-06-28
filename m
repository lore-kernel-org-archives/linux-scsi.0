From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request
 payload
Date: Mon, 28 Jun 2010 17:14:28 +0900
Message-ID: <20100628171218Q.fujita.tomonori@lab.ntt.co.jp>
References: <20100627110712.GA14511@lst.de>
	<20100627212952D.fujita.tomonori@lab.ntt.co.jp>
	<20100628075738.GA26606@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:44128 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab0F1IPE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jun 2010 04:15:04 -0400
In-Reply-To: <20100628075738.GA26606@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: fujita.tomonori@lab.ntt.co.jp, snitzer@redhat.com, axboe@kernel.dk, dm-devel@redhat.com, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org

On Mon, 28 Jun 2010 09:57:38 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Sun, Jun 27, 2010 at 09:32:07PM +0900, FUJITA Tomonori wrote:
> > On Sun, 27 Jun 2010 13:07:12 +0200
> > Christoph Hellwig <hch@lst.de> wrote:
> > 
> > > > How about this?
> > > 
> > > As I tried to explain before this utterly confuses the I/O completion
> > > path.  With the patch applied even a simple mkfs.xfs that issues discard
> > > just hangs.
> > 
> > Wired. I just tried mkfs.xfs against scsi_debug with my block patches
> > (I saw one discard command). Seemed that it worked fine.
> 
> I've tracked it down to the call to scsi_requeue_command in scsi_end_request.
> When the command is marked BLOCK_PC we'll just get it back as such in
> ->prep_fn next time, but now it's reverting to the previous state.

If scsi_end_request() calls scsi_requeue_command(), the command has a
left over (i.e. hasn't finished all the data), right? You hit such
condition with discard commands?

BLOCK_PC requests don't hit this case since blk_end_request() always
return false for PC.


> While I see the problems with leaking ressources in that case I still
> can't quite explain the hang I see.

Any way to reproduce the hang without ssd drives?

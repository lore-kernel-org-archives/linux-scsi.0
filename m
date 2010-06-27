From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request
 payload
Date: Mon, 28 Jun 2010 01:23:02 +0900
Message-ID: <20100628012055Y.fujita.tomonori@lab.ntt.co.jp>
References: <20100627212952D.fujita.tomonori@lab.ntt.co.jp>
	<20100627141638.GD3970@redhat.com>
	<20100627153545.GC25667@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:44740 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552Ab0F0QXg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jun 2010 12:23:36 -0400
In-Reply-To: <20100627153545.GC25667@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: snitzer@redhat.com, fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk, dm-devel@redhat.com, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org

On Sun, 27 Jun 2010 17:35:45 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Sun, Jun 27, 2010 at 10:16:40AM -0400, Mike Snitzer wrote:
> > My leak fixes have been tested extensively against all permuations of
> > devices with discards (ATA trim, SCSI UNMAP, SCSI WRTIE SAME w/ unmap=1).
> > 
> > I think we need to get Christoph's discard payload transformation
> > complete by fixing the leaks _without_ trying to rework how discard
> > commands are tagged, etc.  E.g. fix what Jens already has staged in
> > linux-2.6-block's 'for-next' and 'for-2.6.36'.
> > 
> > With that sorted out we can then look at longer term changes to cleanup
> > discard request processing.
> 
> I tend to agree.  I'll look into getting rid of treating discards as
> BLOCK_PC commands ontop of you patchset.

Let's start from jens' 2.6.36 tree (or it would be better if Jens can
drop Christoph's patch).

We don't need to start on the top of new discard hacks (specially, the
hack in scsi_finish_command looks terrible). We should not merge them
into mainline. We are still in rc3.

I'll see how things work with other configurations.

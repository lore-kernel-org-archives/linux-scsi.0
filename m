From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Should a block device enforce block atomicity?
Date: Mon, 30 Jun 2008 08:55:25 +0200
Message-ID: <20080630065525.GI20826@kernel.dk>
References: <ce513bcc0806292351t7f4ad933l920112381f4ebb4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:6958 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbYF3Gz1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jun 2008 02:55:27 -0400
Content-Disposition: inline
In-Reply-To: <ce513bcc0806292351t7f4ad933l920112381f4ebb4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Erez Zilber <erezzi.list@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jun 30 2008, Erez Zilber wrote:
> Hi,
> 
> I have a question about block devices and whether they are required to
> enforce block atomicity:
> 
> I read the code of drivers/block/brd.c, and I didn't see any locking
> when blocks are read/written. I also looked at the block layer code
> that calls brd and didn't find any locking there. Does it mean that
> there's no block atomicity (i.e. multiple threads can write a single
> block at the same time)? Is there any hidden assumption here? Is this
> the responsibility of the application to do that (e.g. not start a
> WRITE request before other READ/WRITE requests to the same block were
> completed)?

The block layer doesn't give such guarentees, not for "regular" block
devices either. If the IO goes through the page cache then that will
serialize IO to a given page, but with eg O_DIRECT IO, you could have
the same block in flight several times. So if you are doing raw IO, the
application has to ensure ordering of the same block.

-- 
Jens Axboe


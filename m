From: Christoph Hellwig <hch@infradead.org>
Subject: Re: blk-mq problem on proliant DL380 G3 (cciss)
Date: Thu, 30 Oct 2014 10:45:36 -0700
Message-ID: <20141030174536.GA27799@infradead.org>
References: <alpine.LRH.2.11.1410291233090.12885@adalberg.ut.ee>
 <alpine.LRH.2.11.1410291344220.12885@adalberg.ut.ee>
 <545102FE.3010003@kernel.dk>
 <20141029183828.GA31689@infradead.org>
 <alpine.LRH.2.11.1410292205060.16678@adalberg.ut.ee>
 <54514A7A.8050008@kernel.dk>
 <alpine.LRH.2.11.1410301317340.19899@adalberg.ut.ee>
 <20141030151955.GA12158@infradead.org>
 <alpine.LRH.2.11.1410301916490.13541@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44541 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933947AbaJ3Rpi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 13:45:38 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1410301916490.13541@adalberg.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

On Thu, Oct 30, 2014 at 07:32:52PM +0200, Meelis Roos wrote:
> > can you try the patch below?  It's a hack and not a proper fix, but it
> > addresses what seems to be your culprit, given that it is the only
> > place allocating a request from the error handler.
> 
> Applied it on top of 3.18-rc2, booted with scsi_mod.use_blk_mq=1 and it 
> booted up fine.

Jens,

any idea what we could do here?  We want to lock the door again ASAP
after potentially resetting the device state as far as I can read
the code (the commit message for it is utterly meaningless).

Right now the code allocates the request from the scsi EH thread, which
already is dangerous but mostly works for the !blk-mq case, but with the
strict only allocate a request if a tag is available policy this breaks
down if we still have BLOCK_PC requests that have references on them
blocking another request queued (ATA cdroms tend to have a queue depth
of 1).

Given that this always was best effort anyway we might want to move it
to a separate workqueue to not block EH?

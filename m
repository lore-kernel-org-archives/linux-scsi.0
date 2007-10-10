From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] [PATCH 1/1] blk request timeout handler patches
Date: Wed, 10 Oct 2007 19:04:42 +0200
Message-ID: <20071010170440.GP4984@kernel.dk>
References: <20071004181259.GA16689@us.ibm.com> <20071004181750.GB16689@us.ibm.com> <20071005124940.GA7863@kernel.dk> <20071009053610.GA17794@us.ibm.com> <20071009120048.GB13842@parisc-linux.org> <20071009121524.GO5241@kernel.dk> <1191945372.3294.28.camel@localhost.localdomain> <20071010122508.GL4984@kernel.dk> <20071010165809.GA27613@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:25549 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608AbXJJREr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2007 13:04:47 -0400
Content-Disposition: inline
In-Reply-To: <20071010165809.GA27613@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Wed, Oct 10 2007, malahal@us.ibm.com wrote:
> I don't see blk_delete_timer() actually calling mod_timer/del_timer at
> all.  Doesn't that mean, your timer would eventually expire for no
> reason and walk through the list unnecessarily?

Please stop top posting, thanks.

Yeah, it can only remove the request from the list. We could delete the
timer as well if the list is now empty, I'll now add that check.

It's part of the "design" that the timer may fire and find nothing to
do, my theory is that this is much cheaper than making the enqueue path
more costly. The latter is an absolute no-no, I'd much rather take the
one-timer-per-request hit than start engaging in any type of expiry
sorting or similar at request add time.

-- 
Jens Axboe


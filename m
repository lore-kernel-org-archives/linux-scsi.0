From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] [PATCH] Potential bug fix for blk_tag_queue
Date: Tue, 26 Aug 2008 10:58:52 +0200
Message-ID: <20080826085852.GV20055@kernel.dk>
References: <20080826005856.27375.59152.stgit@feynman.nuovasystems.com> <20080826024620.GC23698@parisc-linux.org> <20080826070046.GQ20055@kernel.dk> <34BDD2A93E5FD84594BB230DD6C18EA205B3437D@nuova-ex1.hq.nuovaimpresa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [93.163.65.50] ([93.163.65.50]:17981 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbYHZI6y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2008 04:58:54 -0400
Content-Disposition: inline
In-Reply-To: <34BDD2A93E5FD84594BB230DD6C18EA205B3437D@nuova-ex1.hq.nuovaimpresa.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Abhijeet Joglekar <ajoglekar@nuovasystems.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org


(please don't top post!)

On Tue, Aug 26 2008, Abhijeet Joglekar wrote:
> Ok, removing that works too. 
> 
> Shouldn't the BUG_ON be checking upto bqt->real_max_depth instead of
> bqt->depth?  
> 
> BUG_ON(find_first_bit(bqt->tag_map, bqt->real_max_depth) <
>                       bqt->real_max_depth);
> 
> 
> In cases where the tag map gets resized to a value less than the
> originally allocated tag map, blk_queue_resize_tags seems to be setting
> bqt->max_depth to the new_depth. 
> 
> There could still be outstanding tags max_depth <= t <= real_max_depth
> which might not get freed, which the BUG_ON will not capture if it
> checks against max_depth.

max_depth is fine, it's the safer choice. For the real_max_depth to
potentially catch any extra offenders, you would have to do a resize to
a larger depth, get bunch of IO issued, then resize down and shut down
the queue. Using real_max_depth should work as well, but then you have
to audit the ending of tags > max/real_max_depth. It looks ok, though.

-- 
Jens Axboe


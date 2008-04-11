From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/3] block: adds padding support to blk_rq_map_user_iov
Date: Fri, 11 Apr 2008 12:55:18 +0200
Message-ID: <20080411105517.GR12774@kernel.dk>
References: <1207837033-23835-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:12801 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803AbYDKKzX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2008 06:55:23 -0400
Content-Disposition: inline
In-Reply-To: <1207837033-23835-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Thu, Apr 10 2008, FUJITA Tomonori wrote:
> As discussed [*1], blk_rq_map_user_iov path is broken regarding
> padding at the moment. In 2.6.24, libata did padding but libata's
> padding code was removed and now libata expects the block layer to do
> that.
> 
> blk_rq_map_user does padding but blk_rq_map_user_iov doesn't so
> blk_rq_map_user_iov doesn't work in case libata needs padding (so far
> nobody has complained, maybe nobody uses blk_rq_map_user_iov
> interface).
> 
> This patchset adds padding support to blk_rq_map_user_iov. I converted
> convert bio_copy_user to bio_copy_user_iov, which uses a temporary
> kernel buffers.  blk_rq_map_user_iov uses bio_copy_user_iov when a low
> level driver needs padding or a buffer in sg_iovec isn't aligned. We
> can safely do padding in blk_rq_map_sg.
> 
> In the long run, I want to integrate several mapping APIs for PC
> commands (and new API should be useful for sg/st/osst) but I need more
> time to finish that work.
> 
> This is against the latest Linus tree. Can we merge this after 2.6.25?

Thanks Tomo, this looks good to me know. I'll queue it up.

-- 
Jens Axboe


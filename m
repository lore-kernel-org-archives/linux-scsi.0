From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 0/3] block: adds padding support to blk_rq_map_user_iov
Date: Fri, 11 Apr 2008 14:43:27 +0900
Message-ID: <47FEFA7F.8010900@gmail.com>
References: <1207837033-23835-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.233]:25457 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbYDKFne (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Apr 2008 01:43:34 -0400
Received: by qb-out-0506.google.com with SMTP id e11so371426qbe.15
        for <linux-scsi@vger.kernel.org>; Thu, 10 Apr 2008 22:43:34 -0700 (PDT)
In-Reply-To: <1207837033-23835-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>

FUJITA Tomonori wrote:
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

Haven't really reviewed line by line but generally looks good to me.

Thanks.

-- 
tejun

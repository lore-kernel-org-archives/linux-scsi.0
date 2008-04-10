From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/3] block: adds padding support to blk_rq_map_user_iov
Date: Thu, 10 Apr 2008 23:17:10 +0900
Message-ID: <1207837033-23835-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:41208 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631AbYDJOT6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Apr 2008 10:19:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

As discussed [*1], blk_rq_map_user_iov path is broken regarding
padding at the moment. In 2.6.24, libata did padding but libata's
padding code was removed and now libata expects the block layer to do
that.

blk_rq_map_user does padding but blk_rq_map_user_iov doesn't so
blk_rq_map_user_iov doesn't work in case libata needs padding (so far
nobody has complained, maybe nobody uses blk_rq_map_user_iov
interface).

This patchset adds padding support to blk_rq_map_user_iov. I converted
convert bio_copy_user to bio_copy_user_iov, which uses a temporary
kernel buffers.  blk_rq_map_user_iov uses bio_copy_user_iov when a low
level driver needs padding or a buffer in sg_iovec isn't aligned. We
can safely do padding in blk_rq_map_sg.

In the long run, I want to integrate several mapping APIs for PC
commands (and new API should be useful for sg/st/osst) but I need more
time to finish that work.

This is against the latest Linus tree. Can we merge this after 2.6.25?


[*1]
http://marc.info/?t=120716961000004&r=1&w=2



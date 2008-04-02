From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/2] block: blk_rq_map/unamp patches
Date: Thu,  3 Apr 2008 01:52:58 +0900
Message-ID: <1207155180-8069-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:48361 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755692AbYDBQza (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Apr 2008 12:55:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, htejun@gmail.com, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp

I'm still working to convert sg (st and osst) to use the blk mapping
API. Here's two patches for these functions that I like to be merged
into mainline before that work.

The first patch is a repost with a proper description, a patch to move
the padding adjustment from blk_rq_map_user to blk_rq_map_sg. This
patch affects only libata and I tested this patch with my CD-R drive
using libata and it works fine. Tejun, does this change break
something in libata?

The second patch changes blk_rq_unmap_user to take a request instead
of a bio. A pointer to a bio is added to request struct (Mike did the
same thing when adding multiple bio support to the API). I know that
it's not nice to add something to request struct, however, the
asymmetry of the map/unmap API lead to trouble easily (it led to bugs
in the past). I think that it worth doing that to avoid future
trouble.

Jens, any comments?




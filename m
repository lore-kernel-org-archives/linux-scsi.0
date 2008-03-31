From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 5/5] bsg: no need to set BSG_F_BLOCK bit in bsg_complete_all_commands
Date: Mon, 31 Mar 2008 10:03:42 +0900
Message-ID: <1206925422-4722-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: 20080331092020R.fujita.tomonori@lab.ntt.co.jp
 <1206925422-4722-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206925422-4722-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206925422-4722-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206925422-4722-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206925422-4722-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:58056 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbYCaBFL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2008 21:05:11 -0400
In-Reply-To: <1206925422-4722-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, pw@osc.edu, tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

Before bsg_complete_all_commands is called, BSG_F_BLOCK bit is always
set.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/bsg.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 9339981..302ac1f 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -467,8 +467,6 @@ static int bsg_complete_all_commands(struct bsg_device *bd)
 
 	dprintk("%s: entered\n", bd->name);
 
-	set_bit(BSG_F_BLOCK, &bd->flags);
-
 	/*
 	 * wait for all commands to complete
 	 */
-- 
1.5.3.7


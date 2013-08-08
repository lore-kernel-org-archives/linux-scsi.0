From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V2 2/8] [SCSI] tgt: add __user annotation
Date: Thu, 08 Aug 2013 10:14:04 +0900
Message-ID: <002501ce93d4$928ac1c0$b7a04540$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:63169 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168Ab3HHBOF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2013 21:14:05 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MR60055PU2A8TE0@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 08 Aug 2013 10:14:04 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: 'James Bottomley' <jejb@kernel.org>, linux-scsi@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>

Added __user annotation to fix the following sparse warnings:

drivers/scsi/scsi_tgt_lib.c:365:45: warning: incorrect type in argument 4 (different address spaces)
drivers/scsi/scsi_tgt_lib.c:365:45:    expected void [noderef] <asn:1>*<noident>
drivers/scsi/scsi_tgt_lib.c:365:45:    got void *<noident>

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No changes since v1:

 drivers/scsi/scsi_tgt_lib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 84a1fdf..bd82ea6 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -362,7 +362,8 @@ static int scsi_map_user_pages(struct scsi_tgt_cmd *tcmd, struct scsi_cmnd *cmd,
 	int err;
 
 	dprintk("%lx %u\n", uaddr, len);
-	err = blk_rq_map_user(q, rq, NULL, (void *)uaddr, len, GFP_KERNEL);
+	err = blk_rq_map_user(q, rq, NULL, (void __user *)uaddr, len,
+			      GFP_KERNEL);
 	if (err) {
 		/*
 		 * TODO: need to fixup sg_tablesize, max_segment_size,
-- 
1.7.10.4



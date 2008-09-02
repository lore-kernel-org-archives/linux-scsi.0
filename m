From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/2] sg: set dxferp to NULL for READ with the older SG interface
Date: Tue,  2 Sep 2008 16:20:20 +0900
Message-ID: <1220340020-4855-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220340020-4855-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220340020-4855-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:34131 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbYIBHVr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 03:21:47 -0400
In-Reply-To: <1220340020-4855-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jpyFUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

With the older SG interface, we don't know a user-space address to
trasfer data when executing a SCSI command. So we can't pass a
user-space address to blk_rq_map_user.

This patch fixes sg to pass a NULL user-space address to
blk_rq_map_user so that it just sets up a request and bios with page
frames propely without data transfer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ed69292..50c07bc 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -615,7 +615,10 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	else
 		hp->dxfer_direction = (mxsize > 0) ? SG_DXFER_FROM_DEV : SG_DXFER_NONE;
 	hp->dxfer_len = mxsize;
-	hp->dxferp = (char __user *)buf + cmd_size;
+	if (hp->dxfer_direction == SG_DXFER_TO_DEV)
+		hp->dxferp = (char __user *)buf + cmd_size;
+	else
+		hp->dxferp = NULL;
 	hp->sbp = NULL;
 	hp->timeout = old_hdr.reply_len;	/* structure abuse ... */
 	hp->flags = input_size;	/* structure abuse ... */
-- 
1.5.4.2


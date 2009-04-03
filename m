From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] sg: fix iovec bugs introduced by the block layer conversion
Date: Fri, 3 Apr 2009 09:12:20 +0900
Message-ID: <20090403091215K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:47180 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343AbZDCAMb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Apr 2009 20:12:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org

This is a fix for another fallout of the block layer conversion (sorry).

This should be go into 2.6.28.y and 2.6.29.y.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] sg: fix iovec bugs introduced by the block layer conversion

- needs to use copy_from_user for iovec before passing it to
blk_rq_map_user_iov().

- before the block layer conversion, if ->dxfer_len and sum of iovec
disagrees, the shorter one wins. However, currently sg returns
-EINVAL. This restores the old behavior.

Cc: stable@kernel.org
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ffc8785..1e40518 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1656,10 +1656,30 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 		md->null_mapped = hp->dxferp ? 0 : 1;
 	}
 
-	if (iov_count)
-		res = blk_rq_map_user_iov(q, rq, md, hp->dxferp, iov_count,
-					  hp->dxfer_len, GFP_ATOMIC);
-	else
+	if (iov_count) {
+		int len, size = sizeof(struct sg_iovec) * iov_count;
+		struct iovec *iov;
+
+		iov = kmalloc(size, GFP_ATOMIC);
+		if (!iov)
+			return -ENOMEM;
+
+		if (copy_from_user(iov, hp->dxferp, size)) {
+			kfree(iov);
+			return -EFAULT;
+		}
+
+		len = iov_length(iov, iov_count);
+		if (hp->dxfer_len < len) {
+			iov_count = iov_shorten(iov, iov_count, hp->dxfer_len);
+			len = hp->dxfer_len;
+		}
+
+		res = blk_rq_map_user_iov(q, rq, md, (struct sg_iovec *)iov,
+					  iov_count,
+					  len, GFP_ATOMIC);
+		kfree(iov);
+	} else
 		res = blk_rq_map_user(q, rq, md, hp->dxferp,
 				      hp->dxfer_len, GFP_ATOMIC);
 
-- 
1.6.0.6


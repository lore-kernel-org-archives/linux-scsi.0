From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 05/21] target: Convert target_core_rd.c to use use BUG_ON
Date: Wed, 17 Aug 2011 23:17:09 +0000
Message-ID: <1313623045-15916-6-git-send-email-nab@linux-iscsi.org>
References: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58301 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1HQXmW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 19:42:22 -0400
In-Reply-To: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Julia Lawall <julia@diku.dk>

From: Julia Lawall <julia@diku.dk>

Use BUG_ON(x) rather than if(x) BUG();

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ identifier x; @@
-if (x) BUG();
+BUG_ON(x);

@@ identifier x; @@
-if (!x) BUG();
+BUG_ON(!x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_rd.c |   24 ++++++++----------------
 1 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 3dd81d2..e567e12 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -390,12 +390,10 @@ static int rd_MEMCPY_read(struct rd_request *req)
 				length = req->rd_size;
 
 			dst = sg_virt(&sg_d[i++]) + dst_offset;
-			if (!dst)
-				BUG();
+			BUG_ON(!dst);
 
 			src = sg_virt(&sg_s[j]) + src_offset;
-			if (!src)
-				BUG();
+			BUG_ON(!src);
 
 			dst_offset = 0;
 			src_offset = length;
@@ -415,8 +413,7 @@ static int rd_MEMCPY_read(struct rd_request *req)
 				length = req->rd_size;
 
 			dst = sg_virt(&sg_d[i]) + dst_offset;
-			if (!dst)
-				BUG();
+			BUG_ON(!dst);
 
 			if (sg_d[i].length == length) {
 				i++;
@@ -425,8 +422,7 @@ static int rd_MEMCPY_read(struct rd_request *req)
 				dst_offset = length;
 
 			src = sg_virt(&sg_s[j++]) + src_offset;
-			if (!src)
-				BUG();
+			BUG_ON(!src);
 
 			src_offset = 0;
 			page_end = 1;
@@ -510,12 +506,10 @@ static int rd_MEMCPY_write(struct rd_request *req)
 				length = req->rd_size;
 
 			src = sg_virt(&sg_s[i++]) + src_offset;
-			if (!src)
-				BUG();
+			BUG_ON(!src);
 
 			dst = sg_virt(&sg_d[j]) + dst_offset;
-			if (!dst)
-				BUG();
+			BUG_ON(!dst);
 
 			src_offset = 0;
 			dst_offset = length;
@@ -535,8 +529,7 @@ static int rd_MEMCPY_write(struct rd_request *req)
 				length = req->rd_size;
 
 			src = sg_virt(&sg_s[i]) + src_offset;
-			if (!src)
-				BUG();
+			BUG_ON(!src);
 
 			if (sg_s[i].length == length) {
 				i++;
@@ -545,8 +538,7 @@ static int rd_MEMCPY_write(struct rd_request *req)
 				src_offset = length;
 
 			dst = sg_virt(&sg_d[j++]) + dst_offset;
-			if (!dst)
-				BUG();
+			BUG_ON(!dst);
 
 			dst_offset = 0;
 			page_end = 1;
-- 
1.7.6


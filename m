From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH v2] iscsi_tcp - make padbuf non-static
Date: Sat, 10 Jan 2009 19:06:07 -0800
Message-ID: <200901110306.n0B367W7016999@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:8423 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbZAKDEd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jan 2009 22:04:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, kxie@chelsio.com

[PATCH v2] iscsi_tcp - make padbuf non-static

From: Karen Xie <kxie@chelsio.com>

Rebased patch on scsi-misc tree head.

virt_to_page() call should not be used on kernel text and data addresses.
virt_to_page() is used by sg_init_one(). So change padbuf to be allocated within iscsi_segment.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 drivers/scsi/libiscsi_tcp.c |    3 +--
 include/scsi/libiscsi_tcp.h |    1 +
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index a745f91..e7705d3 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -177,7 +177,6 @@ int iscsi_tcp_segment_done(struct iscsi_tcp_conn *tcp_conn,
 			   struct iscsi_segment *segment, int recv,
 			   unsigned copied)
 {
-	static unsigned char padbuf[ISCSI_PAD_LEN];
 	struct scatterlist sg;
 	unsigned int pad;
 
@@ -233,7 +232,7 @@ int iscsi_tcp_segment_done(struct iscsi_tcp_conn *tcp_conn,
 			debug_tcp("consume %d pad bytes\n", pad);
 			segment->total_size += pad;
 			segment->size = pad;
-			segment->data = padbuf;
+			segment->data = segment->padbuf;
 			return 0;
 		}
 	}
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index 83e32f6..9e3182e 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -39,6 +39,7 @@ struct iscsi_segment {
 	unsigned int		total_copied;
 
 	struct hash_desc	*hash;
+	unsigned char		padbuf[ISCSI_PAD_LEN];
 	unsigned char		recv_digest[ISCSI_DIGEST_SIZE];
 	unsigned char		digest[ISCSI_DIGEST_SIZE];
 	unsigned int		digest_len;

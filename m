From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 00/33] SG table chaining support
Date: Mon, 16 Jul 2007 22:19:41 +0900
Message-ID: <200707161319.l6GDJffm027482@mbox.iij4u.or.jp>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:60338 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757795AbXGPNUF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 09:20:05 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 00/33] SG table chaining support
Date: Mon, 16 Jul 2007 11:47:14 +0200

> Changes since last post:
> 
> - Rebase to current -git. Lots of SCSI drivers have been converted
>   to use the sg accessor helpers, which nicely shrinks this patchset
>   from 70 to 33 patches. Great!

It's against Jens' sglist branch though there are lots of changes to
the data path in Mike's iscsi tree.

---
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] iscsi_tcp: sg chaining support

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/iscsi_tcp.c |   41 ++++++++++++++++++++++-------------------
 1 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index aebcd5f..4598231 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -316,7 +316,7 @@ iscsi_solicit_data_init(struct iscsi_con
 
 	sg = scsi_sglist(sc);
 	r2t->sg = NULL;
-	for (i = 0; i < scsi_sg_count(sc); i++, sg += 1) {
+	for (i = 0; i < scsi_sg_count(sc); i++, sg = sg_next(sg)) {
 		/* FIXME: prefetch ? */
 		if (sg_count + sg->length > r2t->data_offset) {
 			int page_offset;
@@ -332,7 +332,7 @@ iscsi_solicit_data_init(struct iscsi_con
 			r2t->sendbuf.sg.length -= page_offset;
 
 			/* xmit logic will continue with next one */
-			r2t->sg = sg + 1;
+			r2t->sg = sg_next(sg);;
 			break;
 		}
 		sg_count += sg->length;
@@ -707,18 +707,21 @@ static int iscsi_scsi_data_in(struct isc
 	sg = scsi_sglist(sc);
 
 	if (tcp_ctask->data_offset)
-		for (i = 0; i < tcp_ctask->sg_count; i++)
-			offset -= sg[i].length;
+		for (i = 0; i < tcp_ctask->sg_count; i++, sg = sg_next(sg))
+			offset -= sg->length;
 	/* we've passed through partial sg*/
 	if (offset < 0)
 		offset = 0;
 
-	for (i = tcp_ctask->sg_count; i < scsi_sg_count(sc); i++) {
+	for (i = 0, sg = scsi_sglist(sc); i < tcp_ctask->sg_count; i++)
+		sg = sg_next(sg);
+
+	for (i = tcp_ctask->sg_count; i < scsi_sg_count(sc); i++, sg = sg_next(sg)) {
 		char *dest;
 
-		dest = kmap_atomic(sg[i].page, KM_SOFTIRQ0);
-		rc = iscsi_ctask_copy(tcp_conn, ctask, dest + sg[i].offset,
-				      sg[i].length, offset);
+		dest = kmap_atomic(sg->page, KM_SOFTIRQ0);
+		rc = iscsi_ctask_copy(tcp_conn, ctask, dest + sg->offset,
+				      sg->length, offset);
 		kunmap_atomic(dest, KM_SOFTIRQ0);
 		if (rc == -EAGAIN)
 			/* continue with the next SKB/PDU */
@@ -728,13 +731,13 @@ static int iscsi_scsi_data_in(struct isc
 				if (!offset)
 					crypto_hash_update(
 							&tcp_conn->rx_hash,
-							&sg[i], sg[i].length);
+							sg, sg->length);
 				else
 					partial_sg_digest_update(
 							&tcp_conn->rx_hash,
-							&sg[i],
-							sg[i].offset + offset,
-							sg[i].length - offset);
+							sg,
+							sg->offset + offset,
+							sg->length - offset);
 			}
 			offset = 0;
 			tcp_ctask->sg_count++;
@@ -746,9 +749,9 @@ static int iscsi_scsi_data_in(struct isc
 				 * data-in is complete, but buffer not...
 				 */
 				partial_sg_digest_update(&tcp_conn->rx_hash,
-							 &sg[i],
-							 sg[i].offset,
-							 sg[i].length-rc);
+							 sg,
+							 sg->offset,
+							 sg->length - rc);
 			rc = 0;
 			break;
 		}
@@ -1246,7 +1249,7 @@ iscsi_solicit_data_cont(struct iscsi_con
 		return;
 
 	iscsi_buf_init_sg(&r2t->sendbuf, r2t->sg);
-	r2t->sg += 1;
+	r2t->sg = sg_next(r2t->sg);
 }
 
 static void iscsi_set_padding(struct iscsi_tcp_cmd_task *tcp_ctask,
@@ -1378,8 +1381,8 @@ iscsi_send_cmd_hdr(struct iscsi_conn *co
 			struct scatterlist *sg = scsi_sglist(sc);
 
 			iscsi_buf_init_sg(&tcp_ctask->sendbuf, sg);
-			tcp_ctask->sg = sg + 1;
-			tcp_ctask->bad_sg = sg + scsi_sg_count(sc);
+			tcp_ctask->sg = sg_next(sg);
+			tcp_ctask->bad_sg = sg_last(sg, scsi_sg_count(sc));
 
 			debug_scsi("cmd [itt 0x%x total %d imm_data %d "
 				   "unsol count %d, unsol offset %d]\n",
@@ -1509,7 +1512,7 @@ iscsi_send_data(struct iscsi_cmd_task *c
 				buf_sent);
 		if (!iscsi_buf_left(sendbuf) && *sg != tcp_ctask->bad_sg) {
 			iscsi_buf_init_sg(sendbuf, *sg);
-			*sg = *sg + 1;
+			*sg = sg_next(*sg);
 		}
 
 		if (rc)
-- 
1.4.3.2


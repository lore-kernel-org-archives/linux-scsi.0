Return-Path: <SRS0=31eS=5N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=DATE_IN_PAST_96_XX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA79DC2D0EB
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 16:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA6672073E
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 16:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgC1Qpx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Mar 2020 12:45:53 -0400
Received: from mx.sdf.org ([205.166.94.20]:50049 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727702AbgC1Qn3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 28 Mar 2020 12:43:29 -0400
Received: from sdf.org (IDENT:lkml@sdf.lonestar.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 02SGhHGH020238
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sat, 28 Mar 2020 16:43:18 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 02SGhHZ7020889;
        Sat, 28 Mar 2020 16:43:17 GMT
Message-Id: <202003281643.02SGhHZ7020889@sdf.org>
From:   George Spelvin <lkml@sdf.org>
Date:   Sun, 8 Mar 2020 04:51:35 -0400
Subject: [RFC PATCH v1 28/50] drivers/target/iscsi: Replace O(n^2)
 randomization
To:     linux-kernel@vger.kernel.org, lkml@sdf.org
Cc:     Nicholas Bellinger <nab@linux-iscsi.org>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        linux-scsi@vger.kernel.org
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The previous code would, to generate the nth value in the sequence,
generate a random integer, linearly search the already-generated values
for a duplicate, and repeat until a non-colliding number was found.
That's an average of ln(n) + 0.577 attempts per number output, each
attempt is O(n), and it takes O(n) numbers to fill the array, for a
total of O(n^2 * log n).

For large n, the linear search would dominate, but the excess calls
to get_random_bytes() are painful even with small n.

There were also other bizarre things in the code, like the fiddling with
the sign bit, and "j = 10001 - j" when j is a random 32-bit integer.

Replace with an O(n) Fisher-Yates shuffle, and use prandom_max()
rather than expensive crypto-grade random numbers.

In iscsit_randomize_pdu_lists, I even got rid of the temporary array
entirely and shuffled directly in the PDUs.

In iscsit_randomize_seq_lists(), the "seq_list[i].type == SEQTYPE_NORMAL"
condition makes it hard to shuffle in-place, and I didn't want to
dive too deep into the code, but perhaps someone else could.

Signed-off-by: George Spelvin <lkml@sdf.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Lee Duncan <lduncan@suse.com>
Cc: Chris Leech <cleech@redhat.com>
Cc: linux-scsi@vger.kernel.org
---
 .../target/iscsi/iscsi_target_seq_pdu_list.c  | 72 +++++++------------
 1 file changed, 24 insertions(+), 48 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
index ea2b02a93e455..bc40657d4c7d6 100644
--- a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
+++ b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
@@ -88,40 +88,40 @@ static void iscsit_ordered_pdu_lists(
 }
 
 /*
- *	Generate count random values into array.
- *	Use 0x80000000 to mark generates valued in array[].
+ * Generate an array holding the values 0..count-1 in random order.
+ * count is guaranteed non-zero.
  */
 static void iscsit_create_random_array(u32 *array, u32 count)
 {
-	int i, j, k;
+	int i;
 
-	if (count == 1) {
-		array[0] = 0;
-		return;
+	array[0] = 0;
+
+	for (i = 1; i < count; i++) {
+		int j = prandom_u32_max(i+1);
+		array[i] = array[j];
+		array[j] = i;
 	}
+}
 
-	for (i = 0; i < count; i++) {
-redo:
-		get_random_bytes(&j, sizeof(u32));
-		j = (1 + (int) (9999 + 1) - j) % count;
-		for (k = 0; k < i + 1; k++) {
-			j |= 0x80000000;
-			if ((array[k] & 0x80000000) && (array[k] == j))
-				goto redo;
-		}
-		array[i] = j;
+/* A specialized version of the above for PDU send orders */
+static void iscsit_random_send_order(struct iscsi_pdu *pdu, u32 count)
+{
+	int i;
+
+	pdu[0].pdu_send_order = 0;
+	for (i = 1; i < count; i++) {
+		int j = prandom_u32_max(i+1);
+		pdu[i].pdu_send_order = pdu[j].pdu_send_order;
+		pdu[j].pdu_send_order = i;
 	}
-
-	for (i = 0; i < count; i++)
-		array[i] &= ~0x80000000;
 }
 
 static int iscsit_randomize_pdu_lists(
 	struct iscsi_cmd *cmd,
 	u8 type)
 {
-	int i = 0;
-	u32 *array, pdu_count, seq_count = 0, seq_no = 0, seq_offset = 0;
+	u32 pdu_count, seq_count = 0, seq_no = 0, seq_offset = 0;
 
 	for (pdu_count = 0; pdu_count < cmd->pdu_count; pdu_count++) {
 redo:
@@ -129,39 +129,15 @@ static int iscsit_randomize_pdu_lists(
 			seq_count++;
 			continue;
 		}
-		array = kcalloc(seq_count, sizeof(u32), GFP_KERNEL);
-		if (!array) {
-			pr_err("Unable to allocate memory"
-				" for random array.\n");
-			return -ENOMEM;
-		}
-		iscsit_create_random_array(array, seq_count);
-
-		for (i = 0; i < seq_count; i++)
-			cmd->pdu_list[seq_offset+i].pdu_send_order = array[i];
-
-		kfree(array);
-
+		iscsit_random_send_order(cmd->pdu_list + seq_offset, seq_count);
 		seq_offset += seq_count;
 		seq_count = 0;
 		seq_no++;
 		goto redo;
 	}
 
-	if (seq_count) {
-		array = kcalloc(seq_count, sizeof(u32), GFP_KERNEL);
-		if (!array) {
-			pr_err("Unable to allocate memory for"
-				" random array.\n");
-			return -ENOMEM;
-		}
-		iscsit_create_random_array(array, seq_count);
-
-		for (i = 0; i < seq_count; i++)
-			cmd->pdu_list[seq_offset+i].pdu_send_order = array[i];
-
-		kfree(array);
-	}
+	if (seq_count)
+		iscsit_random_send_order(cmd->pdu_list + seq_offset, seq_count);
 
 	return 0;
 }
-- 
2.26.0


Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C8F0C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 19:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B61AD221E3
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 19:23:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="SRYkjkmZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgIJTWt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 15:22:49 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.5]:26695 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731408AbgIJPvB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Sep 2020 11:51:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1599753059; i=@ts.fujitsu.com;
        bh=NRrwJe2ZsRAirRO3CRV4Dla0AX+lCk25RNMov9BhUhU=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=SRYkjkmZXnA7Gj3T5uxLbE3VIojghJVfVXtmO5Y0Lf8nZZfc7Z0A3o4RPbZJw7yCA
         ss+ADS0bwbyFBUZlCObeq3JawzxIfNMFuSWYH/BzFbfXbTSTUZGtm9/hLHQFK1Ax3g
         MbsyNoPxQHkh+iRL3r8rljsAWwvec28AQMj4itbF3eO9i5f94+YYbn2NlKmzDWVmG0
         Bgphr8mTOBTISoxnIyW+9+8sdmQDME+l/jP9t2KgHhPUwFBzwVzPTsV4n/TM0Cpn8q
         Fu4hPPifIMW8CCp1neTO/EL7zE40kyYGuHlw9sQKMV71JGsmgzJUL4T0pu/jcn7n7M
         ADp0L7FzhwrEQ==
Received: from [100.113.2.80] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-5.bemta.az-a.eu-central-1.aws.symcld.net id CB/E8-13954-36B4A5F5; Thu, 10 Sep 2020 15:50:59 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRWlGSWpSXmKPExsViZ8MRqpvkHRV
  v8OuDvkX39R1sFsuP/2Oy+DvpBqtF69K3TA4sHh+f3mLx+LxJLoApijUzLym/IoE14+OmHYwF
  S/Qqek/dY25gbFTvYuTiEBKYzChxu/MRK4QznVFi7dllTF2MnBxsAgYSKybdZwFJiAisYZRYe
  WceM0iCWUBPYtq/dewgtrBAokTPk5esIDaLgKpEy68fYHFeATuJCwsPgsUlBOQlOg5MZgGxOQ
  XsJU78nQO2QAiopvfhEpYJjNwLGBlWMVomFWWmZ5TkJmbm6BoaGOgaGhrrAklTQ73EKt1EvdR
  S3eTUvJKiRKCsXmJ5sV5xZW5yTopeXmrJJkZgqKQUMkzfwbjmzQe9Q4ySHExKorwCjlHxQnxJ
  +SmVGYnFGfFFpTmpxYcYZTg4lCR4jb2AcoJFqempFWmZOcCwhUlLcPAoifBe9wRK8xYXJOYWZ
  6ZDpE4xKkqJ81qCJARAEhmleXBtsFi5xCgrJczLyMDAIMRTkFqUm1mCKv+KUZyDUQmoAmQ7T2
  ZeCdz0V0CLmYAWN8pHgiwuSURISTUweQT2OAddZOLfq9CcMuuZaklzQO2a+zw2sfOLDb/+Xnd
  CtWvJ32era7Tkn824eW3np/QT5pJZO1QYNOw0NHZVb3aOSO+Vm368fJ+p8MtlHWZrL8gf3Lvw
  Hc9D33Tph2x7WU4aGPEbfKj/nD5rpukGq3m/XkyYIeFf9nxm5UKTB9fCX2usdLl+ovr75Crze
  cGaDq95b2bO+h4vdlrptfGDqSe27rx7pSRM8qeWUcKm7tslnw9MfdX/2u26qeqm2HeOnx3ccl
  1bUq47sz5W1ts2f9rX92FyJv+Parjfzbn3N5rjxqrTodXWsZ90e7LCVsr/Y5v9Kk5J7bXMvoY
  vp5ZLPdcK+OP47faOHb/bKxLuXFdiKc5INNRiLipOBAAsqlZ4EAMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-33.tower-228.messagelabs.com!1599753058!625887!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.60.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 29633 invoked from network); 10 Sep 2020 15:50:58 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-33.tower-228.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 10 Sep 2020 15:50:58 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 08AFosa1022686;
        Thu, 10 Sep 2020 16:50:54 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id CAA95204D1;
        Thu, 10 Sep 2020 17:50:53 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 1/3] scsi: target: tcmu: join tcmu_cmd_get_data_length and tcmu_cmd_get_block_cnt
Date:   Thu, 10 Sep 2020 17:50:39 +0200
Message-Id: <20200910155041.17654-2-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
References: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Simplify code by joining tcmu_cmd_get_data_length and
tcmu_cmd_get_block_cnt into tcmu_cmd_set_block_cnts.
The new function sets tcmu_cmd->dbi_cnt and also the new
field tcmu_cmd->dbi_bidi_cnt, which is needed for
further enhancements in following patches.
Simplyfy some code by using tcmu_cmd->dbi(_bidi)_cnt
instead of calculation from length.

Please note: the calculation of the number of dbis needed for
bidi was wrong. It was based on the length of the first bidi sg
only. I changed it to correctly sum up entier length of all
bidi sgs.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 53 +++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 30 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9b7592350502..fa0c4a42e435 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -177,6 +177,7 @@ struct tcmu_cmd {
 	/* Can't use se_cmd when cleaning up expired cmds, because if
 	   cmd has been completed then accessing se_cmd is off limits */
 	uint32_t dbi_cnt;
+	uint32_t dbi_bidi_cnt;
 	uint32_t dbi_cur;
 	uint32_t *dbi;
 
@@ -558,25 +559,20 @@ static inline void tcmu_free_cmd(struct tcmu_cmd *tcmu_cmd)
 	kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
 }
 
-static inline size_t tcmu_cmd_get_data_length(struct tcmu_cmd *tcmu_cmd)
+static inline void tcmu_cmd_set_block_cnts(struct tcmu_cmd *cmd)
 {
-	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
-	size_t data_length = round_up(se_cmd->data_length, DATA_BLOCK_SIZE);
+	int i, len;
+	struct se_cmd *se_cmd = cmd->se_cmd;
+
+	cmd->dbi_cnt = DIV_ROUND_UP(se_cmd->data_length, DATA_BLOCK_SIZE);
 
 	if (se_cmd->se_cmd_flags & SCF_BIDI) {
 		BUG_ON(!(se_cmd->t_bidi_data_sg && se_cmd->t_bidi_data_nents));
-		data_length += round_up(se_cmd->t_bidi_data_sg->length,
-				DATA_BLOCK_SIZE);
+		for (i = 0, len = 0; i < se_cmd->t_bidi_data_nents; i++)
+			len += se_cmd->t_bidi_data_sg[i].length;
+		cmd->dbi_bidi_cnt = DIV_ROUND_UP(len, DATA_BLOCK_SIZE);
+		cmd->dbi_cnt += cmd->dbi_bidi_cnt;
 	}
-
-	return data_length;
-}
-
-static inline uint32_t tcmu_cmd_get_block_cnt(struct tcmu_cmd *tcmu_cmd)
-{
-	size_t data_length = tcmu_cmd_get_data_length(tcmu_cmd);
-
-	return data_length / DATA_BLOCK_SIZE;
 }
 
 static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
@@ -593,8 +589,7 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 	tcmu_cmd->se_cmd = se_cmd;
 	tcmu_cmd->tcmu_dev = udev;
 
-	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
-	tcmu_cmd->dbi_cnt = tcmu_cmd_get_block_cnt(tcmu_cmd);
+	tcmu_cmd_set_block_cnts(tcmu_cmd);
 	tcmu_cmd->dbi = kcalloc(tcmu_cmd->dbi_cnt, sizeof(uint32_t),
 				GFP_NOIO);
 	if (!tcmu_cmd->dbi) {
@@ -767,13 +762,12 @@ static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 		data_sg = se_cmd->t_data_sg;
 		data_nents = se_cmd->t_data_nents;
 	} else {
-
 		/*
 		 * For bidi case, the first count blocks are for Data-Out
 		 * buffer blocks, and before gathering the Data-In buffer
-		 * the Data-Out buffer blocks should be discarded.
+		 * the Data-Out buffer blocks should be skipped.
 		 */
-		count = DIV_ROUND_UP(se_cmd->data_length, DATA_BLOCK_SIZE);
+		count = cmd->dbi_cnt - cmd->dbi_bidi_cnt;
 
 		data_sg = se_cmd->t_bidi_data_sg;
 		data_nents = se_cmd->t_bidi_data_nents;
@@ -827,11 +821,9 @@ static inline size_t spc_bitmap_free(unsigned long *bitmap, uint32_t thresh)
  * Called with ring lock held.
  */
 static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
-		size_t cmd_size, size_t data_needed)
+				size_t cmd_size)
 {
 	struct tcmu_mailbox *mb = udev->mb_addr;
-	uint32_t blocks_needed = (data_needed + DATA_BLOCK_SIZE - 1)
-				/ DATA_BLOCK_SIZE;
 	size_t space, cmd_needed;
 	u32 cmd_head;
 
@@ -855,23 +847,23 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 		return false;
 	}
 
-	if (!data_needed)
+	if (!cmd || !cmd->dbi_cnt)
 		return true;
 
 	/* try to check and get the data blocks as needed */
 	space = spc_bitmap_free(udev->data_bitmap, udev->dbi_thresh);
-	if ((space * DATA_BLOCK_SIZE) < data_needed) {
+	if (space < cmd->dbi_cnt) {
 		unsigned long blocks_left =
 				(udev->max_blocks - udev->dbi_thresh) + space;
 
-		if (blocks_left < blocks_needed) {
+		if (blocks_left < cmd->dbi_cnt) {
 			pr_debug("no data space: only %lu available, but ask for %zu\n",
 					blocks_left * DATA_BLOCK_SIZE,
-					data_needed);
+					cmd->dbi_cnt * DATA_BLOCK_SIZE);
 			return false;
 		}
 
-		udev->dbi_thresh += blocks_needed;
+		udev->dbi_thresh += cmd->dbi_cnt;
 		if (udev->dbi_thresh > udev->max_blocks)
 			udev->dbi_thresh = udev->max_blocks;
 	}
@@ -990,7 +982,8 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	uint32_t cmd_head;
 	uint64_t cdb_off;
 	bool copy_to_data_area;
-	size_t data_length = tcmu_cmd_get_data_length(tcmu_cmd);
+	/* size of data buffer needed */
+	size_t data_length = (size_t)tcmu_cmd->dbi_cnt * DATA_BLOCK_SIZE;
 
 	*scsi_err = TCM_NO_SENSE;
 
@@ -1031,7 +1024,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 		return -1;
 	}
 
-	if (!is_ring_space_avail(udev, tcmu_cmd, command_size, data_length)) {
+	if (!is_ring_space_avail(udev, tcmu_cmd, command_size)) {
 		/*
 		 * Don't leave commands partially setup because the unmap
 		 * thread might need the blocks to make forward progress.
@@ -1145,7 +1138,7 @@ queue_tmr_ring(struct tcmu_dev *udev, struct tcmu_tmr *tmr)
 	cmd_size = round_up(sizeof(*entry) + id_list_sz, TCMU_OP_ALIGN_SIZE);
 
 	if (!list_empty(&udev->tmr_queue) ||
-	    !is_ring_space_avail(udev, NULL, cmd_size, 0)) {
+	    !is_ring_space_avail(udev, NULL, cmd_size)) {
 		list_add_tail(&tmr->queue_entry, &udev->tmr_queue);
 		pr_debug("adding tmr %p on dev %s to TMR ring space wait queue\n",
 			 tmr, udev->name);
-- 
2.12.3


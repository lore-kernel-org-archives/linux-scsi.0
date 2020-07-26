Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A133DC43462
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 15:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DD4320714
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 15:35:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="X1wGinMF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgGZPf6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 11:35:58 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.4]:60441 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727955AbgGZPfy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Jul 2020 11:35:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1595777751; i=@ts.fujitsu.com;
        bh=y9ylx5PwdzIjX0o5YrFnCMuaeiv73CouMTrYVHBkPDk=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=X1wGinMF23kLdwFp7FbbSCWxPGZisqgt/kHTPqZ5wiwB53tGs2BPfXeUOiu1rf9Ma
         fzsZgzkdq+8vigI3R+4EkdWgr4QKb1E9IYLMS+FAiXlZ8AsKQfPff34BRbbj3PGGyS
         0OaqBY+V5dKM7rl0ai1lT9XJ6IZsIQnHXXM71F8fkHw+1/zssRX5JhjhyIgEBcEThj
         xehOrYwj5mZc2g/FiR3auBoKdVzLzPFANcmxgRPqcngZB4uy0bbJAWHVanVtAmrc8v
         5CF+wLhh/NpGWWDLdk1QyxIjQhSt9/OICMMUhQjjAenjWgqIIvKuuzQM6CK/hAEaqa
         C/FXbtUaP88/w==
Received: from [100.112.192.163] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-a.eu-west-1.aws.symcld.net id 58/B7-17694-6D2AD1F5; Sun, 26 Jul 2020 15:35:50 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRWlGSWpSXmKPExsViZ8MxRffaItl
  4g446i+7rO9gslh//x2Txd9INVovWpW+ZHFg8Pj69xeLxeZNcAFMUa2ZeUn5FAmvG/dtbmQpO
  SFW8WTqLtYHxtFgXIxeHkMBkRolbF5azQDjTGSUOvNjN2sXIycEmYCCxYtJ9sISIwBpGiZV35
  jGDJJgF9CSm/VvHDmILC4RKvJy4mBHEZhFQlZj+oxMszitgJ3H14EQ2EFtCQF6i48BkFhCbU8
  BeYuPcD2BzhIBqlm06wD6BkXsBI8MqRoukosz0jJLcxMwcXUMDA11DQyNdQ0tTXUNTQ73EKt1
  EvdRS3fLU4hJdILe8WK+4Mjc5J0UvL7VkEyMwTFIKDk/fwdj/5oPeIUZJDiYlUV6DKbLxQnxJ
  +SmVGYnFGfFFpTmpxYcYZTg4lCR4ry4EygkWpaanVqRl5gBDFiYtwcGjJMI7ByTNW1yQmFucm
  Q6ROsWoKCXO2w+SEABJZJTmwbXB4uQSo6yUMC8jAwODEE9BalFuZgmq/CtGcQ5GJWFeK5ApPJ
  l5JXDTXwEtZgJa7H5JEmRxSSJCSqqBSclRqYDl5sr6m77iormxvnaSZpynnBbYid9L4z6Ts3z
  JMtv7TbxzZyy6o9rlsnVdi+Uq5+d/Ln3a13oy8B7TFdbgpE+6qdoNqz0+6Myzl4jXrz8z8fsf
  t0ilrPonz557bV+1v+3Xdl2xZ1rvBA6e+xB2LKFyQeYlIfM1wnWJPmkPpjBtjZsUUKD//GM+V
  3QX492GKpVn8/ODPzstuZp5oN347/WLuzalH4grsdKSfyT54M/jqEcM0/N1ubYtmbFp+tG/88
  tLpn5Kn3VwWbue5JEJjMb2ycJvdXiVAh7bM09LPLI9zYghXeethJb1KqMJT35YLPuQ2/xn+hz
  r6tuqqkL7dgs1zNwuLdah/N3jtxJLcUaioRZzUXEiAKJqxI4OAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-4.tower-265.messagelabs.com!1595777749!468837!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 28489 invoked from network); 26 Jul 2020 15:35:49 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-4.tower-265.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 26 Jul 2020 15:35:49 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06QFZkcm009400;
        Sun, 26 Jul 2020 16:35:46 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 4EEDA20699;
        Sun, 26 Jul 2020 17:35:37 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH v3 5/8] scsi: target: tcmu: Factor out new helper ring_insert_padding
Date:   Sun, 26 Jul 2020 17:35:07 +0200
Message-Id: <20200726153510.13077-6-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
References: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The new helper ring_insert_padding is split off from and then
called by queue_cmd_ring. It inserts a padding if necessary.
The new helper will in a further patch be used during writing
of TMR notifications to command ring.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 51 +++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 25c480fde9ee..eb68c5fee7b7 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -926,6 +926,34 @@ static int add_to_qfull_queue(struct tcmu_cmd *tcmu_cmd)
 	return 0;
 }
 
+static uint32_t ring_insert_padding(struct tcmu_dev *udev, size_t cmd_size)
+{
+	struct tcmu_cmd_entry_hdr *hdr;
+	struct tcmu_mailbox *mb = udev->mb_addr;
+	uint32_t cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
+
+	/* Insert a PAD if end-of-ring space is too small */
+	if (head_to_end(cmd_head, udev->cmdr_size) < cmd_size) {
+		size_t pad_size = head_to_end(cmd_head, udev->cmdr_size);
+
+		hdr = (void *) mb + CMDR_OFF + cmd_head;
+		tcmu_hdr_set_op(&hdr->len_op, TCMU_OP_PAD);
+		tcmu_hdr_set_len(&hdr->len_op, pad_size);
+		hdr->cmd_id = 0; /* not used for PAD */
+		hdr->kflags = 0;
+		hdr->uflags = 0;
+		tcmu_flush_dcache_range(hdr, sizeof(*hdr));
+
+		UPDATE_HEAD(mb->cmd_head, pad_size, udev->cmdr_size);
+		tcmu_flush_dcache_range(mb, sizeof(*mb));
+
+		cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
+		WARN_ON(cmd_head != 0);
+	}
+
+	return cmd_head;
+}
+
 /**
  * queue_cmd_ring - queue cmd to ring or internally
  * @tcmu_cmd: cmd to queue
@@ -941,7 +969,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
 	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
 	size_t base_command_size, command_size;
-	struct tcmu_mailbox *mb;
+	struct tcmu_mailbox *mb = udev->mb_addr;
 	struct tcmu_cmd_entry *entry;
 	struct iovec *iov;
 	int iov_cnt, cmd_id;
@@ -980,8 +1008,6 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	if (!list_empty(&udev->qfull_queue))
 		goto queue;
 
-	mb = udev->mb_addr;
-	cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
 	if ((command_size > (udev->cmdr_size / 2)) ||
 	    data_length > udev->data_size) {
 		pr_warn("TCMU: Request of size %zu/%zu is too big for %u/%zu "
@@ -1001,24 +1027,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 		goto queue;
 	}
 
-	/* Insert a PAD if end-of-ring space is too small */
-	if (head_to_end(cmd_head, udev->cmdr_size) < command_size) {
-		size_t pad_size = head_to_end(cmd_head, udev->cmdr_size);
-
-		entry = (void *) mb + CMDR_OFF + cmd_head;
-		tcmu_hdr_set_op(&entry->hdr.len_op, TCMU_OP_PAD);
-		tcmu_hdr_set_len(&entry->hdr.len_op, pad_size);
-		entry->hdr.cmd_id = 0; /* not used for PAD */
-		entry->hdr.kflags = 0;
-		entry->hdr.uflags = 0;
-		tcmu_flush_dcache_range(entry, sizeof(entry->hdr));
-
-		UPDATE_HEAD(mb->cmd_head, pad_size, udev->cmdr_size);
-		tcmu_flush_dcache_range(mb, sizeof(*mb));
-
-		cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
-		WARN_ON(cmd_head != 0);
-	}
+	cmd_head = ring_insert_padding(udev, command_size);
 
 	entry = (void *) mb + CMDR_OFF + cmd_head;
 	memset(entry, 0, command_size);
-- 
2.12.3


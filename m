Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5623C433EB
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 16:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AB9D207DD
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 16:12:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="Gd54Fv9W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgGQQMr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 12:12:47 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.1]:31588 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726736AbgGQQMj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jul 2020 12:12:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1595002355; i=@ts.fujitsu.com;
        bh=RLWTXTWFyHAGnk+WtQu0/qy0qd9euXFeGbDkGp5OEXQ=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=Gd54Fv9WN5j2W2ENvOvs6ohghsepDuuOeJzerWZAEa6mjGzUtuBzwC6faUkQ286ZQ
         UdwKLHEssDVd6g0WO9dXSFx52q7yfQfY6difbuL0kSQ8DNAgf2bMXixwkLiYZoyEaS
         MtSzi/blrf9OXRXlH1EzoYAT2kccVbHXEJgojFAqU9ooZkq/hXtavch2pgBcN5AeyW
         BBSxXd63OXcVpUthzdFmLsnMd1lBDzy6cKyA+CudSkVIM21MZJrar5EZm70by6TD/u
         6pBiVdJzlTQ6SnCReJI9z8hiindv5RxnsX35SgyYs6L/1Kxl9t093ev1IbJ6+Ay4Y1
         OXBdJMj5HnDfg==
Received: from [100.113.2.186] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-a.eu-central-1.aws.symcld.net id 77/BB-07993-3FDC11F5; Fri, 17 Jul 2020 16:12:35 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRWlGSWpSXmKPExsViZ8MxVffzWcF
  4g+ebZC26r+9gs1h+/B+Txd9JN1gtWpe+ZXJg8fj49BaLx+dNcgFMUayZeUn5FQmsGS+7LjIW
  HJSqOPtasYHxiFgXIxeHkMBkRol73w6yQDjTGSVObFvB1MXIycEmYCCxYtJ9sISIwBpGiZV35
  jGDJJgF9CSm/VvHDmILC4RKXD65iAXEZhFQlbi/chdQMwcHr4CdxLaGapCwhIC8RMeByWAlnA
  L2ErO/HWQEsYWASh6se8s8gZF7ASPDKkaLpKLM9IyS3MTMHF1DAwNdQ0NjXSNdU0O9xCrdRL3
  UUt3k1LySokSgpF5iebFecWVuck6KXl5qySZGYJCkFDIZ72C89vqD3iFGSQ4mJVHetlWC8UJ8
  SfkplRmJxRnxRaU5qcWHGGU4OJQkeMVPAeUEi1LTUyvSMnOAAQuTluDgURLhNT4DlOYtLkjML
  c5Mh0idYlSUEucVA0kIgCQySvPg2mBRcolRVkqYl5GBgUGIpyC1KDezBFX+FaM4B6OSMG8YyB
  SezLwSuOmvgBYzAS3e+JkXZHFJIkJKqoHJ1HH58yfGG9MdFpW+jYpknCSzKDltr8zsPW7/C+Z
  //7ZfQqLwML9dp+mr7FOPuyP7dmst2LM/7mK4adXyxkstypmVVTPv8HNryF5w2qXTUPDwrJ7V
  7OrY/46fOZjn7Nsk8ZlDd6PfRf6A34ZCXu5ZKW+uLfLPPmj9fK5mSe2vFhst/n/3Ymr8c3Mtd
  FfWObyaMLW4Z9+O+b6X4iOPF0cEbFKLOT69/uTNnIjMcP8bb/4s7Vty+cnuFecuLpK7pJZ1uG
  OWoYCEpHyb4Cd2qSm9dzl3zjmueObYvClz2u7M1lo9x/kOy8yNbT3uV6VVRYO8tatCFlhuvjv
  FO+CFV2qanW9I8c7GECGJslyBMHklluKMREMt5qLiRADadkB1DQMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-17.tower-232.messagelabs.com!1595002354!1123521!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 29003 invoked from network); 17 Jul 2020 16:12:35 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-17.tower-232.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 17 Jul 2020 16:12:35 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06HGCT3x010090;
        Fri, 17 Jul 2020 17:12:29 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 0FB3820800;
        Fri, 17 Jul 2020 18:12:21 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH v2 5/8] scsi: target: tcmu: Factor out new helper ring_insert_padding
Date:   Fri, 17 Jul 2020 18:12:09 +0200
Message-Id: <20200717161212.10731-6-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200717161212.10731-1-bstroesser@ts.fujitsu.com>
References: <20200717161212.10731-1-bstroesser@ts.fujitsu.com>
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
index 25c480fde9ee..7a27e838a7d3 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -926,6 +926,34 @@ static int add_to_qfull_queue(struct tcmu_cmd *tcmu_cmd)
 	return 0;
 }
 
+static uint32_t ring_insert_padding(struct tcmu_dev *dev, size_t cmd_size)
+{
+	struct tcmu_cmd_entry_hdr *hdr;
+	struct tcmu_mailbox *mb = dev->mb_addr;
+	uint32_t cmd_head = mb->cmd_head % dev->cmdr_size; /* UAM */
+
+	/* Insert a PAD if end-of-ring space is too small */
+	if (head_to_end(cmd_head, dev->cmdr_size) < cmd_size) {
+		size_t pad_size = head_to_end(cmd_head, dev->cmdr_size);
+
+		hdr = (void *) mb + CMDR_OFF + cmd_head;
+		tcmu_hdr_set_op(&hdr->len_op, TCMU_OP_PAD);
+		tcmu_hdr_set_len(&hdr->len_op, pad_size);
+		hdr->cmd_id = 0; /* not used for PAD */
+		hdr->kflags = 0;
+		hdr->uflags = 0;
+		tcmu_flush_dcache_range(hdr, sizeof(*hdr));
+
+		UPDATE_HEAD(mb->cmd_head, pad_size, dev->cmdr_size);
+		tcmu_flush_dcache_range(mb, sizeof(*mb));
+
+		cmd_head = mb->cmd_head % dev->cmdr_size; /* UAM */
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


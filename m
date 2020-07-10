Return-Path: <SRS0=WTMl=AV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD462C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 10:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C8E720748
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 10:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="Jwh4+auD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgGJKtK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jul 2020 06:49:10 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.1]:20874 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727827AbgGJKss (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Jul 2020 06:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1594378124; i=@ts.fujitsu.com;
        bh=RLWTXTWFyHAGnk+WtQu0/qy0qd9euXFeGbDkGp5OEXQ=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=Jwh4+auDPxBE7h9C2SQSsxl/Y8ybHmWwnlfvawGwe/E+f+fWwEV0V9Ni0cM/cSpSm
         FeKDiKcGzVfDwuwbTFC+PnoPCRY3t+bjrhZgGCUmnuQFzlH7TmCc4hz0i6uMGwG0b/
         LAobz/T9qlVWiJr32dzmYsBSJO17e7H9NhJAgrVmitnUaxdyWG4OYnOHsJIvvWLRHB
         CCP9/LbhKd9rvLl/I2Z922uhHs8sHA+aZSqL2ZoHFCb3XsRikFODZLhg89naklpTrq
         jjfHXUgzrhvRC4yQLO4OGUf1QDEWX1Ck/IjbftWOWaZKZ3KmSSl9urDwY6YhajESbS
         nY9nqFO84D7ZQ==
Received: from [100.112.194.55] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-a.eu-west-1.aws.symcld.net id A4/AC-19802-B87480F5; Fri, 10 Jul 2020 10:48:43 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRWlGSWpSXmKPExsViZ8MxVbfbnSP
  eYMVPXYvu6zvYLJYf/8dk8XfSDVaL1qVvmRxYPD4+vcXi8XmTXABTFGtmXlJ+RQJrxsuui4wF
  B6Uqzr5WbGA8ItbFyMUhJDCZUaJhWg8LhDOdUWLFxmlADicHm4CBxIpJ98ESIgJrGCVW3pnHD
  JJgFtCTmPZvHTuILSwQJPG19SZYA4uAqsTpuz/BangF7CRWz9oEZksIyEt0HJgMVsMpYC+xv+
  sfmC0EVLOr7yHrBEbuBYwMqxgtkooy0zNKchMzc3QNDQx0DQ2NdA0tgdjYVC+xSjdRL7VUtzy
  1uETXUC+xvFivuDI3OSdFLy+1ZBMjMExSCg6072B89PqD3iFGSQ4mJVHeaR/Z44X4kvJTKjMS
  izPii0pzUosPMcpwcChJ8Eq5ccQLCRalpqdWpGXmAEMWJi3BwaMkwjvfBSjNW1yQmFucmQ6RO
  sWoKCXO+88ZKCEAksgozYNrg8XJJUZZKWFeRgYGBiGegtSi3MwSVPlXjOIcjErCvNEg23ky80
  rgpr8CWswEtPgoBxvI4pJEhJRUAxPXH3am/14PJmQm1Bn3NgTsTrDqKF/S5c9xWehy5O6Ip7O
  SHz400Yj8HzJV2Tz7uv/Dgt+dq3MeBR70Mr24t+a40/WIn08nZb9iM77mL3/3zqziKBaBPesc
  wm8n/nNbceRpB+e8/sY6k765P1JUHPI8duzruPnMY6PKXqus75ZFHFcfaXZXX7K/tTZaesFa/
  Tjv0kUp98wz1oWviQsLUE8p4tNvfe8XbvPpTtW+q5Zxl9WSr048qHYvvXJ27tL4c26eS26/yb
  BWX3rNy9w5xbTRn+3aueSVvWJ/ZplWnOmNqA/QeNCy/Jzx36cK88WsI+78Xbhf1K+kV6o91P2
  PnIyjDkPn3H1bnJR2bvzVqsRSnJFoqMVcVJwIAFfa8FEOAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-5.tower-265.messagelabs.com!1594378123!571597!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 15097 invoked from network); 10 Jul 2020 10:48:43 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-5.tower-265.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 10 Jul 2020 10:48:43 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06AAmgdM001604;
        Fri, 10 Jul 2020 11:48:42 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 7516A207A9;
        Fri, 10 Jul 2020 12:48:42 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 5/8] scsi: target: tcmu: Factor out new helper ring_insert_padding
Date:   Fri, 10 Jul 2020 12:48:14 +0200
Message-Id: <20200710104817.19462-6-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
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


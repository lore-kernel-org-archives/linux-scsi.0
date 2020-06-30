Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4205AC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 10:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19D9120780
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 10:47:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="HGkB7o5/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732640AbgF3Krk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 06:47:40 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.4]:12828 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732634AbgF3Krj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jun 2020 06:47:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1593514056; i=@ts.fujitsu.com;
        bh=auLvn4X425miopBdp5iT9LE/FP7mM4u482ghwkUczNw=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=HGkB7o5/q//VjsD613Z6k83RMBky/U6No3x5LQY8wifIDhmQetDJdw81FHAdNag2S
         xGMiEVL0G57cHiePdRf3PKX+Tp5pVgg3mrblmyccPiDJXT+of+zMaa+MbW2I5tKerd
         WFbtoc++gE8zRYpWH5zwEoVcepAS2/w+3NETVCcM5EgubR8r9XjyqL1MIK3qThdmEh
         ZaYNnqQn4fjAUYGMJKhK1LplgWen74LiRIfSOw23lPOiM3kl7s76Pn52I1l/6wYIjo
         7Sfayy43hvq+0rf//X3m8pGiNs3EwNfBp7TTwohmAFth0s75mTDNnkuM/HdmRAR67m
         xhvGKQ4cIzkvA==
Received: from [100.112.192.107] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-a.eu-west-1.aws.symcld.net id 0E/9E-17694-8481BFE5; Tue, 30 Jun 2020 10:47:36 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRWlGSWpSXmKPExsViZ8MxRddd4ne
  cwaeXNhbd13ewWSw//o/J4u+kG6wWrUvfMjmweHx8eovF4/MmuQCmKNbMvKT8igTWjOe37jIX
  HJSq6Fj3lqWB8YhYFyMXh5DAZEaJX/1XWCCc6YwSzx92MHcxcnKwCRhIrJh0HywhIrCGUWLln
  XlgCWYBPYlp/9axdzFycAgLhEncXWYKYrIIqEpseS4HUsErYCex4OlxNhBbQkBeouPAZBYQm1
  PAXmLt4dNgthBQzdrNM9kmMHIvYGRYxWiRVJSZnlGSm5iZo2toYKBraGika2gJxCYmeolVuol
  6qaW65anFJbqGeonlxXrFlbnJOSl6eaklmxiBQZJScGDCDsb9rz/oHWKU5GBSEuW99+9XnBBf
  Un5KZUZicUZ8UWlOavEhRhkODiUJ3nax33FCgkWp6akVaZk5wICFSUtw8CiJ8LYLAaV5iwsSc
  4sz0yFSpxgVpcR5V4L0CYAkMkrz4NpgUXKJUVZKmJeRgYFBiKcgtSg3swRV/hWjOAejkjBvgj
  jQFJ7MvBK46a+AFjMBLb6m9QtkcUkiQkqqgSnFdJOXT/ms/IIq814J3dcq+Y/vvVC//a3t6Gn
  z55P6J8637Y18/WzZ29ZnPmU2yWc2bV1y9oHY85yPFxSnG8S9btZY/Dj049RtatM85Q3TT15e
  bvHtd9PFe9ZrZWewvf5yla17XqHPEuHnc07V1ypsMU2empu/0FNYeEVHKof3/+OOU76nqReyN
  OhUXOFe+17wdUb7xQOtUYpGP14U6BWzxBxa90Zs/52/HcXzrLNavOWSV9nv2pbZ4ef6/aetn4
  yYm/dXnr37r0w5FBm+qfig5rFyr/oL/es1rtp8KWXh+6hpF+SdUl97ecWJG1+feNg1ZTWEhlv
  IaCdLf+X/qfPks9CULZcPMfev0fJ3vKbEUpyRaKjFXFScCACEXqmXDQMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-14.tower-265.messagelabs.com!1593514055!1391470!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 23178 invoked from network); 30 Jun 2020 10:47:35 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-14.tower-265.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 30 Jun 2020 10:47:35 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05UAlYsR025927;
        Tue, 30 Jun 2020 11:47:35 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 7861220954;
        Tue, 30 Jun 2020 12:47:32 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [RFC PATCH 5/8] scsi: target: tcmu: Factor out new helper ring_insert_padding
Date:   Tue, 30 Jun 2020 12:47:06 +0200
Message-Id: <20200630104709.23066-6-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
References: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
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
index be95518a31dd..f10d8d182ed9 100644
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


Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F3BDC433E4
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 16:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60A5E2076A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 16:12:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="gDsm07ZQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgGQQMi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 12:12:38 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.1]:49573 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727085AbgGQQMf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jul 2020 12:12:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1595002352; i=@ts.fujitsu.com;
        bh=3Dr9L1Lw9/CiK8afeg4DStkBmBuyCm8ZavaSMzq71do=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=gDsm07ZQDZCE/TaHZcif1WrlbnPyIgqultwyYBgq9AaWtSJZdgyiiIhGT3FdcEno6
         63jFeRHKtIQcOv09h8jkFn2Wdt0cmXjHQQO2qWJf08uLB3ZO7jWwnG3JOkKQbhMjnh
         ie3wTyNnASEJo2N36ei8Wgu62zXiuiooRChSIIC9vQDBFEX8Nc/COf5VYXFb/oqxti
         wlO5N7rz/kUGE4+VP1PwNZv6JC5u6JNv5JkKbm/KvDayaWgiM9BLHiu8vNrimI+TSW
         WBLSzMgiuDd6iWlDZSj8RruUdHGLy5Wo33EEDfFA9IokY5N0mfTiENRr1ecusZDctd
         zVNfkl3W56miQ==
Received: from [100.112.192.94] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-a.eu-west-1.aws.symcld.net id 1E/9B-19802-0FDC11F5; Fri, 17 Jul 2020 16:12:32 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRWlGSWpSXmKPExsViZ8MxRffDWcF
  4gyebuSy6r+9gs1h+/B+Txd9JN1gtWpe+ZXJg8fj49BaLx+dNcgFMUayZeUn5FQmsGdO+zmYv
  uMlb8WfmEvYGxs/cXYxcHEICkxkleiZuZIJwpjNK7Nj6iKWLkZODTcBAYsWk+ywgCRGBNYwSK
  +/MYwZJMAvoSUz7t44dxBYWcJP4PAEiziKgKnHuyA8mEJtXwE5ix2yIuISAvETHgclgQzkF7C
  VmfzvICGILAdU8WPeWeQIj9wJGhlWMFklFmekZJbmJmTm6hgYGuoaGRrqGlkBsYqKXWKWbqJd
  aqlueWlyia6iXWF6sV1yZm5yTopeXWrKJERgoKQUHJuxg3P/6g94hRkkOJiVR3rZVgvFCfEn5
  KZUZicUZ8UWlOanFhxhlODiUJHjFTwHlBItS01Mr0jJzgEELk5bg4FES4TU+A5TmLS5IzC3OT
  IdInWJUlBLnFQNJCIAkMkrz4NpgkXKJUVZKmJeRgYFBiKcgtSg3swRV/hWjOAejkjBvGMgUns
  y8Erjpr4AWMwEt3viZF2RxSSJCSqqBKYr/VGmh45nqCNPQA19LJsQftFC6kSmz8ELVJAmBu8w
  RxwvDF2pbx023sFnQf6RvF4v6q/jbIZJ8xzjmcO7a5nFP4s6j1f9fyASs3GKtu3fCQoUlSQ9Y
  bm+sPbyMbz2ri+7Go1l3T5swOd2cUZR6kF+eu/reuyK/PV7H/PQXe2+9Nu+Czd4Nlld/BItVh
  P25tPgpv67C/8YbS5z3fF43NWT6NU6PAjGNjJkPT0f9Xhvq0vFhrUzZj8UbOXU+iYasfT6ZU2
  Bjm1VIAPeG4xNtpi5d48+yWSL18HvXhzwcrI1T27N22Sh+E537/xeT1fES5fLeKf6vj4YuXr7
  77sffr59Ma97w9d3dT2K3r4QcSsxXYinOSDTUYi4qTgQA1min5A8DAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-23.tower-267.messagelabs.com!1595002351!26012!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 23744 invoked from network); 17 Jul 2020 16:12:32 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-23.tower-267.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 17 Jul 2020 16:12:32 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06HGCLpu028936;
        Fri, 17 Jul 2020 17:12:21 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 0096620561;
        Fri, 17 Jul 2020 18:12:21 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH v2 3/8] scsi: target: tcmu: Use priv pointer in se_cmd
Date:   Fri, 17 Jul 2020 18:12:07 +0200
Message-Id: <20200717161212.10731-4-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200717161212.10731-1-bstroesser@ts.fujitsu.com>
References: <20200717161212.10731-1-bstroesser@ts.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We initialize and clean up the se_cmd's priv pointer
under cmd_ring_lock to point to the corresponding tcmu_cmd.

In the patch that implements tmr_notify callback in
tcmu we will use the priv pointer.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 366878b0b2fd..b06b18d1b135 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -541,6 +541,8 @@ tcmu_get_block_page(struct tcmu_dev *udev, uint32_t dbi)
 
 static inline void tcmu_free_cmd(struct tcmu_cmd *tcmu_cmd)
 {
+	if (tcmu_cmd->se_cmd)
+		tcmu_cmd->se_cmd->priv = NULL;
 	kfree(tcmu_cmd->dbi);
 	kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
 }
@@ -1109,10 +1111,11 @@ tcmu_queue_cmd(struct se_cmd *se_cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	mutex_lock(&udev->cmdr_lock);
+	se_cmd->priv = tcmu_cmd;
 	ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
-	mutex_unlock(&udev->cmdr_lock);
 	if (ret < 0)
 		tcmu_free_cmd(tcmu_cmd);
+	mutex_unlock(&udev->cmdr_lock);
 	return scsi_ret;
 }
 
@@ -1179,7 +1182,6 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 		target_complete_cmd(cmd->se_cmd, entry->rsp.scsi_status);
 
 out:
-	cmd->se_cmd = NULL;
 	tcmu_cmd_free_data(cmd, cmd->dbi_cnt);
 	tcmu_free_cmd(cmd);
 }
@@ -1285,6 +1287,7 @@ static void tcmu_check_expired_ring_cmd(struct tcmu_cmd *cmd)
 	set_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
 	list_del_init(&cmd->queue_entry);
 	se_cmd = cmd->se_cmd;
+	se_cmd->priv = NULL;
 	cmd->se_cmd = NULL;
 
 	pr_debug("Timing out inflight cmd %u on dev %s.\n",
-- 
2.12.3


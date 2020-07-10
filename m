Return-Path: <SRS0=WTMl=AV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C378C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 10:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33B0920767
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 10:48:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="HPyP3npW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgGJKsr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jul 2020 06:48:47 -0400
Received: from mail3.bemta25.messagelabs.com ([195.245.230.81]:39580 "EHLO
        mail3.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727837AbgGJKsq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Jul 2020 06:48:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1594378124; i=@ts.fujitsu.com;
        bh=tK3FIVROxYjkLrzhtoyLVijq5QAfznqa/3uJx7/8R3M=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=HPyP3npWaMvZnXZHexmY6VPFbUOpmQLCAydn2V0FnkJ3encAvX1SKvVXvZiKSUrfN
         uLtytrbsrP2WQ3PeLkowP7UcjVn88E41148dvmuwC3x1eajmxwZrOoe7ptlepBUod0
         TskQSWoS5EKxLUhSEvQ6lJ4TdGm/I5bEqLkFw5V4kjKlhNe8VAan2DFDPnVxULlGic
         +6Pi1ubJOY4J6VxaNi5giZM6cDZILEI2nR1/dfnb6FO9KWsmnt0xkHsFek5OiseYyc
         EewUlPvLTVnWj/CZMgVsCBxn/+741QaJU32cxHMm7MF9WsMmH9c0NvDk20UQ0+belJ
         WZ4/SCvv02A4A==
Received: from [100.112.199.31] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-b.eu-west-1.aws.symcld.net id 86/AA-12842-B87480F5; Fri, 10 Jul 2020 10:48:43 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRWlGSWpSXmKPExsViZ8MRqtvtzhF
  vsLdNy6L7+g42i+XH/zFZ/J10g9WidelbJgcWj49Pb7F4fN4kF8AUxZqZl5RfkcCa8X/GMcaC
  rxwV/Y9KGxifsHcxcnEICUxmlDh27gwrhDOdUWL3nYdsXYycHGwCBhIrJt1nAUmICKxhlFh5Z
  x4zSIJZQE9i2r917CC2sICbxNV/51hBbBYBVYnJDRfBbF4BO4lNj7pYQGwJAXmJjgOTwWxOAX
  uJ/V3/wGwhoJpdfQ9ZJzByL2BkWMVokVSUmZ5RkpuYmaNraGCga2hopGtoaa5raGyul1ilm6S
  XWqpbnlpcomuol1herFdcmZuck6KXl1qyiREYJikFRzt3MP569UHvEKMkB5OSKO+0j+zxQnxJ
  +SmVGYnFGfFFpTmpxYcYZTg4lCR4+1054oUEi1LTUyvSMnOAIQuTluDgURLhne8ClOYtLkjML
  c5Mh0idYlSUEuf95wyUEABJZJTmwbXB4uQSo6yUMC8jAwODEE9BalFuZgmq/CtGcQ5GJaAKkO
  08mXklcNNfAS1mAlp8lIMNZHFJIkJKqoHJa7F3rc7/z8F3drIsWC4vc9pjdrKqiMhlzY5ok/Z
  Oq0NTEgXs/HuSp9+Qec7kVhJxTHSN/pMdQVw7Ky4rHLfd0SEk+pnzH+ulNO8t9nt3xjA8qalY
  Mlnb98ekohtWlVMtZcuEFTbHiLm3F3119HrW8ed/rFPLLYHquVZ7fNe9NtljqmYyL30Xf+Sbu
  W2zrhx/tsijrLPrCKuNj13Zmxm6ncab492Cj3zg+HNxv5hRt+aGRZ4uuuw5W66cMzrn+tCT9T
  jfwrvORj3OwhMiZvSHKU74PWuRw1JdsYjSlbteGBZ6fGjdE7P0uu/ctE/LNrYvZ1zr9/rvZ72
  Tc7O+WUgd4evk+iSh133QhPXmnEIlluKMREMt5qLiRAB3TamcDgMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-7.tower-285.messagelabs.com!1594378122!183263!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 26041 invoked from network); 10 Jul 2020 10:48:43 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-7.tower-285.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 10 Jul 2020 10:48:43 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06AAmgXO025765;
        Fri, 10 Jul 2020 11:48:42 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 6944F20699;
        Fri, 10 Jul 2020 12:48:42 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 4/8] scsi: target: tcmu: Do not queue aborted commands
Date:   Fri, 10 Jul 2020 12:48:13 +0200
Message-Id: <20200710104817.19462-5-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If tcmu receives an already aborted command, tcmu_queue_cmd()
should reject it.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index b06b18d1b135..25c480fde9ee 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1103,8 +1103,8 @@ tcmu_queue_cmd(struct se_cmd *se_cmd)
 	struct se_device *se_dev = se_cmd->se_dev;
 	struct tcmu_dev *udev = TCMU_DEV(se_dev);
 	struct tcmu_cmd *tcmu_cmd;
-	sense_reason_t scsi_ret;
-	int ret;
+	sense_reason_t scsi_ret = TCM_CHECK_CONDITION_ABORT_CMD;
+	int ret = -1;
 
 	tcmu_cmd = tcmu_alloc_cmd(se_cmd);
 	if (!tcmu_cmd)
@@ -1112,7 +1112,8 @@ tcmu_queue_cmd(struct se_cmd *se_cmd)
 
 	mutex_lock(&udev->cmdr_lock);
 	se_cmd->priv = tcmu_cmd;
-	ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
+	if (!(se_cmd->transport_state & CMD_T_ABORTED))
+		ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
 	if (ret < 0)
 		tcmu_free_cmd(tcmu_cmd);
 	mutex_unlock(&udev->cmdr_lock);
-- 
2.12.3


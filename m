Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA6EC433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 16:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AF442076A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 16:12:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="mYmi7lCQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgGQQMg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 12:12:36 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.114]:22352 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726736AbgGQQMf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jul 2020 12:12:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1595002352; i=@ts.fujitsu.com;
        bh=tK3FIVROxYjkLrzhtoyLVijq5QAfznqa/3uJx7/8R3M=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=mYmi7lCQZqy2H2rE01ZVN/fzMc4N32rZ4P9pK6STUgb1M6PPGf0wmqyiaLKaNePIu
         ab/P+CD1CZJuOQPBi8pxKTlw66x6D/QEnTRyxAjwvMbX9G0lNW1Zc6dXBLwvYq1zE9
         M/xplQINZ7ZXGVq/5sBQSTeDAXsXs8gz84+Mdo6sNUGIx5DFhfXBmgSZ2Jxy1NXxuQ
         4YJvczeoUGmeftONDdSNGtmIx1YhNWU3YQPo+jsVglaLTkf3du7YoejTCo4HY7syKv
         2UCm6o49ytEqbcklGQfTzKJGF2mJhnXzTRwCO7RuCmW7SAgZMIheRdLlDuHwJDAZlH
         l0y2GyaBbIOng==
Received: from [100.113.7.235] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-b.eu-central-1.aws.symcld.net id 67/18-62820-FEDC11F5; Fri, 17 Jul 2020 16:12:31 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRWlGSWpSXmKPExsViZ8MRovvurGC
  8wekl7Bbd13ewWSw//o/J4u+kG6wWrUvfMjmweHx8eovF4/MmuQCmKNbMvKT8igTWjP8zjjEW
  fOWo6H9U2sD4hL2LkYtDSGAyo8TuHc0sEM50RolZ3V9Yuxg5OdgEDCRWTLoPlhARWMMosfLOP
  GaQBLOAnsS0f+vYQWxhAU+JlZcPsIDYLAKqElNOX2UCsXkF7CQOPl7ACGJLCMhLdByYDFbDKW
  AvMfvbQbC4EFDNg3VvmScwci9gZFjFaJlUlJmeUZKbmJmja2hgoGtoaKxrpmtkYqCXWKWbpJd
  aqpucmldSlAiU1UssL9YrrsxNzknRy0st2cQIDJSUQrYPOxinvPmgd4hRkoNJSZS3bZVgvBBf
  Un5KZUZicUZ8UWlOavEhRhkODiUJXvFTQDnBotT01Iq0zBxg0MKkJTh4lER4jc8ApXmLCxJzi
  zPTIVKnGBWlxHnFQBICIImM0jy4NlikXGKUlRLmZWRgYBDiKUgtys0sQZV/xSjOwagkzBsGMo
  UnM68EbvoroMVMQIs3fuYFWVySiJCSamAS+7Sqj8sh57rDXIGCLOEM06+p/06tvHxX72Ovh2a
  w5pt4HxeP6xdjij/89L4gfHv+9cJvU9lkbVnltG99m9t7dWL5pO8CliH+de3bH2m/5p8k3br0
  Kv/vT1qn3kqWHzz37c73c7MPrZ/fJSdzyfZigXL//S+Bd2wfpW27temSoOlSPg/pn+pf9FQXL
  lts9bVrbZL8d0Z2JgPV/zzOrYpr/qxd3mBhkB918banV0/7tVVbH98IfHzKpddfknvRtGXfJb
  5YLePcnLk4Y/6ZNrkEWb6+veIznYueFP6Zd+ByfVHO7dgvLh5KCRwH7BYcK42d1dZg8LL+q+B
  Xc877S9N9D0bG6j2N4H59ZXvSM7sGJZbijERDLeai4kQA9ACjIQ8DAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-36.tower-245.messagelabs.com!1595002349!401634!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 23497 invoked from network); 17 Jul 2020 16:12:30 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-36.tower-245.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 17 Jul 2020 16:12:30 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06HGCN0w009783;
        Fri, 17 Jul 2020 17:12:23 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 034F920619;
        Fri, 17 Jul 2020 18:12:21 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH v2 4/8] scsi: target: tcmu: Do not queue aborted commands
Date:   Fri, 17 Jul 2020 18:12:08 +0200
Message-Id: <20200717161212.10731-5-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200717161212.10731-1-bstroesser@ts.fujitsu.com>
References: <20200717161212.10731-1-bstroesser@ts.fujitsu.com>
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


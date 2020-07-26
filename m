Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498EEC4345B
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 15:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 224592070B
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 15:35:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="m6TCvm8x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgGZPf4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 11:35:56 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.4]:62491 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727956AbgGZPfw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Jul 2020 11:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1595777751; i=@ts.fujitsu.com;
        bh=tK3FIVROxYjkLrzhtoyLVijq5QAfznqa/3uJx7/8R3M=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=m6TCvm8xiijc7CAU6Nt/4Xfw6XC81vBwv/qE0Hu4yCjYJR7GWC/CccnN9bOKwnY0u
         0dFTjM+LVEsINuA8xpMOEGsc5DrpLbnC2mx8zEP7otljKlDZ4HySiFD8lXXwi/tVCR
         vFXx8zZETGOyhcsEoeMLS8ifzmESXKMAiQd0mBbZzRV1tYUb4gfqdXSrNd+onKAY6r
         oYsfEJ3gEFVz640Jqn+ZBg5UOvo5PyoTE+DdIOYEFEQST0TZwbTiuMWkkNR7Q/uIK1
         hxsrxwqmtubh9OWhrGXHKnhe6B1qhLD/Yn+REM9I8/Ycfou22IJiM+3FyE4xU+7WDx
         ethnFOx3DM9fA==
Received: from [100.112.192.107] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-a.eu-west-1.aws.symcld.net id 39/B7-17694-6D2AD1F5; Sun, 26 Jul 2020 15:35:50 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRWlGSWpSXmKPExsViZ8MxRffaItl
  4g61zGC26r+9gs1h+/B+Txd9JN1gtWpe+ZXJg8fj49BaLx+dNcgFMUayZeUn5FQmsGf9nHGMs
  +MpR0f+otIHxCXsXIxeHkMBkRolnJ68wQzjTGSWWrXwHlOHkYBMwkFgx6T4LSEJEYA2jxMo78
  5hBEswCehLT/q0DKxIW8JS49O4VC4jNIqAqsbj9GhOIzStgJ3Gj4zNYvYSAvETHgclgNZwC9h
  Ib534AiwsB1SzbdIB9AiP3AkaGVYzmSUWZ6RkluYmZObqGBga6hoZGuoaWJroWxnqJVbqJeqm
  luuWpxSW6hnqJ5cV6xZW5yTkpenmpJZsYgUGSUnAoeAdj35sPeocYJTmYlER5DabIxgvxJeWn
  VGYkFmfEF5XmpBYfYpTh4FCS4L26ECgnWJSanlqRlpkDDFiYtAQHj5II7xyQNG9xQWJucWY6R
  OoUo6KUOG8/SEIAJJFRmgfXBouSS4yyUsK8jAwMDEI8BalFuZklqPKvGMU5GJWEea1ApvBk5p
  XATX8FtJgJaLH7JUmQxSWJCCmpBqYlVyd9jnu8Y5PiyvU7Z9wuXFIVnH9lbU2k5NRDm9z0Uu6
  1eJ3IylO5pR9df7Ui2Mn769tZGvq3o8S2nr0v8Elx+9+9T3c8+GoV41Jz55bIB6XAMMnF+aWO
  t/T/L1h3bNqWZDPfJbnXn851eLzpTW8uzwPJ7qQ+qYotrKZevmvmf9sWc8vfTrZgyzw2p68yg
  o9SYwsbvQJ+FZ+b36898eJ5J7+rIetX8+1V3XL7p9FPrb6lYqzxYX6NrB9zd95U0zK//nV5Y9
  a6+W3nuRY0+2W/CFfLv9PqcOKwQ/Z0tusfLsi/Vpq/0vBw9UarX1ftum6Gi33dXyM/U7A5q2W
  jmtiOqSdv//tou+785FXHGDbvUWIpzkg01GIuKk4EAAask/oNAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-7.tower-267.messagelabs.com!1595777749!466549!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 31289 invoked from network); 26 Jul 2020 15:35:49 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-7.tower-267.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 26 Jul 2020 15:35:49 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06QFZf5R009375;
        Sun, 26 Jul 2020 16:35:41 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 4342420662;
        Sun, 26 Jul 2020 17:35:37 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH v3 4/8] scsi: target: tcmu: Do not queue aborted commands
Date:   Sun, 26 Jul 2020 17:35:06 +0200
Message-Id: <20200726153510.13077-5-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
References: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
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


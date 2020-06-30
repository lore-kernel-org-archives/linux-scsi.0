Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D81C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 10:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83178207FB
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 10:47:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="WHhAnys5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732654AbgF3Krs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 06:47:48 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.116]:14991 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732634AbgF3Krn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jun 2020 06:47:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1593514060; i=@ts.fujitsu.com;
        bh=V1mYi31AUz1A1idkY+oGiLYYIFoQdrkhhsqX+pGUdAg=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=WHhAnys5A7nz1nYirjNph68+PObtOnT9ITaVTA+Fzmk/eAc9mq03xB2wxZGMmNKll
         LD7P/VL4+siqnyW/6RBazQI4ShTeVzOBiUErNMxyYcxtuwIIMukPbYYjHuXBYjNvqZ
         XK2QxKoP0dFgswI1T9t2ZG1ZVslyeR8+mtoemFgs9EpO8uX4+APSsUTrVAgGB9BBvf
         ORwoco+PmnHBMpGOmcHAgJ64e8VLp+pWwdBZb7R4LO+AQEeZMnfSJgTox2199nyi8p
         88E2LV6FxKnyrgHJGdRUVPTgD9RBgPd28q74nbV+qrCVqFmVDWR6pdUMwrcTQ4uY+d
         fs5BqGMNv8x0A==
Received: from [100.113.4.241] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-5.bemta.az-b.eu-central-1.aws.symcld.net id 14/B0-10801-C481BFE5; Tue, 30 Jun 2020 10:47:40 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRWlGSWpSXmKPExsViZ8MxVddb4ne
  cwYdzVhbd13ewWSw//o/J4u+kG6wWrUvfMjmweHx8eovF4/MmuQCmKNbMvKT8igTWjC9TfrIX
  fOWoePH4MFsD4xP2LkYuDiGByYwSLZO7WSCc6YwSF6a8Zuti5ORgEzCQWDHpPlhCRGANo8TKO
  /OYQRLMAnoS0/6tYwexhQW8JI5v/w4WZxFQldhydB1YM6+AncSZrrdgtoSAvETHgcksIDangL
  3E2sOnwWwhoJq1m2eyTWDkXsDIsIrRMqkoMz2jJDcxM0fX0MBA19DQWNdU18jYQi+xSjdJL7V
  UNzk1r6QoESirl1herFdcmZuck6KXl1qyiREYKimFrO92MD57/UHvEKMkB5OSKO+9f7/ihPiS
  8lMqMxKLM+KLSnNSiw8xynBwKEnwPhX/HSckWJSanlqRlpkDDFuYtAQHj5II736QNG9xQWJuc
  WY6ROoUo6KUOO9KMaCEAEgiozQPrg0WK5cYZaWEeRkZGBiEeApSi3IzS1DlXzGKczAqCfMmgI
  znycwrgZv+CmgxE9Dia1q/QBaXJCKkpBqYDt1PYlUSEvhZdmqz7XHZpZf4/FnyDYOrTFkeyKi
  kLBPm4LlUm3nr03HfM41c6bxLLmzZ9Wy+/Sbv/sK/hk+eZaqfLGI8HSB8q/vQI/YdGSsCpm8U
  1dVQErqw+e7Hu14HS2MbyzTfztm46OQhScZ/eRNnnk98z/hbMSG/OmymX77JqqK9D0MFv05Y/
  l3iy9Mzr+wf950507egk2u/j9NNzw/us98elHMKeju1seVVa0raD4XbdvKyrDOvPNrptvxLyj
  e1zqxuzvf7lTLEDbyrdUtSm3RvrJ6n+ivjImOe3Qr+AzVOp8/Ml93tvNZ7ideaxP3zLD+e7Du
  hsimvKPA1e+zSFw0PDjCxh843fpzRqsRSnJFoqMVcVJwIACgE3WIQAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-9.tower-248.messagelabs.com!1593514059!620117!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 13514 invoked from network); 30 Jun 2020 10:47:39 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-9.tower-248.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 30 Jun 2020 10:47:39 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05UAlW0c004423;
        Tue, 30 Jun 2020 11:47:32 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 67DC020723;
        Tue, 30 Jun 2020 12:47:31 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [RFC PATCH 4/8] scsi: target: tcmu: Do not queue aborted commands
Date:   Tue, 30 Jun 2020 12:47:05 +0200
Message-Id: <20200630104709.23066-5-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
References: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
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
index c900e3dd25aa..be95518a31dd 100644
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


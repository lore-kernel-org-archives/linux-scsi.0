Return-Path: <SRS0=amAE=Z3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 908B4C2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 02:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 643732077B
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 02:05:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MEnl6REM";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="JcbJwX2m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbfLECFF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Dec 2019 21:05:05 -0500
Received: from a27-21.smtp-out.us-west-2.amazonses.com ([54.240.27.21]:37964
        "EHLO a27-21.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728419AbfLECFF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2019 21:05:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575511504;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        bh=sN9HQYh6wIVagBIBwBcjFatf2XSTX81OaYD+RTbaeUs=;
        b=MEnl6REMwAWupUgIrkziAx7V4m1WceQyy03mLLXcJEoMoR50iTDnyLBiL8e59lUl
        Zsson7+DjZHBSJ55Vu9M0kBQUEwz83DWy7GS5/krT9Q/P+VTThw5BONLfHYMy726Q6a
        1JeUJkYOp6u4dMbTD1I2an5I1M19nmvuS+Pr92Xw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575511504;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:Feedback-ID;
        bh=sN9HQYh6wIVagBIBwBcjFatf2XSTX81OaYD+RTbaeUs=;
        b=JcbJwX2mEG/7jU6YyaxyUKsPhzpyKNyRe30VD9WnsWS+rIZr/qlba1z/MeqyP4Cn
        pRyYHA1EFTQkb7Uw0T+q+/PeedT6MDbEldKOGvtf2vuyz3Qjo9wwNbtYc9IqLIE6p5t
        uL2CUvEJ+zqK8Mkw82ss0QQgH1E0bt51s0nXrSJo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 96AE5C447A5
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 1/5] scsi: Adjust DBD setting in mode sense for caching mode page per LLD
Date:   Thu, 5 Dec 2019 02:05:04 +0000
Message-ID: <0101016ed3cdb63d-06b5ad68-0049-46c5-bb5d-a01866023be5-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1575511482-15115-1-git-send-email-cang@codeaurora.org>
References: <1575511482-15115-1-git-send-email-cang@codeaurora.org>
X-SES-Outgoing: 2019.12.05-54.240.27.21
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS JEDEC standards require DBD field to be set to 1 in mode sense command.
This patch allows LLD to define the setting of DBD if required.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/scsi_lib.c    | 2 ++
 include/scsi/scsi_device.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5447738..3812e90 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2108,6 +2108,8 @@ void scsi_exit_queue(void)
 
 	memset(data, 0, sizeof(*data));
 	memset(&cmd[0], 0, 12);
+
+	dbd = sdev->set_dbd_for_ms ? 8 : dbd;
 	cmd[1] = dbd & 0x18;	/* allows DBD and LLBA bits */
 	cmd[2] = modepage;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3ed836d..f8312a3 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -172,6 +172,7 @@ struct scsi_device {
 				     * because we did a bus reset. */
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
+	unsigned set_dbd_for_ms:1; /* Set "DBD" field in mode sense */
 	unsigned no_report_opcodes:1;	/* no REPORT SUPPORTED OPERATION CODES */
 	unsigned no_write_same:1;	/* no WRITE SAME command */
 	unsigned use_16_for_rw:1; /* Use read/write(16) over read/write(10) */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project


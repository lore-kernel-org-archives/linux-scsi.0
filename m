Return-Path: <SRS0=amAE=Z3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE51DC2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 02:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85DA82077B
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 02:05:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="N+6NlXe6";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="OJucugfE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbfLECFN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Dec 2019 21:05:13 -0500
Received: from a27-18.smtp-out.us-west-2.amazonses.com ([54.240.27.18]:48512
        "EHLO a27-18.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728393AbfLECFM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2019 21:05:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575511512;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        bh=gngtc14NVRoJKKuDG0wSfRUd5NMYGXYWK/InKVDZAXs=;
        b=N+6NlXe6bxVdIVKFPic9WCakHsQyBp5MuID+H8t2Dv5wHe6eKpoj5HHdWCxZTlFT
        8MUWyzM87NtY4cQcOZpdFbA/h2TQO2RcP/Ban5uiwH4kHgs26Js6KRGPyqmEUSvprdQ
        g6S3JAOTLGRxwEoze23oRqH5PKTlpwZ7Q7+1cI/I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575511512;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:Feedback-ID;
        bh=gngtc14NVRoJKKuDG0wSfRUd5NMYGXYWK/InKVDZAXs=;
        b=OJucugfEODHGuLkdGfM/Ua/c0wOjA2r5a2C+wYnzJ4h97S8XheF9QQzGBqmdBj5N
        ieQ8G/fmDtrA/F1KyiBO21fj2soR3ABvGl04aveIcj5exXR3/fAku4g7HSlD1OChEll
        lyPIzaNrE7a81kWSQ62sVYhAwGq1U2Iv7/8Bb4gE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D715BC447A5
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 2/5] scsi: ufs: Use DBD setting in mode sense
Date:   Thu, 5 Dec 2019 02:05:12 +0000
Message-ID: <0101016ed3cdd341-e872a9c6-38be-4169-b284-8c9ab303b85e-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1575511482-15115-1-git-send-email-cang@codeaurora.org>
References: <1575511482-15115-1-git-send-email-cang@codeaurora.org>
X-SES-Outgoing: 2019.12.05-54.240.27.18
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS standards requires DBD field to be set to 1 in mode sense(10).

Some card vendors are more strict and check the DBD field, hence
respond with CHECK_CONDITION (Sense key set to ILLEGAL_REQUEST and
ASC set to INVALID FIELD IN CDB).
When host send mode sense for page caching, as a result of the
CHECK_CONDITION response, host assumes that the device doesn't support
the cache feature and doesn't send SYNCHRONIZE_CACHE commands to flush
the device cache. This can result in data corruption in case of sudden
power down, when there is data stored in the device cache.

This patch fixes the DBD field setting as required in UFS standards.

Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c28c144..5484177 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4596,6 +4596,9 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
 	/* Mode sense(6) is not supported by UFS, so use Mode sense(10) */
 	sdev->use_10_for_ms = 1;
 
+	/* DBD field should be set to 1 in mode sense(10) */
+	sdev->set_dbd_for_ms = 1;
+
 	/* allow SCSI layer to restart the device in case of errors */
 	sdev->allow_restart = 1;
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project


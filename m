Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD1ACA9ECF
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 01:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6778B218AC
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 01:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbfKBBUo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 21:20:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33314 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbfKBBUn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 21:20:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 22898615C4; Sat,  2 Nov 2019 01:20:43 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EC9FA61587;
        Sat,  2 Nov 2019 01:20:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EC9FA61587
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=pass (p=none dis=none) header.from=qti.qualcomm.com
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=pass smtp.mailfrom=cang@qti.qualcomm.com
From:   Can Guo <cang@qti.qualcomm.com>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 1/5] scsi: Adjust DBD setting in mode sense for caching mode page per LLD
Date:   Fri,  1 Nov 2019 18:20:26 -0700
Message-Id: <1572657631-25749-2-git-send-email-cang@qti.qualcomm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572657631-25749-1-git-send-email-cang@qti.qualcomm.com>
References: <1572657631-25749-1-git-send-email-cang@qti.qualcomm.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

Host sends MODE_SENSE_10 with caching mode page, to check if the device
supports the cache feature.
UFS JEDEC standards require DBD field to be set to 1.

This patch allows LLD to define the setting of DBD if required.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/sd.c        | 2 +-
 include/scsi/scsi_host.h | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index aab4ed8..a9cca2f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2660,7 +2660,7 @@ static int sd_try_rc16_first(struct scsi_device *sdp)
 		dbd = 8;
 	} else {
 		modepage = 8;
-		dbd = 0;
+		dbd = sdp->host->set_dbd_for_caching ? 8 : 0;
 	}
 
 	/* cautiously ask */
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 2c3f0c5..3900987 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -650,6 +650,12 @@ struct Scsi_Host {
 	unsigned no_scsi2_lun_in_cdb:1;
 
 	/*
+	 * Set "DBD" field in mode_sense caching mode page in case it is
+	 * mandatory by LLD standard.
+	 */
+	unsigned set_dbd_for_caching:1;
+
+	/*
 	 * Optional work queue to be utilized by the transport
 	 */
 	char work_q_name[20];
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project


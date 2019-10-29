Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F477CA9EC1
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 03:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43FB921479
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 03:11:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HLfw6Q9r";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IIBiRQ6u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731255AbfJ2DLN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 23:11:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34410 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729145AbfJ2DLN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 23:11:13 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2F9E860D93; Tue, 29 Oct 2019 03:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572318672;
        bh=2xBHrDTj1u+VhhE2a1dXWL7IhuWYHPntPetQAGcWQok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLfw6Q9rDiOwEUPL0axBjoki51BQSdj/s3s77/Y3XpDI82h+b0/jY7cNl81IKyDUa
         173EMe8hLM5gTkwEOawEH+OZ9hCmMkUyPVL8P+CWp33ftp6Kgc2Q8RzNMD3dX1l5+3
         FniAegsHrlH+5Cup0WsL0696JxXcxR/tuIfUjqNU=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0686160D86;
        Tue, 29 Oct 2019 03:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572318671;
        bh=2xBHrDTj1u+VhhE2a1dXWL7IhuWYHPntPetQAGcWQok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IIBiRQ6uP76D14CR+uaT6XxCGNCBGbJ4KkG83lwGfajunzYt1vljTUIw2+glU0c8O
         Wbvd61MGVbOAHH0IilBv0mQDjsVRZssLrHN1jHAQv4gcEBTbGA9YSKF1UOnUuelgXI
         s/HAFL9KADjVLhk0xHDQktNiNtQU5UEI/rgw6KkM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0686160D86
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/5] scsi: Adjust DBD setting in mode sense for caching mode page per LLD
Date:   Mon, 28 Oct 2019 20:10:50 -0700
Message-Id: <1572318655-28772-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572318655-28772-1-git-send-email-cang@codeaurora.org>
References: <1572318655-28772-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Host sends MODE_SENSE_10 with caching mode page, to check if the device
supports the cache feature.
UFS JEDEC standards require DBD field to be set to 1.

This patch allows LLD to define the setting of DBD if required.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/sd.c        | 6 +++++-
 include/scsi/scsi_host.h | 6 ++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index aab4ed8..6d8194f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2629,6 +2629,7 @@ static int sd_try_rc16_first(struct scsi_device *sdp)
 {
 	int len = 0, res;
 	struct scsi_device *sdp = sdkp->device;
+	struct Scsi_Host *host = sdp->host;
 
 	int dbd;
 	int modepage;
@@ -2660,7 +2661,10 @@ static int sd_try_rc16_first(struct scsi_device *sdp)
 		dbd = 8;
 	} else {
 		modepage = 8;
-		dbd = 0;
+		if (host->set_dbd_for_caching)
+			dbd = 8;
+		else
+			dbd = 0;
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


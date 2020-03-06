Return-Path: <SRS0=edO9=4X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1263EC3F2D8
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Mar 2020 04:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0E3F2084E
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Mar 2020 04:59:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="FlYFvdcc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgCFE7f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 23:59:35 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:46971 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726563AbgCFE7f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2020 23:59:35 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583470774; h=References: In-Reply-To: References:
 In-Reply-To: Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=GXpAlZQMJ46d8E+NzPOHbu6ayMMgQpR5QqmL2e60+KI=; b=FlYFvdccdc0SGW0NzLEEmmfsKiXZGch4IJCV92DRL58lEoNtoGBA9ahssNXMnJO3tr3P4bxT
 voVoYHU8b6Xx+9fPOctfpjdVCleQ990gjl9Jtp3cqdn/H/ChIv/AokiKWlLF/tccs6vrXfZ0
 cZ/+/Jf2ocxdseAd1z7j/0WSUME=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e61d8a8.7f0c1172a768-smtp-out-n04;
 Fri, 06 Mar 2020 04:59:20 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A26ABC447A4; Fri,  6 Mar 2020 04:59:19 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: nguyenb)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D0539C433A2;
        Fri,  6 Mar 2020 04:59:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D0539C433A2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=nguyenb@codeaurora.org
From:   "Bao D. Nguyen" <nguyenb@codeaurora.org>
To:     ulf.hansson@linaro.org, robh+dt@kernel.org,
        linux-scsi@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, asutoshd@codeaurora.org,
        cang@codeaurora.org, "Bao D. Nguyen" <nguyenb@codeaurora.org>,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 1/4] mmc: core: Add check for NULL pointer access
Date:   Thu,  5 Mar 2020 20:58:15 -0800
Message-Id: <a4f22132015159005c41f7cce0b361b363c7b845.1583470026.git.nguyenb@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1583470026.git.nguyenb@codeaurora.org>
References: <cover.1583470026.git.nguyenb@codeaurora.org>
In-Reply-To: <cover.1583470026.git.nguyenb@codeaurora.org>
References: <cover.1583470026.git.nguyenb@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the SD card is removed, the mmc_card pointer can be set to NULL
by the mmc_sd_remove() function. Check mmc_card pointer to avoid NULL
pointer access.

Signed-off-by: Bao D. Nguyen <nguyenb@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/mmc/core/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 6b38c19..94441a0 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -666,6 +666,9 @@ void mmc_set_data_timeout(struct mmc_data *data, const struct mmc_card *card)
 {
 	unsigned int mult;
 
+	if (!card)
+		return;
+
 	/*
 	 * SDIO cards only define an upper 1 s limit on access.
 	 */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

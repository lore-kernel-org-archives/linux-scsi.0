Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B896DC5DF60
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 08:15:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C8272178F
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 08:15:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TaJfk4Xu";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dSP1hitI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730330AbfKHIPz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:15:55 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49602 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730151AbfKHIPy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 03:15:54 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0BD1D60EE1; Fri,  8 Nov 2019 08:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573200954;
        bh=wXwwwvUINnj34SUr4o4/StB9CH2B0Z+nZ4KsWx3pSAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TaJfk4Xu9q0nBJ66zU39SLjGYXqaLsUEQSfYqezYLpLLSnAfA/YykmeTA90/WLGZm
         +e0byz1wNFadSTKgVHknzUg08Xa/2vxXW4THnMIIMc8iIatkvX+bDsmBSCrRZ2mYea
         dQhXRW0MVc6tCMQnjL6o77FgjfUzF6/TNcba3QNs=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D81FE60BFA;
        Fri,  8 Nov 2019 08:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573200952;
        bh=wXwwwvUINnj34SUr4o4/StB9CH2B0Z+nZ4KsWx3pSAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dSP1hitIrt90furCq7Xv0WAp/532rCkpGXugGqiYg3DwRRVJpSk6I+KFcwW6QzHXq
         bvRIaKVEk24WnRbomQA/MVZFfxO8FlStBUT7rScUZDNPGTHM5a1c9hnaxFC8v8HMfZ
         4KpwnBbwsExWZgeKZdRYcjPVrEyn/I9VkChsXB8Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D81FE60BFA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
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
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 2/5] scsi: ufs: Add new bit field PA_INIT to UECDL register
Date:   Fri,  8 Nov 2019 00:15:28 -0800
Message-Id: <1573200932-384-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1573200932-384-1-git-send-email-cang@codeaurora.org>
References: <1573200932-384-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add new bit field (bit-15) PA_INIT to UECDL register, this will correctly
handle any PA_INIT error.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index dbb75cd..c2961d3 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -195,7 +195,7 @@ enum {
 
 /* UECDL - Host UIC Error Code Data Link Layer 3Ch */
 #define UIC_DATA_LINK_LAYER_ERROR		0x80000000
-#define UIC_DATA_LINK_LAYER_ERROR_CODE_MASK	0x7FFF
+#define UIC_DATA_LINK_LAYER_ERROR_CODE_MASK	0xFFFF
 #define UIC_DATA_LINK_LAYER_ERROR_TCX_REP_TIMER_EXP	0x2
 #define UIC_DATA_LINK_LAYER_ERROR_AFCX_REQ_TIMER_EXP	0x4
 #define UIC_DATA_LINK_LAYER_ERROR_FCX_PRO_TIMER_EXP	0x8
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project


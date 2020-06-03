Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE73C433E1
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 09:20:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C37020674
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 09:20:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IoM4ng/2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgFCJUh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Jun 2020 05:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgFCJUV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2020 05:20:21 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A9BC05BD43;
        Wed,  3 Jun 2020 02:20:21 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id p18so1129577eds.7;
        Wed, 03 Jun 2020 02:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ogVBeLIbUp0NMkbqjh+n5vv4JgRPcqvKmVHALzkoaQM=;
        b=IoM4ng/2v4WolN9uZtbOyJkSTfaNDpUzdLNwJPJ7EEKEQ92PdmqGo+13pEWhiU7p3X
         Cvj/WbgwtrXXsCWCkA77HlsqEsXxKWmzIo0B63myw02OK1Z6ekb9L/LnKiiPrwAKEOno
         D5fmihdWZm1yzhm9xYK/bHOXmTKZ5QEgv/e2DNzqhadtEA0E7q7Tpl4OP0T4gtiChPmw
         3ifSz7QAjPXiYDsxcH7dgYbuJl93t6OEsuoa8TVJ3s5fmZEy8E7sn98SvMqUii3Lu+zL
         vlLv0e7+luboBunXbQa6NVJSGvJ0KE+0cdhvWXl2Jt3vXJC3uWb8yHvutFH2T0nFIUza
         nh3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ogVBeLIbUp0NMkbqjh+n5vv4JgRPcqvKmVHALzkoaQM=;
        b=fD6s2LNVL4dFfHkNZ6ZdJzRfXNXzTmMUdX76PWiTWDfDJI+/jJZJpFd3abNSEECIM/
         ohsssE8Gv5eW2n51yMSRX1Zw0C9IHSjp0ZM7Lu3S62LHId/Lcgv0SHfz8JcvWgvgw9EC
         HQJRTWQsHLCc+1Gl0dFWApMEzN8iOAopUjtPuTQkRRNsc1x9xDWkYnzHZ05UcoNxPW3K
         DmtRfb83VlLSeEQ9WrOp2dbnrIdfJAouquyYLE14I2rIcX1rfa/UX3OOhsEob/uLcTsy
         G1e/5AFkHe34tvBYWBiYIfIwzoLMDWeb/hSNhNOCvgDZKtmvCLJ8/8OY5gA8bMbooIN4
         Ybag==
X-Gm-Message-State: AOAM533Ll/fbSi/NRz8jDmFZyzYbkBpAoLUbz6byrYH95d8CN0j9yMCy
        mPgdGcju88faGkxMNvGcCPQ=
X-Google-Smtp-Source: ABdhPJzXDCE/8Q8sDevWCrnJ5C9NHj2GgnTLW1qURMiMirBoCgNM5FUphb55fmon7SVn5LwHowXCmA==
X-Received: by 2002:aa7:d79a:: with SMTP id s26mr28799189edq.202.1591176019739;
        Wed, 03 Jun 2020 02:20:19 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:d00c:464c:92b:aecc:3637:dc7c])
        by smtp.gmail.com with ESMTPSA id 64sm865636eda.85.2020.06.03.02.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 02:20:19 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        beanhuo@outlook.com
Subject: [RESENT PATCH v5 3/5] scsi: ufs: fix potential access NULL pointer while memcpy
Date:   Wed,  3 Jun 2020 11:19:57 +0200
Message-Id: <20200603091959.27618-4-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200603091959.27618-1-huobean@gmail.com>
References: <20200603091959.27618-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

If param_offset is not 0, the memcpy length shouldn't be the
true descriptor length.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c18c2aadbe14..7163b268ed0b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3210,8 +3210,8 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 	}
 
 	/* Check wherher we will not copy more data, than available */
-	if (is_kmalloc && param_size > buff_len)
-		param_size = buff_len;
+	if (is_kmalloc && (param_offset + param_size) > buff_len)
+		param_size = buff_len - param_offset;
 
 	if (is_kmalloc)
 		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
-- 
2.17.1


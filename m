Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5309C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 10:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92076208A7
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 10:22:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UtM8cW31"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387837AbgE1KVz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 06:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387810AbgE1KVI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 06:21:08 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76370C08C5C5;
        Thu, 28 May 2020 03:21:06 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j21so13264480pgb.7;
        Thu, 28 May 2020 03:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sw0rt0kzpIX/gUx8+hCgXRUMgtmjnf69jO+OqqsmVeg=;
        b=UtM8cW31AvkQC00j8DXuOSIp629fS3hCuVZFezqVeULbkTblEPhvk6Ey2Fx0Qxnm1k
         eP34hG0buqPe5K7WeGfOwz7sE/7ofmoOGKqBZeDq1SVptUBW+RHbEIqHK4kH4zoM3ikI
         6Gr7P1OP9YmJZDnHE8xj4lgD/Aa5FQSJgevNB8GBCI3GZCQ9v+1qViC+tGIPFIZ0O4CW
         lLAPIdiqZTXFRwHlp4VKamYWM4JjMamCa932exOsrAbc+JaljC6bSKdjdaJVwAjnOZ2L
         lD4dgsSSntxzABZIeSuNi/zfJKAWME61JRPdDGgvfBryQzY6dh+zNnT6XOw5/6lSC3Dr
         s5CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sw0rt0kzpIX/gUx8+hCgXRUMgtmjnf69jO+OqqsmVeg=;
        b=f5Zi1WJkyS8I6KS04s0QFpCo+NAm5lyKfaxM2CRcyZZiPa+2prlWpjaTWmGxTx617T
         nfFyfkwkjOEun6W5wEnmmyA8MxlJEqWsaZpGlbNDLKQsH87mPX7qRoBSBtegEuPZGhHc
         +ikAwWQ0oHg3IBG8+7kpgTAkvZNyiPFaEDa89FpOUdg9H3V97R5+IlwvkGt6hAsY6Sh8
         0KE2JN37UolMskYKpUKljnb0bqcYozgna0IMgkRps9l1p+VJcQYyi2iX2dBIGfYtb2rM
         03Vks9RCAtxM8RqfxTyo1VHreDxMQ+oYGwMHGKkl4dc6voOhTuaJOu+76ye9Dc+v25yw
         tzJQ==
X-Gm-Message-State: AOAM532PXCdDKtFO7/A9kR4r+wL3R13s64JCloCVOOoIocBQkDOf8p17
        nhj8MrMMKJcafFIHN0GnCbU=
X-Google-Smtp-Source: ABdhPJzcLA0+TQPlgAm8Qs94D4yKVFqRRUBD1tklJ3GnQ1Zw51/zVWrAlHppT6eTOe4HIMuqeGm2kg==
X-Received: by 2002:a62:1b87:: with SMTP id b129mr2370316pfb.162.1590661265781;
        Thu, 28 May 2020 03:21:05 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id g65sm370180pfb.61.2020.05.28.03.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 03:21:05 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Chris Boot <bootc@bootc.net>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] sbp-target: add the missed kfree() in an error path
Date:   Thu, 28 May 2020 18:20:56 +0800
Message-Id: <20200528102056.911825-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sbp_fetch_command() forgets to call kfree() in an error path.
Add the missed call to fix it.

Fixes: a511ce339780 ("sbp-target: Initial merge of firewire/ieee-1394 target mode support")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/target/sbp/sbp_target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index e4a9b9fe3dfb..504a755ea344 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1128,8 +1128,10 @@ static int sbp_fetch_command(struct sbp_target_request *req)
 				req->orb_pointer + sizeof(req->orb),
 				req->cmd_buf + sizeof(req->orb.command_block),
 				copy_len);
-		if (ret != RCODE_COMPLETE)
+		if (ret != RCODE_COMPLETE) {
+			kfree(req->cmd_buf);
 			return -EIO;
+		}
 	}
 
 	return 0;
-- 
2.26.2


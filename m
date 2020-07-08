Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8113CC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6076720739
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ePpcXke5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbgGHMCr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729091AbgGHMCp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:02:45 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FA1C08C5DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:02:45 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z2so26409632wrp.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RqlEHKoTUXwkwwzl23khP5gj2PQF0+ph23LGhTCUMbw=;
        b=ePpcXke5tXclT2fBQPujnmP2l9hoUTUx+VX/MZTSmyivctPiQwNyHOIJQlMnwrCBq4
         qWa4BcdVq8Or6fdbX0k/F0sMw7F1z2FPsLCG6vfeo/Ms9fJiAiI+kr9alWl7+HrhZ1Aj
         Oc/Zwx5s4NaFdZYy5PTIXbExIKG5C9bSb3+XM4igB+fncFS/rjaHORj/Y30mC4C7tZjw
         KEvyZbNlV1OzL8BHUCIPhlWAQCVgLNWFWn45Hs2oS5LVejnDrzhid9+8IiugOJUIhMn5
         ySriXNtKzfvJ1mSZxGj+5zuwVDSYli87Cz3vLmSGTjG7DwPM3xyVCaUDtx5zTBFeLgjr
         X1Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RqlEHKoTUXwkwwzl23khP5gj2PQF0+ph23LGhTCUMbw=;
        b=md+15FC46IwDpkW8DecYlM9IbFF1HJ62aeOnGZQ3eEy1qRDLiXyoybdhTEVNK/ZL5+
         9yviglX0kgQvNg9Tmr2sW7T1pOYQk408qJGBylu4pgCkrC8uVUEQaiYbGmof5E/2ihMu
         CqZbd2HS0uCxW5saO5CoEqgNuNwlp04GdjiaUadL0MdZZYD1Cv+mPTDamJIIbSUxY7Yn
         FBUW2OmgGxPtY3GmrKXY6QhqMTmX+k1VRTejS30tII/HnrI+XJ2P4OE+syT7g0YBzU43
         gGhSTQ1nlt2/nsTJ1pA+tcU3uIgcP8yI8igKNz8anE/Wo0jnPXOoFnPpA/stWQFaKRMz
         wqng==
X-Gm-Message-State: AOAM533ZHow8eBq+gHcwOv3cLQ/fgZRKw/gW8mdQWYZ2q+wLLKyH0azf
        9IPJsyWk9lonx8Ggdg9pItqq0w==
X-Google-Smtp-Source: ABdhPJybgCUfC2v2G2nkcbaN94RRipdwi48CXMSX3irN5Cb2W43ouvBk5Pn7IZE/DcQiUbAbUj4GhA==
X-Received: by 2002:adf:efc9:: with SMTP id i9mr61721571wrp.77.1594209763930;
        Wed, 08 Jul 2020 05:02:43 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:02:42 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/30] scsi: libfc: fc_rport: Fix bitrotted function parameter and copy/paste error
Date:   Wed,  8 Jul 2020 13:02:04 +0100
Message-Id: <20200708120221.3386672-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Description should state 'remote' port, not 'local'.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/libfc/fc_rport.c:1452: warning: Function parameter or member 'rdata_arg' not described in 'fc_rport_logo_resp'
 drivers/scsi/libfc/fc_rport.c:1452: warning: Excess function parameter 'rport_arg' description in 'fc_rport_logo_resp'

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/libfc/fc_rport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index ea99e69d4d89c..18663a82865f9 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1445,7 +1445,7 @@ static void fc_rport_recv_rtv_req(struct fc_rport_priv *rdata,
  * fc_rport_logo_resp() - Handler for logout (LOGO) responses
  * @sp:	       The sequence the LOGO was on
  * @fp:	       The LOGO response frame
- * @rport_arg: The local port
+ * @rdata_arg: The remote port
  */
 static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 			       void *rdata_arg)
-- 
2.25.1


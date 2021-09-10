Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84CCBC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F10F61216
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbhIJXeH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 19:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234907AbhIJXdf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 19:33:35 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7683C061574
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:19 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id e7so3240891pgk.2
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s1Azg02AtHBirXEqyTq6HoZbHpnb4Qp9PyPKAwI31As=;
        b=MWsTc1RUsGrMXWPSgxKwKRcDOc8SkIqBAiU18WOKXL4B7xipyZ/A2BBf3NFrhis0bx
         6oUSanDYCX+0+rRCjdKfRQXTq4mH0hOadwfRBaCV5LXDFySAHMWxJTQNh917opP2v52G
         8xXCV30jGfI/RwfbV+tpU4SFSkmUcHT0q7NzjZdGDOVKayp35yrIQF22Hrmni3sBVURX
         zgnMLgNddg2jp5mazWsa8/VDqFBApuBpmadHL8gUR/8mCgRcuk9SSs5Fm+3wMDe5YP5j
         uq2ACTJ11EyPKKYkzAE95KX9XDqLSaCZk7wfGNy/uVg3Ra2RQecoV/m1jFAP9uM+2dNb
         uslQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s1Azg02AtHBirXEqyTq6HoZbHpnb4Qp9PyPKAwI31As=;
        b=F3AG4NFHtdrbbQP3osHoJbfUvPQz14F+oPN2rlQocKeRAHqFO1TR/uWa3UZvkQaA5t
         WcUg0d5wUSgl/8q3t4Fb4l74WO3X64ujWNkJF5UlXCLxCfLkGFokoxHSiH8EO2OiD8pj
         sEtSeyRaqLGNWhbn2Si2IDOuxpmp51+oo7zGoS6LPhlyRqKoo6WxDkp9SV+QWEzK2nEB
         8rAOCI+FjxAhtI+zdJ+0PBmwkQaKZIGYjKfBaAi9ZldtZv9hUQ1zCAyPkwRVSsQEPZiM
         u/zA67Ki0ofLKDdsKY9vwwns/+AC/xTWsUrMb1ueMrvF6Xzx4hImfArrGv6uZYnNjMb6
         OCHw==
X-Gm-Message-State: AOAM532GqkVEoSzsPGOSYqOEUo/Qtuxylivx46KKhE2uwl+lLuSNGcq2
        cNZfSAyuOJy7wWg0RGy/Js+7yatMPTywiWlw
X-Google-Smtp-Source: ABdhPJxDtyvv8PrxyuwdlbdFxPM5SWXt0MkKwTz/kkhizA66gBIJg3P0EhhphnBZxMgdH2Dj/So0nA==
X-Received: by 2002:a62:ab04:0:b0:405:c1c0:543c with SMTP id p4-20020a62ab04000000b00405c1c0543cmr10511666pff.36.1631316738901;
        Fri, 10 Sep 2021 16:32:18 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o15sm11325pfk.143.2021.09.10.16.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 16:32:18 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 11/14] lpfc: Fix I/O block after enabling managed congestion mode
Date:   Fri, 10 Sep 2021 16:31:56 -0700
Message-Id: <20210910233159.115896-12-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210910233159.115896-1-jsmart2021@gmail.com>
References: <20210910233159.115896-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the congestion management framework dynamically enables, it may do
so while I/O is in flight. The updates of cmf info due to inflight
I/O completing may happen before values have been initialized.

Fix by ensure cmf_max_bytes_per_interval is initialized when checking
bandwidth utilization for SCSI layer blocking.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index b70f71b5c1f7..a2cd22728b0f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3961,7 +3961,8 @@ lpfc_update_cmf_cmd(struct lpfc_hba *phba, uint32_t size)
 	int cpu;
 
 	/* At this point we are either LPFC_CFG_MANAGED or LPFC_CFG_MONITOR */
-	if (phba->cmf_active_mode == LPFC_CFG_MANAGED) {
+	if (phba->cmf_active_mode == LPFC_CFG_MANAGED &&
+	    phba->cmf_max_bytes_per_interval) {
 		total = 0;
 		for_each_present_cpu(cpu) {
 			cgs = per_cpu_ptr(phba->cmf_stat, cpu);
-- 
2.26.2


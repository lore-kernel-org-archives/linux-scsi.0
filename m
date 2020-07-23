Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7804C433EC
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9065A2080D
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WubRW/8f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgGWMZE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728891AbgGWMZC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:02 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AB6C0619E3
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:01 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a15so4961517wrh.10
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yvmlSuND1dq+URT3Mh7aUGf3QKAqUJVZgTZGCZzRwW8=;
        b=WubRW/8fEDabiHlW0cMuIotrK98GcRuRKeWXglkuhpZe1tWedsUHyPTVTojGFSz8Dq
         4saNu5qFOJVYnGfac5jVqjNGExz90ry3yTMabTVw/4WqWEzM6DzYrvYwaPhrEjfFbSBN
         oNrHXQnkSnJXTl7FY92M9bJ7o/+bavhe2EFmLWxyo8SUf2tU06D9TaEQUX8w4DrpDUl1
         IN+ZpwmHQv+ZKVTfF0hC0nGYQ8XfBb7XCtZruHZdB37PTxgQC3hr1v5PasojgxGem+qf
         efl9/HvVw7lP8AT1bCoZdB+zJ0XH6lJC8i77HDg4pdmdofQA26UdgwUkHe8Lhd+NhSds
         7p3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yvmlSuND1dq+URT3Mh7aUGf3QKAqUJVZgTZGCZzRwW8=;
        b=AdzMIkJAMYD+qGXrHg6PX4zWbGp6Qpf2OMiurACCC/UcniOYsNJu5nMs2n/vriDZtT
         i/Zko7DV2i35HtE1oM89fGB3NOS8Xfxi7ROW6UQE5+Q8TFz6ohtKga5COIQM8UxpTBGM
         83URYso5gXjWqzdXfl4dtx5jgNQzv8+is/ZVLi2s5Wd01f9ptZlPArqHYwUZPtw9Ap3J
         VkChbkQmAjX3gshZHNQeI5r1LzTrSz1+xFJn1LbNVhNy3k7ITvslb7XeCLK7O6JnduVw
         7Nyx5XmPoLPMS0MnGFT7i2AY4+HLzdQNzCah19gsoJjwQO4kZeHyJQEUulx7azZI0Fvt
         DG+w==
X-Gm-Message-State: AOAM53391CkwWdXtOlAIN+AMd2aiZ4MFE163PhW4B7jYyh3/Eei69sHS
        aBLAK4Gl+SZ0CZUyI2kTiB8mVQ==
X-Google-Smtp-Source: ABdhPJw3N7qcgpT6gajm5zonS2WuFVPLLqmli/V8c2MvjY9t7JgOZnqCzEswBphKqc91FCQWVqoW+A==
X-Received: by 2002:a5d:4bc8:: with SMTP id l8mr3786426wrt.159.1595507100629;
        Thu, 23 Jul 2020 05:25:00 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:00 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Subject: [PATCH 09/40] scsi: bfa: bfa_fcpim: Remove set but unused variable 'rp'
Date:   Thu, 23 Jul 2020 13:24:15 +0100
Message-Id: <20200723122446.1329773-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This change subsequently makes 'rp_fcs' unused also.  Remove that too.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/bfa/bfa_fcpim.c: In function ‘bfa_fcpim_lunmask_delete’:
 drivers/scsi/bfa/bfa_fcpim.c:2338:22: warning: variable ‘rp’ set but not used [-Wunused-but-set-variable]
 2338 | struct bfa_rport_s *rp = NULL;
 | ^~

Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bfa/bfa_fcpim.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 766f2b5ed2ab4..f6bf24084a47a 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -2335,9 +2335,7 @@ bfa_fcpim_lunmask_delete(struct bfa_s *bfa, u16 vf_id, wwn_t *pwwn,
 			 wwn_t rpwwn, struct scsi_lun lun)
 {
 	struct bfa_lun_mask_s	*lunm_list;
-	struct bfa_rport_s	*rp = NULL;
 	struct bfa_fcs_lport_s *port = NULL;
-	struct bfa_fcs_rport_s *rp_fcs;
 	int	i;
 
 	/* in min cfg lunm_list could be NULL but  no commands should run. */
@@ -2353,12 +2351,8 @@ bfa_fcpim_lunmask_delete(struct bfa_s *bfa, u16 vf_id, wwn_t *pwwn,
 		port = bfa_fcs_lookup_port(
 				&((struct bfad_s *)bfa->bfad)->bfa_fcs,
 				vf_id, *pwwn);
-		if (port) {
+		if (port)
 			*pwwn = port->port_cfg.pwwn;
-			rp_fcs = bfa_fcs_lport_get_rport_by_pwwn(port, rpwwn);
-			if (rp_fcs)
-				rp = rp_fcs->bfa_rport;
-		}
 	}
 
 	lunm_list = bfa_get_lun_mask_list(bfa);
-- 
2.25.1


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62A80C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FDF664F00
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhCLJsf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbhCLJsF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:48:05 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138BCC061765
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:05 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id o26so3398358wmc.5
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8874Mz34yg9EJ3yZWmxIP9iMB3o9NkD0mVwqsVKhHmY=;
        b=o0BhCUd++tGlcXgX6faAKPu2hCqjqGs2qb816ITnEc14L07dK1WHygs8EnBtYDDsOU
         MwTh9vIbnLiglv1nQFzUYqPnIAz+PaclqTNvxLvOoN/g3gQCz05qCJ/e5F2o60zMyBI6
         chGkjD8hPZBbvRsZ+dIiPQ7kdWA878XJsgcu0fD978dvkU2Jn8FhbUwW/BIyOK3LvwzR
         rzY1ry6xzObfgarnG5Ih4CyEc1CY0p4TgwFcy0gfFlO0DaB05hUhv+I5oPg7d0ma0ZZD
         DMEdSlISoKyiNOOehfen4oiQfx6H1U6nLLXf9EickgQTIhBvGKj96vdaZqHV+t0cZV/E
         qlYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8874Mz34yg9EJ3yZWmxIP9iMB3o9NkD0mVwqsVKhHmY=;
        b=tM6gh/mjlQX82VBZQCPkxPobH6huQqgT0RyU4ejSKRQFI1j6e5NHZRVspR+xz827OT
         nH6iZeQvLiRsEOcBbzz1dh4ruWxyfkVE5ePL5u5DIT5ihds8RNMnQ7F6z1Jqu22dSsq9
         InekELXwKwdEWkXdcSf5TnRnqTEU9ahM3NN3o8i3PuOl7sYs04EYIiXaqSrm4A5dXPXU
         oytmBiXfvN99RJjnyhPTA7n0kDBmufMv+qq7LlAymdeQt5rpbJjIFF98uTDg/XZZG5dp
         kFzFbJJs3F0kOVJ51hLdKMF6c97Ry4j5RnmZ9p33nW8JOuatmZuGEafxEnGxVY9U1JQH
         9FhA==
X-Gm-Message-State: AOAM531N/vV4H8U1mxSalhMo9c+4xN6DgBExb5Mr/w57hJgOwEiq4dJS
        pcBby7isP/mj4f0aucYsPCb6dg==
X-Google-Smtp-Source: ABdhPJxqBCiJeEamdxeuuAVeWji1bOWp989ocCw4YG2BybqIQUG3wCEW7s9DvtjCe5OkWTV9fBuTJA==
X-Received: by 2002:a1c:f614:: with SMTP id w20mr12006715wmc.70.1615542483828;
        Fri, 12 Mar 2021 01:48:03 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:48:03 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 14/30] scsi: bfa: bfa_fcs_lport: Move a large struct from the stack onto the heap
Date:   Fri, 12 Mar 2021 09:47:22 +0000
Message-Id: <20210312094738.2207817-15-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/bfa/bfa_fcs_lport.c: In function ‘bfa_fcs_lport_fdmi_build_rhba_pyld’:
 drivers/scsi/bfa/bfa_fcs_lport.c:2152:1: warning: the frame size of 1200 bytes is larger than 1024 bytes [-Wframe-larger-than=]

Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bfa/bfa_fcs_lport.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 49a14157f123c..b12afcc4b1894 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -1408,7 +1408,7 @@ static void     bfa_fcs_lport_fdmi_rpa_response(void *fcsarg,
 					       u32 resid_len,
 					       struct fchs_s *rsp_fchs);
 static void     bfa_fcs_lport_fdmi_timeout(void *arg);
-static u16 bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi,
+static int bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi,
 						  u8 *pyld);
 static u16 bfa_fcs_lport_fdmi_build_rprt_pyld(struct bfa_fcs_lport_fdmi_s *fdmi,
 						  u8 *pyld);
@@ -1887,6 +1887,8 @@ bfa_fcs_lport_fdmi_send_rhba(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 		bfa_fcs_lport_fdmi_build_rhba_pyld(fdmi,
 					  (u8 *) ((struct ct_hdr_s *) pyld
 						       + 1));
+	if (attr_len < 0)
+		return;
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 			  FC_CLASS_3, (len + attr_len), &fchs,
@@ -1896,17 +1898,20 @@ bfa_fcs_lport_fdmi_send_rhba(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	bfa_sm_send_event(fdmi, FDMISM_EVENT_RHBA_SENT);
 }
 
-static          u16
+static int
 bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 {
 	struct bfa_fcs_lport_s *port = fdmi->ms->port;
-	struct bfa_fcs_fdmi_hba_attr_s hba_attr;
-	struct bfa_fcs_fdmi_hba_attr_s *fcs_hba_attr = &hba_attr;
+	struct bfa_fcs_fdmi_hba_attr_s *fcs_hba_attr;
 	struct fdmi_rhba_s *rhba = (struct fdmi_rhba_s *) pyld;
 	struct fdmi_attr_s *attr;
+	int        len;
 	u8        *curr_ptr;
-	u16        len, count;
-	u16	templen;
+	u16	templen, count;
+
+	fcs_hba_attr = kzalloc(sizeof(*fcs_hba_attr), GFP_KERNEL);
+	if (!fcs_hba_attr)
+		return -ENOMEM;
 
 	/*
 	 * get hba attributes
@@ -2148,6 +2153,9 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	len += ((sizeof(attr->type) + sizeof(attr->len)) * count);
 
 	rhba->hba_attr_blk.attr_count = cpu_to_be32(count);
+
+	kfree(fcs_hba_attr);
+
 	return len;
 }
 
-- 
2.27.0


Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1856C388F2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:25:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95AE2206B7
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:25:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hckddZGc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgKBOYT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 09:24:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgKBOYS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 09:24:18 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14E2C0617A6
        for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2020 06:24:17 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id a9so14799573wrg.12
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2020 06:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7S7czJXKoFmUehfVFN7m7xZuWWqCXLmTUcmn4WxJNRA=;
        b=hckddZGciYNQI/ruTqugSmxaeCQFdVKoY7bMi4NhUOn/QyP7+FG7MHFkLCjeXxf6A8
         P/Q2ZKb5+WVOmYHHCQ546nhycIjUS0lS/y7iyBanpy1aSK4pNagBtR2CFgI1k0eASkK6
         ye7h3CjRsizH8NIJfUprn7MFXHVomB9fm6UfZjQR1k1WLlMn3aXe4y9V3qg+VDh3HveV
         q+ynpaS4Uw72jXzw9OQ32WwZn+V/sO4CmthSPhRx4rssOnP7sAEHCRUWBAXEMFqiSOMl
         4K2KpFYC/MUOI8jm5hJBw8Qv90r+D+kdjteSzQgr2fiPIswqwsDn9aVbL3jZH90UQhVg
         tU5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7S7czJXKoFmUehfVFN7m7xZuWWqCXLmTUcmn4WxJNRA=;
        b=fRneGCeREm5BrnBlyUnqxFtRrlIClmk/mUaz325yXO5vP65WAfmkDPL3VuuVjaGB+6
         HOspvHphOnrfqH+dGh9EGoWYssgY7OMtpzv22NUaUHtV8icGl6fhrmDVnjWvVAU2oBcs
         cTGbuvM4WUFt3/uuJA0YzO7obp7OJVuiUmAcr719MIdmQby52YE44HDZbKzE79L06Tfz
         SkDf4knw/4jzl6HSM3kjEgmbtPC1hfgpqTyqcq+a/iKxX4W5mI1SUa3pzqovYmdeKaoD
         2Wz6iSz5vxq8xeOQ+ZOuRBYkmF1txDo+uaAQJbGA76uyA/JxtBO/2yuE9Hsz23ThKww3
         LE5g==
X-Gm-Message-State: AOAM531tkqyk9LbE6/yqUys5tTumV0OLqeRqfF4kbmpbB1kNDX4L0qAL
        qzzmTMT93qZ2oCUIMYYrV94c3w==
X-Google-Smtp-Source: ABdhPJwGVmaJ0FERlXGI5CMfBTiQzu33duLDjQFIT+/pYqeoUneqPy4KhIliXa1MhM65Zs48UWP5nQ==
X-Received: by 2002:adf:8296:: with SMTP id 22mr20755927wrc.341.1604327056564;
        Mon, 02 Nov 2020 06:24:16 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id f7sm23542501wrx.64.2020.11.02.06.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 06:24:15 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [RESEND 10/19] scsi: lpfc: lpfc_nvme: Remove unused variable 'phba'
Date:   Mon,  2 Nov 2020 14:23:50 +0000
Message-Id: <20201102142359.561122-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102142359.561122-1-lee.jones@linaro.org>
References: <20201102142359.561122-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_nvme.c: In function ‘lpfc_nvme_ls_abort’:
 drivers/scsi/lpfc/lpfc_nvme.c:943:19: warning: variable ‘phba’ set but not used [-Wunused-but-set-variable]

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 69f1a0457f51e..33d007ca5c8e6 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -940,7 +940,6 @@ lpfc_nvme_ls_abort(struct nvme_fc_local_port *pnvme_lport,
 {
 	struct lpfc_nvme_lport *lport;
 	struct lpfc_vport *vport;
-	struct lpfc_hba *phba;
 	struct lpfc_nodelist *ndlp;
 	int ret;
 
@@ -948,7 +947,6 @@ lpfc_nvme_ls_abort(struct nvme_fc_local_port *pnvme_lport,
 	if (unlikely(!lport))
 		return;
 	vport = lport->vport;
-	phba = vport->phba;
 
 	if (vport->load_flag & FC_UNLOADING)
 		return;
-- 
2.25.1


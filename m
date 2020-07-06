Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 113DCC433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 20:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0F8820720
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 20:42:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aak/J0Hl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgGFUmz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 16:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFUmz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 16:42:55 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2981CC061755
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2020 13:42:55 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j4so40266419wrp.10
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jul 2020 13:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c1Le1OsLpPsNRAHy7m82WO4NbJT9mnf3eoycoYN0gdc=;
        b=aak/J0HloeIaB+x42kJKUjBUCv3MDsdhvLwzmXZZmma0YIBoMDq5b6eA4xJekOyLFB
         lnxqwVXem3xpdAVjuBhNT/jS9tOgPQAGN8ylxMjMnNcSYDRVNvsqOR6kgVzd+eWK06IZ
         47Q+LCdqo00B/VMCXK25eq2wHF1PfC3dv5bv77+ZJtahybVcoxLjVf0/ok0W/Rfehwl3
         r7LI5d+Cfv/qDjCRl66cbQ8BaBZvnRoQSK1zjnU2369iw2KUsLHBMUc0Da/+tD92Ca4z
         ST/2SvAwFyWlUccQbETIZhmP68mMEnYULo+zXQI6XA9AutjOvssYTKlOYLVkPB8KVkbT
         BVBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c1Le1OsLpPsNRAHy7m82WO4NbJT9mnf3eoycoYN0gdc=;
        b=WyjTiMBJ7DYFnaJkrfP7b2Hcxf2UVLBS8lYJHgG+ZRDPgJYbQwnKnvPkAU8ASar2S2
         912WHJUGgb5jpXAheAnD+U3pOr7l5ckkgGE0dB0cJhmd/LbXBPmE7WxuH7ZUbEQ49kSa
         3y/Ch1ODvPkvZQcaXZ+kM24UieCJ0wEibv727MZCBQgMQc4hWSQ0oxdcz/d/Ien0XuVO
         J6NS5nnRAFIB2aKsNRZgKtgcdwM7c1iPKG2GpZexj1dpVzC9mKxCTcQ44Ahzj0AQowW1
         XuAs3uQqqxmw8huPzsDcrNKnrnZEYYzl8+lsruiWohbTWWqjt5wC8o69o8JbZGV6MiUn
         kyUQ==
X-Gm-Message-State: AOAM5303xGVLyvOYoW0stUhsqvye37d/BHRBZJ2VdS18D4uxKuNf6EKh
        ZEd+anBB6TvG+f6j7pZ3GwIaazeh
X-Google-Smtp-Source: ABdhPJyUxbRukkOBy76bjRnTQbnhzILqsNV78F0Q3ocT8BsPp3HrO3TgA6QA2CwwDuswNfhThB/AZA==
X-Received: by 2002:adf:eccd:: with SMTP id s13mr54136349wro.217.1594068173696;
        Mon, 06 Jul 2020 13:42:53 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-85-189.oc.oc.cox.net. [68.5.85.189])
        by smtp.gmail.com with ESMTPSA id z63sm734821wmb.2.2020.07.06.13.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 13:42:53 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH] lpfc: Fix less-than-zero comparison of unsigned value
Date:   Mon,  6 Jul 2020 13:42:46 -0700
Message-Id: <20200706204246.130416-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The expressions start_idx - dbg_cnt is evaluated using unsigned int
arthithmetic (since these variables are unsigned ints) and hence can
never be less than zero, so the less than comparison is never true.
Re-write the expression to check for start_idx being less than dbg_cnt.

After the logic was corrected, temp_idx wasn't working correct. So fix it
was fixed as well.

Addresses-Coverity: ("Unsigned compared against 0")
Fixes: 372c187b8a70 ("scsi: lpfc: Add an internal trace log buffer")
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
CC: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 4ba8202d391b..f3656bdcb582 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -14161,12 +14161,10 @@ void lpfc_dmp_dbg(struct lpfc_hba *phba)
 		if ((start_idx + dbg_cnt) > (DBG_LOG_SZ - 1)) {
 			temp_idx = (start_idx + dbg_cnt) % DBG_LOG_SZ;
 		} else {
-			if ((start_idx - dbg_cnt) < 0) {
+			if (start_idx < dbg_cnt)
 				start_idx = DBG_LOG_SZ - (dbg_cnt - start_idx);
-				temp_idx = 0;
-			} else {
+			else
 				start_idx -= dbg_cnt;
-			}
 		}
 	}
 	dev_info(&phba->pcidev->dev, "start %d end %d cnt %d\n",
@@ -14174,7 +14172,7 @@ void lpfc_dmp_dbg(struct lpfc_hba *phba)
 
 	for (i = 0; i < dbg_cnt; i++) {
 		if ((start_idx + i) < DBG_LOG_SZ)
-			temp_idx = (start_idx + i) % (DBG_LOG_SZ - 1);
+			temp_idx = (start_idx + i) % DBG_LOG_SZ;
 		else
 			temp_idx = j++;
 		rem_nsec = do_div(phba->dbg_log[temp_idx].t_ns, NSEC_PER_SEC);
-- 
2.25.0


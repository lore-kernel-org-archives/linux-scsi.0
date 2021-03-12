Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E67C4332E
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F47464FB9
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbhCLJsi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbhCLJsE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:48:04 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FC5C0613D7
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:04 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id y124-20020a1c32820000b029010c93864955so15387224wmy.5
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LUTl6374hjxEzzjAtH58mHOxzvcGWyfAK+Rs8bCebzw=;
        b=Hh6zFui7TwDn62/fwoASFc2WJnZn7cfVhnggojLiwpEHU6m48GwA0Lnx70kBF5ANG1
         20F+vJb7p5+wSCdx945D/L5JHQutDAnvsfvQIvQ3nFS8dC2MhtOzyApGrceHEjti/RMb
         XFfHi6yUPyANab+8/0QfMzKjdkxj/iyG9YVFreuTjGV9+B0YKbHV0QmZYD2x6PFIxfcA
         2mUd2ivVz9n13uBEkKatPUtdhkdjL2BZeoPc5u/DR41wJZfAm4ynWx0gLig0uR4OFZp3
         JeUfFBr+fVAriffDt7K+/1352rpnWyWDUQPfVwP9SsNTVzKH3MfrTtKJOBdWpdaPQgBD
         9VsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LUTl6374hjxEzzjAtH58mHOxzvcGWyfAK+Rs8bCebzw=;
        b=nOeMbVzuAwQuMId0GLO5QKOlVoUp5EGg92UBp3z77t5wD19FW1haP841aaycfDOQgB
         WDKoirJd4/EwHEt4b1G85sxbL4X/PeQ4ARMvhkqbh/qJ4bCJuUxT0jwJgZo/wgzQ7iJM
         rqwESJeeFEt2z658YC3o9fGTpz1qqLr8IagP4OQIJPCFj8YxdsuexRbf0alcdfiFw+WY
         SBYr/Cg0y2qsGZsVe9bHtRYCBio5IYeQRHoHxMGulY0QLnWvbFayJ2wEPAfa0yzyCzpG
         ZtYHqEJPWsMJYZE3gd8A1lOIm0WltlPz5fCJP/2IShf+gzIpSrZ6rAThT8koyu3ZC0Lb
         IgsA==
X-Gm-Message-State: AOAM533Kv1LdN7KB2kCmfvjrxadRWKAK1fNMJf3UTnruZucFtOS8ttzf
        6bEdVQCZzS7T8g0Opy1rsZ2Kjg==
X-Google-Smtp-Source: ABdhPJzn/shtTEA5v/Qw1hr7rVbUOF0K5gx7TDUttgAS1sUo633Z1joLB92r7MaR0cdeyDjNVXN09g==
X-Received: by 2002:a05:600c:4a06:: with SMTP id c6mr12177115wmp.35.1615542482970;
        Fri, 12 Mar 2021 01:48:02 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:48:02 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 13/30] scsi: lpfc: lpfc_bsg: Fix a few incorrectly named functions
Date:   Fri, 12 Mar 2021 09:47:21 +0000
Message-Id: <20210312094738.2207817-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_bsg.c:3591: warning: expecting prototype for lpfc_bsg_mbox_ext_cleanup(). Prototype was for lpfc_bsg_mbox_ext_session_reset() instead
 drivers/scsi/lpfc/lpfc_bsg.c:3885: warning: expecting prototype for lpfc_bsg_sli_cfg_mse_read_cmd_ext(). Prototype was for lpfc_bsg_sli_cfg_read_cmd_ext() instead
 drivers/scsi/lpfc/lpfc_bsg.c:4371: warning: expecting prototype for lpfc_bsg_mbox_ext_abort_req(). Prototype was for lpfc_bsg_mbox_ext_abort() instead

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index b974d39d233b8..503540cf20414 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -3580,7 +3580,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_bsg_mbox_ext_cleanup - clean up context of multi-buffer mbox session
+ * lpfc_bsg_mbox_ext_session_reset - clean up context of multi-buffer mbox session
  * @phba: Pointer to HBA context object.
  *
  * This is routine clean up and reset BSG handling of multi-buffer mbox
@@ -3869,7 +3869,7 @@ lpfc_bsg_sli_cfg_dma_desc_setup(struct lpfc_hba *phba, enum nemb_type nemb_tp,
 }
 
 /**
- * lpfc_bsg_sli_cfg_mse_read_cmd_ext - sli_config non-embedded mailbox cmd read
+ * lpfc_bsg_sli_cfg_read_cmd_ext - sli_config non-embedded mailbox cmd read
  * @phba: Pointer to HBA context object.
  * @job: Pointer to the job object.
  * @nemb_tp: Enumerate of non-embedded mailbox command type.
@@ -4360,7 +4360,7 @@ lpfc_bsg_handle_sli_cfg_mbox(struct lpfc_hba *phba, struct bsg_job *job,
 }
 
 /**
- * lpfc_bsg_mbox_ext_abort_req - request to abort mbox command with ext buffers
+ * lpfc_bsg_mbox_ext_abort - request to abort mbox command with ext buffers
  * @phba: Pointer to HBA context object.
  *
  * This routine is for requesting to abort a pass-through mailbox command with
-- 
2.27.0


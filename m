Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1FC8C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 03:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388852AbiEFD7l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 23:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388856AbiEFD7W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 23:59:22 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A6A14099
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 20:55:38 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so6821361pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 May 2022 20:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RRiklrwfeFpT22jLAKe6QaKiYruMKel+3owLkp87EMk=;
        b=TgI7qt1n13v1vBypLBYOsf4ctyZgQpad9cda9B7faIcNhYg+6tieeklM2EkF08+bNB
         G4G/6UzGWAxMGmgjpgnqkx0nEsH6hzZZb7+bmnOvMtdY7Lq3q6A3l9BIwzMpUV0k/EEe
         nc7GqCK4K9Re/CeWqIunTJshBul7wukwPbrHVQ2g3EqZ0cJRp2AliizPUQ2TTH9kbrRA
         4RwIS0UfxQp0lRIz12xXrv7BgnsVOK6dh3g/h29J3mOCCM2Z0Kn+ugVY86U8XIqqzrUV
         M2GKz/16nyatknVMoJaO3JQu4h878SfkaEaPK/7xC7jdcuIfC6KZwfYDnLawrCr+W1Dw
         TQYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RRiklrwfeFpT22jLAKe6QaKiYruMKel+3owLkp87EMk=;
        b=znFeMaKTAfO2AqYEepVBWJHtxhGr1XaT00GIUY/e0zbzxcE5g8U28ZzU8PnmOVNRWR
         JAwL90u9dpPrWWQV33E4S2Irw7zMVE/FKAo1tBwJvVo2yGx0GT+RworktSVvlN0Rx+Fw
         9AMRatLAcxrsD5hrxhve5s48RYjDxTVHFsnKVjw0Z48gNQrgB9KpQZg0h09s41K/kbH9
         mS2PoIrfqSQwprZmk9YbdpYe1PWuypqhi4pkrtqS3y0B98QYsyv5pOAMut/emHK3hHHc
         cRMUXinQglGuinZXOYAshq9MdHMg8qs3yw659UUnLAslhn5OxTIQgsQIVh47Q0CTbe02
         3KQg==
X-Gm-Message-State: AOAM530sCQyGJHGSaU7Zt84MeTfCmdIuATl82PdA7+IzjIaHfiCcVH/m
        Mx2+VDNOENzFp9JOw5MVbn3dk8t52aw=
X-Google-Smtp-Source: ABdhPJzosv5+N9aOCeMcukA6e15dpuKqwQoW9CSBKfwh+0ZWTXvPEw9CMUiMtwBZx0Se8YWv69gSOQ==
X-Received: by 2002:a17:90b:4d0c:b0:1dc:d293:148c with SMTP id mw12-20020a17090b4d0c00b001dcd293148cmr2841823pjb.75.1651809337512;
        Thu, 05 May 2022 20:55:37 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ck3-20020a17090afe0300b001cd4989feebsm6065187pjb.55.2022.05.05.20.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 20:55:37 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 12/12] lpfc: Update lpfc version to 14.2.0.3
Date:   Thu,  5 May 2022 20:55:19 -0700
Message-Id: <20220506035519.50908-13-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220506035519.50908-1-jsmart2021@gmail.com>
References: <20220506035519.50908-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.2.0.3

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index a615011c282d..4fab79ed58ed 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.2.0.2"
+#define LPFC_DRIVER_VERSION "14.2.0.3"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.26.2


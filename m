Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD88C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 02:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236795AbiBYCYl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 21:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236782AbiBYCYD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 21:24:03 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271D51C65E4
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:32 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id ev16-20020a17090aead000b001bc3835fea8so3621679pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C70w8BUPCbzOL9C3Lnf+vwcSlpDA1DXJRazZeroCydE=;
        b=HPIR4qTSWVSMqNvlxMCILPN18RqAOUa/juImW/SXD3EsDE984Hc6yT4rDSx9DCoZnf
         gyNPJREnz2FByc4O6XAYcIPf5Xyc7tL6zczwJp2yI3ayC6uGUZqTnIzRX1bV76rzV4/1
         vH9gmuVtSwVshVp9rhsAOlyKE82F770c+ZHl/+oQ7P978A3jXFIov/5b/GwfeMP48L8O
         Fp6iC2+NCURSwbRZBwkYIGcyepCLvLVOXzxRWitjQq/fDccLwATN++WgjG+I6atlOpn9
         iCrD4DkPvshnWeAWiQCYB9fFCIysbUAdJ++lH0mMj6g1HBHkVZaxvq6NQ8ye1rJ+SCJk
         DXlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C70w8BUPCbzOL9C3Lnf+vwcSlpDA1DXJRazZeroCydE=;
        b=26yJ7xH1/Du53LhwG6MSj/jNtjvATOpFL92y5h71EwvdLWFSHc325rSsWHryD7Pv/f
         a28AJ0sVQ+6d34YMEmaZUXfuOnZ8Wk2TlxYtzxdXvI/uDKP8OnqZ+YfVZ2wg4SeQqUQT
         IrikuU7scuLR+/rptN00ad9xgt9HIG5CFl6z2MR8B0U9EtDEJo1bdud2qP/mPfEVpAfG
         0I2lGNHsBY3q/dHvvg8ef30nzLkby40vI1co0bZYkYThqZtvBISW7pKDxbNwOe4laOmq
         bRnUhPCuoq8bzwHlFqUW8jpwgR3PH8S1q7O6Bn1IsZG47Ok1RIBEGIxjgjhBJROPsk/u
         t9Eg==
X-Gm-Message-State: AOAM532uKPcd4OC3Oc3Lc4e+JbQCCf87m1JklCClQ+13us0AdQCWa7dB
        MwXJiohb2lQXVWdp/DSwUK8KyciPW80=
X-Google-Smtp-Source: ABdhPJyIIVFqBTDppZ+dYVTPRHsnL2IZl1Jiw2y7ItpgHfdApiVCY18tIeBBUv56Q968KFn+gSfmYQ==
X-Received: by 2002:a17:90a:1202:b0:1b9:b7e7:1652 with SMTP id f2-20020a17090a120200b001b9b7e71652mr1001282pja.1.1645755811596;
        Thu, 24 Feb 2022 18:23:31 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b004f3b355dcb1sm845596pfh.58.2022.02.24.18.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 18:23:31 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 16/17] lpfc: Update lpfc version to 14.2.0.0
Date:   Thu, 24 Feb 2022 18:23:07 -0800
Message-Id: <20220225022308.16486-17-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220225022308.16486-1-jsmart2021@gmail.com>
References: <20220225022308.16486-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.2.0.0

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 2e9348a6897c..6bceb8a0ae30 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.0.0.4"
+#define LPFC_DRIVER_VERSION "14.2.0.0"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.26.2


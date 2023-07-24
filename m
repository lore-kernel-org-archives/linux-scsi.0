Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B18EB64DD
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 20:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjGXU1R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 16:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjGXU1Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 16:27:16 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8B1A4
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:27:15 -0700 (PDT)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-666e6541c98so4507028b3a.2
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:27:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690230435; x=1690835235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NOuLrpogEcliUJFTaeR3wgrkc35+I2PMcQcj9jx/myA=;
        b=etqiUamaQH0qMPkxSsXfsWb8FDFxSyuqtjA2s06Eh+fwosZ5PMuqKRZWO94D/H19Fg
         2r6ytXFoTIDaO9IF+uBv3AT7iXUTl9PYd/6sVzwjyBffEubvB+G/p+W7g/nO2kd2ByoD
         rolp3dz/RlwLuDGbT7utppVLZhhyL31ZzOWbUvY1AFm3b3rrRVxhGQ4qwEm7WKRGrQk5
         /DBerBqQsMSZnzZ8/I9rDCUMZ6PeMSoMooxT6l9uiuVRKilzDfLz0AvdWfgHAT3lCRG4
         slUwdr/+7qxkVv5F2LuYlfchnKtdIl+/kqipQxE8pvjMMSlVVay45RBSgRkA8xqJgBKm
         Od6g==
X-Gm-Message-State: ABy/qLbf5Pj9jBNCX3Oi/x80iMAElcb2iRotLUt8u7U5eYfRfcVtDy6W
        YzW6MH2KIkxJz0lpyDPgl+M=
X-Google-Smtp-Source: APBJJlEb5QtwcOwRjQCqCmHh50xuPI5tMOXLeQvuJiPGfmrcRCBbfNPJmhhpKDjslEDJEqhCIoZWFQ==
X-Received: by 2002:a05:6a20:1585:b0:137:2b6f:4307 with SMTP id h5-20020a056a20158500b001372b6f4307mr15079788pzj.27.1690230434916;
        Mon, 24 Jul 2023 13:27:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bda6:6519:2a73:345e])
        by smtp.gmail.com with ESMTPSA id v13-20020aa7850d000000b00653fe2d527esm8185540pfn.32.2023.07.24.13.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 13:27:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daniil Lunev <dlunev@chromium.org>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH 05/12] scsi: ufs: Minimize #include directives
Date:   Mon, 24 Jul 2023 13:16:40 -0700
Message-ID: <20230724202024.3379114-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230724202024.3379114-1-bvanassche@acm.org>
References: <20230724202024.3379114-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Only #include those header files that have to be included.

Note: include/ufs/ufshcd.h needs <scsi/scsi_host.h> because of SG_ALL.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/ufs/ufs.h    | 1 -
 include/ufs/ufshcd.h | 1 +
 include/ufs/ufshci.h | 2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index c789252b5fad..8d3187c83dcd 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -11,7 +11,6 @@
 #ifndef _UFS_H
 #define _UFS_H
 
-#include <linux/mutex.h>
 #include <linux/types.h>
 #include <uapi/scsi/scsi_bsg_ufs.h>
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index fc80de57a4c6..67bd089e70bc 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -20,6 +20,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/dma-direction.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
 #include <ufs/unipro.h>
 #include <ufs/ufs.h>
 #include <ufs/ufs_quirks.h>
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 146fbea76d98..4941ffb068ef 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -11,7 +11,7 @@
 #ifndef _UFSHCI_H
 #define _UFSHCI_H
 
-#include <scsi/scsi_host.h>
+#include <linux/types.h>
 
 enum {
 	TASK_REQ_UPIU_SIZE_DWORDS	= 8,

Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06794C001DC
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 19:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbjG0Tq5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 15:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjG0Tqz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 15:46:55 -0400
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2959D2D73
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:46:55 -0700 (PDT)
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3a1ebb85f99so1121334b6e.2
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:46:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690487214; x=1691092014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1UXA5/QsHigIuc8TSIYQ0/DzLgaWkB5vWt7gbM+DwHI=;
        b=PC/sNnrmnsI8qXKLxZXoGd6LnDAdA50yBUjIQfdNIFPbfOYYBJTbsehs46bNeJ9Msa
         RgeNM/+cWDtKYhXAvLclL0WqayLFdqrAA4ZfGDYQVz4V2cdxgTYiC8dgnJETZwy6O2R3
         ojQHPmq49zFx3C4EeQPPYQfF9qFU16jLopa/Z5n/vlGrYas9FIfflK7HU0KlO1+c0+pm
         xMJRlVfMbRJx9IRT2vb91/9uTJt2DXhzzYr2gcqeufNngntIiNrnltx/nlTVUb9xq06s
         mKlg2SWDwoWvoGmCocukPnsQhXq/nZPVx1o+PlxJUyIykbz1TWf/42QLHToR+ozt8BET
         GJaA==
X-Gm-Message-State: ABy/qLZHfnwWaaQx6Lvh7/Ch5Pt/YVk0uADH9kUKbTtScfFESX2Z6sML
        i3GjsduqSBo5qI9t03Y7Du0=
X-Google-Smtp-Source: APBJJlFWn8ZrrejvAQNOVA+4jdcjV/+LySC5HsIJS93jwJIBO3cI3naUB+Bpj/msSUQEQg9eokpfTg==
X-Received: by 2002:a05:6808:2a5a:b0:3a3:762b:4ee5 with SMTP id fa26-20020a0568082a5a00b003a3762b4ee5mr164259oib.28.1690487214382;
        Thu, 27 Jul 2023 12:46:54 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:607:27ba:91cb:68ee])
        by smtp.gmail.com with ESMTPSA id 35-20020a630b23000000b00551df489590sm1879203pgl.12.2023.07.27.12.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 12:46:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daniil Lunev <dlunev@chromium.org>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 05/12] scsi: ufs: Minimize #include directives
Date:   Thu, 27 Jul 2023 12:41:17 -0700
Message-ID: <20230727194457.3152309-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230727194457.3152309-1-bvanassche@acm.org>
References: <20230727194457.3152309-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Only #include those header files that are needed.

Note: include/ufs/ufshcd.h needs <scsi/scsi_host.h> because of SG_ALL.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/ufs/ufs.h    | 2 +-
 include/ufs/ufshcd.h | 1 +
 include/ufs/ufshci.h | 3 ++-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index c789252b5fad..0fb733683953 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -11,7 +11,7 @@
 #ifndef _UFS_H
 #define _UFS_H
 
-#include <linux/mutex.h>
+#include <linux/bitops.h>
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
index 146fbea76d98..c48135554d5c 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -11,7 +11,8 @@
 #ifndef _UFSHCI_H
 #define _UFSHCI_H
 
-#include <scsi/scsi_host.h>
+#include <linux/types.h>
+#include <ufs/ufs.h>
 
 enum {
 	TASK_REQ_UPIU_SIZE_DWORDS	= 8,

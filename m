Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2673FC433E8
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06C3F207BB
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OobXBbuj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730311AbgGUQoT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730663AbgGUQmZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:25 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5141DC0619DA
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:25 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f18so3544924wml.3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/DfSYRPuRwDcPXXqc0SkXKNuKhOq3WxfJnslE6gkykI=;
        b=OobXBbuj8BXy7mxmqZ9lX3C6YZTdndsi68EQRxDPxDSwvzxVt94A1vr9qebthKSX1E
         BSkIMCjgIQ6E6GmrSI09RyBhj1JSIZ/hBcjTF79Sc5FY5DjB7JmuHTqPmliMEs15EPqu
         oQmSniWokczz+cHa6qzQWZNx3zxSwq6kKvgTv5WGCC02AvUm7R4/J7jpiJ8LYNBrt9jQ
         EKyXMgmeSAGjBa5g9d1vvyqa8lF+2334CXDSHWnN/YyCNFnxnVjan8hn1ezjAV7WngP+
         fX2D6NI4rvxEim8PZUjsFVI8kBUttfPPpK4M5RIQ87JxJoNLgQH7xFiJY9HhNVwXEP7Y
         /6zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/DfSYRPuRwDcPXXqc0SkXKNuKhOq3WxfJnslE6gkykI=;
        b=RGyuls5MlnFRMW5gqR2uwKThHLVow80mhFOEzwk1LpbMYYGzc6I3KisIv9Y4Cav6Zz
         lhXCafSIlV49dPmCd/StFmZa3+qK9GtqtsxyrOrC4yKVxseUkNL0Hn0+qvjimYSNSTmC
         mByysqVN2E8pellHcqVsyv9h655i6lWwR5cXAs7f8pL3wYv3XEMMDgZS89pCXcekHhFg
         xSRWGIlQqOc9svyCOUGjttdsaCpNXvMfW94otgyvQ+ovJwjcYugRlUhCV7IZOPeAlXo6
         aqPMLEMq9vHtoJgmaYdP3IoeQqymZiWoRweVsKZD2E5kcEgBdxOutH8X/cSjCyDYR7xV
         49zw==
X-Gm-Message-State: AOAM530so2RCK+dMdLrBaMm69mvj2Thj3GdtEp669GImXMkCNKFsDuSY
        tspjOQGLmofQxY6HUUy/c7+dcR2cVeM=
X-Google-Smtp-Source: ABdhPJydaVuSz6VEZdqx4BxqlWT6OyeufNBNKbKgo2Mb6MJzngrznAqYt3BAmNRT2WLVVJ7G+2OS4Q==
X-Received: by 2002:a05:600c:204d:: with SMTP id p13mr4778452wmg.88.1595349744035;
        Tue, 21 Jul 2020 09:42:24 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:23 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com
Subject: [PATCH 19/40] scsi: qla4xxx: ql4_nx: Move 'qla4_82xx_reg_tbl' to the only place its used
Date:   Tue, 21 Jul 2020 17:41:27 +0100
Message-Id: <20200721164148.2617584-20-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 In file included from drivers/scsi/qla4xxx/ql4_def.h:43,
 from drivers/scsi/qla4xxx/ql4_mbx.c:9:
 drivers/scsi/qla4xxx/ql4_nx.h:602:23: warning: ‘qla4_82xx_reg_tbl’ defined but not used [-Wunused-const-variable=]
 602 | static const uint32_t qla4_82xx_reg_tbl[] = {
 | ^~~~~~~~~~~~~~~~~
 [...]
 NB: Lots of these

Cc: QLogic-Storage-Upstream@qlogic.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qla4xxx/ql4_nx.h | 17 -----------------
 drivers/scsi/qla4xxx/ql4_os.c | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.h b/drivers/scsi/qla4xxx/ql4_nx.h
index 98fe78613eb7b..b7a6e7f169ca9 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.h
+++ b/drivers/scsi/qla4xxx/ql4_nx.h
@@ -599,23 +599,6 @@ enum qla_regs {
 	QLA8XXX_CRB_TEMP_STATE,
 };
 
-static const uint32_t qla4_82xx_reg_tbl[] = {
-	QLA82XX_PEG_HALT_STATUS1,
-	QLA82XX_PEG_HALT_STATUS2,
-	QLA82XX_PEG_ALIVE_COUNTER,
-	QLA82XX_CRB_DRV_ACTIVE,
-	QLA82XX_CRB_DEV_STATE,
-	QLA82XX_CRB_DRV_STATE,
-	QLA82XX_CRB_DRV_SCRATCH,
-	QLA82XX_CRB_DEV_PART_INFO,
-	QLA82XX_CRB_DRV_IDC_VERSION,
-	QLA82XX_FW_VERSION_MAJOR,
-	QLA82XX_FW_VERSION_MINOR,
-	QLA82XX_FW_VERSION_SUB,
-	CRB_CMDPEG_STATE,
-	CRB_TEMP_STATE,
-};
-
 /* Every driver should use these Device State */
 #define QLA8XXX_DEV_COLD		1
 #define QLA8XXX_DEV_INITIALIZING	2
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 27064c602dc70..2572f7aef8f88 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -188,6 +188,23 @@ static int qla4xxx_sysfs_ddb_logout_sid(struct iscsi_cls_session *cls_sess);
 static struct qla4_8xxx_legacy_intr_set legacy_intr[] =
     QLA82XX_LEGACY_INTR_CONFIG;
 
+static const uint32_t qla4_82xx_reg_tbl[] = {
+	QLA82XX_PEG_HALT_STATUS1,
+	QLA82XX_PEG_HALT_STATUS2,
+	QLA82XX_PEG_ALIVE_COUNTER,
+	QLA82XX_CRB_DRV_ACTIVE,
+	QLA82XX_CRB_DEV_STATE,
+	QLA82XX_CRB_DRV_STATE,
+	QLA82XX_CRB_DRV_SCRATCH,
+	QLA82XX_CRB_DEV_PART_INFO,
+	QLA82XX_CRB_DRV_IDC_VERSION,
+	QLA82XX_FW_VERSION_MAJOR,
+	QLA82XX_FW_VERSION_MINOR,
+	QLA82XX_FW_VERSION_SUB,
+	CRB_CMDPEG_STATE,
+	CRB_TEMP_STATE,
+};
+
 static const uint32_t qla4_83xx_reg_tbl[] = {
 	QLA83XX_PEG_HALT_STATUS1,
 	QLA83XX_PEG_HALT_STATUS2,
-- 
2.25.1


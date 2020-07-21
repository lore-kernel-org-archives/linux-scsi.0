Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFBF8C433F7
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86690207BB
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DGiYiaOD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbgGUQoe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730607AbgGUQmU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:20 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85A8C061794
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:19 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id r12so21754761wrj.13
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i1t6w9ay3sOmlutV6cB6eyGNoYyihN1jZLsdY9V5Zes=;
        b=DGiYiaODLokYEAI+AI5UbT0lLOrg3Ifcm/RzMDGdm8oJV9a0IAf3bD1HK8iC6Ueidc
         tbgUWGpsRufUlovyBs1bl+NbSve1qKezI0JdYGkv3sU9s41aKr5gyLPrnDisERd7JAZ0
         Yfgep1jEa0Inn+eGE8Ldrg49Tuy9kyGNOHZC2ZQd+0VCL22rh6znEizPgDMLvJ78L0Wq
         lhojR5YHNeerQ26ZNdWzc+bBVdq7wxrEarJXx80f1Q3UfXmVifmvri2jjMTRtO0XgCXJ
         YOpHu4wdTl4cONOHjlvw89nl/ZOgTtg1kwiITzBH2J3e7G0UoretUdHT8lpA9Ai9Uia/
         RtiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i1t6w9ay3sOmlutV6cB6eyGNoYyihN1jZLsdY9V5Zes=;
        b=K9VS3SF5K2BDr/qYY18fSuGinJ+sjBgUr6Jdwr/JUZWZJZyD2aWpnckuPm2fdLg1hG
         GiLSR+riHA3eGj+st+qT0GlKv8/bkjgw450G1f3i8avfp/AmbaF12b2yyFfY48mwCUDF
         zHyEvP3jtwD53l1ZZXjzbT//es+MXSZegDyvi+jXG9Cy2z48UuyAYRpbfdQJDSsIhwhy
         Zg+Z0kd+weeYPtXo2qgpX7GQhoU8x7PpvluNsp+dj8HquJ+o9eDkIVO/R9wLa1jeXvKD
         +XkpqwDzy3alyWALVfwDyK6UJhhCq/r/vDrvexMAaVLSTjWQG5lJ1I3HVbFmjgcvFheb
         fMOA==
X-Gm-Message-State: AOAM533Xg7btyrwBl6TPtIpM5eJBwCM/Xct418R1du5loPemfvfiNI1g
        fqq97mmJovDiuaQ/jb9P6a453OLQZWg=
X-Google-Smtp-Source: ABdhPJw+DORx0hKIwI5r4QAYg10zVLEOIpWLSpc8KbFESAziRXZJ7WUr3kehUxk5/iy21yXkQnALCw==
X-Received: by 2002:adf:e38b:: with SMTP id e11mr27052566wrm.65.1595349738630;
        Tue, 21 Jul 2020 09:42:18 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:18 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com
Subject: [PATCH 14/40] scsi: qla4xxx: ql4_83xx: Move 'qla4_83xx_reg_tbl' from shared header
Date:   Tue, 21 Jul 2020 17:41:22 +0100
Message-Id: <20200721164148.2617584-15-lee.jones@linaro.org>
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

'qla4_83xx_reg_tbl' is only used in 'drivers/scsi/qla4xxx/ql4_os.c',
move it there.

Fixes the following W=1 kernel build warning(s):

 In file included from drivers/scsi/qla4xxx/ql4_def.h:46,
 from drivers/scsi/qla4xxx/ql4_init.c:9:
 At top level:
 drivers/scsi/qla4xxx/ql4_83xx.h:90:23: warning: ‘qla4_83xx_reg_tbl’ defined but not used [-Wunused-const-variable=]
 90 | static const uint32_t qla4_83xx_reg_tbl[] = {
 | ^~~~~~~~~~~~~~~~~
 In file included from drivers/scsi/qla4xxx/ql4_def.h:46,
 from drivers/scsi/qla4xxx/ql4_mbx.c:9:
 drivers/scsi/qla4xxx/ql4_83xx.h:90:23: warning: ‘qla4_83xx_reg_tbl’ defined but not used [-Wunused-const-variable=]
 90 | static const uint32_t qla4_83xx_reg_tbl[] = {
 | ^~~~~~~~~~~~~~~~~
 [...]
 NB: Lots of these - snipped for brevity.

Cc: QLogic-Storage-Upstream@qlogic.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qla4xxx/ql4_83xx.h | 17 -----------------
 drivers/scsi/qla4xxx/ql4_os.c   | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_83xx.h b/drivers/scsi/qla4xxx/ql4_83xx.h
index 775fdf9fcc876..f34583e5f8dee 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.h
+++ b/drivers/scsi/qla4xxx/ql4_83xx.h
@@ -87,23 +87,6 @@
 #define QLA83XX_FW_API			0x356C
 #define QLA83XX_DRV_OP_MODE		0x3570
 
-static const uint32_t qla4_83xx_reg_tbl[] = {
-	QLA83XX_PEG_HALT_STATUS1,
-	QLA83XX_PEG_HALT_STATUS2,
-	QLA83XX_PEG_ALIVE_COUNTER,
-	QLA83XX_CRB_DRV_ACTIVE,
-	QLA83XX_CRB_DEV_STATE,
-	QLA83XX_CRB_DRV_STATE,
-	QLA83XX_CRB_DRV_SCRATCH,
-	QLA83XX_CRB_DEV_PART_INFO1,
-	QLA83XX_CRB_IDC_VER_MAJOR,
-	QLA83XX_FW_VER_MAJOR,
-	QLA83XX_FW_VER_MINOR,
-	QLA83XX_FW_VER_SUB,
-	QLA83XX_CMDPEG_STATE,
-	QLA83XX_ASIC_TEMP,
-};
-
 #define QLA83XX_CRB_WIN_BASE		0x3800
 #define QLA83XX_CRB_WIN_FUNC(f)		(QLA83XX_CRB_WIN_BASE+((f)*4))
 #define QLA83XX_SEM_LOCK_BASE		0x3840
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 5dc697ce8b5dd..97fa290cf295f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -188,6 +188,23 @@ static int qla4xxx_sysfs_ddb_logout_sid(struct iscsi_cls_session *cls_sess);
 static struct qla4_8xxx_legacy_intr_set legacy_intr[] =
     QLA82XX_LEGACY_INTR_CONFIG;
 
+static const uint32_t qla4_83xx_reg_tbl[] = {
+	QLA83XX_PEG_HALT_STATUS1,
+	QLA83XX_PEG_HALT_STATUS2,
+	QLA83XX_PEG_ALIVE_COUNTER,
+	QLA83XX_CRB_DRV_ACTIVE,
+	QLA83XX_CRB_DEV_STATE,
+	QLA83XX_CRB_DRV_STATE,
+	QLA83XX_CRB_DRV_SCRATCH,
+	QLA83XX_CRB_DEV_PART_INFO1,
+	QLA83XX_CRB_IDC_VER_MAJOR,
+	QLA83XX_FW_VER_MAJOR,
+	QLA83XX_FW_VER_MINOR,
+	QLA83XX_FW_VER_SUB,
+	QLA83XX_CMDPEG_STATE,
+	QLA83XX_ASIC_TEMP,
+};
+
 static struct scsi_host_template qla4xxx_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= DRIVER_NAME,
-- 
2.25.1


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CFEDC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A89364EBA
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355672AbhCDAcj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359761AbhCCOuu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:50:50 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F520C0611BF
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:47:42 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id u187so5392691wmg.4
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GU8Y2fU2IPGLTocyu2Vs2OyGQon6ldafbekOMqUJ5SM=;
        b=M3q0WIe1Cnzq0w/d7Q+kHBzw27f0RuiCBJB7Xim0oB03tMl0FA88FSXO1wH9QA14vW
         ZIU/xJ/wRJ5rZhQZtn9lh7hX5c55tSVUjEC5klSItz8DIdMkaL/1SwBrYh+iYJuNbrLN
         bdeQtFltgGxvi0M/mlMz2HrhV41uRDfSm7hhF6aYRnqf5/SqoIsltPrcwdI4SRtzyCi7
         JoJ3j6k7bE+BxykdsZIqsMPT+83RmowzJ6Md5gzsRQ1kRMb/3fxRupK1jBDN4gLKzcV0
         zR4dKzovB+xi9fqFZ4uW488cbMynrswf5XQlCZfS3Et8rODuprLxP2CSA2jCkb5f+fAO
         c6hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GU8Y2fU2IPGLTocyu2Vs2OyGQon6ldafbekOMqUJ5SM=;
        b=ij1hyT17N6Mk83yWqvyjii2Fom3x/Yae2tMTJomF4F1fTlyLCwdBrZf5a10M1IKTcJ
         97YYSbMQcSqnhU/GFjkw4S49PoyiT3PvLv39+AovxgP7yUSYCnTQRDpr/+AI4AypbDqw
         R3Ul9qlg6HuJfEBzUO7+lmxT1LxTNjuExv3fpkZKSjueP5qatZW6Nwo6Of6JeNeNqFF7
         vECo2dhuR1DUUHns24J45TMeQWmKK+WoNLbOGWTwKk078d52ut+rEgfBSVBQ2rUEYhyL
         qEN9ex4QjbM3ibodGl05yOUCLcYR6bQPld8Uzjl+ygGlkKOm+sxn54FOLwulGDU8sSmm
         oUPg==
X-Gm-Message-State: AOAM532Yh3wL8etB4+pYvod1BGNL2gbEcKCgBxmykpYy2u/XAQF3M0zk
        Tch3A1U8BYQ2RFQARsLSd6FioVGgtSjgHQ==
X-Google-Smtp-Source: ABdhPJw4ZS6vhz895/y/q1aE97JtZo5BnoyyQUg+XtYLIs3G9VcdEShToaonr7xYVVEHHh4yAYKUDg==
X-Received: by 2002:a1c:730a:: with SMTP id d10mr9233099wmb.53.1614782860947;
        Wed, 03 Mar 2021 06:47:40 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:47:40 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 23/30] scsi: qla2xxx: qla_gs: Fix some incorrect formatting/spelling issues
Date:   Wed,  3 Mar 2021 14:46:24 +0000
Message-Id: <20210303144631.3175331-24-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qla2xxx/qla_gs.c:1259: warning: expecting prototype for qla2x00_snd_rft_id(). Prototype was for qla2x00_sns_rft_id() instead
 drivers/scsi/qla2xxx/qla_gs.c:1492: warning: expecting prototype for qla2x00_prep_ct_req(). Prototype was for qla2x00_prep_ct_fdmi_req() instead
 drivers/scsi/qla2xxx/qla_gs.c:1596: warning: expecting prototype for perform HBA attributes registration(). Prototype was for qla2x00_hba_attributes() instead
 drivers/scsi/qla2xxx/qla_gs.c:1851: warning: expecting prototype for perform Port attributes registration(). Prototype was for qla2x00_port_attributes() instead
 drivers/scsi/qla2xxx/qla_gs.c:2284: warning: expecting prototype for perform RPRT registration(). Prototype was for qla2x00_fdmi_rprt() instead

Cc: Nilesh Javali <njavali@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 517d358b0031a..8e126afe61b11 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1247,7 +1247,7 @@ qla2x00_sns_gnn_id(scsi_qla_host_t *vha, sw_info_t *list)
 }
 
 /**
- * qla2x00_snd_rft_id() - SNS Register FC-4 TYPEs (RFT_ID) supported by the HBA.
+ * qla2x00_sns_rft_id() - SNS Register FC-4 TYPEs (RFT_ID) supported by the HBA.
  * @vha: HA context
  *
  * This command uses the old Exectute SNS Command mailbox routine.
@@ -1479,7 +1479,7 @@ qla2x00_update_ms_fdmi_iocb(scsi_qla_host_t *vha, uint32_t req_size)
 }
 
 /**
- * qla2x00_prep_ct_req() - Prepare common CT request fields for SNS query.
+ * qla2x00_prep_ct_fdmi_req() - Prepare common CT request fields for SNS query.
  * @p: CT request buffer
  * @cmd: GS command
  * @rsp_size: response size in bytes
@@ -1582,7 +1582,7 @@ qla25xx_fdmi_port_speed_currently(struct qla_hw_data *ha)
 }
 
 /**
- * qla2x00_hba_attributes() perform HBA attributes registration
+ * qla2x00_hba_attributes() - perform HBA attributes registration
  * @vha: HA context
  * @entries: number of entries to use
  * @callopt: Option to issue extended or standard FDMI
@@ -1837,7 +1837,7 @@ qla2x00_hba_attributes(scsi_qla_host_t *vha, void *entries,
 }
 
 /**
- * qla2x00_port_attributes() perform Port attributes registration
+ * qla2x00_port_attributes() - perform Port attributes registration
  * @vha: HA context
  * @entries: number of entries to use
  * @callopt: Option to issue extended or standard FDMI
@@ -2272,7 +2272,7 @@ qla2x00_fdmi_dhba(scsi_qla_host_t *vha)
 }
 
 /**
- * qla2x00_fdmi_rprt() perform RPRT registration
+ * qla2x00_fdmi_rprt() - perform RPRT registration
  * @vha: HA context
  * @callopt: Option to issue extended or standard FDMI
  *           command parameter
-- 
2.27.0


Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F9AC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 922772073E
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FCjmwtor"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgGGOBI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 10:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbgGGOBH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 10:01:07 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF144C08C5EE
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2020 07:01:06 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id l17so43400836wmj.0
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2020 07:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y26Vcc37Y6OJEhG8oY+4cT2VI5Efu0cSqIbZ+fS/jqU=;
        b=FCjmwtorz6vctEvTWYfiq6Y8f6Fbx+tEDfnlJ4nB5DOyvJmPt//qLYZCSdT1zX1nkk
         mMz1faRYby4rbkKcS+C0KGL5LFQsQMep3SxKa7N+B2i1kW5PZG1LACp9KoGKNKPdmk8m
         6hra1t1Pec7tsMfKPiVo1jeEFbuslPDFkGBfig7Q/5HqW4xYOeM+z55AMZcbFr+NAgss
         fYetrg61K4XOj+wS/l8gsTVbPAWiGPTFH+H2WweP8zHXhhd7zDVcK0TMGzGQZIQFufB8
         cAsc2iPIbGETO8T8H7n5QpZYZeq56MrH9mxqxuUsRROd9RQBI/lsaprFh99AYJ+RXasi
         eoRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y26Vcc37Y6OJEhG8oY+4cT2VI5Efu0cSqIbZ+fS/jqU=;
        b=JP/GWlmmDOHl4kk6egl4rce84oirzeEb8IW5GLx9YphsaBXNaoQWlYuRT8I34teVDW
         Oc7Z5Kt8fzA7Yhg+OzF86fb87P36eqUXMgcJ36BqaaSNmUoNKWGbP3k2wadgNKNQBnyT
         xCIfcbU5FI507JTYTyT9zLVe9N6vNZ3J0gc/qz2JiQjYzOQiQ9av+1q6/AMbKWKX/j3T
         eQfyLI/EY84t8N0J4knL+lV8Op8KzO2+6/HCv5GuSZHGpUWA0Cuh1cXHfSkLsAOoonPd
         Jokd21LJJgjG4wVkcdfffKrLbCjY0KGptmEs+K1DOvF5VPQlPU+9HPM7Z1I6nvtn6fv6
         lFKQ==
X-Gm-Message-State: AOAM531BjRKKznhI0sX22M22biDarYcCItM4ouImPYDKotFKJIXX/EtQ
        GS8Y8C78hvgOKxJnzL1EY3YZyQ==
X-Google-Smtp-Source: ABdhPJz9FiSCfYQyexg75B2J0366VKNTbJB4HFjPBXFZA9hl6Dsav7GSP0byu0+b/dcrkwrBbF/fFw==
X-Received: by 2002:a1c:804c:: with SMTP id b73mr4286540wmd.59.1594130465582;
        Tue, 07 Jul 2020 07:01:05 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id z25sm1102823wmk.28.2020.07.07.07.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 07:01:04 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        megaraidlinux.pdl@broadcom.com
Subject: [PATCH 05/10] scsi: megaraid: megaraid_sas_base: Provide prototypes for non-static functions
Date:   Tue,  7 Jul 2020 15:00:50 +0100
Message-Id: <20200707140055.2956235-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200707140055.2956235-1-lee.jones@linaro.org>
References: <20200707140055.2956235-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For Megaraid DebugFS functions called from 'megaraid_sas_base.c'.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/megaraid/megaraid_sas_debugfs.c:102:6: warning: no previous prototype for ‘megasas_init_debugfs’ [-Wmissing-prototypes]
 102 | void megasas_init_debugfs(void)
 | ^~~~~~~~~~~~~~~~~~~~
 drivers/scsi/megaraid/megaraid_sas_debugfs.c:112:6: warning: no previous prototype for ‘megasas_exit_debugfs’ [-Wmissing-prototypes]
 112 | void megasas_exit_debugfs(void)
 | ^~~~~~~~~~~~~~~~~~~~
 drivers/scsi/megaraid/megaraid_sas_debugfs.c:122:1: warning: no previous prototype for ‘megasas_setup_debugfs’ [-Wmissing-prototypes]
 122 | megasas_setup_debugfs(struct megasas_instance *instance)
 | ^~~~~~~~~~~~~~~~~~~~~
 drivers/scsi/megaraid/megaraid_sas_debugfs.c:161:6: warning: no previous prototype for ‘megasas_destroy_debugfs’ [-Wmissing-prototypes]
 161 | void megasas_destroy_debugfs(struct megasas_instance *instance)
 | ^~~~~~~~~~~~~~~~~~~~~~~

Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: megaraidlinux.pdl@broadcom.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 4 ----
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 6 ++++++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 00668335c2afc..1ccd72b1cbe7f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -202,10 +202,6 @@ static bool support_pci_lane_margining;
 static spinlock_t poll_aen_lock;
 
 extern struct dentry *megasas_debugfs_root;
-extern void megasas_init_debugfs(void);
-extern void megasas_exit_debugfs(void);
-extern void megasas_setup_debugfs(struct megasas_instance *instance);
-extern void megasas_destroy_debugfs(struct megasas_instance *instance);
 
 void
 megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 30de4b01f7035..5f657d2ba733a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -1388,4 +1388,10 @@ int megasas_check_mpio_paths(struct megasas_instance *instance,
 			      struct scsi_cmnd *scmd);
 void megasas_fusion_ocr_wq(struct work_struct *work);
 
+/* DebugFS Prototypes */
+void megasas_init_debugfs(void);
+void megasas_exit_debugfs(void);
+void megasas_setup_debugfs(struct megasas_instance *instance);
+void megasas_destroy_debugfs(struct megasas_instance *instance);
+
 #endif /* _MEGARAID_SAS_FUSION_H_ */
-- 
2.25.1


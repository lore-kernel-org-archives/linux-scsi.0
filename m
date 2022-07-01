Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971CDC43334
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 21:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbiGAVPE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 17:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiGAVPC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 17:15:02 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9734D3DA7E
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 14:15:00 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id v6so2731457qkh.2
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2022 14:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mf1n3IfYE4tkuvBXa7TSqXP0sfdAmMoJONStgoSsKbU=;
        b=nT9dHr5PBsmOf6Nwqb1wUZKGG14pjyt5vxuBIjQ6vXhGK5Cxxz1/+mJZnteW4YJEay
         c5iNUDnCSYm2Bzga7OTZ0jCwR3b7FwgrhmNX7oavpT0S+4JsnSrMW/6PEsMrKk6BukY7
         B689zD6ZdggWLQsbun6dEwBh7VwFR7bOdzpNOYnCa4HqML2RHcOWQHbSd2JQGr3VzNCd
         TfZ5GK6nYZ0536/R+ugtmmpBOAZQmBTUT1fncGs16igkbJ8CURmbv+3Qhp3u56nNeSq4
         S0cOSnmGTcux9ZVJ1WuglTOYfASMJBjSw0s5FhfEwzxZHv1yTa0k3zzD8469zzqYoaw4
         hUAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mf1n3IfYE4tkuvBXa7TSqXP0sfdAmMoJONStgoSsKbU=;
        b=DkySJf4JiNUmPg8cITzv8evYkNMbmux5ld+QUqrpgWlD8pUXlI+rGKkJuvJR6Wpgvy
         jtUsw6DWLc4znPivwsaQitr/Np2j8+FyT2lsY4ME+zvnkCpxHAe+b09g84/yqtKewXGi
         36AjTUv/Y7U4kz1w5K8WDDtM8ktFXJSFFC30i/FXzfH0h8MvVrTs3Gs+hjJFa32LRHE4
         IewZCo81M/Q1wONFdqGI1QlkGaLsSR9PdnAf2bgqE0PaxNs3Ng54ijkDddQC3S+JcMfH
         KLwZjepnh7NBJPC446brSM3GIMTtiHOInFSh8TdknEyZWb2Xc2odG4zwYaZMn8JM/BMn
         i87A==
X-Gm-Message-State: AJIora8BSO9HiDfoSrtJYl8gpDkVi0x4sUY6xn2MToc+Av8gKcj9mGDz
        L0wyat7ERWWXKkK3KGIbHXYlpCL5LMw=
X-Google-Smtp-Source: AGRyM1sfV0R/srlDkDKmRleXB/YmYW4bSP3vGARo0WK+83p8CRgeJ5bhPbqkDLXwEXZFBMM6Tx9BPQ==
X-Received: by 2002:a05:620a:2607:b0:6af:1442:9c61 with SMTP id z7-20020a05620a260700b006af14429c61mr12420476qko.148.1656710099642;
        Fri, 01 Jul 2022 14:14:59 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g6-20020ac842c6000000b00317ccc66971sm14584509qtm.52.2022.07.01.14.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 14:14:58 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 02/12] lpfc: Prevent buffer overflow crashes in debugfs with malformed user input
Date:   Fri,  1 Jul 2022 14:14:15 -0700
Message-Id: <20220701211425.2708-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220701211425.2708-1-jsmart2021@gmail.com>
References: <20220701211425.2708-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Malformed user input to debugfs results in buffer overflow crashes.
Adapt input string lengths to fit within internal buffers, leaving
space for NULL terminators.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 7b24c932e812..25deacc92b02 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2607,8 +2607,8 @@ lpfc_debugfs_multixripools_write(struct file *file, const char __user *buf,
 	struct lpfc_sli4_hdw_queue *qp;
 	struct lpfc_multixri_pool *multixri_pool;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
@@ -2688,8 +2688,8 @@ lpfc_debugfs_nvmestat_write(struct file *file, const char __user *buf,
 	if (!phba->targetport)
 		return -ENXIO;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
@@ -2826,8 +2826,8 @@ lpfc_debugfs_ioktime_write(struct file *file, const char __user *buf,
 	char mybuf[64];
 	char *pbuf;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
@@ -2954,8 +2954,8 @@ lpfc_debugfs_nvmeio_trc_write(struct file *file, const char __user *buf,
 	char mybuf[64];
 	char *pbuf;
 
-	if (nbytes > 63)
-		nbytes = 63;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
@@ -3060,8 +3060,8 @@ lpfc_debugfs_hdwqstat_write(struct file *file, const char __user *buf,
 	char *pbuf;
 	int i;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
-- 
2.26.2


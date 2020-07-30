Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE565C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F9E7204EA
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:21:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Dd+KkYA3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgG3IEo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 04:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728758AbgG3IEk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 04:04:40 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A21C061794
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2020 01:04:40 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id f9so3742662pju.4
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2020 01:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=a5nmJMsF4AiFmiopuj7CUgXTZG7wxT7g+bAIWIJ8I7E=;
        b=Dd+KkYA3GBIV34ktpiCLByQhY4MjmSoHQWPsUpkE0BtrJepy+GdRER/QjtnMSJITXh
         ZtCbAHqgdG8cS1rD4z7prq37R+1djXpDgYNQjLdbsOszZ0f4E+QJYszdG5aYDtyf8B51
         VLpgLI8MdkNeI9cyyWlE1TDmXhp/vHCUjgPas=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=a5nmJMsF4AiFmiopuj7CUgXTZG7wxT7g+bAIWIJ8I7E=;
        b=C+cu30i4AZEcXF1mVNTShz+3OQVkp7LEmu+E9HRdphmQ1YrB+z8Mq76DhCb9o3o9Am
         90UlWNVce4kvBRZ00TPyy/pGbzFUuwMcre8KR9w5bn34FJTeCUBnHEewa37oqipiYLBp
         glb3xuRve/OOoOigBoZWkDsQnx8wdmFBVOPKCNaNCvP9QyrjzNh1a7BcdJSUtkoVo7wJ
         ZhH7eZ3Ck64RuIRzZCDB1qXmYJCowskDLpohDqV97rewBttTAoAI41ayfgAjfZeJGvzs
         Erh3865wcTXx18GKKF1hafMUq1s2KPIU+97NGZK9XsVUm+gU8xAxwpLchuS/fNeqpz+/
         VxKg==
X-Gm-Message-State: AOAM530JlTuJ1rCEhP0avtBhUE+zT3d1J+V76SnpL8a3PoYTsqUe7pYQ
        jEtPSOSiThldQUBp0edAlrh/3sK0Xpw8Jg==
X-Google-Smtp-Source: ABdhPJw+uypwZ3BUW/yYnIr4Y5zRYvs+pLpa4pjkqVx9WSR4ZIzvHFYyl+peW2T3iqL4fWqWLcvQXw==
X-Received: by 2002:a17:90a:230d:: with SMTP id f13mr10137906pje.116.1596096280154;
        Thu, 30 Jul 2020 01:04:40 -0700 (PDT)
Received: from localhost.localdomain ([192.19.212.250])
        by smtp.gmail.com with ESMTPSA id d13sm5051412pfq.118.2020.07.30.01.04.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 01:04:39 -0700 (PDT)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sreekanth.reddy@broadcom.com,
        sathya.prakash@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 7/7] mpt3sas: Update driver version to 35.100.00.00
Date:   Thu, 30 Jul 2020 13:33:49 +0530
Message-Id: <1596096229-3341-8-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596096229-3341-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1596096229-3341-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Updated driver version to 35.100.00.00

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/compile.sh     | 6 +++---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/compile.sh b/drivers/scsi/mpt3sas/compile.sh
index f0bcf6b..d8ac38f 100755
--- a/drivers/scsi/mpt3sas/compile.sh
+++ b/drivers/scsi/mpt3sas/compile.sh
@@ -48,9 +48,9 @@ fi
 # Set SPARSE to non-zero value to enable sparse checking
 #	kernel="2.6.18-8.el5"
 #	kernel="2.6.18-53.el5"
-#	kernel="2.6.27.15-2-default"
-	kernel=`uname -r`
-SPARSE=0
+	kernel="5.8.0-rc1+"
+#	kernel=`uname -r`
+SPARSE=1
 
 blacklist_enclosure
 rm -fr output.log
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index feb8328..b11459a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -76,8 +76,8 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"34.100.00.00"
-#define MPT3SAS_MAJOR_VERSION		34
+#define MPT3SAS_DRIVER_VERSION		"35.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		35
 #define MPT3SAS_MINOR_VERSION		100
 #define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
-- 
2.26.2


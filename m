Return-Path: <SRS0=dbdl=37=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 337AEC352A3
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 10:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B8E920848
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 10:18:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LhiRP6FA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgBKKSw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Feb 2020 05:18:52 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54375 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbgBKKSw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Feb 2020 05:18:52 -0500
Received: by mail-wm1-f65.google.com with SMTP id g1so2699077wmh.4
        for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2020 02:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yiMT/yrySDoFC9TXxmmPmuHWpRnbocCWOPD6sgJ4jEY=;
        b=LhiRP6FAUlcCS9/r8hy5UUPfs7pFzlE5sbvwAIBIXhWSL0ueJmZjPtL08t3/rYHki7
         pB7pH7iJz5lHKr+ougJ5hq7KkD8e7q2jVazBdkyTCRbTDI92VtAj7VD+uWKnhe1SGVNX
         0176ZlToLobyv1Ywo00PBK36xUPPonj7OY6sg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yiMT/yrySDoFC9TXxmmPmuHWpRnbocCWOPD6sgJ4jEY=;
        b=Bk1ca6aBdQiTT48nCQrepzBMl82Z93rvZcgyZpt7UriLqtkTSmcrYzgsB+I0S7LZNk
         VAOjaSr0QQV3Z5ubMs3Cpdj2odwTI0tW8BDSDVz+KttOJ9s3HD/B+l3QP81lhwuLVKNA
         erTCxcosFLSVsMuGfE5yHutHi8F5lfKPkgb9HoySLSQANNHCwEb4Hy/JqPxa4Y9tZll+
         eeImrwMWerGZYeq0SLWsEGWCyYnAJQQqt9Yi47lC6uUjh4Ro982OKO7143WMd9BukcvS
         XhKKwRPqHo/WthM3BoxzFwA9aNxvicduH1lSL7KKpGvqcJIiN2bIL90yGuhKVkbG9xDa
         rVwQ==
X-Gm-Message-State: APjAAAVAdce5nx7ehgsoxsC5XJLkvJevU2cuYcFBvP6/7MzIBOTtnbA0
        r8IEp76Z+CqqevhzpVm8mS5gRi7/d94tS6jnKR+nR+gK6KFxH21LPvFyCyRadzu5fo2OlA+7DDG
        gHsI9QcRybnT5m+232K8dkco7Hr+xJbCciMZ/GB39zoPUouE/6qmxYQbDsFesfAdSJOpXEsn0l/
        elGd5nMD9wfFgRKU/21QYHkY0=
X-Google-Smtp-Source: APXvYqwwfTf/+e9UHeD9XsCEunwmIr6Fp/i3LiNCf+fyJul5NPMM15PWiTKPrK9S99RhETPDh6P4fA==
X-Received: by 2002:a1c:bdc5:: with SMTP id n188mr4823230wmf.124.1581416329958;
        Tue, 11 Feb 2020 02:18:49 -0800 (PST)
Received: from dhcp-10-123-20-55.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id f65sm3058895wmf.29.2020.02.11.02.18.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Feb 2020 02:18:49 -0800 (PST)
From:   suganath-prabu.subramani@broadcom.com
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, kashyap.desai@broadcom.com,
        sathya.prakash@broadcom.com, martin.petersen@oracle.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 5/5] mpt3sas: Update version to 33.101.00.00
Date:   Tue, 11 Feb 2020 05:18:13 -0500
Message-Id: <1581416293-41610-6-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1581416293-41610-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1581416293-41610-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

Update driver version from 33.100.00.00 to
33.101.00.00

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 30ca583..25f1701 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -76,9 +76,9 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"33.100.00.00"
+#define MPT3SAS_DRIVER_VERSION		"33.101.00.00"
 #define MPT3SAS_MAJOR_VERSION		33
-#define MPT3SAS_MINOR_VERSION		100
+#define MPT3SAS_MINOR_VERSION		101
 #define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
 
-- 
1.8.3.1


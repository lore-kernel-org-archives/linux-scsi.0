Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A68EDC6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbjCVUCO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbjCVUB1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 16:01:27 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7F66B31E
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:55 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id ix20so20302035plb.3
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xct695NTdKunJwZpBlsAMpxZPmRVUZn+AcEa7DsrRUQ=;
        b=hJFTkgidnLMKFlvRTwHvHDI//PXLJrmSDB773zy8pwocL64neP7QH8Y9jYLDoExIJA
         QtTnIkCVD/7qnmb34enMJhD5LMcWFfxJuVVVxWyWnmpIBKqbvREIggukGKLizJS9aFvJ
         1CdZ/af/ZsFxOoa+Bg4BhC1xtkjvRGVnO+jbROVjg5Xw7irRDMkLDcQCpzvQ8Xu5AtDT
         /ArUEO3JYHpAwCbPtaFCFBAEBk49SAmplW8r35C0AB1HVNRj3Ai+xPf8dUHALrUpEKGH
         dnYDVHP10jC0mSP+7K50AnCNkxqzfwuHaofzCUAQch+JShSnSPsrW0iM1oWr4Hff8lNA
         VJNA==
X-Gm-Message-State: AO0yUKU2TAKul/lGickmgrxR8Ezxg06SYEsJQL7cMXC0muvCk1n1YCtk
        xc7jIEL3KCFX8i0ZYBvJu2U=
X-Google-Smtp-Source: AK7set/wiFQZdBUvujG4YTJD64YFezGsAO5Shbwt0m+LlrJwosdmebai6gUArpKIsu8NG5jI+Mu8sg==
X-Received: by 2002:a17:90b:4d8f:b0:23d:3a3f:950b with SMTP id oj15-20020a17090b4d8f00b0023d3a3f950bmr5310356pjb.22.1679515119400;
        Wed, 22 Mar 2023 12:58:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 66/80] scsi: qla1280: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:55:01 -0700
Message-Id: <20230322195515.1267197-67-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla1280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 1e7f4d138e06..6e5e89aaa283 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4115,7 +4115,7 @@ qla1280_get_token(char *str)
 }
 
 
-static struct scsi_host_template qla1280_driver_template = {
+static const struct scsi_host_template qla1280_driver_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "qla1280",
 	.name			= "Qlogic ISP 1280/12160",

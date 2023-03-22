Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393A9C6FD1C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjCVT4s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjCVT4h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:56:37 -0400
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD205BDA9
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:28 -0700 (PDT)
Received: by mail-pl1-f171.google.com with SMTP id bc12so19685695plb.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679514987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qFxngvs+9YQWf/cm0pKR7KdAZBfNtlH0C+J3zrjYTbg=;
        b=SXI404o2mZgbtalFlLv9qKZyC+ruhuKt3AePmOSK4dIge65DxFwh0yzbt+EZ1iZ8da
         ihNVp/5ozhNkpB4T/kNh5GV0BT9aO70E2EH5bHXifbQxTRD2nERejVXNOOkw7Xb1kRhb
         pIAgeyWOSIjY4/y94lLJpopJNYk340dXoYw5Xc5elD63pQIqzE9hGjj2OuB1w6mIXTC0
         QIdRwR5EmhMW7zK32605+U8Ppp8V+MGdKM3y/JxVZwyENB5Pw6BGffkjbABRSKhaqRhX
         B0JZs0+DUjYXf9V6SLsC2BnJ3B/gUBqGDPznNAp2u0EYiCoNdkAA9YbAfRwAEPFIuP7R
         awJQ==
X-Gm-Message-State: AO0yUKWgDePfThw4bjuofDu2sqrDhIcL5HnplGFeQvyCep+HPMKtTSU3
        Ze5G6PnRCukQYs2PItVe6OY=
X-Google-Smtp-Source: AK7set/cjyI4n+K8eOrCXeBR7Z9Ch0RZa52H6mfj6/+1F8hjbRd17cKnv3wtWtxUWyfpj5ve8V1n0g==
X-Received: by 2002:a17:90b:1d81:b0:23f:37b6:48f4 with SMTP id pf1-20020a17090b1d8100b0023f37b648f4mr4592575pjb.43.1679514987560;
        Wed, 22 Mar 2023 12:56:27 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:56:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v3 07/80] scsi: message: fusion: Declare SCSI host template members const
Date:   Wed, 22 Mar 2023 12:54:02 -0700
Message-Id: <20230322195515.1267197-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host templates are not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/message/fusion/mptfc.c  | 2 +-
 drivers/message/fusion/mptsas.c | 2 +-
 drivers/message/fusion/mptspi.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index fac747109209..22e7779a332b 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -105,7 +105,7 @@ static int mptfc_abort(struct scsi_cmnd *SCpnt);
 static int mptfc_dev_reset(struct scsi_cmnd *SCpnt);
 static int mptfc_bus_reset(struct scsi_cmnd *SCpnt);
 
-static struct scsi_host_template mptfc_driver_template = {
+static const struct scsi_host_template mptfc_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptfc",
 	.show_info			= mptscsih_show_info,
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 88fe4a860ae5..86f16f3ea478 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1997,7 +1997,7 @@ static enum scsi_timeout_action mptsas_eh_timed_out(struct scsi_cmnd *sc)
 }
 
 
-static struct scsi_host_template mptsas_driver_template = {
+static const struct scsi_host_template mptsas_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptsas",
 	.show_info			= mptscsih_show_info,
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 62089a8caa2f..6c5920db1e9d 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -820,7 +820,7 @@ static void mptspi_slave_destroy(struct scsi_device *sdev)
 	mptscsih_slave_destroy(sdev);
 }
 
-static struct scsi_host_template mptspi_driver_template = {
+static const struct scsi_host_template mptspi_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptspi",
 	.show_info			= mptscsih_show_info,

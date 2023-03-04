Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E77C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjCDAfg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjCDAe6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:34:58 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CABB452
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:21 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id m20-20020a17090ab79400b00239d8e182efso7843717pjr.5
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xct695NTdKunJwZpBlsAMpxZPmRVUZn+AcEa7DsrRUQ=;
        b=RtYg967URvg1Ru5YmOjH1upm8cSDSaP6TZRv2pUBEryaj1Nd8f/ULqlh9vprD3kwj/
         pwUJPCR33lf4ihBdAVRh5OzTtsG5leMmfSIBnX+JWPH8SAlalp2gyBWNs/rEsRE92hOv
         qirgPTKgRmbN1FYQ1RquOEjoyaju5HpHBPpb/yCh8JY0+y7TIczYS2i5THzc35TMIC3g
         iP/UUTQrKkfnAOI1Gr79+556ZmPiBkKqotgkOG5Lxk+mkNF2NwxawycdyA43z88MmmIV
         MX+wvHiDh9KChMplXAJ7NkGleKESOZfctKJ5wrkgksOWJ50MgZqf3PFnc3IhAXz6daih
         5s+A==
X-Gm-Message-State: AO0yUKWENAbJiOtqapqhxILyBJiaR+ccQATpMY43HebVZxEF6Zyfg7FP
        hE0k8Lit0ty44+HCCzRP2+hlGcqzroKGoA==
X-Google-Smtp-Source: AK7set80/eV6wg8O3wHVJWBb1ztYsl/6lcbtg/UpYkRc4ybjPVTW3NsjuG1t2AifHBTsETATOv3ypg==
X-Received: by 2002:a17:902:aa81:b0:19c:be03:d1bd with SMTP id d1-20020a170902aa8100b0019cbe03d1bdmr3108486plr.30.1677890060686;
        Fri, 03 Mar 2023 16:34:20 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:34:19 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 66/81] scsi: qla1280: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:48 -0800
Message-Id: <20230304003103.2572793-67-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
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

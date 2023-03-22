Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6405C6FD1C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjCVT6D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbjCVT5c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:32 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569006923B
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:14 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id le6so20265831plb.12
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BvVVQ+ktXujbe64yu0zbTHHU9T+PctoEBb3huhrnTek=;
        b=WBSEOyi+OtaC15W58jeJkk5lnO9UUqUbaBf59EcC+GWgY6PBR93clDkdVdCJqdW74u
         ZLc1+aBcB21KZm81m90bJrw5Ksgm7aWbxLSh0lJzOMy1bWvtHH3JcbkgZflZhNgjaylq
         2SL3xCkFdbDj7yY4YvZoczU2W1i4spR9mY+snn/QtvDnQjfHbmbXzrvV0l0Avi7oUQPv
         ctctPae2htIAAr6CxBiWkEXZqF7QEGQvAbXGotAQhZl0R229rzhtGSNAFRIftXH+Ca6h
         y9tpT12U1GOS7QqvaJkOtg/ew1/DCJi2Ww+ObbAx4cBcyuoYrt222jAxDI29cCCz+AlM
         lIAA==
X-Gm-Message-State: AO0yUKVyoqGrygBqNqWfZTmwEsugLef9dBecN7XLsA3iYVa2noEbwHEF
        20oejFL7AJt/0uKR2v9C5os=
X-Google-Smtp-Source: AK7set9b8TfAnp6aiaG57OQEDXLqVjkYO0m/2M5Yd9G/35LeOjmEtF7aNXXjoKbovXx+iEDb3TYNuA==
X-Received: by 2002:a17:90b:4f91:b0:234:656d:2366 with SMTP id qe17-20020a17090b4f9100b00234656d2366mr4607365pjb.42.1679515033776;
        Wed, 22 Mar 2023 12:57:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 30/80] scsi: dc395x: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:25 -0700
Message-Id: <20230322195515.1267197-31-bvanassche@acm.org>
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
 drivers/scsi/dc395x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 670a836a6ba1..c8e86f8a631e 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4541,7 +4541,7 @@ static int dc395x_show_info(struct seq_file *m, struct Scsi_Host *host)
 }
 
 
-static struct scsi_host_template dc395x_driver_template = {
+static const struct scsi_host_template dc395x_driver_template = {
 	.module                 = THIS_MODULE,
 	.proc_name              = DC395X_NAME,
 	.show_info              = dc395x_show_info,

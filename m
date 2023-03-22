Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2319C7619A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjCVT64 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjCVT55 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:57 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640356A1F8
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:39 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso24688786pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=239hkCXB94hvY9rEBCDXzyIlK2lqlyBB9GRut91MAN8=;
        b=XgAnVGy1VVlxaSNvNYB1sZAtqBzZjljSVBLbqJFP1L4MTbcgdkZdbkaxv48zdSCGro
         cgEkiTc/gva/ljzQfutqYuUHPGQJ+gIl3EZTjm7iqgnxC19WkSAAtBAL7wxwlzexgD91
         heWtW84nU0bQI9G48iDILAtrV3AuJbXk7eDFwr0HtfjucdBYd3RE2Pfx4dJLs+j5Oklj
         QImNRG7IBiA0esSnCimcXztRm3IGrMxkauSa/hJkpmaKtrhb79GL9xnMf4UDvxSJ9yzK
         pdaqN3XA6o4MnDVNki+apwzLmPHMK3ALRVeBigaOX2eSZV7zv/yKJckWjEMzzZzWwoJ4
         2OHA==
X-Gm-Message-State: AO0yUKUy2sEpsnUREgsKe34q8/us9HGkRPNLu+HgPUmLdUoddofoceVP
        ILVkkCnZl922goKMugXU+a4=
X-Google-Smtp-Source: AK7set+OBehp+W0YYvkjUaeErgCKCX4rmh1bhnZHbT1ikAqhsDWYgqX0esfKNhd3CLImMLxQJ8Oi1Q==
X-Received: by 2002:a17:90b:3eca:b0:23d:e0c1:8b8e with SMTP id rm10-20020a17090b3eca00b0023de0c18b8emr4857788pjb.17.1679515058887;
        Wed, 22 Mar 2023 12:57:38 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 43/80] scsi: hptiop: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:38 -0700
Message-Id: <20230322195515.1267197-44-bvanassche@acm.org>
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
 drivers/scsi/hptiop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 7e8903718245..06ccb51bf6a9 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1159,7 +1159,7 @@ static int hptiop_slave_config(struct scsi_device *sdev)
 	return 0;
 }
 
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module                     = THIS_MODULE,
 	.name                       = driver_name,
 	.queuecommand               = hptiop_queuecommand,

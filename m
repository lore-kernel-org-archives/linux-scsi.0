Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB67C76196
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbjCVT6A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjCVT5b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:31 -0400
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1AE69CE5
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:09 -0700 (PDT)
Received: by mail-pl1-f171.google.com with SMTP id iw3so20295567plb.6
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vZ5GgqrDyGWwIxYM6EGxbvTY6mYY1oAJ1o0rPWwJtYA=;
        b=185IE1WzaNBYUk5qVrzVT25z0w7aLesGWHLtNZL3e2F6zFljDlIpFDgy3N1SX69qmx
         O/cikE1ItYl+7VeuKwwhpNZ5EhDN4nRFlLyzAwTlUyVWNknIbNsGh+LEUXqTWWNQlZYD
         j+WoPM4WBPi31gBy4u9h+/C2MU51AaLWkyrdb18wlr4cRTi2eXgZtaqonpPXxYMnFJwg
         BVBvsZt+892ZIHPYOwWJD2ECogJgYer6ciwBQq2pA/5gyBuhPBNo0h+6i07Ex2mlSBMG
         sIupXVIaG7OpzKiP6fpKjEUN2BiZYSdGINVOqW1pjDdxZXeWLvPfM14Z4/y8gXZJNlXe
         E7CQ==
X-Gm-Message-State: AO0yUKUEjKlgaJ+X3+Bq5xeEsSzNd7F3QycIROqF/8cXt5qWf/x2X4EL
        r1gLUrOJefgZAvMfJSkC1vNl47Rhxt4=
X-Google-Smtp-Source: AK7set+8JmyhmwXHc6mo4jc9UV6WWSbZQ08uK4n21u050jWCSzpvJOFR4kDhXAbPlhT0RkgQ4GwXPA==
X-Received: by 2002:a17:90b:4a12:b0:239:fd9b:85bd with SMTP id kk18-20020a17090b4a1200b00239fd9b85bdmr4683009pjb.27.1679515028893;
        Wed, 22 Mar 2023 12:57:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 26/80] scsi: eesox: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:21 -0700
Message-Id: <20230322195515.1267197-27-bvanassche@acm.org>
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
 drivers/scsi/arm/eesox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index 6f374af9f45f..b3ec7635bc72 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -473,7 +473,7 @@ static ssize_t eesoxscsi_store_term(struct device *dev, struct device_attribute
 static DEVICE_ATTR(bus_term, S_IRUGO | S_IWUSR,
 		   eesoxscsi_show_term, eesoxscsi_store_term);
 
-static struct scsi_host_template eesox_template = {
+static const struct scsi_host_template eesox_template = {
 	.module				= THIS_MODULE,
 	.show_info			= eesoxscsi_show_info,
 	.write_info			= eesoxscsi_set_proc_info,

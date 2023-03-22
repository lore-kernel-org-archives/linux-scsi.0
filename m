Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7E7C6FD1C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjCVT6B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjCVT5b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:31 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00F369CD1
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:11 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id d13so19539327pjh.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dtvaziFz+alOfUQZbNe+VAlPBd5fDCw1fGTb/wB6Zxw=;
        b=v1wyq9Q783hwJJ88jwwfy6VQqSztBd1W3hx32LxYP600TOUElP844dID9maRfQybHC
         zgd2Ca6DhKrQTvOJrMKqEv3RFLRLRSYGFpUe0J3cL5ymmW48PhpwzLdup46hmkQ8rT8w
         DxrpYH1nd0l900UxkIPmf0r+r9toK1fExQj0OfudtnGtIf9yIykdshnqI6VXy9WG2le0
         zXwCxNej8CyYV6M9S451AVBZc3TPdmt+KkT7aUzmRybPMDP0Cx0LRT8MBX2cMYkurygf
         P+iZSQ9kgsTASbjFlTYFsWtkZhlBfSGcYXoKpspbxssNL07noJCZyPrxl6uETSn65pxr
         7wyw==
X-Gm-Message-State: AO0yUKXvthn69I2sCE+Bdnn/xYR7VTCuiEev3h1fIfsBJXcNTvegfSpg
        geGMqxxdu6OsWj2NZ7mT+QU=
X-Google-Smtp-Source: AK7set+z9MoEqWEy0f+OAbr0Pb4vFNXfVhuPN4/8GESKV5oDrjvH5Q0k9IyVsYfKXHTs4pYkMC233w==
X-Received: by 2002:a17:90b:4d07:b0:237:91df:9fcd with SMTP id mw7-20020a17090b4d0700b0023791df9fcdmr4165299pjb.48.1679515031291;
        Wed, 22 Mar 2023 12:57:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 28/80] scsi: powertec: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:23 -0700
Message-Id: <20230322195515.1267197-29-bvanassche@acm.org>
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
 drivers/scsi/arm/powertec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index 7586d2a03812..3b5991427886 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -279,7 +279,7 @@ powertecscsi_store_term(struct device *dev, struct device_attribute *attr, const
 static DEVICE_ATTR(bus_term, S_IRUGO | S_IWUSR,
 		   powertecscsi_show_term, powertecscsi_store_term);
 
-static struct scsi_host_template powertecscsi_template = {
+static const struct scsi_host_template powertecscsi_template = {
 	.module				= THIS_MODULE,
 	.show_info			= powertecscsi_show_info,
 	.write_info			= powertecscsi_set_proc_info,

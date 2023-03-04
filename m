Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6AA8C678D5
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjCDAc4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjCDAcu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:50 -0500
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5514D65441
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:48 -0800 (PST)
Received: by mail-pj1-f52.google.com with SMTP id h11-20020a17090a2ecb00b00237c740335cso3915774pjs.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JFvxo/sJNe3B0K/5I7wr+cSfqXHj+OqtPwyJqG3lYLo=;
        b=S81BTNtl6zDUNeGjnRBq4b9ywX162URLjDiLADN+7ydQJXTidNmsmD43LSULU3CHy3
         jytjSoyjd/NqtzCTCg2hqE7KFTNkgDlFo4lUNBo2jsKwmwawZXcl+kZJuoopnQLa5vcC
         sTJZAixE5Qb5FdAvw+TsafjMDHKkcOgV1IwuutcD6X8qhjSaFpJ9l98P8l9oKzG9lIxk
         Eu9loNiSfJ53dnQ+X/UQRnxD4leC8R/Ej5X6JiBa2A1IfnHmn2KDiLMHnTyaEFRabIh8
         +CB3MGmfPmXe045DwqDqnZ7Xzv2ESsEMAyqT5AApdjrGrHsBTaY6ceLN4o4Fq/BWFcMW
         XV1g==
X-Gm-Message-State: AO0yUKX+Y9DWeJNvNLaAAXkrCSOzx6f3wtm+MXzdNYkIhq6G9MBfREQS
        SGehGQ/sRjHlRDX6ggoiMp8=
X-Google-Smtp-Source: AK7set93oakt+KyG/9V9/obtdnXB45Gcuna37eeQjhyQSSqtqLG6wDVXhUlcHfQHjwG2UIgaHsXD+Q==
X-Received: by 2002:a17:902:ba83:b0:19d:14c:e590 with SMTP id k3-20020a170902ba8300b0019d014ce590mr2903929pls.9.1677889967772;
        Fri, 03 Mar 2023 16:32:47 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:46 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 31/81] scsi: dmx3191d: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:13 -0800
Message-Id: <20230304003103.2572793-32-bvanassche@acm.org>
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
 drivers/scsi/dmx3191d.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
index a171ce6b70b2..dfb091d34363 100644
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -39,7 +39,7 @@
 #define DMX3191D_REGION_LEN	8
 
 
-static struct scsi_host_template dmx3191d_driver_template = {
+static const struct scsi_host_template dmx3191d_driver_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= DMX3191D_DRIVER_NAME,
 	.name			= "Domex DMX3191D",

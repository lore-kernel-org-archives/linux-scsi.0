Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CDD9C6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjCITbv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjCITbS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:31:18 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261F2FCF15
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:30:11 -0800 (PST)
Received: by mail-pl1-f171.google.com with SMTP id v11so3098794plz.8
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:30:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iHexfxqhHa9lPmHb4Wa8nZQ2WhbsAHB+F6q2CfoJf+4=;
        b=hf8kJNchKKAa3RtkWUdNJE6BxSaSP1/DvRxJ4LlLKY5CYMLdIf5NgJESXQCMlyD6k1
         fm8D5bg0258+2KzIlHYqxok1FBYEF2xw0qtJzKnLlZp8tZ8arPbbojijKIhiRvkuyVXh
         YV/gHezTzs+vaai18ljYxRsR8OZNmJPEsvwsQI7K2OBcwXQr2P6hIfie9rKxea7StTBc
         PDqH4OKeDEeDdzE3nTy5Cjilir/znqLYkRT3iuo0qdYJjh1qZs+NpHJsBtS0Q4jxdd+J
         HCM+e+NrCtN/jKbGqZ8RC27yYns4HCkP+ccHS75kDzHzf7uz7XSMZTAVMojGZjGVXvfD
         UMzw==
X-Gm-Message-State: AO0yUKVA+iAr3VJaJTmu8X8p+XfkPGg2Zv9jnbXC4JVVEUrecX7Xw6GX
        C959jPqF1Lwlb//SJYwQcZQ4GG6LMtUo8g==
X-Google-Smtp-Source: AK7set8vJg0MioWMPDvAekq7/1cFVz5gDt6fcJD3JTgObz88LImQrTai1FID2ugLfTyOQLldXHYarQ==
X-Received: by 2002:a05:6a21:33a2:b0:cd:97f3:25e1 with SMTP id yy34-20020a056a2133a200b000cd97f325e1mr30322840pzb.51.1678390210582;
        Thu, 09 Mar 2023 11:30:10 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:30:09 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 76/82] scsi: wd719x: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:26:08 -0800
Message-Id: <20230309192614.2240602-77-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/wd719x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index ff1b22077251..5a380eecfc75 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -878,7 +878,7 @@ static int wd719x_board_found(struct Scsi_Host *sh)
 	return ret;
 }
 
-static struct scsi_host_template wd719x_template = {
+static const struct scsi_host_template wd719x_template = {
 	.module				= THIS_MODULE,
 	.name				= "Western Digital 719x",
 	.cmd_size			= sizeof(struct wd719x_scb),

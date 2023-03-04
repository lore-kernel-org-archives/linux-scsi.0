Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3CE2C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjCDAca (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjCDAcW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:22 -0500
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5505D6513D
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:21 -0800 (PST)
Received: by mail-pl1-f177.google.com with SMTP id ky4so4557383plb.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PUVyuRxOnhRj9LsT5qhnnwF2XXY/eNUcYo7//Y4UXag=;
        b=WaXiQLGOY9KdXSZ2hX/neZhy8EgjLnH6ZWH23vR8BiiOpXrsiZFTl9l/qgY++i6jlG
         tWTYJ5UxY+hSt3Y208IIBDUcc4XuUL30jmDSR3Hpp5UTda7SZv91B+hjNeAXwOdticJH
         GD3HYbbtt5OPyPPCSXvQpYrYUzWLngsLwXIXyZJS4p8NQ1Rt1yai8zM2lHErSawPa9xm
         yJ6AL+jJmeaY7J3+f3wT5oaTEahRdRdFBLDoCGZkhzNwYihUhEOxFrjL8siH7C5mKQ0C
         rw8nEdmg+82QpHS0xnNcuPwu+UXZ80duYkxPkUSStuU5ygm1RA+uNqBvomgaq8AGd6l8
         nQzA==
X-Gm-Message-State: AO0yUKV3h3Gb3m5yCZ639yFdv+XM0gxAAiizBALouBH3GB2u4NWKuSxh
        9lQAqh0dY3e3+PIk7ARE8iA=
X-Google-Smtp-Source: AK7set+k2OMzb17hxEouiQS1Im+9YwXa4/OdB9khdC/d+z3Uxro+eln0pjyAMcwEOy8FuJXGPySg2w==
X-Received: by 2002:a17:902:bf42:b0:19a:ad2f:2df9 with SMTP id u2-20020a170902bf4200b0019aad2f2df9mr3204649pls.55.1677889940762;
        Fri, 03 Mar 2023 16:32:20 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:20 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 20/81] scsi: aic94xx: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:02 -0800
Message-Id: <20230304003103.2572793-21-bvanassche@acm.org>
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
 drivers/scsi/aic94xx/aic94xx_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 954d0c5ae2e2..f7f81f6c3fbf 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -35,7 +35,7 @@ static struct scsi_transport_template *aic94xx_transport_template;
 static int asd_scan_finished(struct Scsi_Host *, unsigned long);
 static void asd_scan_start(struct Scsi_Host *);
 
-static struct scsi_host_template aic94xx_sht = {
+static const struct scsi_host_template aic94xx_sht = {
 	.module			= THIS_MODULE,
 	/* .name is initialized */
 	.name			= "aic94xx",

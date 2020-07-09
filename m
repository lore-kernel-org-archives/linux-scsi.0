Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D38BCC433E1
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE0B8207D0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MHzyKOxt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgGIRq0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728658AbgGIRqY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:24 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782C4C08C5CE
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:24 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j4so3275405wrp.10
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LaCRoLNPh8rfOtJymwBCMA+9wwfzZ0YZT8hDB5cEPf8=;
        b=MHzyKOxtOXPmABYls8bZGdJ0/FFwgWKEjJZ2uNXDNi+1EhQXcbBGozwD1qdFSzqyHI
         lHQK2aOSSA5ysnbzPIGEPrfDdt2pLdpRiRPeXLudDa0ShJrmZ45aQ3Tn76aMKUtFPVVS
         7OPeyC+yoTPgPCvRt+9+oD1lWbV9xf2zuZT5Hj3VeCX/7G+N3iY23K+0kej9+5k4s2EW
         8qKVvOJ5yKAN1RB6D0wFoTHoIkEY14bC/uhokXf4t6GTkml0v6QzRDpvIGSOfWscP03H
         7rv0njww555uSJdnwzLb3XdBGLYsDN90x9vcFunzyMgSnCEAyTAB/uO88v/jgpb9qVc7
         9j2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LaCRoLNPh8rfOtJymwBCMA+9wwfzZ0YZT8hDB5cEPf8=;
        b=C3kSIPuhFvWtaLT1eNRv9IWwYZ1mIuZcVqqnpIY+eRYLPsbvVHJ0eX+VSDqv44FgXV
         jZMGuU98o18Pctnu+sE4LVs/MXK7llrjvWLpPsk0KoHrV8TC2duNk59+W597Q/2onUDg
         A1TvXVQtZMe4GT7wt9FzZEYMiSBS5xzDKV91x5gpZNVnDCe1AnomGCmbm3y7sP8N58l/
         zFjVxWW+q7p7mOMxtQvWlDCGPRxw7Kz7Dy/No2atKbt4p5poL8UApTw1MFOs1/R/VB/3
         XqNw5z3sHY8tnLQbu1R6dHanHEuebW0EfzwIjGTc8FKDMh1DvnXL1xTSJSR6bDHMJar3
         4Hrw==
X-Gm-Message-State: AOAM533lXt1a2R8GUL9vy1DXfpnGySyDmk72f2ieV1NGLeVwViChFjcO
        qvjg5EqWLnW5/chLCCZhLWQyfbectFQ=
X-Google-Smtp-Source: ABdhPJy6LrvDQt95ybGxKacGSLi0IIOHk0vIsv/MO6uk/lJXy+lh7TszUuzy+QhVyyiBwD7oAgk4IQ==
X-Received: by 2002:a05:6000:6:: with SMTP id h6mr63120313wrx.26.1594316783189;
        Thu, 09 Jul 2020 10:46:23 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:46:22 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 21/24] scsi: aic7xxx: aic79xx_osm: Remove unused variable 'ahd'
Date:   Thu,  9 Jul 2020 18:45:53 +0100
Message-Id: <20200709174556.7651-22-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hasn't been used since 2005.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic7xxx/aic79xx_osm.c: In function ‘ahd_linux_slave_configure’:
 drivers/scsi/aic7xxx/aic79xx_osm.c:703:20: warning: variable ‘ahd’ set but not used [-Wunused-but-set-variable]

Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index dc4fe334efd01..9235b6283c0b3 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -700,9 +700,6 @@ ahd_linux_slave_alloc(struct scsi_device *sdev)
 static int
 ahd_linux_slave_configure(struct scsi_device *sdev)
 {
-	struct	ahd_softc *ahd;
-
-	ahd = *((struct ahd_softc **)sdev->host->hostdata);
 	if (bootverbose)
 		sdev_printk(KERN_INFO, sdev, "Slave Configure\n");
 
-- 
2.25.1


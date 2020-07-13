Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08B1C433FC
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EE142072D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:00:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZQTRM1Vs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbgGMIAz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729389AbgGMIAc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:00:32 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DBFC08C5DD
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:32 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id o11so14777724wrv.9
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LaCRoLNPh8rfOtJymwBCMA+9wwfzZ0YZT8hDB5cEPf8=;
        b=ZQTRM1VsfjTdDHT/1hpHbIxUExXVOBDSnR3Et1qhO6f504dX/NOSChAGPoB3N/qTYd
         WBlMv5AA/udLN4laXwk6b5Vosy52ncwaQeJqOQJ/Q5bdp4DM4d9767ErY7pKSwENdRnp
         Vz7mXZevhaBlxYd4M0+Xww9HkDka6fatLrpZU2E/zXKKKEXv3eeekfzx5Nb3pgIwlreu
         cYnWfxl/48kP/OPNKhMaY06/ytykZwK0wEaZxKr5dM6bPGQjMvjUp5JLuRMF6+EGI/tU
         2hnCDUW2jY3iV2h/gHNn8vqIy7zdYsgvZAgrMgcU/YE8T9KrR5Io2gX65LyKFiI0Qopx
         7SiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LaCRoLNPh8rfOtJymwBCMA+9wwfzZ0YZT8hDB5cEPf8=;
        b=UUMMD1aUXdRjv3L5PJnPadJvP/gO9+SbAZTU3lf861kTWs8TFxdSjvlqBOUxycfGr3
         NFnU0RnElk+eSxN+aWkEqpf154VbCI04YUhU1TqEWDMCaaTAprvhY/8JAp1nQ4cuICcB
         3ER1wDzeDmgpUYjvYyhBs85cL5R9oBFWsY3MrlQVQgne4wF6EiEtiWJM6h8KW91bJHCZ
         DPVwYefXrg0eeNw0RohEuKAJ8/viIoJ7gf8Dv3wa5+wX7LxUhgtF63SbjrMJDV9H+g0x
         3zb+wHlt+/pgYw1rCVQ+IzbrROTrYmMV/Zs59mlGeKiZ9omwFDJ2/3M/gFstKuMwfdHh
         Rzhg==
X-Gm-Message-State: AOAM533cc2+AxXQOaYu3K11F43dxKTiOHdB8VIgLkV6TrrB4eh0g2x/D
        DKiN9OSj31/gHaoWNYmZoDKjkA==
X-Google-Smtp-Source: ABdhPJxKicTSZbFkuGFawFDfbc10gkLYi4SoSH/aW8aZ4hkrCVIIMhwvzRBWXdbBp7irLptT/YMMLg==
X-Received: by 2002:a5d:40c9:: with SMTP id b9mr75708958wrq.425.1594627231014;
        Mon, 13 Jul 2020 01:00:31 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id 33sm24383549wri.16.2020.07.13.01.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 01:00:30 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH v2 21/24] scsi: aic7xxx: aic79xx_osm: Remove unused variable 'ahd'
Date:   Mon, 13 Jul 2020 08:59:58 +0100
Message-Id: <20200713080001.128044-22-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713080001.128044-1-lee.jones@linaro.org>
References: <20200713080001.128044-1-lee.jones@linaro.org>
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


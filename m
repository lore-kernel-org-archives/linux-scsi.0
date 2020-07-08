Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E303FC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C13F320772
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:02:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UVVJVhkk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgGHMC6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729088AbgGHMC4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:02:56 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FF5C08E6DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:02:55 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id q5so48642101wru.6
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sy/K8f8HsXXHV/Uh8PtUz+jEUwEZnfQCudyYCgnVPrY=;
        b=UVVJVhkkvXU5mQaYO7/e6LDc6Bn+WyCrxwonvgA5bXcIDKlvL9UZyftgtkF/mFygO9
         Y92+vMSrt60fiM8wodrySHgosdmXqwjvaG1WzE9xIhuct+M/8L+96nZZbbCOnULeiPeN
         ZTVXO+EZChxwre/ooWZwMBRtGz/N4IHmc4b4dzDo4XBqs5IZVDEKI/RWuz/xu4Y/nxll
         oEOYdjvrgnEqGvYKb2wvkiCLmtuI4POA5MgvjqNTPNlGUFedPELjVCNPRZUakEPFg46j
         idt6O3eIE1ZjoTHSb6RgXUs5GAOkd/qW1jc7JHesY4MaWWwu08UKU8pn5Lj+Y/aThEDi
         CgaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sy/K8f8HsXXHV/Uh8PtUz+jEUwEZnfQCudyYCgnVPrY=;
        b=gTPpeeYTsuj8lRjp6D2akJmcjGPNhaJfCq7sAW/jE7Xwm9JEAwK6/o8Xf8ZHPVUzPG
         lhP55OXPiMt4Nzl+NqfE01tHujj3txC4JFnH8Og6AklqLSNzRm3Wp8Ql8gG53d+qhwTa
         nOcpBqxPSymnc9jBWf+/7EEGTpT1O9kDjy8XhYhOw+oYTz1B0nl/vyXpQ1qH1WXUo2w+
         ZvJL1sAPxcWr+RJ53cgAldNmslBALK0f8olIlP76CMfwObqgpbF+blc7pOgeR/AjAmAP
         3naCqVzGtnoAj9gEDAZ6WZ03E8xlfI96oprjEM88y5Snd0jU2oPsmyM1fHLu0LvjokmG
         1CgQ==
X-Gm-Message-State: AOAM530+e0BZZruNV078cwjpyat/6Ebyz60lWO6RUQMYy3qyY8flXA7z
        6ckdQuTS/uSIItKaG61u5ebHwQ==
X-Google-Smtp-Source: ABdhPJwhGEqPkcJyX2dv/WqMG7iM0VhAhQCXAAfNOLSl+0U4picjbr+HsPGcLq6WylxaF+kkxtJ1Ow==
X-Received: by 2002:adf:efc9:: with SMTP id i9mr61722445wrp.77.1594209774488;
        Wed, 08 Jul 2020 05:02:54 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:02:53 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.com>,
        "Daniel M. Eischen" <deischen@iworks.InterWorks.org>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 20/30] scsi: aic7xxx: aic7xxx_osm: Remove unused variable 'ahc'
Date:   Wed,  8 Jul 2020 13:02:11 +0100
Message-Id: <20200708120221.3386672-21-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks as though 'ahc' hasn't been used since 2005.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic7xxx/aic7xxx_osm.c: In function ‘ahc_linux_slave_configure’:
 drivers/scsi/aic7xxx/aic7xxx_osm.c:674:20: warning: variable ‘ahc’ set but not used [-Wunused-but-set-variable]
 674 | struct ahc_softc *ahc;
 | ^~~

Cc: Hannes Reinecke <hare@suse.com>
Cc: "Daniel M. Eischen" <deischen@iworks.InterWorks.org>
Cc: Doug Ledford <dledford@redhat.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 32bfe20d79cc1..cc4c7b1781466 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -666,10 +666,6 @@ ahc_linux_slave_alloc(struct scsi_device *sdev)
 static int
 ahc_linux_slave_configure(struct scsi_device *sdev)
 {
-	struct	ahc_softc *ahc;
-
-	ahc = *((struct ahc_softc **)sdev->host->hostdata);
-
 	if (bootverbose)
 		sdev_printk(KERN_INFO, sdev, "Slave Configure\n");
 
-- 
2.25.1


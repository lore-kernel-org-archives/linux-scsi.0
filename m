Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F181C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 10:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390986AbiEFKfF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 06:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234050AbiEFKfE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 06:35:04 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C5A60D9F
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 03:31:21 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bv19so13630420ejb.6
        for <linux-scsi@vger.kernel.org>; Fri, 06 May 2022 03:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J35uIH1MpaLMm4O9zHZtzxGvZaPj2KZMm6bhTi3q+LQ=;
        b=ugQ8XacPmkEYJiJc58YEHbJUJ7NK74NaSHGyvTNb4jwSlconhpPRhNrQQ3UTCfS3BB
         BTK8Q+X+mOZavYcY/73XZZ1JYVqL+f34zs0X64w1u/NhiIvDQTg1T2VkvjPnwBRnaDyA
         sK6BpmnlxKH0v6v7CoWROzkR3+t1D5nVRFPf+fiIpewaEzC/VSuWBrDkfP/Pq/rYmgp/
         bn6+k1cNZ27X/A+7kR59k1cC514MwuaBYKL8tL0XjKNd3mQGuV2iFZBPiW3GRt2XcwFY
         n8Vd0Nz/8caFWDC+C9r/yj3jpBdGGexg65hSWMNXwCZccbsKTDWKiaVah5UgG2lNgkKz
         EOZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J35uIH1MpaLMm4O9zHZtzxGvZaPj2KZMm6bhTi3q+LQ=;
        b=R3E+xSyTDA/PvNR71h1RbkO0VZ9E3qmLdj7pkRU8Rz+Ju8rzJMWuXdXtrIGbrbo5ml
         rkP00WifphgzCk44DePJ01NgODAUg0zoIyGNoSZXx1HEfBaQzEULyVXv0Faqw0DhXKTT
         frv3rvoAzQYiWWD0cSNtDPjEH8Sgrr13yQq63mqoqs5YFh7QyNLvBamHRSNyJZ7ANmy4
         VfU+8kuiJuezi46gSwt+ifP1FWZjRmwI0SiDQpe/q2U3uhmtbH/zgCwsOqzklDmMR1Q2
         ddkyZ+asiz9SRH0S4o8BEt+Hinvpq1KdMD6Q9dM8z01PVyJ+P3WiUM0G6GR73cTLEO13
         Ltfw==
X-Gm-Message-State: AOAM532QaVWiI5DjYHrliWO8UUzYSPjDY62uGyuCCzR844vsb6z78xkZ
        NTgQiWpjZ90eumvwVSsyq5a9HooUVpd7vPED
X-Google-Smtp-Source: ABdhPJySuCJkTp8M2KS8fsBloFRhVmt81jhTpFBcGO5RLAHY6FWsaCUPPqRpvv46N4TyqbTR/MYzhg==
X-Received: by 2002:a17:907:7dab:b0:6f4:6650:395d with SMTP id oz43-20020a1709077dab00b006f46650395dmr2250550ejc.82.1651833080456;
        Fri, 06 May 2022 03:31:20 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id em10-20020a170907288a00b006f3ef214e6dsm1726957ejc.211.2022.05.06.03.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 03:31:19 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v2 0/3] scsi: ufs: minor cleanups
Date:   Fri,  6 May 2022 12:31:12 +0200
Message-Id: <20220506103115.307410-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Changes since v1
================
1. Drop patch 1 (needs further work).
2. Rebase on current linux-next (including Bart Van Assche's work).

v1: https://lore.kernel.org/all/20220408103027.311624-1-krzysztof.kozlowski@linaro.org/

Best regards,
Krzysztof

Krzysztof Kozlowski (3):
  scsi: core: fix white-spaces
  scsi: ufs: ufshcd-pltfrm: constify pointed data
  scsi: ufs: ufshcd: constify pointed data

 drivers/scsi/scsi_debug.c         |  2 +-
 drivers/scsi/scsi_priv.h          |  4 +--
 drivers/scsi/scsi_proc.c          | 14 ++++-----
 drivers/scsi/scsi_scan.c          | 10 +++----
 drivers/scsi/scsi_sysfs.c         |  4 +--
 drivers/scsi/scsi_transport_spi.c | 49 +++++++++++++++----------------
 drivers/scsi/scsicam.c            |  6 ++--
 drivers/scsi/ufs/ufshcd-pltfrm.c  | 10 +++----
 drivers/scsi/ufs/ufshcd-pltfrm.h  |  4 +--
 drivers/scsi/ufs/ufshcd-priv.h    |  6 ++--
 drivers/scsi/ufs/ufshcd.c         | 42 +++++++++++++-------------
 drivers/scsi/ufs/ufshcd.h         |  6 ++--
 include/scsi/scsi_cmnd.h          |  2 +-
 include/scsi/scsi_device.h        | 10 +++----
 include/scsi/scsi_host.h          | 13 ++++----
 include/scsi/scsi_ioctl.h         |  2 +-
 include/scsi/scsi_transport.h     |  2 +-
 include/scsi/scsi_transport_spi.h |  2 +-
 include/scsi/scsicam.h            |  2 +-
 include/scsi/sg.h                 |  2 +-
 20 files changed, 96 insertions(+), 96 deletions(-)

-- 
2.32.0


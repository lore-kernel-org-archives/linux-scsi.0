Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC27AC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A66292075B
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YCILm8df"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgGGOBA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 10:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727800AbgGGOBA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 10:01:00 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107B8C08C5E1
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2020 07:01:00 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 17so46585451wmo.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2020 07:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YDWmEcudqEHLtwf/RKE1CHN8JF3UPekBXjlO05WGYPU=;
        b=YCILm8dfx6J0RRLoEJzwZEtZPGpnq2+39qZdn0I4jEdfuWxD4KC8PILlXTVNr0jsY2
         Aoo1g8vDXHsI+EFCYTgsgs5FNAdsxnNSjlnHBhKkDHQJTUGBlkcKs5xUAj0L2hNQu5Pu
         Yp9cTB9Dp4BsQ7L60KLZqKibBpe3L1J/b1ip8JUcAHEMg9iWSAOwoMAs0vGCHuP95FC0
         K+B0HD35Lq2rceD5QZZV5ZW6l0NrM8PZdex/5vdWUA2GtuYoD0os3o55mKGv+2pssYWl
         zCFoVLPaq/T1CTo/TDdfxVBl41MJ1brkS29XDIWlDGUygjDDI8Wc/9qlDXuPzNWhf3dQ
         LuzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YDWmEcudqEHLtwf/RKE1CHN8JF3UPekBXjlO05WGYPU=;
        b=j9OKrgtEQeZaRGAC81sC4+vx99HmsNnf7FGn8+fpY/WPsVhAuAvC+C6HAIWmW4VJsr
         X3s0ynia5P4XXBT7jG7ETN7LauoEtWB9SsBM3eAPtWTzyA1jzocijKwfmAa0dOwmpL5c
         cNRhjtAEjVdlIzXldJpLiTXAJo+azwdGiPhDLGp2P0RLXFdB9rLurQbdNDB7p4nkVV2h
         UkeWisdm033drR3mXPzI/mzbC89ZGey9c1BZy4TFPJolwfpZ3k0/cDM0En72wP3sF4QP
         FlMI/OSd8Web5BH7SUqrHC5Q4pDW+uT5oKvM+G7YutMEPppOMA2siWyxjXPlYHfCuIZW
         G8NQ==
X-Gm-Message-State: AOAM530RvGL0IideUeUZNO4EX8MeGafhgmzGAPnBV+3kVYJkmQVrFOHV
        C8fxqByqhp+qdgUKoTPCfibUOg==
X-Google-Smtp-Source: ABdhPJwiFN6Pi0XW8PKRFR8WoDwYkfTftlzPnvTlv7DFLE5xp4Rf3wPnaGdd1+C2BnYswrv9LPFNpQ==
X-Received: by 2002:a1c:dd86:: with SMTP id u128mr4343891wmg.123.1594130458680;
        Tue, 07 Jul 2020 07:00:58 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id z25sm1102823wmk.28.2020.07.07.07.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 07:00:58 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 00/10] Fix a bunch SCSI related W=1 warnings
Date:   Tue,  7 Jul 2020 15:00:45 +0100
Message-Id: <20200707140055.2956235-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This set is part of a larger effort attempting to clean-up W=1
kernel builds, which are currently overwhelmingly riddled with
niggly little warnings.

There are a whole lot more of these.  More fixes to follow.

Lee Jones (10):
  scsi: megaraid: megaraid_mm: Strip excess function param description
  scsi: megaraid: megaraid_mbox: Fix some kerneldoc bitrot
  scsi: fdomain: Mark 'fdomain_pm_ops' as __maybe_unused
  scsi: megaraid: megaraid_sas_fusion: Fix-up a whole myriad of
    kerneldoc misdemeanours
  scsi: megaraid: megaraid_sas_base: Provide prototypes for non-static
    functions
  scsi: aha152x: Remove unused variable 'ret'
  scsi: pcmcia: nsp_cs: Use new __printf() format notation
  scsi: pcmcia: nsp_cs: Remove unused variable 'dummy'
  scsi: libfc: fc_disc: Fix-up some incorrectly referenced function
    parameters
  scsi: megaraid: megaraid_sas: Convert forward-declarations to
    prototypes

 drivers/scsi/aha152x.c                      |   3 +-
 drivers/scsi/fdomain.h                      |   2 +-
 drivers/scsi/libfc/fc_disc.c                |   6 +-
 drivers/scsi/megaraid/megaraid_mbox.c       |   4 +-
 drivers/scsi/megaraid/megaraid_mm.c         |   1 -
 drivers/scsi/megaraid/megaraid_sas.h        |  25 ++++-
 drivers/scsi/megaraid/megaraid_sas_base.c   |   4 -
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 102 ++++++++------------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |   6 ++
 drivers/scsi/pcmcia/nsp_cs.c                |   5 +-
 10 files changed, 81 insertions(+), 77 deletions(-)

-- 
2.25.1


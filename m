Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC8D6CCA47B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 10:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239567AbiFMKHF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 06:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234880AbiFMKHD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 06:07:03 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B241225FE
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 03:07:00 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id x62so6381289ede.10
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 03:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=388rVfLziXGbjQS21Tul2j/I7M6Zt1K95tN24K1AmoM=;
        b=hNPIvBFiRMJ6rB/VHNwmWvua/nH8QKLJWyeJkrEUtfgSTBNVuaQxhkbVVpGMdFbjRr
         8LEM6GKxwsaJ+IGRBEPZ5cL3V68XTQWq3Aw//53cWUmdeBb7cFfKiCxoD0TWWiptbIL/
         jWGZvp3CsaRaRaogyBL+TKOexYVfbxexw4ssqWWiTXn9DSWXN45SchBd44isMpwxWuSa
         OnzxtDc82Fea/jlWVAQzdMCGB/l4fNmhfWMyphWpbwg0FJvwAlZ600AO9HPDhaOHb9By
         Wy8Olozr1Xjub65R8YtZPR4+ZrGIj271V6fcw7137YbsyDzvqpYLPlcHJhqZVzrdXEuS
         bsgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=388rVfLziXGbjQS21Tul2j/I7M6Zt1K95tN24K1AmoM=;
        b=plMBCBE6bK2iZI0EAXiQXVR1AWMwYpO/a+mwuav0UYByofLzyl365z6Qo8bRWWvT6c
         KBNK0QehqGlG3F2epcWeXQtysvpmoEY+D0/EHS8V8ef+GB4i6UpVOw+Bv/tfG/Gvmp1x
         mO1caBTPesW1FmAFERpVdQ/lgDBqyWBjodQHCkMUXC1xmoyBQYWg6qapJqMxB6MTDnuj
         0xroAjHwA7/Sqrm4nyB1BcXJN+xeJ3v0RIK7RBqAAn4imX9s8woK4ur4QyMofeTMaL6L
         4EITL7rBVbqX6W/JU6WshGJOR4Jngy5YjGRDJX4cfHaLFQwSuz6JLlo//qrdceU8IvXV
         EFcQ==
X-Gm-Message-State: AOAM533Xgp+QG4POYCgva/OXfQjcIa0yIPfoj0ln9+97l12bT9p6KPdS
        2pJNpPO4u+p47BeLF0gLI5t6tw==
X-Google-Smtp-Source: ABdhPJyLVR6mKaSnfeAjdGkfvs4pku53sb5gAxMEnTrk6uCc+t28wi5xWYywt1WZ8NQMLmTOvRKS7Q==
X-Received: by 2002:a05:6402:5252:b0:42f:b566:c189 with SMTP id t18-20020a056402525200b0042fb566c189mr52169148edd.398.1655114819283;
        Mon, 13 Jun 2022 03:06:59 -0700 (PDT)
Received: from krzk-bin.monzoon.net (80-254-69-65.dynamic.monzoon.net. [80.254.69.65])
        by smtp.gmail.com with ESMTPSA id v2-20020a170906858200b006fe921fcb2dsm3639911ejx.49.2022.06.13.03.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 03:06:58 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v3 0/3] scsi: ufs: minor cleanups
Date:   Mon, 13 Jun 2022 12:06:52 +0200
Message-Id: <20220613100655.105301-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Changes since v2
================
1. More whitespace cleanups.

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
 drivers/scsi/sr.c                 |  8 ++---
 drivers/ufs/core/ufshcd-priv.h    |  6 ++--
 drivers/ufs/core/ufshcd.c         | 42 +++++++++++++-------------
 drivers/ufs/host/ufshcd-pltfrm.c  | 10 +++----
 drivers/ufs/host/ufshcd-pltfrm.h  |  4 +--
 include/linux/libata.h            |  6 ++--
 include/scsi/scsi_cmnd.h          |  2 +-
 include/scsi/scsi_device.h        | 10 +++----
 include/scsi/scsi_host.h          | 13 ++++----
 include/scsi/scsi_ioctl.h         |  2 +-
 include/scsi/scsi_transport.h     |  2 +-
 include/scsi/scsi_transport_spi.h |  2 +-
 include/scsi/scsicam.h            |  2 +-
 include/scsi/sg.h                 |  2 +-
 include/ufs/ufshcd.h              |  6 ++--
 22 files changed, 103 insertions(+), 103 deletions(-)

-- 
2.34.1


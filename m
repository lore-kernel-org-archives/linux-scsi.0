Return-Path: <SRS0=+N3d=7S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ADE9C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 19:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26841207ED
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 19:15:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nezISLCo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgFETOw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Jun 2020 15:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgFETOw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2020 15:14:52 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68C3C08C5C2;
        Fri,  5 Jun 2020 12:14:50 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a25so11284402ejg.5;
        Fri, 05 Jun 2020 12:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Q8+7spbokzVe6hSGhArvhH2DUs4dawK0jPKpMA3EIRw=;
        b=nezISLCo1uQculSQVrIIM0g26zADuq2ly3qWTrcXSxvEFhvWADjwyAi5ar9PmZAAVQ
         fvUw0liy7Wg4kzjuS/C/RwUE2uW0J5tHJRIGkI0COg6MeyNjq1XDvFBPbpkSv7XMAsVe
         FTYWPs4r/Fq6MKcw21pZReqtKJfwubRlk2sj/GJvzNhCe7SE2f/VA+2c36rrvnrtix+L
         y10aVKitXJ3LARmA+t5qi8ObFEtDGR/EmHXOPxsYs0ta2feao3YvP/2DxFaJnPNTnjPu
         duFc4v6THfsgDvHG8cw0s0I2ATMUFibq1kkYX/e+LFZMttwPTMMibNh/Kl7+soipRd45
         P+YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Q8+7spbokzVe6hSGhArvhH2DUs4dawK0jPKpMA3EIRw=;
        b=MG5HMU1q5XgXzZk9Gn0GlpdTHRB1TP/5BDOXMwQqlTw9h/XE671lJeB+WivW04cAGN
         jzDQTBYqjbvKU3TvOUlBl2IBpkC+6lSh2/M8ZU/zYm6hnUSYllrwvXS0gd390XhVfPe7
         PwwxtlS2b0a0WBasa69XdDnR3HvZoNI/GfKGNKTFXe1mnk2t5NtSGeduuJuylr64ZWR/
         WQX0prvK21euST4pxn7V5EnRm2PFt8vYniKgg0xldDAsXWeXxaKx2iwVmiIbMCCuUyV+
         SW99tCivLi640Fc4mwc8ONMIOg8YTb9JDl53HNly0t6sp02PV4lWpjXZxHjbr/cygAjv
         om7A==
X-Gm-Message-State: AOAM531y/bC0pddh6Xu6egywfOcIDgheeIhoa+nmYp8PlK4socGhvbjc
        /VFnJSfKMmGV74ZykSVX29s=
X-Google-Smtp-Source: ABdhPJxmtiX4IgBA7i3W5z4AeLrtYeTjOpx/paBoRrzKyGKX20q08jsKI3aYB7uyCfVSfDqCXzPzVw==
X-Received: by 2002:a17:906:2c08:: with SMTP id e8mr9979623ejh.385.1591384489595;
        Fri, 05 Jun 2020 12:14:49 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcfd.dynamic.kabel-deutschland.de. [95.91.252.253])
        by smtp.gmail.com with ESMTPSA id ck11sm5123614ejb.41.2020.06.05.12.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 12:14:49 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] scsi: ufs: cleanup UFS driver
Date:   Fri,  5 Jun 2020 21:14:37 +0200
Message-Id: <20200605191439.19313-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Cleanup, no functional change

Changelog:

v1 - 2:
    1. split patch (tomas.winkler@intel.com)

Bean Huo (2):
  scsi: ufs: Add SPDX GPL-2.0 to replace GPL v2 boilerplate
  scsi: ufs: remove wrapper function ufshcd_setup_clocks()

 drivers/scsi/ufs/ufs.h           | 27 +-------------
 drivers/scsi/ufs/ufshcd-pci.c    | 25 +------------
 drivers/scsi/ufs/ufshcd-pltfrm.c | 27 +-------------
 drivers/scsi/ufs/ufshcd.c        | 62 +++++++-------------------------
 drivers/scsi/ufs/ufshcd.h        | 27 +-------------
 drivers/scsi/ufs/ufshci.h        | 27 +-------------
 6 files changed, 18 insertions(+), 177 deletions(-)

-- 
2.17.1


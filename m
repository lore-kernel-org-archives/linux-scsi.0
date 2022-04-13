Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8864CC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Apr 2022 22:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbiDMWEx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Apr 2022 18:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234544AbiDMWEt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2022 18:04:49 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE47B21E0A
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 15:02:27 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 2so3335919pjw.2
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 15:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thejof-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MeEWKHYAnpCheg2ErYcSwwes853wTP7HY76lfX9DjwI=;
        b=ABffHkk3ADfjKAOK5yKTtraSMlhXCcjoqUpk5KQ/0BW9k0CZbmqRUT9OrGyHYdVOiz
         F2K6bRDPu3yuhgJyekOhhnhqWzz9e5SVhHf+vRCqSMkHxQeIargvc3x3rec/CRZjz3AV
         E8BEa4oO529AgquZWyi+N2uQZ5dwCXbW5ShibEnV6WEz3SIjwm9gMUW+HZFvJMhYf6j1
         /VyTBn2UZiviOiwa+kaKzH8Ql0Og70CZeHYceUhxQkOwbMGpS+zBTsnkhd86HL5WM4l1
         6HAmK453d5Zo62CcV/iSx2LUoWIwT4zsa10YVLoBEvny+b3wWlb1osn22eDyG/L4XurG
         GQsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MeEWKHYAnpCheg2ErYcSwwes853wTP7HY76lfX9DjwI=;
        b=k8oPjrWM0MmNyPwU+mVZ56FkA5dwSA5znxihydkamnM7uUds4cJsgNyfC+3hfC1hCC
         3BS83Q27y2pSexVoQ+qnxen2Hn8JLEjGkAAs0jZCFuagVbtnWcpW2n+6xVlV8CTLE1MJ
         328yjloNivlxOb90gNN3VXsXQtkGWbOpEh/Nie0HN7cZ+NRcBDFk8eHZ2CBAfXIS8y+h
         Jy96A9xAo35AOU+c80EwTHYfrW1og35nimmXsgSV6uwCpYi5X7/DS49CxM3kaST552Ky
         IQPGbT3Rh4mvzslfO/oyWtvk1rDgx/BKkHRZSuGZ6oSMGVeg+dcW7dBZXm5KJgrByDHt
         XGrg==
X-Gm-Message-State: AOAM531pbDnhZun5g2SOmAgqttLK0oKjDo7xmqg5vvluFIbhjGElhJce
        dKLyoL5735goz3srnv+o3y77YlPdan56imc6tAOsWg==
X-Google-Smtp-Source: ABdhPJxLM2makZjUCc8Etn2b4ULp+vpjCKzovDnzL3u5V7fFNjOFVOSKerHDbYj+ZJoVhwxER4ncpQ==
X-Received: by 2002:a17:903:248:b0:155:e8c6:8770 with SMTP id j8-20020a170903024800b00155e8c68770mr43129619plh.129.1649887346914;
        Wed, 13 Apr 2022 15:02:26 -0700 (PDT)
Received: from oak.jof.github.beta.tailscale.net ([2601:645:8780:7d20::5f8c])
        by smtp.gmail.com with ESMTPSA id z6-20020a056a00240600b004e17ab23340sm55586pfh.177.2022.04.13.15.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 15:02:26 -0700 (PDT)
From:   Jonathan Lassoff <jof@thejof.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jonathan Lassoff <jof@thejof.com>
Subject: [PATCH 0/1] Rebase: Add printk indexing to scsi drivers.
Date:   Wed, 13 Apr 2022 22:02:11 +0000
Message-Id: <20220413220212.4738-1-jof@thejof.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Just rebasing this patch to keep it current.

Jonathan Lassoff (1):
  Add printk indexing to scsi drivers.

 drivers/scsi/scsi_logging.c | 7 ++++---
 include/scsi/scsi_device.h  | 8 +++++++-
 2 files changed, 11 insertions(+), 4 deletions(-)

-- 
2.30.2


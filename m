Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 095AFC4338F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 18:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEB8660F01
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 18:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240173AbhHDSVy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Aug 2021 14:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240184AbhHDSVw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2021 14:21:52 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E724C061799;
        Wed,  4 Aug 2021 11:21:39 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id c16so3221900wrp.13;
        Wed, 04 Aug 2021 11:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TSOBKjAd++Kj/iKty0QearydCYGWn+33+zYOdWLDwPE=;
        b=iENdKfgemjNQnTRL4GkafjFYn8A9iq0lzeKRdTLknb742+ibJsewCAUz3avJekux3w
         bpVR+/SvdO/YgTgxr82Kcx0pEIbGL8mB2cjniAWc7+uSWRjcwgqfyURbFrGJGeMXVuPL
         n0mF2VNlWAZp+xekDTSFg/iXNTP8hgHfm4Qs2+kwrzEz+ff+Y6sXN1LlwRovLHkiJvUx
         3u/rQJV9n8P6Z+FSR3PyK2fkeAtOmVEiKR4W3CD2DUicbad2BeyvLGEKyARt0JoeuJCC
         jrPDhbsFV9HkYVJfNqU0F7JSGXoovRCrhck7dOkWxM8U2h/s6CmZHppV8xSkbAL3j43g
         fwpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TSOBKjAd++Kj/iKty0QearydCYGWn+33+zYOdWLDwPE=;
        b=nAtcTBcH0K1xbURiAYJgDgSBHZ9lLCXb0KUja3dCWnjGc8aL4E7Du+MZ38B4IyZwwf
         Vc2N9wjiIl6Dj2NR75yexhteUK/zGVEZ2TIKCBh8k/cx/+dicvPV6mgvDFGgkXZhtSEG
         wOHT6YKIrMG+Gr9ZIRz/gUM4ZUTAOUa8ouPYt3EtlDH5tTKxA/gXAJ5un3VeZJsKsq33
         5DKr4I16lLuQdba1mF9Iy06pXCfx5wJfjxBNWfinb/JtK49Os5/EH8B1gLeCYqS2R89V
         iNqtVRbh20zVKc0/g9CV+cYKHB2wwM7rTD1Oj9oN8DyP3+9OkkaiTaCAYNXHW1eNmuw9
         Z9lA==
X-Gm-Message-State: AOAM532+8VYXD86b5z9Mm8k7yj+uvOTj6TxtwO1ANzbsX+z5Hj8iDBYp
        xNE0ihHKNuslMifXICPF4No=
X-Google-Smtp-Source: ABdhPJxjE6//47ZoicP7+WuAiBf7OsG8JUwkIagI8ZwH3M+Z/ArcLPZKzQFZZbKBI22acsQebXLfBA==
X-Received: by 2002:a5d:5703:: with SMTP id a3mr658765wrv.333.1628101298071;
        Wed, 04 Aug 2021 11:21:38 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.gmail.com with ESMTPSA id n5sm2914880wme.47.2021.08.04.11.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 11:21:37 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, cang@codeaurora.org,
        daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/2] two changes for UFS/HPB
Date:   Wed,  4 Aug 2021 20:21:26 +0200
Message-Id: <20210804182128.458356-1-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

These patches are based on the Martin's git Repo 5.15/scsi-staging branch

Bean Huo (2):
  scsi: ufs: Add L2P entry swap quirk for Micron UFS in HPB READ command
  scsi: ufs: Add lu_enable sysfs node

 drivers/scsi/ufs/ufs-sysfs.c  |  3 ++-
 drivers/scsi/ufs/ufs_quirks.h |  6 ++++++
 drivers/scsi/ufs/ufshcd.c     |  3 ++-
 drivers/scsi/ufs/ufshpb.c     | 15 ++++++++++-----
 4 files changed, 20 insertions(+), 7 deletions(-)

-- 
2.25.1


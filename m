Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E459CC2BBD5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 14:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEAC024158
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 14:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403885AbgLKOBp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Dec 2020 09:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395095AbgLKOB1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Dec 2020 09:01:27 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE24CC0613D6;
        Fri, 11 Dec 2020 06:00:46 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id u19so9455468edx.2;
        Fri, 11 Dec 2020 06:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=72cACysZDLkGnBT4ag2igYzkfQSf/FBKFU7gwyj+muA=;
        b=Buj+BU84hTkSyt/2MvqYt6Ms9JH0uylV1kJFLt4Ta6U1SGvXZPZP9cew5P6/DzZLnP
         zI+cgen/gDzAl08XU1/f2IuiPY6UuA49/U7PJGvDyZL+CC8STCW2aF0m4JHmOczhiLBm
         +ZeKH8nfT/QwlngxM1aIOiqNw7L8ZOdnnpfHIFWeZ+3O6+MsJEwf2jP+XK2KRTO5ftjG
         Q4F8doeOxHxzILLQl9I6DoIuVsYWpSoZxG/HutOBiZtXAy7OnX61TtDgKwMkzbc4W7la
         eLsM6Vc99vpSxoT3PLwtYpYJw890Jij3Td8jrTapJybh8Ev6g3J0sle59yfgB9kW9n7f
         pMDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=72cACysZDLkGnBT4ag2igYzkfQSf/FBKFU7gwyj+muA=;
        b=sOx42qyU02wczQN7o9rMUwcKK5qEdwpQkJnfEiAw0PmsNGPW14zIwjCbHotg5Jpjcc
         BySG5uW6mth7ZmaW7afS7IGWZWB+hMd5KoRQJcUwtYpiZmZUMJzmu9ol9mHArRV/fkRE
         MKtEJmrKBxrt0LO76u2g2OZloERgrPb0tVTuai6hvp4N57XbcZl/p1Y06bcIhmWbD+Eh
         1q5082/pd1WVtVMMrDywxsrY5WCFegWGEMYMj4peb3kUqnhQXRp08qghM0G8/4zsH7JB
         TtRs2cy3riFPSIoq7feaMc6qjIG/BA+d/4MIAHD446l7Zo3f7Ic2KTLo0b/xLx5GMxJH
         Rqbw==
X-Gm-Message-State: AOAM533QPgBxt4VJ33nZENDeoHw9NIWz4MZWq1iZQIalXP4dJhHInlJR
        OapfzicU5sZVHz2HGz0Tqaw=
X-Google-Smtp-Source: ABdhPJwPJPujKQGyoKUcLcI9Fax4dxFU9y+tuK3AeK7EKaHQg/RMTYRvo030GoTdKlZFMU2sFEaLoQ==
X-Received: by 2002:a50:d5c1:: with SMTP id g1mr12266359edj.299.1607695245435;
        Fri, 11 Dec 2020 06:00:45 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id z24sm7797818edr.9.2020.12.11.06.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 06:00:44 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/6] Several changes for UFS WriteBooster
Date:   Fri, 11 Dec 2020 15:00:29 +0100
Message-Id: <20201211140035.20016-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Changelog:
v3--v4:
  1. Rebase patch on 5.11/scsi-staging
  2. Add WB cleanup patches 3/6, 4/6 adn 5/6

v2--v3:
  1. Change multi-line comments style in patch 1/3 (Can Guo)

v1--v2:
  1. Take is_hibern8_wb_flush checkup out from function
     ufshcd_wb_need_flush() in patch 2/3
  2. Add UFSHCD_CAP_CLK_SCALING checkup in patch 1/3. that means
     only for the platform, which doesn't support UFSHCD_CAP_CLK_SCALING,
     can control WB through "wb_on".

Bean Huo (6):
  scsi: ufs: Add "wb_on" sysfs node to control WB on/off
  scsi: ufs: Changes comment in the function ufshcd_wb_probe()
  scsi: ufs: Group UFS WB related flags to struct ufs_dev_info
  scsi: ufs: Remove d_wb_alloc_units from struct ufs_dev_info
  scsi: ufs: Cleanup WB buffer flush toggle implementation
  scsi: ufs: Keep device active mode only
    fWriteBoosterBufferFlushDuringHibernate == 1

 drivers/scsi/ufs/ufs-sysfs.c |  41 +++++++++++++
 drivers/scsi/ufs/ufs.h       |  33 +++++-----
 drivers/scsi/ufs/ufshcd.c    | 114 +++++++++++++++--------------------
 drivers/scsi/ufs/ufshcd.h    |   4 +-
 4 files changed, 112 insertions(+), 80 deletions(-)

-- 
2.17.1


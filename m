Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F396FC43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 18:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C8E120872
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 18:37:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cLpOUy6y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgIOShV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 14:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727974AbgIOSIx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 14:08:53 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E31DC06178A;
        Tue, 15 Sep 2020 11:07:24 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id i1so3991857edv.2;
        Tue, 15 Sep 2020 11:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Cf1iAlZ7KW1crellt7Mb98w82iNdc/UJBUN0U2Sts40=;
        b=cLpOUy6yWPdQ6VmED21jNgkVOJHDl7n7dVXX0yb84QeXtpQ6BFeWf7QrIM4FFM0nVB
         oAjy/cFnJ89fK8SFyLLMCeWKCI+TniZxw7z9n6il7qHMazDEjSvm8sWSqJtU1B1EHClO
         EGOReqSI2jMtARbcW+ibkfYtGCgweMtnGDaDz67uUt54Q34fgsegkkVP2p6cb95odG35
         cqn9KmxD/20IzwqHnxIyoKJiHBZmkT13aWOA1GGBXQ/voX9cT8RSHA+JnVox99i1xqLs
         jqiSww8O3gUTp+OQ+cSUiifNZqPv5/Kx8UXX7qGYiQ+Rbhu1UNRtRpYjOorLCncp77TR
         vf1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Cf1iAlZ7KW1crellt7Mb98w82iNdc/UJBUN0U2Sts40=;
        b=TwgClWgCymwhykF7m/1bd6XCSQ9YaYDUFzsKivRKx9/TRdxiFcu0WnHcLtOf8Onl8n
         aboEvXBZaDC5ixLNzJhB2eUmB9lbXSG6hZPYwaOtFZySPji7BromVGSZLzbvLLUDheCb
         T/04GROm/mhojDTFSW+5/CTvqSGN/02tnBkIuDUFqan1fDfEh5N7RyCH21XNYKBQa+Mc
         l8Yq5wDPkN44mTBBPXFodoUW4P2WS9ZzsLlS7GqwaIlxsPJ2XmFTgw+cJgPjgXiwofnb
         P+0XNLCwoyYbFd2AVsrqXGLY9hBHCTp089qB0AH1XTG2jMJ5qqHuYth1dDr20tGo4La0
         d6tg==
X-Gm-Message-State: AOAM5304Rz95fe4vHGgxsAzN82IxBtZEhE9x+g4hZTt/mq+yF86d5c14
        4UziTMajm1jhJVkMCHu9qRZNIYQKxd0=
X-Google-Smtp-Source: ABdhPJy1Q2hvhWMQ2fCeUCqU3OIoJM2WrHy0Eqkzh3Nl59GcGdTyhXA+nJ9yVmXqW5Ndw4NP2favZg==
X-Received: by 2002:a50:8c66:: with SMTP id p93mr24032312edp.156.1600193242760;
        Tue, 15 Sep 2020 11:07:22 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:b890:1ee4:75d6:3bdd:1167:483e])
        by smtp.gmail.com with ESMTPSA id k25sm10687083ejk.3.2020.09.15.11.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 11:07:22 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Use devm_platform_ioremap_resource_byname()
Date:   Tue, 15 Sep 2020 20:07:06 +0200
Message-Id: <20200915180708.12311-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

platform_get_resource_byname() and devm_ioremap_resource() have been wrapped
to the single helper devm_platform_ioremap_resource_byname(), so use it and
simplify the code.

Bean Huo (2):
  scsi: ufs-mediatek: use devm_platform_ioremap_resource_byname()
  scsi: ufs-qcom: use devm_platform_ioremap_resource_byname()

 drivers/scsi/ufs/ufs-exynos.c   | 10 +++-------
 drivers/scsi/ufs/ufs-qcom-ice.c |  9 +--------
 drivers/scsi/ufs/ufs-qcom.c     | 23 +++++++++--------------
 3 files changed, 13 insertions(+), 29 deletions(-)

-- 
2.17.1


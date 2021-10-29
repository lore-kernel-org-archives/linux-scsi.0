Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE5AC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B0CE61040
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhJ2TwO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 15:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhJ2TwM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 15:52:12 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFF3C061570;
        Fri, 29 Oct 2021 12:49:43 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id v17so18131463wrv.9;
        Fri, 29 Oct 2021 12:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nODuHqqLXhrehpN4UhPvpnUAcOfWSvkEEwZIi+tzNVQ=;
        b=moFAQkSQIf0E5S4prhj8oYc01swVqvxyZmTe25/7STN6eNI8v5997DzCigklDVzKdt
         6fTkQwhu8+KYwlGja760WTH1Q+W124Pnf+feWy04TNfGUMaPULue4Oj9ILK9ObhbQx28
         uudenj+zWi52+8s7M08Jo/VEh23yi8qCFV2F8DjYipcA4AHdorT1yxoCoWhXO/jjoVRD
         GpGB2VwzxprQNZ3BuTV/xob5Uj0rqnORa8qw/Ei9QQP3L74f6nkJL5QeB2BN9kJ1Wn6s
         qDoaAwLKhcFcr6XIDFkrCFTy1/4DLht4YiT1FU4+SEc1cshOnczwlnPCRDx2Jc7uLhkV
         cM/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nODuHqqLXhrehpN4UhPvpnUAcOfWSvkEEwZIi+tzNVQ=;
        b=gRE6heGHhvjeihFmnZp6eQ5C+IP+w9p10emHqthzhts8K7wROJRho48z1fDDoj822/
         l/K0pljJmvd1FNtQKmn3fZZXUGNboShuDkQB6357pDRdAQXFhxpCs+KvDHbv+gFB/Doh
         9qRtUFtJqQdEs2RIhaULLxarVTyI30SsOLMzKkvPr8+aSJromc8uo4apg+LBx1QDPYDO
         Yr+lK1ixJcOa3YnlR+KCDi03PaXL0WZc1QsQyX4jD4xUtvufNHEv6w1YyvxdeWYlagWy
         Tw02KvXfqEFX4XcTSQCxZVIaKvYM2yjriqPej2Y+LZKqsm9h7cQYnp3aUtzqUmDMtob9
         sZdA==
X-Gm-Message-State: AOAM530Ek+HkPf74m7fMKJFcRVWtNQ+pfaeyCuZIp3bI2Y1UmVkSqTU2
        51HnedcCIyl42CDT0t9cXxY=
X-Google-Smtp-Source: ABdhPJwZTC4NIMQAekMcjejGmcwGU6cAwVjzEYyOma+c1LVsxfgUtlf++ZVwoIMJa4Lr1Dt53jn9nQ==
X-Received: by 2002:a05:600c:1c21:: with SMTP id j33mr21372038wms.163.1635536982330;
        Fri, 29 Oct 2021 12:49:42 -0700 (PDT)
Received: from ubuntu-laptop.speedport.ip (p200300e94719c92a81a9947a27df1b21.dip0.t-ipconnect.de. [2003:e9:4719:c92a:81a9:947a:27df:1b21])
        by smtp.gmail.com with ESMTPSA id r11sm6323365wro.93.2021.10.29.12.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 12:49:42 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] Clean UFS HPB 2.0
Date:   Fri, 29 Oct 2021 21:49:29 +0200
Message-Id: <20211029194931.293826-1-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Hi Martin and  Bart,

These patches are based on Avri's patch "scsi: ufs: ufshpb: Remove HPB2.0 flows",
which has been applied to 5.15/scsi-fixes.

v1-v2:
    fix typoes in the commit message

Bean Huo (2):
  scsi: core: Ignore the UFSHPB preparation result
  scsi: ufshpb: Delete ufshpb_set_write_buf_cmd()

 drivers/scsi/ufs/ufshcd.c | 11 +++++------
 drivers/scsi/ufs/ufshpb.c | 14 --------------
 2 files changed, 5 insertions(+), 20 deletions(-)

-- 
2.25.1


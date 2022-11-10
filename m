Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42680C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 13:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiKJNjA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 08:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiKJNi7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 08:38:59 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA13F1400F;
        Thu, 10 Nov 2022 05:38:58 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id gw22so1544317pjb.3;
        Thu, 10 Nov 2022 05:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VGjzo6k1HgWuN54AaXTg+YSGJQzCDip4EE3SOo8wCPI=;
        b=XSZYL/6B+eOI8G2YF+6Uf9V35FeFWo5Xs0RfLEykQdGRy1F5lUEV9zWwVEhkHyoJe8
         kEtQExa/WAJ/Exudg4r5HEJeaRaFRBK5EF9Ez2VgMpScRb3nmbi2R5g+RMnHPizq1Equ
         nkug8dk4OK5fuNBLDZNmAbg3aDrR1v9j4Mvb0uumeGDUFiPDUEbnX3Q6LMlLJqbKAbcF
         fziVXXBUb7t6Xahn4PuspSVl3kOE0t//BEU+8TuZyDMiSJiGutTWN9baQtUmhixbqbLh
         qxIRaJZXzz2nQi/vILPQ5fROn8G1Ch3xofIDAdzc4ioBMcEw7cBf0thHZijfiTjDZx7d
         govg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VGjzo6k1HgWuN54AaXTg+YSGJQzCDip4EE3SOo8wCPI=;
        b=xaH6N+Qw6sWRoJWVlZ9I1xS9SpoMXA4iBBovjhQMtcjzVsUtorREmXKuBFwpRiEneg
         LLPzrL7u7AN1OWCr6PdeAbpt96PnZQc3ZCWWb8KtI1lZKhBZ5frsqKtwBs9hjNa7Gjy4
         jz95e0vy7SKtapmrzrRHOorG9nhht2RVh1jD5PcnOLX8U2uA0JEEGAV/hioFAG84gLu5
         iWyHs33+ILBtLj32qKOLd6ec9JqyNHjG/hbGd6FjriA4xqF93SgEHH9S8VPe0Jn3WKoI
         TpIFl0QNj5EXQvjDoa0p3VQhwrJzae9c3aeKqO31oYg1vtC1RHkcM3MA3yjKITw4h13x
         MsWg==
X-Gm-Message-State: ACrzQf1LfCCrjhpUkr8LChwKV355MG46itycrBN7m+V3zHYAYud+ZbiG
        3c+0u8hwqZ0oppETDikPQw8=
X-Google-Smtp-Source: AMsMyM6F4gmk0VdMUEa6WFI2GrsZ07BMDcYfHGP3Cq4KDA+8KVBENFoqW8yK9nK/yP0FOVCNFWC0dg==
X-Received: by 2002:a17:902:74cc:b0:17c:73a5:d7a1 with SMTP id f12-20020a17090274cc00b0017c73a5d7a1mr1339383plt.37.1668087538499;
        Thu, 10 Nov 2022 05:38:58 -0800 (PST)
Received: from xm06403pcu.spreadtrum.com ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id j8-20020a170903024800b00186b758c9fasm1609045plh.33.2022.11.10.05.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 05:38:57 -0800 (PST)
From:   Zhe Wang <zhewang116@gmail.com>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com
Cc:     linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        zhe.wang1@unisoc.com, orsonzhai@gmail.com, yuelin.tang@unisoc.com,
        zhenxiong.lai@unisoc.com
Subject: [PATCH 0/2] Add support for Unisoc UFS host controller
Date:   Thu, 10 Nov 2022 21:36:38 +0800
Message-Id: <20221110133640.30522-1-zhewang116@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Zhe Wang <zhe.wang1@unisoc.com>

Add this patchset to support the Unisoc UFS host controller.

Zhe Wang (2):
  dt-bindings: ufs: Add document for Unisoc UFS host controller
  scsi: ufs-unisoc: Add support for Unisoc UFS host controller

 .../devicetree/bindings/ufs/sprd,ufs.yaml     |  72 +++
 drivers/ufs/host/Kconfig                      |  12 +
 drivers/ufs/host/Makefile                     |   1 +
 drivers/ufs/host/ufs-sprd.c                   | 445 ++++++++++++++++++
 drivers/ufs/host/ufs-sprd.h                   | 125 +++++
 5 files changed, 655 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/sprd,ufs.yaml
 create mode 100644 drivers/ufs/host/ufs-sprd.c
 create mode 100644 drivers/ufs/host/ufs-sprd.h

-- 
2.17.1


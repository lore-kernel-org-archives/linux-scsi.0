Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF33C07E9A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 09:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D74CE61369
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 09:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238466AbhGNJUu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 05:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238147AbhGNJUt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 05:20:49 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F40AC06175F
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 02:17:58 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id h1-20020a255f410000b02905585436b530so1751937ybm.21
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 02:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=wlrejQF48WL4uSnd99LoOFS/aI1Cbh+kk7n1cuLb8Cw=;
        b=P1U+2qmKrZFPH1F205C0/YpTnPSOtrtZBISVrVuEwKIgIwSqtTHUeBOxhmFB/MvPem
         2cLbH//lBQbItf6/Yc3FkRmungVvfG2zSsBaUwKDE/P5z4CjvB7jWDetnL+2r9KzMUpi
         gIbMOZMlPnGP5E9kj/cEmpbjW9wnXRnCakZzq6OaxHE7giuBuEMO2O54imLNby/x/Nsp
         IE/Ktf90LufxxRvIiKvriv4sSdGNeXul5YdCxx2YJF0bfpJOYOhZIHbjzQAsMkbNOvRp
         4jz/2/2oT3h6NQysEUnSd2ysPyr0MMSn/tdotxY0VoZTkoQ6It9txcbkrvge+5gddc90
         3BUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=wlrejQF48WL4uSnd99LoOFS/aI1Cbh+kk7n1cuLb8Cw=;
        b=dmJAZCI8teNYFlsACpzKWxbjQ0SNVKZkxulFugw1GLRnAenwTFC++OGVjfIzPBMfxZ
         2WJGh9vlIetWYY7Y+7NZvTt06gxSbOqV+hAOReeeUfDFQdrp1E6mXzVwOIZtL2km+VRd
         B65TbhF4et5reKmYX2TI/aMTJN/4N3RERwJkqcJidu2gyw8t+cSYEgCU+xM6BxxPuI81
         Fq73QVMsRdd+IFbTp7JiPYQCeW648+XUkeF9LiorxFSiGchck+YWi0SvgvA6/IBhb/PF
         CHnKsOuIBhznP3s63IXj+dfE8e2gwxRK4vdp+S+6KlENjvUnhBAWW/MEfg4EYyUrdSsg
         JGBw==
X-Gm-Message-State: AOAM532wYJa5H+1scigHGptzLtA9TbN0noLkUggKKpwlQzCnWyfmuSgV
        clg+niTH6QyRVoqBf+rFOoeNfCKF
X-Google-Smtp-Source: ABdhPJzvZoBrVMLmKVofazWugPLVIdobBxAIACgaacdGRcC6DEb+OIp6+hpvaCQiE14wFI8hFJkY3Qjipw==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:c569:463c:c488:ac2])
 (user=morbo job=sendgmr) by 2002:a25:764b:: with SMTP id r72mr12013800ybc.254.1626254277400;
 Wed, 14 Jul 2021 02:17:57 -0700 (PDT)
Date:   Wed, 14 Jul 2021 02:17:44 -0700
Message-Id: <20210714091747.2814370-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH 0/3] Fix clang -Wunused-but-set-variable warnings
From:   Bill Wendling <morbo@google.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches clean up warnings from clang's '-Wunused-but-set-variable' flag.

Bill Wendling (3):
  base: remove unused variable 'no_warn'
  bnx2x: remove unused variable 'cur_data_offset'
  scsi: qla2xxx: remove unused variable 'status'

 drivers/base/module.c                             | 6 ++----
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 6 ------
 drivers/scsi/qla2xxx/qla_nx.c                     | 2 --
 3 files changed, 2 insertions(+), 12 deletions(-)

-- 
2.32.0.93.g670b81a890-goog


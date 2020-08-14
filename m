Return-Path: <SRS0=qkKg=BY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B5FC433E4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 09:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99A95204EA
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 09:51:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zid6xstj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgHNJux (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Aug 2020 05:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgHNJux (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Aug 2020 05:50:53 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6FAC061383;
        Fri, 14 Aug 2020 02:50:48 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id g19so9274671ejc.9;
        Fri, 14 Aug 2020 02:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WNpAdv9km1uSVUV1TKQfr3pXz8plMWVKyzdHM2lXuHY=;
        b=Zid6xstjNEJ+Ojy+Igat6s986EPti2Cz6985+CrUNIi7PcZEEA5B+Ya3t2ua139C7o
         b17KIoWB/odbinp1GSSIFVQIicrZDOBuRXqTT0OXBgh2OI1DrwQSPFQ/evUlrPxhQSpK
         ceVY+XQuZA1zLFzR9WG6yDNxhSWOMSWgA4D4KLp1uIP2vMmSvihVwHmcvPEga5we3g9G
         2n46Vv46jyuy5biQrJK/eDcLN/SHbRNol0ikB2M/18YuuxYx0BRcejW1UPCFfLMypQ3P
         pNzZFuAE28FsckdNF52uIPu4T7oo6lsiHY1pFjoI8+F0/ix3Tfka9bgXOQ+7n0N3uVkJ
         0bRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WNpAdv9km1uSVUV1TKQfr3pXz8plMWVKyzdHM2lXuHY=;
        b=nLaULnjE8r3VK/3UyR35F4BvvFFcQIPXN7+Exgs4SU1uv9GbMkkymqFZSWqBs96MVK
         Ho21cKGfEGK4MEnx4fGb+13UzFhfc55j4SjW9xPqnjQR6xC1fOk3PGMfZ/wuUUXK66Ub
         jXRi8DP2lKIBhs5V3Y/dLHwvWevg5H8BC2FYX4FoogqWgbSyHbJgAfIAjnFc3e7AQEkA
         Dos+szGPEYORTNcyn58zbS+f88wNYsf3b/brXcDKDe2EVSYwgvXHPRsVFQCnlgblM+Ra
         /xJgtSEwCJ5RLgtI6S0RD7bkgcnqbGX4Te7Ai+Rs7jHWUchHLXKt50FUF5qK838nUUHu
         0pIA==
X-Gm-Message-State: AOAM530yXsYP8Obm4sIBjILsl59ujICoxbAYMbHhb5d03JLBbogHCT1f
        vEbPnqLAS/fS0QELjYak6Tw=
X-Google-Smtp-Source: ABdhPJz5afr+WO4b9EAN0zTaUv4SE/i3JW36quSgxaxMqvfcGFAh6jLGNNfcoc1hTVreL5QIlt79sw==
X-Received: by 2002:a17:906:8490:: with SMTP id m16mr1606355ejx.132.1597398647222;
        Fri, 14 Aug 2020 02:50:47 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:8980:3d37:44c:d55b:5f94:2fc4])
        by smtp.gmail.com with ESMTPSA id r25sm6016448edy.93.2020.08.14.02.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 02:50:46 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] make UFS dev_cmd more readable
Date:   Fri, 14 Aug 2020 11:50:32 +0200
Message-Id: <20200814095034.20709-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Changelog:
    v2 -v3:
        1. fix a coding style issue in [2/2] (Asutosh Das)

    v1 - v2:
        1. remove original patch scsi: ufs: differentiate dev_cmd trace message
        2. add new patch scsi: ufs: remove several redundant goto statements

Bean Huo (2):
  scsi: ufs: change ufshcd_comp_devman_upiu() to
    ufshcd_compose_devman_upiu()
  scsi: ufs: remove several redundant goto statements

 drivers/scsi/ufs/ufshcd.c | 32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

-- 
2.17.1


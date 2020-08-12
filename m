Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9A71C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 14:37:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95FA820855
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 14:37:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a7Xs8eiL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgHLOhR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 10:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgHLOhQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 10:37:16 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C326AC061383;
        Wed, 12 Aug 2020 07:37:15 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id kq25so2525061ejb.3;
        Wed, 12 Aug 2020 07:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eMsBZ/mNa/JxQKyQPdcReQp5+OXk8qYiQBle2FaJYWE=;
        b=a7Xs8eiL9sQb5S+77grjIRHd+2a3QftR5KKYmOk2cEtBdF2hASeNP8VstAOIdPNi6o
         a7LqDbYU+vFa+DQUeowupLv/W+x59t6uSIT0K8RFVH/ctwL19S2kwZvBpnkcSjhqGOdf
         k00K5tsQEUN/6NArTteoAvVMZ6OlzMGsiOE3A/K4SlENEq3IDmUQJ/gifZQQBkypYERu
         anbnaetgf33tJG4umNIvfu/+nAISsUXYOIO2g8SpsaxXUDlpXF8hZSkInHpzbAExoBAT
         LsYTvRMnE47SXc1O8WwLBe9BbhycGbXP73A5f/grL9cIkkYbbQGgUizfGN6ct+Y0tMO2
         1zuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eMsBZ/mNa/JxQKyQPdcReQp5+OXk8qYiQBle2FaJYWE=;
        b=g8VRAwaAsMyrWpUYDcnvLLC7PsRuH+jmNTAPVZWM7xzL2CBt5GVu3fMD7ogxBA0tGe
         0ZhxIlj0tV1pPJuQij/mlrNIbcwydsA0DWPD77meSB+gVxF8aOSmnFtjaDrJov6jvkpa
         NQ3GA3y6dURhYiueXvUROJNCZFYDDFAj7r8IDExmML/2LGIImQtvuM7TcHXileFBayND
         zx9AAdXbuGt39vmuZ51Pt/I9FCjECirWqgXKkf8Vu1moBuYo0pPiEmdrnLjiYKkpwcrC
         M8341bxP0bt7Dq7u1KQ2smgClY8NTCSFIncQ8F+/S+iw2jufM2H8XVLnxoaAp/SG+XAb
         WNKA==
X-Gm-Message-State: AOAM530MVTPzWUBoNm25KUHUMUoLFJojOp2p+Vd7GSyAo3kEHglS8RtR
        efyAfcBdStMGo/Gt6uFEXexJFfiB
X-Google-Smtp-Source: ABdhPJw5PoytbQ6YlGTPiwjYLYZwLQRCn9WeP1u5MjMGQcf0z+eviTLrmL7xDCD4PBY/gove+nh6PQ==
X-Received: by 2002:a17:906:2f17:: with SMTP id v23mr55947eji.343.1597243034601;
        Wed, 12 Aug 2020 07:37:14 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:b90f:8e5c:44c:d55b:5f94:2fc4])
        by smtp.gmail.com with ESMTPSA id d20sm1661179ejj.10.2020.08.12.07.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2020 07:37:14 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] make UFS dev_cmd more readable
Date:   Wed, 12 Aug 2020 16:37:02 +0200
Message-Id: <20200812143704.30245-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Changelog:
    v1 - v2:
        1. remove original patch scsi: ufs: differentiate dev_cmd trace message
        2. add new patch scsi: ufs: remove several redundant goto statements

Bean Huo (2):
  scsi: ufs: change ufshcd_comp_devman_upiu() to
    ufshcd_compose_devman_upiu()
  scsi: ufs: remove several redundant goto statements

 drivers/scsi/ufs/ufshcd.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

-- 
2.17.1


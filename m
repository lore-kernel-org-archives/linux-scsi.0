Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6BE6C433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 17:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AA302098B
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 17:53:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ui6InmAw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgH1Rxo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 13:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbgH1Rxj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2020 13:53:39 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75770C061264
        for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2020 10:53:39 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id i13so82769pjv.0
        for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2020 10:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fc3BOzKVJl2dqsg5OXJvVDuQ5v0PBIyT7SIjEZPYYMI=;
        b=Ui6InmAwX7L45/0eXyP8zP17mE9nH+oYx3hz8tmqJ4p+JyiXosh0V5cVVTdGMbEdl4
         JKnezS4pkFQdJSenmKSv76gC+F7C3vebk7CCWsLz2HBDmG+rb3Bfsgcijn53f0vKFBsS
         5DZ6Od6E9u0ItOAs7kP0Th91i4OTexa0jJtfw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fc3BOzKVJl2dqsg5OXJvVDuQ5v0PBIyT7SIjEZPYYMI=;
        b=IUzo9289ol0KCVAqFXy/HYZKvu7zp3OUklVZSf47i0dTNvBMaaQvAGXPadgp8lvlpB
         efqAFMIdwV497TEZtzKDgc7Vs4y8pvij1esM9uHH+F5/PWyp2Lju3kf0tGnkngDWx061
         HpmwEvRJO1SB60+uupcyHRKSz8yWqGi4abwlsfRjXQ6OXBCf+GeAYhJwuqpCi/znd9fN
         RsmQBeWmaZ+aNcNht5DyDPs7UAGmeBk8Cttl3UTtgqTxaVdJwR6MbRofZAUngq2ywlA8
         Dpp5IxN2zMrO2PM8TT5eO2WPjne3q4OH8887AigEZvTg9bC9ckOH8LWFqK4BVHpnvSlE
         +r2g==
X-Gm-Message-State: AOAM533ib9SidYsQ6dFOkbxNagALfBftvDzTB2PSGHV61kQ1u+vxfu5h
        OhyAnypojQ82IGAu2hKbak+eg832b3wBv7oDaCEvO+T6gfN6Qx/90czc3dAdNFmno7RfMhOLFjz
        n877CoIyP+zCNjraTT4pE1+aSewzpV0s8Fj2jDA/0uA+yZ2p5ALXCqF30yB+rlXZs0/Luzi6QZE
        oysnE=
X-Google-Smtp-Source: ABdhPJzRR0ctt2zL0grc+ptt+fWPB0HAE+u+C9a2XWzceHMVGdCaOpKg/y8MHXs4SlIm0rEMwWMUIw==
X-Received: by 2002:a17:902:fe88:: with SMTP id x8mr57078plm.204.1598637218467;
        Fri, 28 Aug 2020 10:53:38 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e65sm88734pjk.45.2020.08.28.10.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 10:53:37 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>
Subject: [PATCH 0/4] lpfc: Update lpfc to revision 12.8.0.4
Date:   Fri, 28 Aug 2020 10:53:28 -0700
Message-Id: <20200828175332.130300-1-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.8.0.4

The patches were cut against Martin's 5.9/scsi-queue tree

James Smart (4):
  lpfc: Fix setting irq affinity with an empty cpu mask.
  lpfc: Fix FLOGI/PLOGI receive race condition in pt2pt discovery
  lpfc: Extend the RDF FPIN Registration descriptor for additional
    events
  lpfc: Update lpfc version to 12.8.0.4

 drivers/scsi/lpfc/lpfc_els.c     | 7 ++++++-
 drivers/scsi/lpfc/lpfc_hw4.h     | 2 +-
 drivers/scsi/lpfc/lpfc_init.c    | 1 -
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 4 files changed, 8 insertions(+), 4 deletions(-)

-- 
2.26.2


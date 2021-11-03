Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF9BC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 00:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4408561076
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 00:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhKCAIO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 20:08:14 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:37627 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbhKCAIN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 20:08:13 -0400
Received: by mail-pj1-f53.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so174060pjl.2
        for <linux-scsi@vger.kernel.org>; Tue, 02 Nov 2021 17:05:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fv7lqMyWDth+SEYIAoan/uEyOUPGRh49mPDPvy3zJjA=;
        b=SnmcOxkyeuGSarrwY7J/4279gRVnJMeiHFvIg56PPml+cjcpZU+rVBxl0C9iuO/qHV
         cLTpRALx9Hdl3oJBWZ2DFfVX3xi3eYwFF9J/8Xl9FII9NZI24DFU1w4d9IqU7c5Z/QU1
         zIFigMPgxk1AzEiRGZqkBcEqWkyUXy4d+sTYztyTvfcvhqoIK7kpzHy9nKigFOVoj/3m
         lCdj4/hcBcwtEzo6C8fWQP0KMTBF27+K+Onca+hnDgSpqVwaoqisOhjMQmZ5JZPc2B15
         8pbLTdMcZmPN/zUJl7mDRCK50lp1+9Yiceb/mzxZLKRzIQqadV/3OGTLg7I0whbOfjk1
         ibMg==
X-Gm-Message-State: AOAM533z56i3KL9b0nMG82pVHHC233FBps+bmUZNAflJiFNLlmdoP0Ds
        gH2OEOaZS4aDDgBy+eLj0ko=
X-Google-Smtp-Source: ABdhPJyd+Y8FQiiv+7s+mox9aEiktVT2fzjE+xIq03+iITQzsTLvVM+TibdeN/1Imefp7g+S3XAJeQ==
X-Received: by 2002:a17:90a:ab06:: with SMTP id m6mr10690235pjq.112.1635897937588;
        Tue, 02 Nov 2021 17:05:37 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9416:5327:a40e:e300])
        by smtp.gmail.com with ESMTPSA id u2sm279282pfk.142.2021.11.02.17.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 17:05:36 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Fix a deadlock in the UFS error handler
Date:   Tue,  2 Nov 2021 17:05:27 -0700
Message-Id: <20211103000529.1549411-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series fixes a deadlock in the UFS error handler. I will repost
this patch series after the merge window has closed.

Bart Van Assche (2):
  scsi: core: Add support for reserved tags
  scsi: ufs: Fix a deadlock in the error handler

 drivers/scsi/scsi_lib.c   |  4 +++-
 drivers/scsi/ufs/ufshcd.c | 20 ++++++--------------
 include/scsi/scsi_host.h  |  9 ++++++++-
 3 files changed, 17 insertions(+), 16 deletions(-)


Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9533CC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 12:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69E1921548
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 12:08:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eE7jAjL8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388780AbgE1MIL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 08:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388784AbgE1L4h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 07:56:37 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEA7C08C5C5;
        Thu, 28 May 2020 04:56:36 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id d128so1732728wmc.1;
        Thu, 28 May 2020 04:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tq+q++/frST5N5CKETYuRqUnrOlaPvf/ODtcvH07zHM=;
        b=eE7jAjL8k8KesdXQ8UHRMzDquL2AN+NiiE5Ao/ztSJTqX/49+V4QyMgvpYLstoGEui
         l/9NgM3PVhu2Y3RghbdJcM/kPsQSce/RVVcZ/RZraP8e4lrmVuq9oINYYaYltQ2oPM9G
         4OM1YDfwzsgPmp5l+ILk4RyiaP4aeSqEoib0C6VrpSiG4V+kOtz0Lpfwis0zu3ryBhRh
         9u+5lodqjSz9NGOeF+fhnjH+/T0BWzMy0m4iqDaMWlsL+/n7PnNunIyfDi493W+SYApR
         WS8Y4A9L4lgZntMs/NfU8tAkEWHE/JCQI9wa4qAFmOI8qsIY67lDiwfHkTUdArIFu+xK
         DHMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tq+q++/frST5N5CKETYuRqUnrOlaPvf/ODtcvH07zHM=;
        b=Y5LMQ1/sRKIwUcEoY+exfXUdWmheyRAjWUCFKQscx+u9+tNSR3uQX0uREe3RcnGDyG
         QG+aWjc+Xm9E5DLAKU/IfodkZReXfwTq6OvU3BKXYarkag26qZwk9pKwm+4tsPi/wXDs
         L2RK0ElaiQTGM91gYE/vQggigTWDkxBphRkutjNdQvbyaI8bX9k2nbXPUw1aYc3tlMYB
         eX5ZXDCb98x6NEgWsx0rLjRT+4w38m07an0LBrfaKuNDogS/M7kZFjiQeUmbmPAfyJqk
         N1hozLGl4kNWOKLux8pO89AGAJzS2fZqOaRM98R6vNA0KgRS3WFSsA4YsIa/adtZQXnm
         PWyQ==
X-Gm-Message-State: AOAM5325ZI87Q13BAEWTXpI3f6TO2q4JzhJZqVGnxN5KCSA1ManUSeAQ
        cGhqFEjL8SU6aDZ5g+qTBqw=
X-Google-Smtp-Source: ABdhPJxWIov3wIHFYf08Dxe/mGLEPx1E1mLIZwJgbqV2sS3UN5RUfoXpV0uTQjt2XBqLEIbdmRbWbA==
X-Received: by 2002:a1c:7c02:: with SMTP id x2mr3204327wmc.183.1590666995753;
        Thu, 28 May 2020 04:56:35 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.gmail.com with ESMTPSA id y37sm6589178wrd.55.2020.05.28.04.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 04:56:35 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] scsi: ufs: cleanup ufs initialization
Date:   Thu, 28 May 2020 13:56:13 +0200
Message-Id: <20200528115616.9949-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

This patchset is to cleanup UFS descriptor access, and delete some
unnecessary code.

Changelog:

v1 - v2:
    1. split patch
    2. fix one compiling WARNING (Reported-by: kbuild test robot <lkp@intel.com>)

Bean Huo (3):
  scsi: ufs: remove max_t in ufs_get_device_desc
  scsi: ufs: delete ufshcd_read_desc()
  scsi: ufs: cleanup ufs initialization path

 drivers/scsi/ufs/ufshcd.c | 166 ++++++++------------------------------
 drivers/scsi/ufs/ufshcd.h |  12 +--
 2 files changed, 34 insertions(+), 144 deletions(-)

-- 
2.17.1


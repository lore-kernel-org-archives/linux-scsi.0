Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C22DC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 16:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D103E2077D
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 16:41:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bE8JsViJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgE2QlR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 12:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgE2QlR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2020 12:41:17 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09137C03E969;
        Fri, 29 May 2020 09:41:17 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id y17so4385028wrn.11;
        Fri, 29 May 2020 09:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5H7t2JkJtK8bEnNB5nn596iezOidqOpYmSimrSsUglM=;
        b=bE8JsViJ37vX9JA94OJxidc026Lxn8nybhNKSLyo8hK8PELjDMDYSe8zb/vhX5VrvX
         YJOGbyo/dJYYDnyKetZEWArQAlsS2Poi/8+LjW+MrDCOcft36YQY4pMY02ECamJ3gfGz
         9X932oObjmiaZFUeFdlNF4nExE7+F9IZSqLnnJMVmUwWNlwHl4PVN1wVAftvuVr0vzv1
         NSHfpfEFM0+b/OQ+xRAqkM9zTiNJSvY9ZajnjQL7i0Xlry5EUabjs7XiH2Pa3hBTX6uf
         MND/NAzAfPwkzC7Z5CJhPNp3i69ViW3FJYAdJ9vr2AilfiCqIHQwB1Bdv8SX4Wxfg6yI
         U2vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5H7t2JkJtK8bEnNB5nn596iezOidqOpYmSimrSsUglM=;
        b=EWRe5jmUSoRjEgJ5AMMwT4/MjMduQje5hvF8VSP4DM+tghpHYjJEfFI0QKkYRC21Rw
         CvC40j/gDN0TaNF67WwmHV+tzZrj+IHya9delG79D/JY+KINu2ue23Mh4pWvD0jTlPqE
         h4dyIJyO5f7d6kryddoU9U92r9iC0B0jq4ep7lrZm2+H7/9f2fyg1OdZaL4mgvAJMYKo
         Bmxot9qbf6wYcg0O9ED8zsifafE+ymaVevNa/6zr3VYEL9rGlkxooY11mAWEVnXZmXzI
         vDg55PjACHJaZgJl85SRoHAimjD5Ll6s4r/Bhnei60AohN29KRLVzrH9z7IRw22wtDsj
         DSFw==
X-Gm-Message-State: AOAM533FWvKsy2FR3LBVXyXWoLTWsOcO+0HCfCsq0bNAb9cuO95A+9fX
        HBd4tNf1Bbndq8SDhtQDB0S4pWEnU5A=
X-Google-Smtp-Source: ABdhPJw9+4r/R74QnBRhy9oZZ9OjeYshXAy8R82oDM3m2jIJUrT+58o2X8+mbvMBeHWCNb5XGG+nOQ==
X-Received: by 2002:adf:dcc3:: with SMTP id x3mr9164926wrm.93.1590770475776;
        Fri, 29 May 2020 09:41:15 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.gmail.com with ESMTPSA id z25sm17344wmf.10.2020.05.29.09.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 09:41:15 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/4] scsi: ufs: cleanup ufs initialization
Date:   Fri, 29 May 2020 18:40:50 +0200
Message-Id: <20200529164054.27552-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Cleanup UFS descriptor length initialization, and delete unnecessary code.

Changelog:

v2 - v3:
    1. Fix typo in the commit message (Avri Altman & Bart van Assche)
    2. Delete ufshcd_init_desc_sizes() in patch 3/4 (Stanley Chu)
    3. Remove max_t() and buff_len in patch 1/4 (Bart van Assche)
    4. Add patch 4/4

v1 - v2:
    1. Split patch
    2. Fix one compiling WARNING (Reported-by: kbuild test robot <lkp@intel.com>)

Bean Huo (4):
  scsi: ufs: remove max_t in ufs_get_device_desc
  scsi: ufs: delete ufshcd_read_desc()
  scsi: ufs: cleanup ufs initialization path
  scsi: ufs: add compatibility with 3.1 UFS unit descriptor length

 drivers/scsi/ufs/ufs.h     |  11 +-
 drivers/scsi/ufs/ufs_bsg.c |   5 +-
 drivers/scsi/ufs/ufshcd.c  | 200 ++++++++-----------------------------
 drivers/scsi/ufs/ufshcd.h  |  16 +--
 4 files changed, 50 insertions(+), 182 deletions(-)

-- 
2.17.1


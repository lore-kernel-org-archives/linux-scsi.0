Return-Path: <SRS0=V0rO=7N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E1CC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 31 May 2020 15:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3B0C20723
	for <linux-scsi@archiver.kernel.org>; Sun, 31 May 2020 15:09:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P7izPgsB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgEaPIp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 May 2020 11:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgEaPIp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 May 2020 11:08:45 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B211BC061A0E;
        Sun, 31 May 2020 08:08:44 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g9so5338454edw.10;
        Sun, 31 May 2020 08:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=cSx9zeRQDNEgHX3X5I2ozAXJomME/x9VxcUo23d79NA=;
        b=P7izPgsBaNvXpJvZqn/UcLhIRav5PZZbRGgyZdrhc5GWsUyyJXNQZP16UhzbcCL4HZ
         DhMImo8g27E/edm5gqQmo33KG1oh/cZ4cOT7cKwKjXlPdxZf8AWG3AqOArRK1Y6L8RLJ
         MX8Fs7TgtpdWjsfTZRDGEdGhGjnGcIE0lvRaR0RKZ3zsCimikhFVXTCAoiR4k4v87vqR
         zbGx3yR6gpw6nYMrZS2y5ZKcnKllYxYyu5Iz1zeN4BCciH+kNIyU0Bx/j+ibdV2mSSHX
         vrhoGcNUO/X080C8XQrBM27sqSSEz+lrUmvEV44TIMcqk3B8ST3qGvMi+CcUGITE5Cj2
         GXcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cSx9zeRQDNEgHX3X5I2ozAXJomME/x9VxcUo23d79NA=;
        b=YS1qFPPOB+HV2AfgnyzfltVwc9lGNgasv79YDBiRXI3OjyIgXywD9+YO4peZ06ZCim
         xggrHerGkDh7gLYLDZO9WGczuPHvH/udPyTdWzrqqwVgfQ9Uw25VNc1k4pUAxF6K7so9
         umaQjXdzEZqSYunpAOZpziuZ/F9iUxha84E/SuelPcWPbVfGn9IHfervkg9cbEGLrWDU
         lJt9eeODKOib1Fo8gJ5roYbNoUopU7bcDfor6fUGPk8bZnvrlgMIwmGCPTXg5MuE97Y6
         6JqgmU98HfVvElGfkhne90Dq7W2q/b75I4lcIWrihReuyhIWp4aYO/ZIHu4wLIj5/WHK
         IAGw==
X-Gm-Message-State: AOAM531sz+gyTqiadZw95WFBZRglhu7aHmZAE4OBjsD/UhfCA5T6+h+b
        VUjL4t1ljjkO/QNE3sz2R88=
X-Google-Smtp-Source: ABdhPJw8p+v7/xy3NDXGBC6pAR5tmFC3KXHHpI40gNpjwb41XKl0dd3LouExjZlPL13FgJSW1zMctQ==
X-Received: by 2002:a05:6402:c99:: with SMTP id cm25mr17106007edb.2.1590937723328;
        Sun, 31 May 2020 08:08:43 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcfd.dynamic.kabel-deutschland.de. [95.91.252.253])
        by smtp.gmail.com with ESMTPSA id a62sm9564928edf.38.2020.05.31.08.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 08:08:42 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/5] scsi: ufs: cleanup ufs initialization
Date:   Sun, 31 May 2020 17:08:26 +0200
Message-Id: <20200531150831.9946-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Cleanup UFS descriptor length initialization, and delete some unnecessary code.

Changelog:

v3 - v4:
    1. add desc_id >= QUERY_DESC_IDN_MAX check in patch 4/5 (Avri Altman)
    2. update buff_len to hold the true descriptor size in 4/5 (Avri Altman)
    3. add new patch 3/5

v2 - v3:
    1. Fix typo in the commit message (Avri Altman & Bart van Assche)
    2. Delete ufshcd_init_desc_sizes() in patch 3/4 (Stanley Chu)
    3. Remove max_t() and buff_len in patch 1/4 (Bart van Assche)
    4. Add patch 4/4 to compatable with 3.1 UFS unit descriptor length

v1 - v2:
    1. split patch
    2. fix one compiling WARNING (Reported-by: kbuild test robot <lkp@intel.com>)

Bean Huo (5):
  scsi: ufs: remove max_t in ufs_get_device_desc
  scsi: ufs: delete ufshcd_read_desc()
  scsi: ufs: fix potential access NULL pointer while memcpy
  scsi: ufs: cleanup ufs initialization path
  scsi: ufs: add compatibility with 3.1 UFS unit descriptor length

 drivers/scsi/ufs/ufs.h     |  11 +-
 drivers/scsi/ufs/ufs_bsg.c |   5 +-
 drivers/scsi/ufs/ufshcd.c  | 205 +++++++++----------------------------
 drivers/scsi/ufs/ufshcd.h  |  16 +--
 4 files changed, 53 insertions(+), 184 deletions(-)

-- 
2.17.1


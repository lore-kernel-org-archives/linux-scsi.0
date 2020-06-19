Return-Path: <SRS0=E1i/=AA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A31F3C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 15:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7270E20809
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 15:42:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BxpJGkQ4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394000AbgFSPle (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 11:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392034AbgFSPld (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 11:41:33 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC257C06174E;
        Fri, 19 Jun 2020 08:41:32 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id e12so7986269eds.2;
        Fri, 19 Jun 2020 08:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KpGjicrxstQUYFzwH57Owwl0NACRgRYZg/C23NotbfM=;
        b=BxpJGkQ4EyWZYKrHVs9D3CbDeJqQRk3exCmnoWFYqLtMrJrOzEmFi7JsMtRtqwOssX
         B6q14V/pGZcaqo60fUj+FmmYx7HqLvCAZt7vEImL7miykkkNM1DnVcylTXeDNtwD9p77
         OWl5YeyETIfxzgz98ThTioo4GiVwdSnA1Ih939YXO08Iz8CzSXUUWAkHGnsYU3YT5Leq
         ms8exHAG2GGpOLgG5F6ofHyHzmwTw7A4Guzz+giBCPAxlfkIe1z4Z5uFgokYnl06HZqf
         YXrJe3HoucXtNOF68hV74d66kH8hy4eGe5xVac0rvcY7aBXUNc/nvp9nMCO3B1/El8Fm
         KsKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KpGjicrxstQUYFzwH57Owwl0NACRgRYZg/C23NotbfM=;
        b=le99rDZsmIyD4u1X4qKabwaVJCXlwHx/vrK4eTSsQDTRaLiwABb2/vlQNDYDhozQAF
         RrZuhDTN4StQJk7ulsYw39/RtFrXVStBFq0lZI1pLgJdbaD8ZnkODt7WPorqMGedhbaB
         zNPA+2QI5oLG2DHD4eA3Z7MeXkzGmYUsSe5Kh8lGPUkJ/tfLQghj87gALhjh3uKrjTw8
         7Ue3ijgPbc7a9f5hehwwClG7LIyS2rIxrfwegVRkG+iFteL501ARUF4ipg3VRJV5UbFp
         iTM8FPW4sm19fXIB9cd0g7nxeJmnNMCkumafEpZjJmmFelm1ejZH8KoMdYwl0xO+bxgl
         VZnA==
X-Gm-Message-State: AOAM5335r23v1UFPCZ5zzvQ5DsOJ8vnxi9QuB+uTktOjg1GdZKXcO5JC
        HbKdwQnpXu8JWdtjk3qWR+A=
X-Google-Smtp-Source: ABdhPJyYW80P4JxYyH5IZgoMk06IUj/9QxWDqEbg72RU4bolBoWA1gKoeJUJ8FDv5cd+n+mjcx2XrQ==
X-Received: by 2002:aa7:c541:: with SMTP id s1mr3993960edr.167.1592581291714;
        Fri, 19 Jun 2020 08:41:31 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.gmail.com with ESMTPSA id ew9sm4986163ejb.121.2020.06.19.08.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 08:41:31 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bvanassche@acm.org
Cc:     beanhuo@micron.com
Subject: [PATCH v2 0/2] scsi: remove scsi_sdb_cache
Date:   Fri, 19 Jun 2020 17:41:15 +0200
Message-Id: <20200619154117.10262-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Changelog:
v1 -- v2:
    1. split patch
    2. fix more coding errors in the scsi_lib.c

Bean Huo (2):
  scsi: remove scsi_sdb_cache
  scsi: fix coding style errors in scsi_lib.c

 drivers/scsi/scsi.c      |  3 ---
 drivers/scsi/scsi_lib.c  | 58 +++++++++++++++-------------------------
 drivers/scsi/scsi_priv.h |  1 -
 3 files changed, 21 insertions(+), 41 deletions(-)

-- 
2.17.1


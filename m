Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B24EC433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19603207D0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:47:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WDb4/2PU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgGIRqC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbgGIRqB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:01 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C4FC08C5DC
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:01 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id f18so3321339wrs.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+HM3pvSE2JuDZ5Kc5EJ0B/qyBhrrEM7iialxYUUhb/4=;
        b=WDb4/2PURWwxaGQwRJjnz9i/la25WsNSlHDya20V36viFuVtojjzGqAnvuy7vUEm4t
         Og6WGYoBpWprPJtHhtHqZrpJyiN389DZlx+34S8P8QHcgvpRgcqdzjVl3q37fH7vQ1zo
         o2QcgK1KjTxH4bO6jWLvfhx9PW4yvqaPybZdtdi3eVv73ToAQPbmokuHuLPe90Ol62zW
         NRS2deZWPrxQv1PRENzzix4hwcDUDWbpmXu/vRgxpu8cKRgmfqDrMkcr3zgUoIsTQxzA
         DZPoREIGPTVOzj4mifN2qm1LVAGPDOwP/Zax1sC4tvlOa1aJf+UKSvEmXTSR66emON4i
         py3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+HM3pvSE2JuDZ5Kc5EJ0B/qyBhrrEM7iialxYUUhb/4=;
        b=rhc2qlCcpTe59EUv8un3p1oR5TcW5+bcmxzxw0MhRZKxri56BRJaz52Q7zsDzbkjxP
         AnqeVooPGYoD+qXSos8vKShbi53RnhtEOaCbTnkGeqe8Vypa7+DjdmsR6W9aPo7Raecu
         Y/Sui+KnVKY6Jeixta+JcYDahTgcIYfrF3AgnWJANj+j4m5qBUaOb8Fdcqtn9YG79/d4
         mirBB+WQ8BP63KNuqmyzzwfEzULJvv66BRKownZupbtkvk1yxCL1qHmBGDqro0dmcuHA
         o7jZdlZizKSHMIVpuMoiTQtWbUB5MY7TmLo3jszeZSqMoiDMpcApL5YRPlhs6fQJzG5m
         u6Zw==
X-Gm-Message-State: AOAM532aCwt3xGX4dV0Zd3fpkftvvjUkeP3ju6HgAsONd66O6WNDIleA
        qdjphPd5uvpDoXj6mDx7nSZsSg==
X-Google-Smtp-Source: ABdhPJwbBMcRBUwiHwlUcHEbNOIw3Cs4aimOxss5nWTLcWczRu9XuNDuEXKWUzgRyeMOs7MYyxlNxg==
X-Received: by 2002:a05:6000:d0:: with SMTP id q16mr33060169wrx.166.1594316759904;
        Thu, 09 Jul 2020 10:45:59 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:45:59 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Subject: [PATCH 01/24] scsi: aacraid: aachba: Repair two kerneldoc headers
Date:   Thu,  9 Jul 2020 18:45:33 +0100
Message-Id: <20200709174556.7651-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function headers for aac_get_config_status() and aac_get_containers()
have suffered bitrot where the documentation hasn't kept up with the API.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aacraid/aachba.c:358: warning: Function parameter or member 'dev' not described in 'aac_get_config_status'
 drivers/scsi/aacraid/aachba.c:358: warning: Function parameter or member 'commit_flag' not described in 'aac_get_config_status'
 drivers/scsi/aacraid/aachba.c:358: warning: Excess function parameter 'common' description in 'aac_get_config_status'
 drivers/scsi/aacraid/aachba.c:450: warning: Function parameter or member 'dev' not described in 'aac_get_containers'
 drivers/scsi/aacraid/aachba.c:450: warning: Excess function parameter 'common' description in 'aac_get_containers'

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aacraid/aachba.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 7ae1e545a255c..769af4ca9ca97 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -350,7 +350,8 @@ static inline int aac_valid_context(struct scsi_cmnd *scsicmd,
 
 /**
  *	aac_get_config_status	-	check the adapter configuration
- *	@common: adapter to query
+ *	@dev: aac driver data
+ *	@commit_flag: force sending CT_COMMIT_CONFIG
  *
  *	Query config status, and commit the configuration if needed.
  */
@@ -442,7 +443,7 @@ static void aac_expose_phy_device(struct scsi_cmnd *scsicmd)
 
 /**
  *	aac_get_containers	-	list containers
- *	@common: adapter to probe
+ *	@dev: aac driver data
  *
  *	Make a list of all containers on this controller
  */
-- 
2.25.1


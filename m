Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA70C43466
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96FDF2073A
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:02:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u90mu1uE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbgGMIAK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgGMIAK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:00:10 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F17AC08C5DD
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:10 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id o11so14775208wrv.9
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+HM3pvSE2JuDZ5Kc5EJ0B/qyBhrrEM7iialxYUUhb/4=;
        b=u90mu1uENJfv42WQrr4sPLX09MrjDa6vroB7o+MEKc0HVsOVjzzYhFRBmi4LomvAHJ
         19XJjQxmv/FGSKG4HiGnLg93xo/JlRpijQz94rqfPzTApnPD7Em6lAZKb93CaoNhvwKh
         vXyE70gCKUaQhtl0J7ye9p7SY6Bx1VsBj9pXMxkL+SPqPlvszcneSFaxPbMcX6fPTLb8
         4TM58j9gsBFH7mKR6xZewVmGNIeWsjiJdcpd5CBCkNn7+1PMIUu4pqLqSKsYqC2PpNln
         WVnPwiXP5f0o6E/sLPnCbFPKW4YulHfMnddz/bXDuTcKGhH1zbpqKVeF8cEcq+EulVwm
         zUVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+HM3pvSE2JuDZ5Kc5EJ0B/qyBhrrEM7iialxYUUhb/4=;
        b=Ls/idrxK71ZGkc5YAz/TcuppIazXKRwXbwLVJdIasvS1Y2NDuoj6F9X54EWo03MOer
         npHLlwVIJ0pNhW49awI9T9l80CUPILp0CeKufq+csHwwhoqt+2MvXWH4i94kuIeovjGX
         mxnrV4ar/3bYAcPFpvMI9PeA3/x1Nh9NH6rPIKJU2d7HvvwvbzkgXU2bxrG5JyK9+C57
         TANWSu4IV1w9Fwzp8Ak2SIvswV6tBy0hScBJPEsfd4faUTCZCBke78xiQqo7Sa1V8N8Q
         nlgcs0PGhXgUFc9FeKUv7C259rJasLwFulJJxVZANtGMM1HWNNcmTx+k1q2dVA8hWyC5
         SanQ==
X-Gm-Message-State: AOAM533NLmsdSg2PIONp9QpwWV0jS44MrVZ7clPSwxFLxPYkJkyH/xaH
        9lXBmW6X8RB4jBVSb2S+wDoLGQ==
X-Google-Smtp-Source: ABdhPJwq1WiUMeXrjichLdO4rSnqr9PqPnI9d1e3unEYlTcbaL8MMSizXuzJG4lfZkLLNgl4n3WlhQ==
X-Received: by 2002:a5d:4a01:: with SMTP id m1mr77435792wrq.250.1594627208654;
        Mon, 13 Jul 2020 01:00:08 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id 33sm24383549wri.16.2020.07.13.01.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 01:00:08 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Subject: [PATCH v2 01/24] scsi: aacraid: aachba: Repair two kerneldoc headers
Date:   Mon, 13 Jul 2020 08:59:38 +0100
Message-Id: <20200713080001.128044-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713080001.128044-1-lee.jones@linaro.org>
References: <20200713080001.128044-1-lee.jones@linaro.org>
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


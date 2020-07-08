Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CCD6C433E1
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4797E20772
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HcEJA8WD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgGHMDG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729199AbgGHMDF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:03:05 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32024C08E6DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:03:04 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id s10so48634748wrw.12
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oQ4WvRwPDFUcNrh06O2K9jOUxxfeZulaKjQ0ybDc5os=;
        b=HcEJA8WDl4WeJ2vXIx9y7tBCth1cotVU/SGVBEDKeoxBy/vHIVkUEVxUdRO0FHSzuR
         ibKIsFFbEhwKcXgsnSy5GbgBrKsb3JMgHrxW2eiAPh28qoXxbmBoNF6JAP3Qe3fZLW2c
         XSEoh/x0mVS5KNb/8Lu7uVYR8fx3X1830tDuS+dj0Tn7BXba7wJhtiX2qIyLLFZR3dwd
         /BBfXElqsVR1A/f5KJTzaJJE3SvCKvuYKRf/p58LaYkTV6MrdtawQiS6bgqW30VLM2Gt
         unrA4NE6cx7pEQkdDtUkkOSQVeJNjKUhnp20MnowWCLVVKURPzHppVzG1gQfciGp+VhC
         +l5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oQ4WvRwPDFUcNrh06O2K9jOUxxfeZulaKjQ0ybDc5os=;
        b=Q9saBBN+v/4GGtezrF1hjSy2sbgybyIHm8STdoNomIctSRpnAhUehFnONM+D4UQA1/
         15AB8dRLvmelqrCCkBHCqTVdAqvn4o1QlOfabKJPMdxW7Ozdq4TJjLfJKYeg2IUNrg0y
         DiYa73C6HXzVX9StR/nNjXBUYFw1P2ZDV5iiqWGdAiY4SegYUGCBu5jXOtVsXk8akOrz
         zDBiudGRjAunkzdc7BRKEy2OlYlLlk0IkIBNxV/I8JBVaVxPRe1uqfmnpN+667dPPrNU
         NJSbgARC9EjXU0ujGSi5FABjqb0unllZ3/PX4p7rqckTn6P0pfk5S+28oEedrP29Dndq
         eaNA==
X-Gm-Message-State: AOAM531uxFt7oBb4DkwbQ45p1+Nh/C0oIbUAQcgPgf8SsrZoTVx2cb9X
        4b/9YnP3PIbN/VkzJ2PzznmksQ==
X-Google-Smtp-Source: ABdhPJwVLbtlb7LCz9yj2ORin0ecR6yZcKzsnIjqiqxEm/K74D5PXILyHP5nAyq2AdzFCvfsEY1XSA==
X-Received: by 2002:adf:82e1:: with SMTP id 88mr37664379wrc.376.1594209782309;
        Wed, 08 Jul 2020 05:03:02 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:03:00 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Subject: [PATCH 25/30] scsi: aacraid: linit: Fix a couple of small kerneldoc issues
Date:   Wed,  8 Jul 2020 13:02:16 +0100
Message-Id: <20200708120221.3386672-26-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Most likely caused by bitrot (docs not keeping in sync with API).

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aacraid/linit.c: In function ‘aac_biosparm’:
 drivers/scsi/aacraid/linit.c:368:41: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
 drivers/scsi/aacraid/linit.c:243: warning: Function parameter or member 'shost' not described in 'aac_queuecommand'
 drivers/scsi/aacraid/linit.c:243: warning: Excess function parameter 'done' description in 'aac_queuecommand'
 drivers/scsi/aacraid/linit.c:1176: warning: Excess function parameter 'inode' description in 'aac_cfg_ioctl'

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aacraid/linit.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 734dd6e67246d..f043e378652c1 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -230,8 +230,8 @@ static struct aac_driver_ident aac_drivers[] = {
 
 /**
  *	aac_queuecommand	-	queue a SCSI command
+ *	@shost:		Scsi host to queue command on
  *	@cmd:		SCSI command to queue
- *	@done:		Function to call on command completion
  *
  *	Queues a command for execution by the associated Host Adapter.
  *
@@ -1160,7 +1160,6 @@ static int aac_cfg_open(struct inode *inode, struct file *file)
 
 /**
  *	aac_cfg_ioctl		-	AAC configuration request
- *	@inode: inode of device
  *	@file: file handle
  *	@cmd: ioctl command code
  *	@arg: argument
-- 
2.25.1


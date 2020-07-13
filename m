Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC524C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92ED820720
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:47:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bUcu1mtJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbgGMHrQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729375AbgGMHrP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:47:15 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B725DC061794
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:14 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id s10so14621526wrw.12
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oQ4WvRwPDFUcNrh06O2K9jOUxxfeZulaKjQ0ybDc5os=;
        b=bUcu1mtJaYXv0rh5cEHC/NbY4/26cuQSnsGFXLA/v1BBuA3R1qfK7CaKBSmp+NQQy3
         7md3AfU1fH0fr9k4TgyHrvcSh9ygvPY7leVg+ShqTC18ad+y7UCITOUYFtm2PQRp8AZU
         dhEQNC1q8PBtwArgX7Zd99DCkX75OybT13BC9bwj09cEKuQcIRHwjEGypxBq48DQBLec
         SaMxU+jhk2QGCyJNwiGMyiQNoFZJEXFp298UMjbXfBGxe2almnz231E8HarbSlo2QFRh
         pEwX0Z1AFLdFnKqQUxqmStTpHBCLMktPi0IYyXZLjkSJ6lm1oketJhhE/6Dd6fEQJsjq
         GJJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oQ4WvRwPDFUcNrh06O2K9jOUxxfeZulaKjQ0ybDc5os=;
        b=kyEpfeLBiaQ4bw83iq+baVecAmNqGqgXWfTVfraKDlQMZvbKNJz/muIq7hrvonJtGw
         sx/nSN6LvFvP3QvVcxcZizoLRQF4C0AipBjiB8aNy+Snhlv03ACje782c4hDqi0QGbcV
         Sms00sDHIiiNpcz0qf9D7/01Q+5LAjts3mgWykyHJH0IarOy7BHMXWDrxJEulhaWBRDE
         DQd/kW5kT+xPCk5aAbMOlBZP/mDtEqHo4o8RpJI7EPvtg5nZaGIUV2GreQGkePZVWCHK
         6/Ks+/Uc2NiqfZOk5R9CcClFYH5wFC7vd07RJXoQrR2tZw5d8Oz9FZZ+k7znNHYq7pla
         90LA==
X-Gm-Message-State: AOAM532iJ8h0iOEtTVPIKrmc7Ohh2qJFxXjFIdiBvDQy+nJ8G+7I0H82
        amH2TUgOugxNOssENcl48UZHCw==
X-Google-Smtp-Source: ABdhPJy6RpS9ZC9BVht0XLiAt356TcBAMpjPseMYjz3KUEjghzC5DOIW8//i2A6SUG+flGinxVVO2g==
X-Received: by 2002:a05:6000:86:: with SMTP id m6mr45539519wrx.173.1594626433513;
        Mon, 13 Jul 2020 00:47:13 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:47:12 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Subject: [PATCH v2 24/29] scsi: aacraid: linit: Fix a couple of small kerneldoc issues
Date:   Mon, 13 Jul 2020 08:46:40 +0100
Message-Id: <20200713074645.126138-25-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
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


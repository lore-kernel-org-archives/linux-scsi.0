Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E1EC433EC
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D437E2080D
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="U90SFM2X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgGWMZo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729139AbgGWMZl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:41 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFBCC0619E3
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:41 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id y3so4978952wrl.4
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e/a+n7xeT+4IypaMdZEOHPtxjDCXYhdWbia6WF8lJXM=;
        b=U90SFM2XfntMbbnKnpL8NIcPeMt35ipcq6Dn11/o5syJemNsgkTGwnAef33kj+uNTc
         DriqRPXhk78sPhGfpXjcZZS0kOou3ET6f+Fg46iKHmQFE6TldgHGr3BZLU39n7/6axET
         occ6OmfpC459wp/wuL3KZveW9siDSXs9DeDZDtxDAHdaPC+LA5Rk10BtDHusbCXXJD9N
         5wyAabHHnCEHOtiq7veQY85rYVYHMf6M384luLNiB4AwwZVbh7zSDXTXY0KmshygRX4v
         b7QeGD4rVWoFSZZ/zITPdb8scodvtQdKCCVCQxmRvSru02xmEIUJRWhbH7lMrRH800as
         zh2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e/a+n7xeT+4IypaMdZEOHPtxjDCXYhdWbia6WF8lJXM=;
        b=BmDNLFE2jywRgsG9AeC0s7MubJzwv0mDORCKvmiDEGqj2yFtup5vRnSKc4n4+cEFws
         TCX1yi7ol4mQQsC7dqdrsLM7Xp8je8iZozi2ZbqD2KqKTGGBumtOMQQtiobHItW1thIH
         hH535KqYEdBS+X8ybr14H9oj8YEJfFWEu1Yri/Qi8IhFYAV7OTnOJfj55hXv7TVQMqaT
         IOQyempvc5tNI4V28MKTuKTW5zsjATj0HGUy3PfgcISyp+svhvOPj0syzS87yPto8MK8
         xDlc+9GkexV4QGqkLum4bGeANuJoNvpiWNiqbHuzPBPYqqteOm5RoP64cULUZg2MhH11
         3CtQ==
X-Gm-Message-State: AOAM53145jeqPKtBZsBQqaCf6vXmsdIFriFfQ7WptRwdnNy+KwevllqK
        4w5YFTq4p3OvYEEfyzPQFNty4w==
X-Google-Smtp-Source: ABdhPJy4d9ZY4EAHaWXH/a0t/Z9kXHv2xcUkY8FSTT7ZehgX4cv+QGUBUbgxKGPINTm00P6AAbNzyA==
X-Received: by 2002:adf:e704:: with SMTP id c4mr4196356wrm.81.1595507139735;
        Thu, 23 Jul 2020 05:25:39 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:39 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Bradley Grove <linuxdrivers@attotech.com>
Subject: [PATCH 40/40] scsi: esas2r: esas2r_log: Demote a few non-conformant kerneldoc headers
Date:   Thu, 23 Jul 2020 13:24:46 +0100
Message-Id: <20200723122446.1329773-41-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/esas2r/esas2r_log.c:86: warning: Function parameter or member 'level' not described in 'translate_esas2r_event_level_to_kernel'
 drivers/scsi/esas2r/esas2r_log.c:120: warning: Function parameter or member 'level' not described in 'esas2r_log_master'
 drivers/scsi/esas2r/esas2r_log.c:120: warning: Function parameter or member 'dev' not described in 'esas2r_log_master'
 drivers/scsi/esas2r/esas2r_log.c:120: warning: Function parameter or member 'format' not described in 'esas2r_log_master'
 drivers/scsi/esas2r/esas2r_log.c:120: warning: Function parameter or member 'args' not described in 'esas2r_log_master'
 drivers/scsi/esas2r/esas2r_log.c:183: warning: Function parameter or member 'level' not described in 'esas2r_log'
 drivers/scsi/esas2r/esas2r_log.c:183: warning: Function parameter or member 'format' not described in 'esas2r_log'
 drivers/scsi/esas2r/esas2r_log.c:211: warning: Function parameter or member 'level' not described in 'esas2r_log_dev'
 drivers/scsi/esas2r/esas2r_log.c:211: warning: Function parameter or member 'dev' not described in 'esas2r_log_dev'
 drivers/scsi/esas2r/esas2r_log.c:211: warning: Function parameter or member 'format' not described in 'esas2r_log_dev'
 drivers/scsi/esas2r/esas2r_log.c:237: warning: Function parameter or member 'level' not described in 'esas2r_log_hexdump'
 drivers/scsi/esas2r/esas2r_log.c:237: warning: Function parameter or member 'buf' not described in 'esas2r_log_hexdump'
 drivers/scsi/esas2r/esas2r_log.c:237: warning: Function parameter or member 'len' not described in 'esas2r_log_hexdump'

Cc: Bradley Grove <linuxdrivers@attotech.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/esas2r/esas2r_log.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_log.c b/drivers/scsi/esas2r/esas2r_log.c
index 65fdf22b0ba9a..b545798e400c4 100644
--- a/drivers/scsi/esas2r/esas2r_log.c
+++ b/drivers/scsi/esas2r/esas2r_log.c
@@ -75,7 +75,7 @@ static char event_buffer[EVENT_LOG_BUFF_SIZE];
 /* A lock to protect the shared buffer used for formatting messages. */
 static DEFINE_SPINLOCK(event_buffer_lock);
 
-/**
+/*
  * translates an esas2r-defined logging event level to a kernel logging level.
  *
  * @param [in] level the esas2r-defined logging event level to translate
@@ -101,7 +101,7 @@ static const char *translate_esas2r_event_level_to_kernel(const long level)
 	}
 }
 
-/**
+/*
  * the master logging function.  this function will format the message as
  * outlined by the formatting string, the input device information and the
  * substitution arguments and output the resulting string to the system log.
@@ -170,7 +170,7 @@ static int esas2r_log_master(const long level,
 	return 0;
 }
 
-/**
+/*
  * formats and logs a message to the system log.
  *
  * @param [in] level  the event level of the message
@@ -193,7 +193,7 @@ int esas2r_log(const long level, const char *format, ...)
 	return retval;
 }
 
-/**
+/*
  * formats and logs a message to the system log.  this message will include
  * device information.
  *
@@ -221,7 +221,7 @@ int esas2r_log_dev(const long level,
 	return retval;
 }
 
-/**
+/*
  * formats and logs a message to the system log.  this message will include
  * device information.
  *
-- 
2.25.1


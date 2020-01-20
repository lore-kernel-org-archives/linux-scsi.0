Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1529C32771
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 19:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABC96217F4
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 19:00:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PgYpMeXt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgATTAw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 14:00:52 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46112 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgATTAv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2020 14:00:51 -0500
Received: by mail-ot1-f66.google.com with SMTP id r9so651627otp.13;
        Mon, 20 Jan 2020 11:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PDpQAF+i2pq2uHsVICQDd7TG2O7Wyb3VR4zR7cxgZZ4=;
        b=PgYpMeXtihwo3UHMOxBKlsQe4971PvToO4dB2O8HWjcXfBeadRdQP8crFLAWI+0PCQ
         o02RAX0zyIbXaAdopDWAKJyXJQR2vYqqaJd0A/Rf3bbGLs3/FYkMFAsqb8AxQKeVVVe8
         uBAE/jMhmnENlSb1cCQxZvs6FkloOy9uTWY12LNUPRioi1g10aVBc8utX4QuC/coPuxr
         qA+1VW6ttoiAvKLAenNTDP5Vz/KbxHjr3wC4S74iuzEypKQJIqWRdNAiZJ2tFuYCOcpm
         JydHWn0HCmXBtNKBdyT31Y9DJ+TT6zXWMStdzNskgLJTtqb1EmaNVAZDZD1lXFQ+v3Ne
         LpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PDpQAF+i2pq2uHsVICQDd7TG2O7Wyb3VR4zR7cxgZZ4=;
        b=nWVJF9L91U2pVbtYlp7XzvU2NJD3Jte/JEp8WKwPU2RstuvnmsRPn9EW6FeMxAGXmk
         MhxLlVdqiZHF88E5ZcQSENuZT+4ZyYzrP0e/nGbAPJBW5f8QQ6znwkNkgFHY1i6JZuy5
         j+a1BmFlpimWkDmyCUAt8TPBErQiayXRrLmNiFuxodsz+92VSgsNJchwZf+cwtkUJh9S
         G93IINsZbPa8qOvNHgHr9V9caj2EhVN5/B1d4tDqA2HgYpZkIDZEy4E2Ipa5HO0cBIyG
         MFCMtcIX0UmfzwzvcDH/FXeUwJ7Qp1E1rOr5lJMu3BSRs7QQRDzF26YSbvYumGx31ksu
         2ZVQ==
X-Gm-Message-State: APjAAAWKV6IXUoGXQnwFzyzy7LnUtX7xrOisc1HH6kgR3rPxJeX7pITF
        Eli+dooWdAlG1Kp/6EqO+V4=
X-Google-Smtp-Source: APXvYqxxGUypQRdE6ZNJl9t7UwurrtKJL2Fgml/ADb4BkoE3IFa3lbxtMrMqIvSjt9gGAfKpMuu2RQ==
X-Received: by 2002:a9d:7b4a:: with SMTP id f10mr747171oto.4.1579546850655;
        Mon, 20 Jan 2020 11:00:50 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id i20sm12641352otp.14.2020.01.20.11.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 11:00:50 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Michael Reed <mdr@sgi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] scsi: qla1280: Fix a use of QLA_64BIT_PTR
Date:   Mon, 20 Jan 2020 12:00:21 -0700
Message-Id: <20200120190021.26460-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Clang warns:

../drivers/scsi/qla1280.c:1702:5: warning: 'QLA_64BIT_PTR' is not
defined, evaluates to 0 [-Wundef]
if QLA_64BIT_PTR
    ^
1 warning generated.

The rest of this driver uses #ifdef QLA_64BIT_PTR, do the same thing at
this site to remove this warning.

Fixes: ba304e5b4498 ("scsi: qla1280: Fix dma firmware download, if dma address is 64bit")
Link: https://github.com/ClangBuiltLinux/linux/issues/843
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/scsi/qla1280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 607cbddcdd14..3337cd341d21 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1699,7 +1699,7 @@ qla1280_load_firmware_pio(struct scsi_qla_host *ha)
 	return err;
 }
 
-#if QLA_64BIT_PTR
+#ifdef QLA_64BIT_PTR
 #define LOAD_CMD	MBC_LOAD_RAM_A64_ROM
 #define DUMP_CMD	MBC_DUMP_RAM_A64_ROM
 #define CMD_ARGS	(BIT_7 | BIT_6 | BIT_4 | BIT_3 | BIT_2 | BIT_1 | BIT_0)
-- 
2.25.0


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1CC9C433DB
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 15:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7335123A04
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 15:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbhAIP5t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Jan 2021 10:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbhAIP5s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jan 2021 10:57:48 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6374EC061786;
        Sat,  9 Jan 2021 07:57:08 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id t30so11920416wrb.0;
        Sat, 09 Jan 2021 07:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4HHQ9RGvj6Z9FZXDkRGAkIAp92S56tPsxAgDh/4OaCc=;
        b=u/sYmc5c/Cu8NO4mrleoXIANn1/0yWcpS5qVSuu9Ej40Pg6cIb1W2VHcLIVSdoCM6+
         092goA2x2vIMKwi5Ke5VYmmG1GErTTCvTzbEfpYmZBw4jtkaelBK82s76kGcemq31HOA
         xfqL7O2GggO3X/Ddxew5rZQWgIubw+JiMPgcApNTL6KGhsV4T6KP0ofhksy5GlO29DSX
         3x8b9IwI+DBc3+WIhiMmrbwg3efHOI6dZAB6maG8BDBVlsKpLv9P1C5z6mpef39lCJis
         0mv4jFNZirOzb331PwKpD4f0JkL7vaf2PnqQsVwR8hEhsXQFFi6ewCYBqwVzo15sxcHx
         QYwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4HHQ9RGvj6Z9FZXDkRGAkIAp92S56tPsxAgDh/4OaCc=;
        b=bVbNa+kkp/3isdgMGG1VhEBaK3l9RhX679qN1hq+PmWVXVQW4LVewz8i8oPrwzk1QH
         sim7m4LovsCBERMWFnqd57AjomJl4NRPr/AeVKqhjs5T+uhhlz9KwvqQe3NX9/xWq7lT
         IQ3U9vJv2ph506vIpU+9Sx8KmEwsFtjsWQcDcRdIX0+VaFwNnNpeFGIsxlhXmQ2dtyTC
         hTiy33iQnYV/yD7bULfgGYGnePLJHOMfNvUjrHWcpK6ZmOpdkJQu7MvTMtoe1b2GCW7h
         mwISWkVyBC9k70L/87NfmX6A5B2p17NwY+iAvnL/w3Rq2hdxVkag39UR0jNRx54brIuA
         uu7A==
X-Gm-Message-State: AOAM532MS4HNYR8bD3unNJ41EGQIgtVCpIYzC6FxQSzBrfQM6obJ3oL+
        3uIYupty3eR4xRA5kYOwVNQ=
X-Google-Smtp-Source: ABdhPJzu3MTQCx9PGGHDjGtBcArNIBFP5vEbHEdINlX+Fuik0EPOehbsiOXBuocEkmu9WGSU1L04IA==
X-Received: by 2002:a5d:56c3:: with SMTP id m3mr8671869wrw.419.1610207827145;
        Sat, 09 Jan 2021 07:57:07 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id g78sm15563568wme.33.2021.01.09.07.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 07:57:06 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] target/file: don't zero iter before iov_iter_bvec
Date:   Sat,  9 Jan 2021 15:53:27 +0000
Message-Id: <34cd22d6cec046e3adf402accb1453cc255b9042.1610207523.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iov_iter_bvec() initialises iterators well, no need to pre-zero it
beforehand as done in fd_execute_rw_aio(). Compilers can't optimise it
out and generate extra code for that (confirmed with assembly).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/target/target_core_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index cce455929778..5a66854def95 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -267,7 +267,7 @@ fd_execute_rw_aio(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	struct fd_dev *fd_dev = FD_DEV(dev);
 	struct file *file = fd_dev->fd_file;
 	struct target_core_file_cmd *aio_cmd;
-	struct iov_iter iter = {};
+	struct iov_iter iter;
 	struct scatterlist *sg;
 	ssize_t len = 0;
 	int ret = 0, i;
-- 
2.24.0


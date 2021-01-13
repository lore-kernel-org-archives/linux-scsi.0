Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 377DBC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 02:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E97B72310F
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 02:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbhAMCZd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 21:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727623AbhAMCZd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 21:25:33 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FC8C061786
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2021 18:24:46 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id c132so519378pga.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2021 18:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ZLtice1nArt7jeoxDX0NGpwcyWaGkm1EOKCNYIGZC4Q=;
        b=EMd7F0+P3snbFhURV79sqR8NlInubcXcgrTCD0GIvwkVTOeVx/7A+D3Afq5TdawQ+i
         lSXI2sOX130bcryb+K0ckT9WpOewZqB+znP3RzCTBlKlGPVvlfIhuWknKlLXYP7k/drD
         YugwgJXlxgXlZKL1KWqpVEegNzNviCZQS4k29y3ApDv339yAgVjpZuDZZoUfBAqBxxf0
         55e4F+hOB5wS3DS9QCQ1qCTj6LhGElTHRAWhIB2/t808vqPi1XOYNheJlonnOOpKMtZT
         hLSd8OdmDryS2nRhYdVvI8PnG7FnyiR4KsKRuUl9tHvKBVDCjocIpDwItccSdN87X6Sv
         YyFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ZLtice1nArt7jeoxDX0NGpwcyWaGkm1EOKCNYIGZC4Q=;
        b=iMeSsFrr5rfngL/qraGGzwK9+cFoeZOXgs+G++iUBs4XtzFzVN+0CycxfzPPy5Y9fr
         brNaHhKaV8ZkxFm6VzPVfczwKk4VLYuAO40tSsHzHgdRTARVPvHWrYuYrQ9fOqM8xp1R
         001Uvom87VljRRUd0UbCx3vovaPu+vQgmENaFuDzoQzjreL069iDeeFNs4zyhlAgVuI3
         JWgIwhDfz5E0za8r3ikQ7ZsY89a/u6/234bGFDaUSkPwgZ6UYSGoXtuEULS7dv5mR41h
         jNBNlZ+3kZpR/dy+tN4b+hrtwMqoF7wj7U00l1Y1vYYpYeFKj17Hl3lm9ycfy0GuBk//
         aoVA==
X-Gm-Message-State: AOAM532z3quyt5xzcn6I89ERnaeiz8wBY5zXF73KwHDYWyl0pn09Y8of
        tUo9FzO8QWGUSdI+7dZl5sRuasfV6TiviPFpMVb7CGbhNHkIPw==
X-Google-Smtp-Source: ABdhPJwfJ7yP+7vV86l6Sa01qKKVVtAtdXqsIYigoQfOFWJ1KFSZrZm26XPzfoDNfYuQUW46vkUVjzfk7rB/aSuQCXI=
X-Received: by 2002:aa7:9ab7:0:b029:19d:ac89:39aa with SMTP id
 x23-20020aa79ab70000b029019dac8939aamr2299019pfi.10.1610504686305; Tue, 12
 Jan 2021 18:24:46 -0800 (PST)
MIME-Version: 1.0
From:   Patrick Strateman <patrick.strateman@gmail.com>
Date:   Tue, 12 Jan 2021 21:24:35 -0500
Message-ID: <CA+-=Uwah2MS_aD+PeSBkQa_=1wCD+3=g6W4PvLnbJ_-px8G97g@mail.gmail.com>
Subject: [PATCH] st: reject MTIOCTOP mt_count values out of range for the
 SPACE(6) scsi command
To:     linux-scsi@vger.kernel.org
Cc:     =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Values greater than 0x7FFFFF do not fit in the 24 bit big endian two's
complement integer for the underlying scsi SPACE(6) command.

Signed-off-by: Patrick Strateman <patrick.strateman@gmail.com>
---
 drivers/scsi/st.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 43f7624508a9..190fa678d149 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2719,6 +2719,22 @@ static int st_int_ioctl(struct scsi_tape *STp,
unsigned int cmd_in, unsigned lon
     blkno = STps->drv_block;
     at_sm = STps->at_sm;

+    switch (cmd_in) {
+    case MTFSFM:
+    case MTFSF:
+    case MTBSFM:
+    case MTBSF:
+    case MTFSR:
+    case MTBSR:
+    case MTFSS:
+    case MTBSS:
+        // count field for SPACE(6) is a 24 bit big endian two's
complement integer
+        if (arg > 0x7FFFFF) {
+            st_printk(ST_DEB_MSG, STp, "Cannot space more than
0x7FFFFF units.\n");
+            return (-EINVAL);
+        }
+    }
+
     memset(cmd, 0, MAX_COMMAND_SIZE);
     switch (cmd_in) {
     case MTFSFM:

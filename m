Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73633C71153
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Aug 2023 21:46:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbjH2Vpm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Aug 2023 17:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234473AbjH2Vp1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2023 17:45:27 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D517D7;
        Tue, 29 Aug 2023 14:45:24 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id 5614622812f47-3a9b342c398so3136609b6e.3;
        Tue, 29 Aug 2023 14:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693345523; x=1693950323; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M17+48+v4XZJYcb7OmaQ1jozg48HxT2IrHI5UpNpAOU=;
        b=nHc36x1zF/wzqlBiRTpsptfvvLK/duwOaOlrIgBb2xY0AjzgwL3yqoM2l1lbFlRtfF
         5U5rrbZd45PanzZ7vt6xfhZKpHyLOhgSFRiIeiOJ2zBz/s6ScnG2POQNeqLS7GP4zc9x
         KGYSYVcwBB4h7EOpHvWr2P9s2tm82tOITt0KXJp59MX9mQEI/2pdx13Y9r7YDi2FLR3I
         +x9v3LURxWkI/Znese0OrgZfcLSXfdH/T05S8qaAL81+leKz5iTqAgcxWZSNxJIFTSjL
         sCVrczF0lCa3gJW+FfgL0a6xS52GlhmEFZsk+ZvHXr9jghtOdBYn6P8i4ZkAzftY2XT/
         Sbqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693345523; x=1693950323;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M17+48+v4XZJYcb7OmaQ1jozg48HxT2IrHI5UpNpAOU=;
        b=MB+eLXlJhNu4gqJUt6d8ZC4ub0RThMhjZq1JZu4CI9wUMH6gGSrqVQUXWWKSJtg4wz
         gOHpQFP3lVJ0S1Geo9BIrn8dZCQXEmMNfkNfh2R0ysUQzVOW1MaMjIsHQlXa9vZRBK+u
         sj8ySyeyISX+RC7JsRQVb+SqM0QDzm3CByco5M0kcZbcfMuGVEBB8lkzmzyP900Jzb48
         rnxo8GhScxdGavCpJnuCv4437DSd97iy5gvSlwqTkohu0XQjI/oflA8oeTWwZQgcCFCS
         3KXJTUOcNP+Fjj32ik4lewL9d6QDqxw/ovJzTmDOmWzEZgAHAndvrDBP7v4eImtlTvLV
         TQhw==
X-Gm-Message-State: AOJu0YwMq1ZdPjXSBg5DKu9c2eJlcqCHGSvXu2AUAeIHl9R1fOFnBds1
        0ljV3X8CuOD2yFzoNL3JSVg=
X-Google-Smtp-Source: AGHT+IH2ZqAVMjOU3KX2Kveo5EIDpAucPdgmJmzR+rxw/ln1iPvV89dXQ1x4KB2v2EcLIlbwjTx6lQ==
X-Received: by 2002:a05:6808:238f:b0:3a1:e85f:33ee with SMTP id bp15-20020a056808238f00b003a1e85f33eemr425520oib.56.1693345523635;
        Tue, 29 Aug 2023 14:45:23 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (125-236-136-221-fibre.sparkbb.co.nz. [125.236.136.221])
        by smtp.gmail.com with ESMTPSA id y14-20020a63b50e000000b00563590be25esm9374129pge.29.2023.08.29.14.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 14:45:23 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 74F9B360439; Wed, 30 Aug 2023 09:45:19 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     linux-m68k@vger.kernel.org, geert@linux-m68k.org, arnd@arndb.de,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH] scsi: gvp11: add module parameter for DMA transfer bit mask
Date:   Wed, 30 Aug 2023 09:45:17 +1200
Message-Id: <20230829214517.14448-1-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit bfaa4a0ce1bb ("scsi: gvp11: Remove unused gvp11_setup()
function") removed the unused gvp11_setup() which had allowed
to override the default DMA transfer mask defined for GVP II
SCSI boards on Amiga. There now is no way to set a non-default
DMA mask on these boards.

Introduce a module parameter to allow users to override the
default DMA mask for the gvp11 driver.

Fixes: bfaa4a0ce1bb ("scsi: gvp11: Remove unused gvp11_setup() function")
Link: https://lore.kernel.org/r/20230810141947.1236730-12-arnd@kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
---
 drivers/scsi/gvp11.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 0420bfe9bd42..12160d70a571 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -50,6 +50,9 @@ static irqreturn_t gvp11_intr(int irq, void *data)
 
 static int gvp11_xfer_mask = 0;
 
+module_param(gvp11_xfer_mask,  int, 0444);
+MODULE_PARM_DESC(gvp11_xfer_mask, "DMA mask (0xff000000 == 24 bit DMA)");
+
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
 	struct scsi_pointer *scsi_pointer = WD33C93_scsi_pointer(cmd);
-- 
2.17.1


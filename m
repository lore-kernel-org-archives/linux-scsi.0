Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D60C48BE8
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 23:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4A9960FE7
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 23:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbhFRXRq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 19:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbhFRXRp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2021 19:17:45 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B5AC061574
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jun 2021 16:15:34 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id n12so352838pgs.13
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jun 2021 16:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qBhWFSDC/pGq6lffGacYxIQ2MA2iKJixy0K9unDji68=;
        b=a2hc7nccDIhHlM1QVgAzhHIQUyflxy4OHHmG0Iej4GxegyHZdBtrzEZCQot5Ejf+R8
         MAL9n/al5iwS7afQfZ6B2qNOBhrchddgSl1Y3+55YH36ECgotOkEKYrOKR49wstkcGZH
         /RlXr807Ufo/FRW3dbbLr+M6yo1lphgL4CgdjU0V32flUuKoLctiusJ5dNKODhGE/bZU
         aKtsVSZuwUqV9y4tEj+9K9mt+iuWhXvkJ8Jr6MJ3sYQCDSoF0/+KOcJTEbJ9/lmKwLAZ
         LS/uAf0JNzimJwGYhycYDvaDM4mLdEAliUaf7eKHUqb2HntS/MJ2HCxqL7063Elkfs/C
         ehvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qBhWFSDC/pGq6lffGacYxIQ2MA2iKJixy0K9unDji68=;
        b=Q/Ai7obRoPEaFMMt6Yl7OnHP9Mw25r9+iIAfLbZbGAULFPZi2Q3tMN8IsA9lBo5nEr
         Rsh8v6V47mxSxU3HDVMFWzkcOFpQozIdtne207/26QL9ctSehCqQAgGSb3JHnVk1YI17
         S+By8aBr38kUrlK8FgksS7y+Rq40Of4iD98pi1U6XXjZ2L68iNWQMr+o/a7Uadv7sZYG
         8pG9xd1tL0nal4CYA7+sN7H0o1GS9gN9JBuZlSQ8u+P1hyPhizscq6hDr3NTU9kYWBBw
         k8UFslRNcwUHSQ05cTQm3s96P5MSG8vfI4cKzH/Foc4ogBit3pHI7koRKOLSMpgFjwsb
         lVbg==
X-Gm-Message-State: AOAM532meiTUAgEgI7diyR+KDczcguD4uMdiT+UCFFURY0YDuxIXmSQL
        0R46+mY8ozPKJ0uvZitJ/JDI5cQLMPE=
X-Google-Smtp-Source: ABdhPJzL6r0vtqwDebNocck/4/yDOC2sl9en+sExEQv97wtfZwuBLL/mlQwzp9GYDsRzWW399tUvSg==
X-Received: by 2002:a63:f047:: with SMTP id s7mr12092635pgj.272.1624058133848;
        Fri, 18 Jun 2021 16:15:33 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u1sm10050072pgh.80.2021.06.18.16.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 16:15:33 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     ram.vegesna@broadcom.com, dan.carpenter@oracle.com,
        James Smart <jsmart2021@gmail.com>
Subject: [PATCH] elx: efct: fix is_originator return code type
Date:   Fri, 18 Jun 2021 16:15:24 -0700
Message-Id: <20210618231524.83179-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

efct_hw_iotype_is_originator is returning a negative (-EIO) status which
doesn't make sense for a u8 function type.

Reviewing the code, the function only needs to return true/false, thus a
bool status is most appropriate.

Change the function return type and patch up the one callee as the bool
inverses the if check.

Fixes: 4df84e846624 ("scsi: elx: efct: Driver initialization routines")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/efct/efct_hw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index ce4736c41564..0d86c2b81f46 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -338,14 +338,14 @@ efct_hw_init_free_io(struct efct_hw_io *io)
 	io->wq = NULL;
 }
 
-static u8 efct_hw_iotype_is_originator(u16 io_type)
+static bool efct_hw_iotype_is_originator(u16 io_type)
 {
 	switch (io_type) {
 	case EFCT_HW_FC_CT:
 	case EFCT_HW_ELS_REQ:
-		return 0;
+		return true;
 	default:
-		return -EIO;
+		return false;
 	}
 }
 
@@ -408,7 +408,7 @@ efct_hw_wq_process_io(void *arg, u8 *cqe, int status)
 		 * If we're not an originator IO, and XB is set, then issue
 		 * abort for the IO from within the HW
 		 */
-		if ((!efct_hw_iotype_is_originator(io->type)) &&
+		if (efct_hw_iotype_is_originator(io->type) &&
 		    wcqe->flags & SLI4_WCQE_XB) {
 			int rc;
 
-- 
2.26.2


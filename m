Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5059BC43603
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 01:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 252F1206EC
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 01:47:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ejtmUYb4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbfLRBrc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 20:47:32 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35439 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfLRBrb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2019 20:47:31 -0500
Received: by mail-ot1-f68.google.com with SMTP id f71so358798otf.2;
        Tue, 17 Dec 2019 17:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fK7652sfa7E29q2xM3IFKXXWsa6prHuIfKMbUEKFJ90=;
        b=ejtmUYb4OU/fbQQWxkWWCGczZmjyD5jlerT2WiBX6aKrp1H+ay/3LyzTGll5chaLhj
         3pgXMWvaOa2He8yrR9fj6dEpWiljxo2CYQTgZRfbk3MbuJUNYIAk5sL5yIjh1pVLLQ4B
         6G2wd95EwoeMVp9MRAfzTNqu7R6iamaGG2K8ESaAK3qgrbEVN1CAD+G15OkbDOBloSYP
         Shviw/BJ47Gdjpgo9fwM64MzXRznYIKDtRPPfebstXppeVCy10H2hdSJev/OkKLflJZm
         attquMR3nhCKsnwGBg73JYNgLuE/nt1DHaR4CJZTSx8ac4raWn6jHetypRKIWlMmmmNO
         TGlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fK7652sfa7E29q2xM3IFKXXWsa6prHuIfKMbUEKFJ90=;
        b=osYRf/3EWenCR7DiO98q+zO5DAy4E9lNi97NtoU2hY84TTJZbC7o4KsUsLk4b5IysH
         VRxfYtLjhZc9uQBPX1odBWLhnxFiN9xXd1FiieBgKykxJhuiTBFltqUI5Blk5GEIL0v0
         qTHJQaRPUsKyFMexjzbyt6xyAOJxCWmrwCejfm2bstnWWJNtaikS4QhBRPJuIlB50DAd
         AjGDCi+ys17bmqXL87baviA8bgxxsfaWDS1Lyv9EQ1WlIqFa8QnK2Nxr8yRI+0pfMaMW
         tRAhIIgD7LDlQrAhGgGqTlnPrNglmqj1FihwxITNuA2hTGnmUyjedApDcnkSAEJQwA4h
         i3cw==
X-Gm-Message-State: APjAAAVp+Ah5acyA/LlPIFn2E4qxHA74oCflvbpmAoG+C7bhNtHlL6Ge
        jdFjWUuSkkuLx49qPZiQu60=
X-Google-Smtp-Source: APXvYqzTKnBpHOzeVNBHDCs5lMGd8//DgIxwXoSBSwnQhZyZpV0Z/t5jxg40ZDwIMXtsUB50yhoFVw==
X-Received: by 2002:a9d:7495:: with SMTP id t21mr335119otk.86.1576633650807;
        Tue, 17 Dec 2019 17:47:30 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id z12sm237462oti.22.2019.12.17.17.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 17:47:30 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] scsi: csiostor: Adjust indentation in csio_device_reset
Date:   Tue, 17 Dec 2019 18:47:26 -0700
Message-Id: <20191218014726.8455-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Clang warns:

../drivers/scsi/csiostor/csio_scsi.c:1386:3: warning: misleading
indentation; statement is not part of the previous 'if'
[-Wmisleading-indentation]
         csio_lnodes_exit(hw, 1);
         ^
../drivers/scsi/csiostor/csio_scsi.c:1382:2: note: previous statement is
here
        if (*buf != '1')
        ^
1 warning generated.

This warning occurs because there is a space after the tab on this line.
Remove it so that the indentation is consistent with the Linux kernel
coding style and clang no longer warns.

Fixes: a3667aaed569 ("[SCSI] csiostor: Chelsio FCoE offload driver")
Link: https://github.com/ClangBuiltLinux/linux/issues/818
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/scsi/csiostor/csio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 469d0bc9f5fe..00cf33573136 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1383,7 +1383,7 @@ csio_device_reset(struct device *dev,
 		return -EINVAL;
 
 	/* Delete NPIV lnodes */
-	 csio_lnodes_exit(hw, 1);
+	csio_lnodes_exit(hw, 1);
 
 	/* Block upper IOs */
 	csio_lnodes_block_request(hw);
-- 
2.24.1


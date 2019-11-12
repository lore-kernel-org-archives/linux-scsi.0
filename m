Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 375B6C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 22:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F1A121A49
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 22:35:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fa3Zj2A5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfKLWfX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 17:35:23 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46811 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbfKLWfX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 17:35:23 -0500
Received: by mail-wr1-f67.google.com with SMTP id b3so41918wrs.13;
        Tue, 12 Nov 2019 14:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=267YKYgyio7TvNsDEgQVQTzsRypxQUBUtaiCGWnT0yA=;
        b=fa3Zj2A5ic679JdA2Tr29Cc2fg3g1pHkGbNkvmPMS1fxjQMCYZxdTwEF9CJRRsVd0K
         +V4Qj+yiS/XLZNVpyfcWhD0ra2J5SdNzUjhm20QZG2KBlsct9aXecmLy2/dfykmInM5z
         OpD53d3XZuBhYPBB6sYZQIRnwdEKyjNX8Ik2RKT6BneYj3fRnCjalhw5jr0gTmw5sfaq
         WVedFJljG+j2qHa61969Etf9aMuAehleXpba6n6Szeb/wBBc/l4fC2ZOSWuaWGPwEFzC
         oBekCQBSvs3mJAG3u2wEAbE5JWfwxO8ypifu+QoQ0Kdud4WwBW/m5RcHvJt1/bqq5kfF
         4nXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=267YKYgyio7TvNsDEgQVQTzsRypxQUBUtaiCGWnT0yA=;
        b=GmK2DWEd3VZ7ZQQ6l2WocXIHZULGyg4kCv67ub+d7IACEaxjHdtZsTQncUUHmH+Cy1
         doaJrt14ZFh0X2u1IxmQ5f4pBuHoKeh3CJQMxSLbMN0B8sR8g9E+IUkPGFJ85c+af9Rx
         nqJcpG7FW3cBJ5hav4Kv2Ll+yabDKQgP5ncbX/ZBegQbA2yyd5AueR8kdkzDA4Mz37wQ
         JUMfZ5RKNqjajzWyZpzojgv0iUeAe/M2dWqWoWty03LUHplR6OfmSMCldwraxxgEB6a2
         LX/X92FuJ4u55Ck1pLbR3qqBXBKhd5T0Qz3iKI+M9NBYYqaPz45/wO0Zx2e8W6Iv1FjU
         LAlw==
X-Gm-Message-State: APjAAAUsNoYw31u9Fa1/Llqea9mQZ7TYHKCd47xJ7ssGAfCE5l57vgXq
        P5NmEevmOfp1s1o3pNRZpmA=
X-Google-Smtp-Source: APXvYqxL8zTIaeKSQxAAgs6j2sCP3b9FQqqoJcyEDr7Cb7A7vUWv3xINyoXrNeldhmp+rEEcrwni0g==
X-Received: by 2002:adf:f490:: with SMTP id l16mr28109225wro.77.1573598121326;
        Tue, 12 Nov 2019 14:35:21 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfdef.dynamic.kabel-deutschland.de. [95.91.253.239])
        by smtp.gmail.com with ESMTPSA id d20sm584356wra.4.2019.11.12.14.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 14:35:20 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        pedrom.sousa@synopsys.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] scsi: ufs: print helpful hint when response size exceed buffer size
Date:   Tue, 12 Nov 2019 23:34:35 +0100
Message-Id: <20191112223436.27449-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191112223436.27449-1-huobean@gmail.com>
References: <20191112223436.27449-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Print out returned response size and buffer size, while the front one
is bigger than the back one.

Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9cbe3b45cf1c..527bd3b4f834 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1938,8 +1938,8 @@ int ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 			memcpy(hba->dev_cmd.query.descriptor, descp, resp_len);
 		} else {
 			dev_warn(hba->dev,
-				"%s: Response size is bigger than buffer",
-				__func__);
+				 "%s: rsp size %d is bigger than buffer size %d",
+				 __func__, resp_len, buf_len);
 			return -EINVAL;
 		}
 	}
@@ -5864,7 +5864,9 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 			memcpy(desc_buff, descp, resp_len);
 			*buff_len = resp_len;
 		} else {
-			dev_warn(hba->dev, "rsp size is bigger than buffer");
+			dev_warn(hba->dev,
+				 "%s: rsp size %d is bigger than buffer size %d",
+				 __func__, resp_len, *buff_len);
 			*buff_len = 0;
 			err = -EINVAL;
 		}
-- 
2.17.1


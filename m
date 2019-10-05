Return-Path: <SRS0=qHo0=X6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B91FEC47404
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Oct 2019 07:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D1D2222C0
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Oct 2019 07:56:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ri3WTsPp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbfJEH4F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Oct 2019 03:56:05 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45186 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfJEH4F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Oct 2019 03:56:05 -0400
Received: by mail-pl1-f194.google.com with SMTP id u12so4224739pls.12
        for <linux-scsi@vger.kernel.org>; Sat, 05 Oct 2019 00:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IQ6+F9XQNmIkqfflKyzKzZ34SfBhOGzml56NDDvgJgE=;
        b=Ri3WTsPpoqycddA9NOIWXbB98XPi8NpP0Jf0744u4QcKozqEDdj2nKfwfwtffyqgQf
         ZecFtvDDKq3xDJQhmZbnTAMwtfDjQXUrkYwMR1EQ3C3n9hzBIdrpQ2KLuG5PEei4+tso
         9m5+S7dq7APvEEMy8nbPsyg1XUpSiP08ogXtoTxm8FlnC68TJnkgz/GwtwvrPsLXNeVh
         0dIfUUxka9H+b6cLBjwYdPFeypjSU0vAP2Oq08bYF/CHD4njzFn7qBT7xVegvdVnNbQb
         TiCgSQkTI0dj+cCNGBu2CAvS3RM9Wm2eLzvtl3XyweJcDWpHUNnNKiSzAZKsfCYLr5Ih
         UcpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IQ6+F9XQNmIkqfflKyzKzZ34SfBhOGzml56NDDvgJgE=;
        b=fzqyNBuTY957QWc6WN/j8bVy6HLBNgcu+wT+TyzR8c0vcV73dhGSP6GrZsf9LVpKiM
         x7PSLYo2zo43Go2u7pETQqjDrnbrWhP6kGfGP39DEHgnMo7uOGmGkD5gioD1r+sCglqx
         6CIP6ZmTLWfwxNRBYTuNbTF79PAX6zIATmn5D37Coruhq4rr88Az1Magk7vRD2qge1SB
         MfTlybERIR8eeCtLzezPcczUagnWWTFnrzeiJ+LhJB6FqzyTI2nDf978p1CVK1K5X8Vu
         hr12J/5YUCBsaBweK3ApFjQuF8ZArb0lG5yJeWxhxsYK8PV8Kn0ub88R0P7nE0oXxLkI
         0EcQ==
X-Gm-Message-State: APjAAAXbE9yVluhpgPkFZ+f1ESYCgeerNwRj3yJT0qW+kbje8Ks4OlKO
        fmTuMP4jWVxAJz5MvvnPQnU=
X-Google-Smtp-Source: APXvYqyeOL2A7pYQ+vDCptua92lhuBvWsO9GbwRhyf/AbEfCH4cgPGRQy4PNVweGw826H4i/PR9YXA==
X-Received: by 2002:a17:902:a706:: with SMTP id w6mr19297687plq.138.1570262164920;
        Sat, 05 Oct 2019 00:56:04 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1950:559a:117f:4889:e0ff:3af])
        by smtp.gmail.com with ESMTPSA id 14sm9673099pfn.21.2019.10.05.00.56.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 00:56:04 -0700 (PDT)
From:   aliasgar.surti500@gmail.com
To:     QLogic-Storage-Upstream@qlogic.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     Aliasgar Surti <aliasgar.surti500@gmail.com>
Subject: [PATCH] drivers:scsi:bnx2fc: removed unnecessary semicolon
Date:   Sat,  5 Oct 2019 13:25:51 +0530
Message-Id: <20191005075551.25209-1-aliasgar.surti500@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Aliasgar Surti <aliasgar.surti500@gmail.com>

There is use of unneeded semicolon on multiple places in
single file. Removed the same.

Signed-off-by: Aliasgar Surti <aliasgar.surti500@gmail.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index b4bfab5edf8f..ffb59df6a69b 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -942,7 +942,7 @@ static void bnx2fc_indicate_netevent(void *context, unsigned long event,
 				 */
 				if (interface->enabled)
 					fcoe_ctlr_link_up(ctlr);
-			};
+			}
 		} else if (fcoe_ctlr_link_down(ctlr)) {
 			switch (cdev->enabled) {
 			case FCOE_CTLR_DISABLED:
@@ -962,7 +962,7 @@ static void bnx2fc_indicate_netevent(void *context, unsigned long event,
 				put_cpu();
 				fcoe_clean_pending_queue(lport);
 				wait_for_upload = 1;
-			};
+			}
 		}
 	}
 	mutex_unlock(&bnx2fc_dev_lock);
-- 
2.17.1


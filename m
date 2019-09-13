Return-Path: <SRS0=Er8N=XI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52645C4CEC7
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23EF8206BB
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cTFoWxn3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387795AbfIMNFI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Sep 2019 09:05:08 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41147 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387533AbfIMNFI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2019 09:05:08 -0400
Received: by mail-pg1-f193.google.com with SMTP id x15so15227066pgg.8
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2019 06:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uZ0ryVDhFnGzLZcrMR5qrWRgUAYTaxLSApMq9rjkF/Y=;
        b=cTFoWxn3J6s52d1shTziQJPn3dgAqxdUZaoORlOsQe2zk3qw22b9wEiP7J9uqyCqKl
         8zXHeAmmfQI5br1IRR/LxcXsUM58/Zg2EpO/f9PLNqILgf0wDb+NudiYiRJgMrrp9T+r
         XtXySw6h7pZaQ1Ac22WZP5L6hhmyhmgAsF4Ls=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uZ0ryVDhFnGzLZcrMR5qrWRgUAYTaxLSApMq9rjkF/Y=;
        b=FyQB4pIWZsI5OSsQUs5PNze2poyttNdq9wVmg29Y2djwEvVdU0SFj4vClyWXzjLb33
         sOLwHoww4IYmLDhvCOSYCA1QTBRK1SQvC1C3FyRIkLDANd/6sldv9wR7QIT5CTX2WeUs
         nC14x8cKwAWllrU7X6KZzDKp2J0umq1VhjdDVLu3TMrhA9wKdpoJvXGcFZTsEYbtza5t
         OcbeUYW5htOJmvG8YwWXE8KtpPCjR4bWYMypJ4SKm/E98YK2thM25IbISZbOds7TBa7F
         gunS2X4Jdak1bzx1C55Pg9qB+8WFsAvdF9blMekyy/lNVdJwnxLMcXfRY30k/zjLe2LO
         T6Ug==
X-Gm-Message-State: APjAAAV9T+yMHU690HNroZxWB8Ky470mFWgcZ3hzqGamDlQmVgitxN9c
        QsqjIQsGvws8MFII6j8w8TguHZn0nxY=
X-Google-Smtp-Source: APXvYqxqyKfx3pcbt8lvGKqRc3SQKPByaFBOlKooaZzBXG35f0OLt5+d3PRchnmxQN1IF/rSER3HtA==
X-Received: by 2002:a63:a011:: with SMTP id r17mr44190989pge.219.1568379907852;
        Fri, 13 Sep 2019 06:05:07 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 69sm37208841pfb.145.2019.09.13.06.05.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 06:05:07 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 03/13] mpt3sas: Fix clear pending bit in ioctl status
Date:   Fri, 13 Sep 2019 09:04:40 -0400
Message-Id: <1568379890-18347-4-git-send-email-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
References: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Issue:
 when user issues diag register command from application with
 required size and if driver unable to allocate the memory then it
 will fail the register command. While failing the register command
 currently driver is not clearing MPT3_CMD_PENDING bit in
 ctl_cmds.status variable which was set before trying to allocate the
 memory. As this bit is set so subsequent register command will be failed
 with BUSY status even when user wants to register the trace buffer
 will less memory.

Fix:
 Clear MPT3_CMD_PENDING bit in ctl_cmds.status before returning
 the diag register command with no memory status.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 76ca416..a195cae 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1591,7 +1591,8 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 			ioc_err(ioc, "%s: failed allocating memory for diag buffers, requested size(%d)\n",
 				__func__, request_data_sz);
 			mpt3sas_base_free_smid(ioc, smid);
-			return -ENOMEM;
+			rc = -ENOMEM;
+			goto out;
 		}
 		ioc->diag_buffer[buffer_type] = request_data;
 		ioc->diag_buffer_sz[buffer_type] = request_data_sz;
-- 
1.8.3.1


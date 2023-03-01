Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72472C7EE23
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Mar 2023 23:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjCAXHQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 18:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCAXHP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 18:07:15 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4437FC679
        for <linux-scsi@vger.kernel.org>; Wed,  1 Mar 2023 15:07:14 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id d7so16189741qtr.12
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2023 15:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677712033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rieBKGd7o1erdCd49tEdelZ5ZlqM1PJ8uG8LaNXqWMQ=;
        b=KY/FgldWcTxWmPWg9B8VWskQfoI8NrCDW72/K9RCY/U1WzBuZdXCYGq/nq7BEskkQH
         bkiar3Y1fWOkstd1b/VirPr+6nFPOeKfcQ/j9lzf07GhWY9SOii+Qtwdr7Jd0iuedVP/
         EHMnsjfj+BRL/mUUZ6fs9ZAo0xpi4GUNULl4Qkzbik1rlrN918/ZOWqF8uEM612VF2bM
         wPR5Gj9nzH1PNUzxbwtGDZbn6+8gKk+lWiJ8Uoj/L+ideGI2KRWr+Eh4qFbDfRGRdJN4
         q+z0ywaj6MblbIE2iMBt9cOWRaP2Gah2z/0iM1iopttNMsLv5/0yq2WheQLYC/KPMEc4
         Cp3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677712033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rieBKGd7o1erdCd49tEdelZ5ZlqM1PJ8uG8LaNXqWMQ=;
        b=kSr5XSG7DHieHa9TkxPyk8XAvnQA1F1YOaWVsN7h4adF0ghwZAv6yJWz7/y3Hc8eQD
         rBtdx3PhrlcQn6d9Km9/2u9hS9QpY2JmxXUnlT4DZkwbs9iQUTfd1ldDBqpGooxcSipC
         KvR7DoiWGZytyu9zdgH9Dmsen4FMIhxE1U+MYPTLl8QM1pneQPNxcWv2GdjvXmZAhKrM
         EyRHIWO6mbHlNRTzRcNFMlZkh4I01EQcPiAKLPjsJbYzqPh6Uj1Iqx3cT4uDA1uilwFd
         08x3Yz554/tubScz9XhcxpLRC/iNnv9E3fsIZOmRM8aTt9E/mauYYgF73o957kMDUa5d
         pS8Q==
X-Gm-Message-State: AO0yUKUTotcrv3XZ+UhfpCswxEJyjifvRUBSs3t0nLeiCyZCWigKH/Ex
        H0XAjDGFq8KNAZUI5x5IxIFPh2x9DSM=
X-Google-Smtp-Source: AK7set/6JAzKSssGjSY04m6wpZtMHReuZcNPmJUMfEalF4dXX5NNVs/QQ1mYAN6YUku+IfyYUUPCcA==
X-Received: by 2002:a05:622a:1896:b0:3bd:1c0f:74f3 with SMTP id v22-20020a05622a189600b003bd1c0f74f3mr16810352qtc.2.1677712033226;
        Wed, 01 Mar 2023 15:07:13 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9-20020ac85509000000b003b86b99690fsm9047572qtq.62.2023.03.01.15.07.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Mar 2023 15:07:12 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 01/10] lpfc: Protect against potential lpfc_debugfs_lockstat_write buffer overflow
Date:   Wed,  1 Mar 2023 15:16:17 -0800
Message-Id: <20230301231626.9621-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230301231626.9621-1-justintee8345@gmail.com>
References: <20230301231626.9621-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A static code analysis tool flagged the possibility of buffer overflow when
using copy_from_user for a debugfs entry.

Currently, it is possible that copy_from_user copies more bytes than what
would fit in the mybuf char array.  Add a min restriction check between
sizeof(mybuf) - 1 and nbytes passed from the userspace buffer to protect
against buffer overflow.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index f5252e45a48a..3e365e5e194a 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2157,10 +2157,13 @@ lpfc_debugfs_lockstat_write(struct file *file, const char __user *buf,
 	char mybuf[64];
 	char *pbuf;
 	int i;
+	size_t bsize;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
-	if (copy_from_user(mybuf, buf, nbytes))
+	bsize = min(nbytes, (sizeof(mybuf) - 1));
+
+	if (copy_from_user(mybuf, buf, bsize))
 		return -EFAULT;
 	pbuf = &mybuf[0];
 
@@ -2181,7 +2184,7 @@ lpfc_debugfs_lockstat_write(struct file *file, const char __user *buf,
 			qp->lock_conflict.wq_access = 0;
 		}
 	}
-	return nbytes;
+	return bsize;
 }
 #endif
 
-- 
2.38.0


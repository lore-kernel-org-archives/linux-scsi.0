Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B20C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Dec 2021 00:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354494AbhLDAaZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 19:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383694AbhLDAaU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 19:30:20 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2CBC061751
        for <linux-scsi@vger.kernel.org>; Fri,  3 Dec 2021 16:26:56 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 71so4647465pgb.4
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 16:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tangISIjMFoARjF61DTQkK8+AJWtgxHEidCHBUi2IkA=;
        b=ZopRFYHg5UWYvdlS0VRvSyIBttTQSbOXFF7leFWJSr/CTMHcuQ2qUkWimL/U+BJdWj
         NiRg2/PbVmSkGca/3T33cLv82aq/6tb0aoQlmnteSpAj/eKVX+2SBg1tMVvjnD4v/qgI
         50I7FJ/vb3nTH0+RxCWI/J99o4S8zyGqo9RPTlM669SY2hvr1IAldK0RLvfyHH10vOct
         lDNr5pvzbM1FJXbcqQK1Oa+eqr0BeOy2wTJ3ATTGHGu12fatDqPEbglUype26pla/zKu
         RkxhskCnsToWC4wLGtYu34g6RwnYlC81vHYGBjF0AsEtpB8vDyWTa3SN6qGI7f5Y8RVv
         /7oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tangISIjMFoARjF61DTQkK8+AJWtgxHEidCHBUi2IkA=;
        b=kCJ+jOfQU1tr0MFwE21ojxEvqv39RZ3RyapN5kj7Y+rJo+wE66unQGPyMXOVZvMd6q
         B51+fwIGtYFGYHKbaKwRf4B6AzYTAlAaV6rHTquVnZdz43DLC8pl7fulCQkHRG92Kfv0
         H5yGFlv/nxDCt45vbkZ9tOMw7wnKYLFsLCstuhI8LbHtVODrNq5dycSw8fkm+kMo4erJ
         mxbtToO5SZL5+YGsjae6EP59AA8a/uByufLJZLmLx8P6UBpzY6NLFj1rVskjMBd5DN10
         es9dV7f9+dVipuJZRgYo4DRT57Wuvg3+AeK6Jh8nPfBT78dLbFdkSS/CHmagE47d0eFq
         VqLg==
X-Gm-Message-State: AOAM530DxBF3DnJiBjN4De86kPwIPp8qcAHoyhAPtS26AFNNyeYDoCcq
        avFJhiK4LcodwtKUtTG1KbLvcA01TKo=
X-Google-Smtp-Source: ABdhPJyJk9ohiXwqUUnqg12mTkSFKWvLGpD7U8vULjmqE6y1ma5CCUKojXdsfy5HpxqhHIPWbtiKNw==
X-Received: by 2002:a65:4bc8:: with SMTP id p8mr7105686pgr.119.1638577615526;
        Fri, 03 Dec 2021 16:26:55 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q17sm4970707pfu.117.2021.12.03.16.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 16:26:55 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 8/9] lpfc: Add additional debugfs support for CMF
Date:   Fri,  3 Dec 2021 16:26:43 -0800
Message-Id: <20211204002644.116455-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211204002644.116455-1-jsmart2021@gmail.com>
References: <20211204002644.116455-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dump raw CMF parameter information in debugfs cgn_buffer.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index ab2550ad0597..21152c9a96ef 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -5484,7 +5484,7 @@ lpfc_cgn_buffer_read(struct file *file, char __user *buf, size_t nbytes,
 		if (len > (LPFC_CGN_BUF_SIZE - LPFC_DEBUG_OUT_LINE_SZ)) {
 			len += scnprintf(buffer + len, LPFC_CGN_BUF_SIZE - len,
 					 "Truncated . . .\n");
-			break;
+			goto out;
 		}
 		len += scnprintf(buffer + len, LPFC_CGN_BUF_SIZE - len,
 				 "%03x: %08x %08x %08x %08x "
@@ -5495,6 +5495,17 @@ lpfc_cgn_buffer_read(struct file *file, char __user *buf, size_t nbytes,
 		cnt += 32;
 		ptr += 8;
 	}
+	if (len > (LPFC_CGN_BUF_SIZE - LPFC_DEBUG_OUT_LINE_SZ)) {
+		len += scnprintf(buffer + len, LPFC_CGN_BUF_SIZE - len,
+				 "Truncated . . .\n");
+		goto out;
+	}
+	len += scnprintf(buffer + len, LPFC_CGN_BUF_SIZE - len,
+			 "Parameter Data\n");
+	ptr = (uint32_t *)&phba->cgn_p;
+	len += scnprintf(buffer + len, LPFC_CGN_BUF_SIZE - len,
+			 "%08x %08x %08x %08x\n",
+			 *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3));
 out:
 	return simple_read_from_buffer(buf, nbytes, ppos, buffer, len);
 }
-- 
2.26.2


Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C20C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34AF020866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KqqQb38u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbfHNX55 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:57 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40646 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729832AbfHNX54 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:56 -0400
Received: by mail-pf1-f196.google.com with SMTP id w16so333546pfn.7
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QCegCWakw9HckjeZcYvQktRE7/G1yOJ6h73lJ4RcoAw=;
        b=KqqQb38u0BxrQpppaDL7gaGMZWsCNe0Z6GJfQ1lts7h8/I5TzYNwPuSZtwpoAM6MOp
         /dSlgpwI+42w9nwkDvTsVhmswaRWgrMdatOJ3jNxU8JGk/A7O1vHvBA7gZs+0SzU1Ge/
         lLTMJq3fUsHi8abVrv1PpeAVAfni69kWLR9LopJcLEwuWzGs8+3R0CjOYEYtq9ctyPIN
         M1yXreXqfnbbdrDjjGxyFK6kAzpXMogOmiide6gDm1R9Z2JdWeBLTMDFMax3fOrGNMRt
         49sr09KlX+d8v/xAIkRB9jZuzYF5eoS8Th1TxdnhKLjXG2WmhckwjwPh1dRqkvVHD3/4
         bASg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QCegCWakw9HckjeZcYvQktRE7/G1yOJ6h73lJ4RcoAw=;
        b=lp/cMR2aEyM9gzH5l25+PM+n8k+tj5vfmU2GOaemyx83hCNCN6a4pJWng8yOjwGrf9
         UR2k50gFcXZ4+a/URxCQ96UTB4W4Mgs/wvf1j8O43zIgBV0lelhr7cn553rmTqlAFCVY
         31s+0GMnV8ePzXmKmV5KWGFLWAKtnK2mNbIhVSLuLIlUgrDRNb0aX8oWTT8XBwLRTD8v
         XNUyaugDrRVXsPbvdwjkzS4+gZtFhC1HSgyaBw5KvtEl13PKgMm5kFPbPHBtHdDRzS0+
         qS9Xiw6xMSpnUtwvFM1Dlg84q9rfhP+/HHVzyqB4EHxEHEUa017nx5mj+hoePCGxEYDL
         T9ug==
X-Gm-Message-State: APjAAAVrR8xYJjWIQzb3b/V8yqSRYIYdupMfmdMu6gf1Xijk9YByq1+c
        Owb2GHBbV3eaA4tTqpKY+zXivI95
X-Google-Smtp-Source: APXvYqyRhtntYXdRONxehhOXMmZYe8L3GlFqkVYHmgC7WqF0F73TcJ0myrq/zCQSD/11K9E0kseRpA==
X-Received: by 2002:a63:2685:: with SMTP id m127mr1399249pgm.6.1565827075466;
        Wed, 14 Aug 2019 16:57:55 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:55 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 42/42] lpfc: Update lpfc version to 12.4.0.0
Date:   Wed, 14 Aug 2019 16:57:12 -0700
Message-Id: <20190814235712.4487-43-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 12.4.0.0

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index f7e93aaf1e00..b8aae31ffda3 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "12.2.0.3"
+#define LPFC_DRIVER_VERSION "12.4.0.0"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.13.7


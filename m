Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AEADC35280
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 21:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EB63208DB
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 21:43:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NtFdSzrH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgEAVnh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 17:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbgEAVnh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 17:43:37 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176A5C061A0C
        for <linux-scsi@vger.kernel.org>; Fri,  1 May 2020 14:43:37 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id o27so7867292wra.12
        for <linux-scsi@vger.kernel.org>; Fri, 01 May 2020 14:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wyyVgkpuZlIh7zJlRzXspUTnINp0Fb+fl/yjcwwod4s=;
        b=NtFdSzrHVVSd+cmkVTQZ//8/wNN0F2bPhpw4pqk9Ukdm7ds3SYjJ/IJpAnODH/h+q2
         eMr9u1uoB2XO/vdugvGpIShDP6OaenFaRt2EQcM0I+G0YN6t6rn9L6dnCeNmLacvuSsh
         qmQA04JK0c8Bi2ikbC33BH6myOwjgKBu1f0ZsnH4nAlcwmxPLXzXPmeKwsc3/8dns0Ck
         IJhwTk49MIxQlmFTAKTnR5TxLCWB1II7Xqk06b3AQ1iZ9qF712SwBGgIVw4BSbwUM7nq
         CV2jqidxsf3FI5zwBmt+JKzGc6qmDMXH+hs7XmaczCFYvXQaTOGddtCjFj7tWvikJZTi
         OnOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wyyVgkpuZlIh7zJlRzXspUTnINp0Fb+fl/yjcwwod4s=;
        b=qPgcWAKndBuxB2j2DglVaP9HqR0n0TNhvA2TWclIGIx8GkpDM/p4/16E3j/61uJOYT
         Sg/AeeSHbVv3gRaXLqVV7HQxEBTfZohvacjAhuZPhY6cgO5kihX53S0IlfdJ0SYVeoWT
         lAbZRuiGYoPbnoif3skTjSkLju7dY1h/cyS/mO8Kn7t4PEMD1C4TquJ736ASOns2FLls
         LDgataSYUUaTW+PqmRGpCZHRfHdob+mbMW3pdOF0WAxiR/vDCPB1giLkfLiCMThVTOho
         LRTu3TizlmxwZFhhmMlhsBelcEWN2bG09Ekj92oNAvHgeymPW79aSBe41JBlwzveR7oK
         VvTA==
X-Gm-Message-State: AGi0PuZbXdtrGq6P7x3vA3f+l47OU0HIl0D4rymGWpYidHMfIZRoeaQW
        hZZDexX+h+Y0ZGbnNvGRDmXkGRy5
X-Google-Smtp-Source: APiQypLjdkzxdbU2qneMePFRYtIdUR0pXHcLn6STNhKu3e+DeSCIlXE1cqGY766kb6jf39Vv7Ohw+w==
X-Received: by 2002:adf:e943:: with SMTP id m3mr5904595wrn.248.1588369415404;
        Fri, 01 May 2020 14:43:35 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t2sm1207734wmt.15.2020.05.01.14.43.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 May 2020 14:43:34 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 9/9] lpfc: Update lpfc version to 12.8.0.1
Date:   Fri,  1 May 2020 14:43:10 -0700
Message-Id: <20200501214310.91713-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200501214310.91713-1-jsmart2021@gmail.com>
References: <20200501214310.91713-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 12.8.0.1

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index ca40c47cfbe0..ab0bc26c098d 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "12.8.0.0"
+#define LPFC_DRIVER_VERSION "12.8.0.1"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.26.1


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE63C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D632F64EBB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381117AbhCDAcX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359666AbhCCOuU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:50:20 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17E8C0613BB
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:47:27 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id l22so5411546wme.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ySODZ2632aeayKlQPyHeudZTc8h2kJ2bKUfsQdptsf8=;
        b=cUBgEPDjKYhvu0dZiA4icyJA4vYab4lZb6iX/nQJ2sOJUYF/AQq3BkXozRnfCXXyZf
         C5lXrtJF48Tk/3a5M7tUI+AiDfrXocEW5VOVyqrEz/158Yyzs0rDJt4ZJsjiLM0B+zIp
         mooa1IFW/sBUw0tkpWtuGZln6XSKuxzDukJyRyh0FM4Z56DeAHP4aCdRNXkhUvwKV1qq
         Ra7tgXvQscr5N0phsB/kcKVu5DAxsOKX2KyMN4jivihgcgMJvu3jxSd8EKJxkxd7hfyQ
         +61uagjqC+STaS0xxSqAo4Mw4/XeNrP+k9nQnWJ918DiYvwJdZis0YTzimsMrlXkRBXG
         b6mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ySODZ2632aeayKlQPyHeudZTc8h2kJ2bKUfsQdptsf8=;
        b=rjbpPu27hPNIWBCk8TOvyoYjIqajCRqvePvEc0mstwTU+bXIQEwWstsmDhd1df5gT5
         OUgZeqFZmeAcYjFDQiVO3lHSmB4xOHT9XRJ9a+aT0vW6kVlRgl2elVRlQ5Oh5S2ginVu
         iEHotVK4fnfFVAettNm7nLgQGVcLVnHPjyzGxzBPTkCVNCW486DVfweu/xTl7cnpqfva
         fElXvnNKMt5SuNshMe8DrK0bM3vQt+ZRisQ8zqh719KWszGopwXMQQsVUE7PQxJVh+Um
         nj7tc/MkeaezJdf6FWyiEmShn66xsyxRcb014bSdbZGe6V0FoBHAU3xgFfCASQTdJ0Jd
         Hn1g==
X-Gm-Message-State: AOAM530kvjqM4CB1OeDRyfs2o1GkKHhSeQit7IDRNXTU4tCuzz+bDdNC
        XW9ygFK2dMi72tr0V7ne9NBuIQ==
X-Google-Smtp-Source: ABdhPJwRUXmasnEMFe8nVPXeu7uGCy56SCGhP6kMptpmGfqtmkZqKvMv/OK5kAcnTJUUuGMzy2RHiQ==
X-Received: by 2002:a05:600c:1550:: with SMTP id f16mr5447864wmg.97.1614782846325;
        Wed, 03 Mar 2021 06:47:26 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:47:25 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 19/30] scsi: qla4xxx: ql4_mbx: Fix kernel-doc formatting and misnaming issue
Date:   Wed,  3 Mar 2021 14:46:20 +0000
Message-Id: <20210303144631.3175331-20-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qla4xxx/ql4_mbx.c:47: warning: wrong kernel-doc identifier on line:
 drivers/scsi/qla4xxx/ql4_mbx.c:947: warning: expecting prototype for qla4xxx_set_fwddb_entry(). Prototype was for qla4xxx_set_ddb_entry() instead

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Manish Rangankar <mrangankar@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qla4xxx/ql4_mbx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 17b719a8b6fbc..187d78aa4f675 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -44,7 +44,7 @@ void qla4xxx_process_mbox_intr(struct scsi_qla_host *ha, int out_count)
 }
 
 /**
- * qla4xxx_is_intr_poll_mode – Are we allowed to poll for interrupts?
+ * qla4xxx_is_intr_poll_mode - Are we allowed to poll for interrupts?
  * @ha: Pointer to host adapter structure.
  * returns: 1=polling mode, 0=non-polling mode
  **/
@@ -933,7 +933,7 @@ int qla4xxx_conn_open(struct scsi_qla_host *ha, uint16_t fw_ddb_index)
 }
 
 /**
- * qla4xxx_set_fwddb_entry - sets a ddb entry.
+ * qla4xxx_set_ddb_entry - sets a ddb entry.
  * @ha: Pointer to host adapter structure.
  * @fw_ddb_index: Firmware's device database index
  * @fw_ddb_entry_dma: dma address of ddb entry
-- 
2.27.0


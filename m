Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 128DCC43331
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 23:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBD7C2173B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 23:04:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qQGgcuQS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfKKXEZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 18:04:25 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54585 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbfKKXEZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Nov 2019 18:04:25 -0500
Received: by mail-wm1-f66.google.com with SMTP id z26so1057437wmi.4
        for <linux-scsi@vger.kernel.org>; Mon, 11 Nov 2019 15:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sOmK1ZlOg5VZIkG9PhEAAGs5AvFYBfaMCcStmXFkrnw=;
        b=qQGgcuQS8LYMK6OVOajrPAm27ktm8Zz5o8rpAoKRIP43RxgCcFnTE879hvlgGcaxj3
         NDRPpE+Zgw5TQjdQChNVDG1rQZtYtcw+wl1chtZx/aSu8qBeA94bHbAuzNgSQSYuFwkJ
         Pz20QZFPOGAYvLShPxDlkuucPn3A6UXnaKCSkTOvvigtlQD6IdQAqxnvEC5uxYbyI2p6
         9+yE3tzCcjDHvuDh1D0uQzlaoDcnRQ4527BkIxeA4pXepkL0r8JBXZCuBbV+u2aqGOro
         kYnU8GG19VA59xfQ+rrwIx3vukRRTy6qhTKAxIqslrF2jj18n16Lm8Wt9n36kok2FAyZ
         2TLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sOmK1ZlOg5VZIkG9PhEAAGs5AvFYBfaMCcStmXFkrnw=;
        b=TpC35bVpS3l0TNZbEjszinqaMUUhDb9PIa3ZbEM85hbgWQ8oCs36AluwnLVhPbTlGq
         +ZbHV6QFC7s4TK/JTUjRVnVpAj4Whd9MpQ0MAdWUHZJUNfIwiZquny6mzbdYmlV1jA9N
         grTkmFawXgs1nFrs8O14+R1z8XQE5D3VL/m3GiJVZi37jeuCP0SddaP34Hqar++ldy2y
         KyMGjTXTxjprLZh0HOeyAzWVpJmYnrZfDVAlMmI2PdlU8TelUBr3R4OIemju4V/dMmVu
         3rIT9/++8iwwZ1BGsAli03cZHho4mRyjxlLX9Dt2XwN96stkiPyffIzZ/sn117n1+9Ax
         DuGw==
X-Gm-Message-State: APjAAAWhPIEJf/uNvtWS/1tSl7ldYsXvuvtzpdS/KymZrlTrd14s9Rza
        o7erseSuJ2YJWDRWlDJp65QLt5cO
X-Google-Smtp-Source: APXvYqx5/u9w2+3j5G4F/0cTU66F5Pu64B9nneBVnHa/C9rh0F+2iui6wzB/qFLWUps1uHPxAAU4YQ==
X-Received: by 2002:a1c:e90b:: with SMTP id q11mr1078111wmc.125.1573513460731;
        Mon, 11 Nov 2019 15:04:20 -0800 (PST)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m25sm655146wmi.46.2019.11.11.15.04.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 11 Nov 2019 15:04:20 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 6/6] lpfc: Update lpfc version to 12.6.0.2
Date:   Mon, 11 Nov 2019 15:04:01 -0800
Message-Id: <20191111230401.12958-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191111230401.12958-1-jsmart2021@gmail.com>
References: <20191111230401.12958-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 12.6.0.2

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 1532390770f5..9e5ff58edaca 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "12.6.0.1"
+#define LPFC_DRIVER_VERSION "12.6.0.2"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.13.7


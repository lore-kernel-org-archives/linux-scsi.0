Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB60CA9EAB
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51CB62089C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cm1yLb6P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502569AbfJRVTT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:19:19 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36253 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502466AbfJRVTS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 17:19:18 -0400
Received: by mail-pg1-f193.google.com with SMTP id 23so4031466pgk.3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 14:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mHQD5lGpa9VUJHFTaaUuJJfu9b5++BgIKRdWTTbvwVU=;
        b=Cm1yLb6P5NUpOKbUKhkQ1uozHzhLDQ6z90iLQVW3hclBE1dxQqhuhcjRg5ZzOPkAnO
         Z7iO53dAcU5aWuGKT8UPfmoCv/iUFeM9lsF/qUlR1hBqbeHneES3qQlU8pgdnEy274Oj
         iHTIg4AuiIS+CcedJ/rpQ6+f5ix0lMx9Bb9d1kY0ds2N0P5U5jtyN91mh1NWOAJUgFe3
         n2bzdtW7PrWFJDtmZH+Z+TYKigM+9WX/DTtH6tspw7TOdqGMRKVIfXJZVz6fikqxInUX
         aZa6yc9ZkuXwJTfVMXynb6LJV2k71YLtHOsIbxEL0bJMNUD/FqO3YELfLAG+2t6n/2Sk
         Yyyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mHQD5lGpa9VUJHFTaaUuJJfu9b5++BgIKRdWTTbvwVU=;
        b=RIF1j9yjh4s2P8xnbOJ+7eVtwRIHrYBXSjpvAzVrqwdjLbOlc/d+y4LPaNA2Q5/f10
         FEPOy4AqRL+NFLmteKPhIPJuEqgrpPRIvA8WRPj3IItSsGeHcCjyqCPw5rHQn766lTd4
         z6E1+MXxUdyHtM2/V2pVHY0FFJnNGNgTL2LuOcob7Y9AZxEd2zCt8GhAgHUL3KMVJ/DS
         lHa5/E+WJy6xeb9SdYZ5M5VZXi6G/wbKUzBEVj6MeF9XwV7QvCZK4rOZhxUrBygubvDd
         tmzqyqXUuB8HvE9VohXmhWCOdxJjoObOgw5w6Cqy6k9WX45Wgv3wVDB0iKYGwkJQ7w5K
         4Reg==
X-Gm-Message-State: APjAAAWK+0UXhW18bQobUFtIHUt3HzhivpFPM+sbbfpwnE8tMYI/TNCH
        Tx/5eqLIkdXru8NE4gjbAElroEFE
X-Google-Smtp-Source: APXvYqxQffmFYdL+6rWnjbnV+EbmyIUg6ja3oGP+q7AEHF9WA1jKm7ohx57KjoOmuFJUMyanZll0/w==
X-Received: by 2002:a62:6842:: with SMTP id d63mr8880888pfc.16.1571433557793;
        Fri, 18 Oct 2019 14:19:17 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 22sm7538878pfo.131.2019.10.18.14.19.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 18 Oct 2019 14:19:17 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 13/16] lpfc: Add FA-WWN Async Event reporting
Date:   Fri, 18 Oct 2019 14:18:29 -0700
Message-Id: <20191018211832.7917-14-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191018211832.7917-1-jsmart2021@gmail.com>
References: <20191018211832.7917-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add decode support for adapter Async Events which report
FA-WWN configuration errors.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
Note:
 Requires the prior patch:
  lpfc: Add log macros to allow print by serverity or verbocity setting
---
 drivers/scsi/lpfc/lpfc_hw4.h  |  1 +
 drivers/scsi/lpfc/lpfc_init.c | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index ac86b80230e7..818a0f4325af 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4261,6 +4261,7 @@ struct lpfc_acqe_sli {
 #define LPFC_SLI_EVENT_TYPE_DIAG_DUMP		0x5
 #define LPFC_SLI_EVENT_TYPE_MISCONFIGURED	0x9
 #define LPFC_SLI_EVENT_TYPE_REMOTE_DPORT	0xA
+#define LPFC_SLI_EVENT_TYPE_MISCONF_FAWWN	0xF
 #define LPFC_SLI_EVENT_TYPE_EEPROM_FAILURE	0x10
 };
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 316a2c2beb0c..d821adbb0047 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5430,6 +5430,16 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
 				"Event Data1:x%08x Event Data2: x%08x\n",
 				acqe_sli->event_data1, acqe_sli->event_data2);
 		break;
+	case LPFC_SLI_EVENT_TYPE_MISCONF_FAWWN:
+		/* Misconfigured WWN. Reports that the SLI Port is configured
+		 * to use FA-WWN, but the attached device doesn’t support it.
+		 * No driver action is required.
+		 * Event Data1 - N.A, Event Data2 - N.A
+		 */
+		lpfc_log_msg(phba, KERN_WARNING, LOG_SLI,
+			     "2699 Misconfigured FA-WWN - Attached device does "
+			     "not support FA-WWN\n");
+		break;
 	case LPFC_SLI_EVENT_TYPE_EEPROM_FAILURE:
 		/* EEPROM failure. No driver action is required */
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
-- 
2.13.7


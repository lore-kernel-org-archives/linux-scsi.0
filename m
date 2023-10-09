Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A86DE95A9F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Oct 2023 16:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377100AbjJIQF3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 12:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377072AbjJIQF2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 12:05:28 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6691E99
        for <linux-scsi@vger.kernel.org>; Mon,  9 Oct 2023 09:05:27 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1c76ef40e84so8472905ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Oct 2023 09:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696867527; x=1697472327; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ANXO/4U1CWyDTjjBTbo/Pgx7AydEgFFfWGdDyy2SRB4=;
        b=cNXG0biIpxeWVKHFDHa/EAIG81Pc9CwL785/OTFxBtXI+NfpGdMdWMt5SRU3HSewSC
         nSDHoWGUUsZLkGEE70G/kb1Cq1AjozRE6a+bFbPyeN/Mp1u/IbjUirhDIC/58NiXSDoa
         4n0u2E2ytzAsDuJEjD8ZJJTVqF95YQlz7CWWhIiuVN2VrFbOmt6TSY+S+8v4Ll7zA69a
         C1fG3Wd3GcC4MEMCYmbhgsUYt4IVZM1bRcbD/VWQluwhFGUFloN3pb3ZkxR/7BPp5hG3
         EkdWoWDyKeKcsfkx3tqTn0IIakB3AxoHM/NX1bXEaOgLt7D4+OxjPDpEQMU2veF5N1Rk
         je/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696867527; x=1697472327;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ANXO/4U1CWyDTjjBTbo/Pgx7AydEgFFfWGdDyy2SRB4=;
        b=fCZa25Bq+W6aQq9N8mkKlvnghLtwASyyJYJSZg6P+708nnVtXQxbsfhKfAwh9rDSWi
         H7290clRoubuIUYRaE12NOenVglLrU3hqrmw1S6ZXdnHk9YJ3hEz5FOb+0KoG6kGk55L
         Xe+pyU47ux116spMHyZUp8RLBZ/52UrNzHtRFJCjnlxZUMzKreF0MVNzvzuh9+K/J/7V
         mxLTDvFAjdTCIedVm66Gv7wP5kcKhg3FC96E9WTQPHKukEAZA4z6YKVhJgIRusjXVDKg
         sJwt4evgJmAeXp8JQh7Xo1ZjrQvLjipGUUaMwKZGl4QBdRhtvSFGevFGrh/vvPL6O/FQ
         9gZw==
X-Gm-Message-State: AOJu0YzmEcsHmhzfbtsDSploagPSajvUUX+W55b+MqeZxtsXxZ/lLaDo
        HgcoyHPKvscP8pLe6SJlRPgEokTHTBg=
X-Google-Smtp-Source: AGHT+IFRFAOiqHFObMeKqfqZgwxYLjAlUj1wOzzAFU8iOMIA55LQwpiktO3HYcWQ9DDRRt+JxLyXIg==
X-Received: by 2002:a17:902:dacd:b0:1b3:d8ac:8db3 with SMTP id q13-20020a170902dacd00b001b3d8ac8db3mr17853013plx.6.1696867526587;
        Mon, 09 Oct 2023 09:05:26 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l13-20020a170902d34d00b001bb9f104328sm9793418plk.146.2023.10.09.09.05.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Oct 2023 09:05:26 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 1/6] lpfc: Remove unnecessary zero return code assignment in lpfc_sli4_hba_setup
Date:   Mon,  9 Oct 2023 09:18:07 -0700
Message-Id: <20231009161812.97232-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20231009161812.97232-1-justintee8345@gmail.com>
References: <20231009161812.97232-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In order to enter the !rc if statement block in question, rc had to have
been zero to begin with.  Thus, the rc = 0 assignment is unnecessary and
can be removed.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 4dfadf254a72..9386e7b44750 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8571,12 +8571,10 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	 * is not fatal as the driver will use generic values.
 	 */
 	rc = lpfc_parse_vpd(phba, vpd, vpd_size);
-	if (unlikely(!rc)) {
+	if (unlikely(!rc))
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"0377 Error %d parsing vpd. "
 				"Using defaults.\n", rc);
-		rc = 0;
-	}
 	kfree(vpd);
 
 	/* Save information as VPD data */
-- 
2.38.0


Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 532A3C2D0D2
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27E4C21D7D
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lWhH02+Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfLRX62 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 18:58:28 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40205 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfLRX62 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 18:58:28 -0500
Received: by mail-wm1-f65.google.com with SMTP id t14so3779510wmi.5
        for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2019 15:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Cn+hgHgXLDZqThg4qoDORZGKQZ/ccON73+7VFhks274=;
        b=lWhH02+Z2UFdKJ/rlLydfYpSpNVd576kHAiqnXjQyPr86s0B36vAovTVwXdxElwbYI
         TMM/rm2TkIeDSW9ZhydUZA4JhPyeq1kRWxhbtlJ8PNuz/59/JyQGn1sNa/azdgD0//zK
         h30jKGTv9tY8TyKB9mVozkHA3hSKJ7PmSXDiBgJ/zaEDtoAnNngAPhHU9Qemed8Qzg7E
         LwCKqlWe5hFis2ByrscmOU5m1+v3z7LU2rafREAXIj5CDegHm8wlTSuzB3JAVCTYp2aE
         43SZ7W6XJWa08ofN/Pdbnc6IfY8DrUolapbE6FK21XFhTyy/gTuMc1B7XP1gK4qK4fDM
         OptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Cn+hgHgXLDZqThg4qoDORZGKQZ/ccON73+7VFhks274=;
        b=ZHR4TBQUFGBmNt9vyOCwsriQrjKDCLQLjxThqTr2Li8XWAcMFPOsxNRdWqAleA6pSF
         4ql+be/vQWil3+RX8pR1hSglIZJfbp9Jq4kKOnIhJi0v/3z++lUJgTPDBZF8jwJeTT4L
         UQw2bxkVUQDS7TxWTYuTmJOMuEJZE7h3S30Pc6DljgWnf0IpryheW/gPa721cZK+wPOD
         Hl8699PCJ+5iPaeu6WnVWwIi08DiBfVnM8TVhPVEZxj7EeaCaPR4TwH8boHTtaibIaWV
         20/DrWXE8b/qMAUHJHLzNK4qYFyvZ//sLXwVPd8cahzCwIQwEyIJL7IUu8/+zrZAQMyL
         3ZYQ==
X-Gm-Message-State: APjAAAUWr3jiqGmTp1GwGLL2y0zYAh7Ks+TcRlqsDjvYQFZr9rE9qzno
        vvv24Sfz8bKxSYUdyRsGSVE1VcOO
X-Google-Smtp-Source: APXvYqytEbiK4M57XdvcZviT9plOtSYD3CIp/mRG1wmet482458EGVxAj63dN04hZWpIMyVu9THPYA==
X-Received: by 2002:a1c:bbc3:: with SMTP id l186mr6352026wmf.101.1576713506270;
        Wed, 18 Dec 2019 15:58:26 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x11sm4240731wmg.46.2019.12.18.15.58.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 18 Dec 2019 15:58:25 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 05/10] lpfc: Fix ras_log via debugfs
Date:   Wed, 18 Dec 2019 15:58:03 -0800
Message-Id: <20191218235808.31922-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191218235808.31922-1-jsmart2021@gmail.com>
References: <20191218235808.31922-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

/sys/kernel/debug/lpfc/fn0/ras_log always shows the same ras_log even if
there are link bounce events triggered via issue_lip

Dynamic FW logging had logic that prematurely breaks from the buffer
filling loop.

Fix the check for buffer overrun by looking before copying and restricting
copy length to the remaining buffer.  When copying, ensure space for NULL
character is left in the buffer.  While in the routine - ensure the buffer
is cleared before adding elements.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 2e6a68d9ea4f..d7504b2990a3 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2085,6 +2085,8 @@ static int lpfc_debugfs_ras_log_data(struct lpfc_hba *phba,
 	int copied = 0;
 	struct lpfc_dmabuf *dmabuf, *next;
 
+	memset(buffer, 0, size);
+
 	spin_lock_irq(&phba->hbalock);
 	if (phba->ras_fwlog.state != ACTIVE) {
 		spin_unlock_irq(&phba->hbalock);
@@ -2094,10 +2096,15 @@ static int lpfc_debugfs_ras_log_data(struct lpfc_hba *phba,
 
 	list_for_each_entry_safe(dmabuf, next,
 				 &phba->ras_fwlog.fwlog_buff_list, list) {
+		/* Check if copying will go over size and a '\0' char */
+		if ((copied + LPFC_RAS_MAX_ENTRY_SIZE) >= (size - 1)) {
+			memcpy(buffer + copied, dmabuf->virt,
+			       size - copied - 1);
+			copied += size - copied - 1;
+			break;
+		}
 		memcpy(buffer + copied, dmabuf->virt, LPFC_RAS_MAX_ENTRY_SIZE);
 		copied += LPFC_RAS_MAX_ENTRY_SIZE;
-		if (size > copied)
-			break;
 	}
 	return copied;
 }
-- 
2.13.7


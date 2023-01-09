Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 829BFC63797
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 23:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237824AbjAIXW4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237557AbjAIXWx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 18:22:53 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C32838BC
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 15:22:52 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id jn22so11266730plb.13
        for <linux-scsi@vger.kernel.org>; Mon, 09 Jan 2023 15:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WvEXd7AdBlyGZ8KpDI3u38Yqrgqo1XAo/GSGWUCVwYQ=;
        b=i3jQbQX/ZlPK80GhNyQkPS35ArdyEnp1dd/lNmrA1GyOj3Rch8FatKhoLuQHSuRrTm
         9ayLcAzrUScMX3eDwLd00auTCOBGuimdzInwjbs1mYe1Wr24nFLXknxssidNhbPFaQE1
         w4ZU1b7yzyM2YuAqO2wfzQDF0RAcIrA1yYFB+NyfCDGhZJJhDlc+HOnvRbKj+cHWOgd+
         HML/eCSOKkceRjRHS5Na4IQukKTATzGWrxbGBqGqDIErFuXSgAiNREclfJs25eXcrEXr
         OPJn/BqcsmxvPq1Mb5cTWRoymQxsdMy8Q6sbMp+azxRMAARXHcjzNeWHAK91gWNFKMeQ
         +kqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WvEXd7AdBlyGZ8KpDI3u38Yqrgqo1XAo/GSGWUCVwYQ=;
        b=Mvda9Mb2NiYL4bPz1OkQdbbbss1UFsddDxijfi/DzY6sulNmVnhHptxbU6Ll0mUoGF
         aq4bgMiOenCKifs8NGheetygGvD7kqsQA7m8qcZrNt3hSz64uOdgbY2sTn8HlzV/x4Wv
         lfwbqA+JKH4joEjV7swbz5OxDQol3DhLtCK0IkfR10UCvOrQvakbxYXHEpEUSj5992b9
         /sSjrWerRH29fl29lBKR9FXSqurT+eXWcNXhowmNMXQRlMm+9SGVyuaQ83FYgjSRxPaY
         cVbx0gP7YP2MhCSpZQhZMVuOgknwYzQo1hEbP39K7tyJUQWm/W0krlfyKJtHdsJI7bra
         xMeQ==
X-Gm-Message-State: AFqh2kpM5S4pGBGkKNhJyig+r3YEvQDcIP/JSSFosifmF+Ada5NzXSfQ
        SWU1WLQIEmjDE26SksmBgrHyXjfF2hE=
X-Google-Smtp-Source: AMrXdXtIoiuYBkyOlkniSGSH9SENgvTG6jfDZpp4NOSjRw10DO00AR3SFMHs06mP3SrifVvns9mXTQ==
X-Received: by 2002:a17:903:181:b0:193:3154:625c with SMTP id z1-20020a170903018100b001933154625cmr6679618plg.35.1673306571924;
        Mon, 09 Jan 2023 15:22:51 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d22-20020a170902aa9600b001871461688esm6628572plr.175.2023.01.09.15.22.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Jan 2023 15:22:51 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 08/12] lpfc: Fix use-after-free KFENCE violation during sysfs firmware write
Date:   Mon,  9 Jan 2023 15:33:13 -0800
Message-Id: <20230109233317.54737-9-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230109233317.54737-1-justintee8345@gmail.com>
References: <20230109233317.54737-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During the sysfs firmware write process, a use-after-free read warning is
logged from the lpfc_wr_object routine.

BUG: KFENCE: use-after-free read in lpfc_wr_object+0x235/0x310 [lpfc]
Use-after-free read at 0x0000000000cf164d (in kfence-#111):
lpfc_wr_object+0x235/0x310 [lpfc]
lpfc_write_firmware.cold+0x206/0x30d [lpfc]
lpfc_sli4_request_firmware_update+0xa6/0x100 [lpfc]
lpfc_request_firmware_upgrade_store+0x66/0xb0 [lpfc]
kernfs_fop_write_iter+0x121/0x1b0
new_sync_write+0x11c/0x1b0
vfs_write+0x1ef/0x280
ksys_write+0x5f/0xe0
do_syscall_64+0x59/0x90
entry_SYSCALL_64_after_hwframe+0x63/0xcd

The driver accessed wr_object pointer data, which was initialized into
mailbox payload memory, after the mailbox object was released back to the
mailbox pool.

Fix by moving the mailbox free calls to the end of the routine ensuring
that we don't reference internal mailbox memory after release.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c21187c93a5f..55dfab9ae3c9 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20815,6 +20815,7 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
 	struct lpfc_mbx_wr_object *wr_object;
 	LPFC_MBOXQ_t *mbox;
 	int rc = 0, i = 0;
+	int mbox_status = 0;
 	uint32_t shdr_status, shdr_add_status, shdr_add_status_2;
 	uint32_t shdr_change_status = 0, shdr_csf = 0;
 	uint32_t mbox_tmo;
@@ -20860,11 +20861,15 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
 	wr_object->u.request.bde_count = i;
 	bf_set(lpfc_wr_object_write_length, &wr_object->u.request, written);
 	if (!phba->sli4_hba.intr_enable)
-		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+		mbox_status = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 	else {
 		mbox_tmo = lpfc_mbox_tmo_val(phba, mbox);
-		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
+		mbox_status = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
 	}
+
+	/* The mbox status needs to be maintained to detect MBOX_TIMEOUT. */
+	rc = mbox_status;
+
 	/* The IOCTL status is embedded in the mailbox subheader. */
 	shdr_status = bf_get(lpfc_mbox_hdr_status,
 			     &wr_object->header.cfg_shdr.response);
@@ -20879,10 +20884,6 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
 				  &wr_object->u.response);
 	}
 
-	if (!phba->sli4_hba.intr_enable)
-		mempool_free(mbox, phba->mbox_mem_pool);
-	else if (rc != MBX_TIMEOUT)
-		mempool_free(mbox, phba->mbox_mem_pool);
 	if (shdr_status || shdr_add_status || shdr_add_status_2 || rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"3025 Write Object mailbox failed with "
@@ -20900,6 +20901,12 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
 		lpfc_log_fw_write_cmpl(phba, shdr_status, shdr_add_status,
 				       shdr_add_status_2, shdr_change_status,
 				       shdr_csf);
+
+	if (!phba->sli4_hba.intr_enable)
+		mempool_free(mbox, phba->mbox_mem_pool);
+	else if (mbox_status != MBX_TIMEOUT)
+		mempool_free(mbox, phba->mbox_mem_pool);
+
 	return rc;
 }
 
-- 
2.38.0


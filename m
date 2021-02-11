Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF2EEC433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C115A61494
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbhBKXqT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbhBKXqP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:46:15 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33633C06178C
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:57 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id a16so4186945plh.8
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lb3NgBiWrJIpJgdUmhxMsOWe5zW/heMiJ1kpzQJ9U5E=;
        b=uQZQ1YGU6IfkMPcS12DCghLMj/Hn2s6BGvap40vnm7Wp2+S87u1oxytAzT1WZpygO5
         7tru3zusvyEjQOW6PDEfVjbGjyan8uBwE9Od8Tce2t/L+WXyaIVmV0pTuP4xanpC8sk+
         rk4tOo50ToNFE8knx5TUE+zD5WE5EQFRC3OYdaNUtdWfT2cEJjXNR0xwQR7jFr3cuSlm
         PoY1A6gCCPMrg4zdEFGU/xSqAiA1yS7xKBHSe562aT5/BfYCfz6e8GAp/lIwSaXS0ga5
         moXOU8lxnU9jPszkyvvBqhMftquIk90oOcE/Bls3HqC9PxwU3K9ENaHjujOnLo6/c095
         s9OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lb3NgBiWrJIpJgdUmhxMsOWe5zW/heMiJ1kpzQJ9U5E=;
        b=TSbt+K2Rk8rvrpRyN9MZaq+sVkMA8cPLlbnTuQpV/sJ20Zm2ovhE6WhJBB3W/ouX2C
         qGObVBlfZUdLgw15wvyVY1wpL4LqVBiVBjTE6CnrOXYL1+C0OJ4Rd4xTUGNQWsOBvosg
         IN2+IPocQFFrRS5CT6dZXBiHUJYyPQXUUWRjLbPbs1PUMr07I8vFDUqUujcq19z4SynE
         Yvyi5es0TT2Z6LG562PstxpgMVak6iSOH/FvbAVBUKkpPDsRevsbXWLNkRXPVaJpKN+/
         +ZSJ498vfRuhsC6TgJqPpYLuzvTS5NdvlkffLRRFRNcAOJ+W1lxiaciIt3MyuttyFSNg
         0Png==
X-Gm-Message-State: AOAM531EZhd1kK4TOKnZnmQKzm0z9PQRrY3a4AYQN6iy6B9j6YEjhduq
        AIa7bQwpt1gv87kQcs0P3LRUSsfdm+U=
X-Google-Smtp-Source: ABdhPJwTSD5immUkWMDKcX8SmbxR93cQhf4yjpTFdzTuiBxBl4cAqYPF7S/xTda61uuGj/HaXOq2VQ==
X-Received: by 2002:a17:902:9a48:b029:e1:268d:e800 with SMTP id x8-20020a1709029a48b02900e1268de800mr450019plv.69.1613087096696;
        Thu, 11 Feb 2021 15:44:56 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:44:56 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 08/22] lpfc: Fix unnecessary null check in lpfc_release_scsi_buf
Date:   Thu, 11 Feb 2021 15:44:29 -0800
Message-Id: <20210211234443.3107-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211234443.3107-1-jsmart2021@gmail.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

lpfc_fcp_io_cmd_wqe_cmpl() is intended to mirror
lpfc_nvme_io_cmd_wqe_cmpl() for sli4 fcp completions. When the routine
was added, lpfc_fcp_io_cmd_wqe_cmpl() included a null pointer check for
phba. However, phba is definitely valid, being dereferenced by the calling
routine and used later in the routine itself.

Remove the unnecessary null check.

Fixes: 96e209be6ecb ("scsi: lpfc: Convert SCSI I/O completions to SLI-3 and SLI-4 handlers")
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 1a9343e5b8f2..8446165b15ba 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4093,7 +4093,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 
 	/* Sanity check on return of outstanding command */
 	cmd = lpfc_cmd->pCmd;
-	if (!cmd || !phba) {
+	if (!cmd) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "9042 I/O completion: Not an active IO\n");
 		spin_unlock(&lpfc_cmd->buf_lock);
-- 
2.26.2


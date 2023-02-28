Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 403A6C64ED6
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Feb 2023 04:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjB1Enw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Feb 2023 23:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjB1Enu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2023 23:43:50 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F700CC01
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2023 20:43:49 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id bk32so7008485oib.10
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2023 20:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677559428;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N8YFQuNnreBL5V8vGVgajwk8uB/PFJdo9Gf2qWGXmXY=;
        b=ObcV8zp9xeKnahkuhOx9NrQ7YbjnQWYbPsPyTMHzBZQrKG/44YGmTyt5jKrkmXM+z6
         3iXidaLrN9Lo1aKWLQvfXWACsdwNrGaQKtaRSdt+bMW+FRU6/9AyFgo2jrzzuTRGVcjz
         WnuE60kxt9r5EJ/NuW/23RtyqOoQA/mIfvLnxP4XlD2iVhtQDQus656gED76Q+kUaCGV
         K694o4eBtmjp7kmACTkSwlc+NcNbKTnlbqzozbUbvzG3hFZwxmlg7CSs0Z6XGnzY/F2I
         eOh8HlP4azyZxlagbuQxrOfH2JLLHU63UsURe56/H/2jEnDHhEwg/ymuB6dQ3dQ2GiTK
         Q9/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677559428;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N8YFQuNnreBL5V8vGVgajwk8uB/PFJdo9Gf2qWGXmXY=;
        b=jmX/cnutTDgX194+Ke3p+pJ9UnKlTI66pkcXww7BrdN9kUyRmBWG5UDTz/CRKpc66b
         rM4GERzlDkX3Z8P4bZxmSIf/xOunketsM87sXFSxGOZy6wilySYi+wLsTcadfsvY4sQ0
         tvD5GZSGC8BXvWimtWZBk8c4q8qgBt04wEEoj0wXacUuislN5muaihmbn28jO6jBIJlK
         KAl9Gfk+0lvP37hO8Ux8BUqP2jNZ4gbENNXrL8AqqRAT0fujgnU0ZUO27uxohsp1BKDY
         ggV2RXPz3TQQYFiw5Jwr4KBTVgBjjHYF5sBNpu5wLP7jALCa69EFvEpsr0QGiPin+Frf
         MP8g==
X-Gm-Message-State: AO0yUKU0+zfqMwdfeRX7KbvDr8V5P/7itsx9v4UQNq0Fo0R7a/bNmUMW
        OkScygNuqfwT/Pf7zroEqmxE4cZiacY=
X-Google-Smtp-Source: AK7set8rn/KfHA9IxsJfGGYIxIDVz2WbyRnP+TbYEY6Cmlpcu7AT31O52Gl2rR5LHOWsubOjjI1HzQ==
X-Received: by 2002:a05:6808:1907:b0:37b:8eef:55cf with SMTP id bf7-20020a056808190700b0037b8eef55cfmr1178280oib.1.1677559428538;
        Mon, 27 Feb 2023 20:43:48 -0800 (PST)
Received: from lenny.attlocal.net (172-1-152-64.lightspeed.irvnca.sbcglobal.net. [172.1.152.64])
        by smtp.gmail.com with ESMTPSA id r129-20020acaa887000000b0037fa035f4f3sm3918047oie.53.2023.02.27.20.43.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Feb 2023 20:43:48 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>,
        Kang Chen <void0red@gmail.com>
Subject: [PATCH v2 1/1] scsi: lpfc: add null check of kzalloc in lpfc_sli4_cgn_params_read
Date:   Mon, 27 Feb 2023 20:43:36 -0800
Message-Id: <20230228044336.5195-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If kzalloc fails in lpfc_sli4_cgn_params_read, then we rely on
lpfc_read_object's routine to null check pdata.

Currently, an early return error is thrown from lpfc_read_object to
protect us from null ptr dereference, but the errno code is -ENODEV.

Change the errno code to a more appropriate -ENOMEM.

Reported-by: Kang Chen <void0red@gmail.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 ++
 drivers/scsi/lpfc/lpfc_sli.c  | 4 ----
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7573708..def0b9a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7290,6 +7290,8 @@ void lpfc_host_attrib_init(struct Scsi_Host *shost)
 	/* Find out if the FW has a new set of congestion parameters. */
 	len = sizeof(struct lpfc_cgn_param);
 	pdata = kzalloc(len, GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
 	ret = lpfc_read_object(phba, (char *)LPFC_PORT_CFG_NAME,
 			       pdata, len);
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c5b69f3..c5ad46f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -22109,10 +22109,6 @@ struct lpfc_io_buf *lpfc_get_io_buf(struct lpfc_hba *phba,
 	struct lpfc_dmabuf *pcmd;
 	u32 rd_object_name[LPFC_MBX_OBJECT_NAME_LEN_DW] = {0};
 
-	/* sanity check on queue memory */
-	if (!datap)
-		return -ENODEV;
-
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
-- 
1.8.3.1


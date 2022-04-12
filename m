Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971B8C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbiDLXgO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbiDLXcx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:53 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68278D6B0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:28 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id 12so248586pll.12
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SRmtQAtBGvdTP+tt85PYdOpcLOejxftSaskfLW/2skw=;
        b=mn4/jBAaFZaeYRJVPh9aXOdu+XeVUfcT5W/PPnDo7R5v2xIYBH4oDynKJ1xp3iSEwr
         BJ27VGBcwQq/Bp5qV8qxfbvdM3NES9LEEPnpUBVy3Sv/J7Kr0ig1TA6fe+dwfzDs8YRk
         7zK3EytRApAl7RuTsMiWVAuoLKuvw3ZOjkpm9ZSycWippdeT9Ajfl1SFjoLHJD9PQs+N
         Q78dd/W5ka+nd3CBBziLQY1PfHzf5UegzYbW8Pz06v8rNBpHe3qLaPfbZahEhb5LYGI2
         v8AIF7HEbTOiDQiAG5PuzDxVTQNyVXRCLlULFnxAs4zfuhlmCCGRrJTJSmmr/JmcbzGM
         8bSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SRmtQAtBGvdTP+tt85PYdOpcLOejxftSaskfLW/2skw=;
        b=y8xpY8afonoJuqY8G6AlNHAkDzbGJAUlGc7vgxk6xVgpsb5cIEHRATddYgdLhqjkrS
         5cTUJQ51ROoiPQrNJ2ZBOgK6f0Rb4Vhr/+5EwpeZbVtxo9VUHiL0kcLorZA5VX2n8RSS
         1dNHtVZUI27lpClxN1OcyfY5ATXlhNMnnGUnaezS55sLwRPjTwZGVWvCmVWcSUnQOO8v
         LN0/1z6CKZMRZR3m0evncqrrm9q5GmXld+b/UExtQBKXLFWJmSsfO2zbRNxmQ1OLfsfu
         J0ZLsnESHEXxXeqtWx2rxXm/N7zFBwnaM47ws/9iT2lCwFzSOWn6iPcQAdFn5ezoykhh
         KfBg==
X-Gm-Message-State: AOAM532Aa4M5DKKZ8sbb2uZU/o92IbEk7AFVmFUH0KvnF9f1n955YOAE
        EBrNqcELT6vSN7f+olGr+M2gPBYQpZQ=
X-Google-Smtp-Source: ABdhPJy289U4Qyiaqle1Z4nAcKr1DRcpOq3CH0SVso+ZGIfKqwTGxchDdqxiDKPWA1TQPnglkNsjvw==
X-Received: by 2002:a17:902:e891:b0:158:8b58:b94 with SMTP id w17-20020a170902e89100b001588b580b94mr4484326plg.161.1649802028174;
        Tue, 12 Apr 2022 15:20:28 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:27 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 17/26] lpfc: Remove false FDMI NVME FC-4 support for NPIV ports
Date:   Tue, 12 Apr 2022 15:19:59 -0700
Message-Id: <20220412222008.126521-18-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

FDMI FC-4 Active Type for vports mistakenly shows NVME support.

Fix by adding a check to only set the NVME support bit for the physical
port.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 5f2b2d8eacbf..8df5ba3ed482 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -3153,6 +3153,7 @@ static int
 lpfc_fdmi_port_attr_active_fc4type(struct lpfc_vport *vport,
 				   struct lpfc_fdmi_attr_def *ad)
 {
+	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
@@ -3163,7 +3164,8 @@ lpfc_fdmi_port_attr_active_fc4type(struct lpfc_vport *vport,
 	ae->un.AttrTypes[7] = 0x01; /* Type 0x20 - CT */
 
 	/* Check to see if NVME is configured or not */
-	if (vport->phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
+	if (vport == phba->pport &&
+	    phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
 		ae->un.AttrTypes[6] = 0x1; /* Type 0x28 - NVME */
 
 	size = FOURBYTES + 32;
-- 
2.26.2


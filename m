Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B17DC433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FBF920866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dKycomtH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729805AbfHNX5q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:46 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40815 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729274AbfHNX5o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:44 -0400
Received: by mail-pg1-f193.google.com with SMTP id w10so418090pgj.7
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eLhVuoRrokclWvApSDlim0NTChrXQGYPqDlCbt2IdxY=;
        b=dKycomtH+EOhqBbTzP2vzCgIVA/KVpxmpnBBNFYCHiE31+/AR952nC2C4P/2nz2P1S
         LspPgY1AWt8y0r9j5Klo+KlLeyILcG7A2+4yEyBUeSlzpR3PsckMbM2eLVFIB5xiIO9r
         MF1Zwb0Xutou7q812bINGx11DuRhwazmt1IP8lpLebeeeJFUl4H3kMkXc9jyXEamVPIK
         NkS7fmpnquD4c3y5iQqZXsfKM99cmKVEhOCndvXcE5LUZpaymLNzMdq1wuKHCvJuqSd1
         sXNNlx7jxzO+OOo2BCB+0kQ0mZP0iSGB1sFELeqQ9Ey7jRsBwoCeMDWu18ZSVjwKVnkw
         zXFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eLhVuoRrokclWvApSDlim0NTChrXQGYPqDlCbt2IdxY=;
        b=dbzKKjADLfotzRhlgEYZ9coV4yELPAShcwAibc1gtLt9zFJZnqlFflrkxRiIEkQDKd
         0XWZZS1yPS9zkwR9B4eblrg8qPltmoNz9rHpGy0uITQQNPnjD/L+vPnJilt3dpaWNzD3
         I1fEpOlmBGfm4iHMl3GgIfs3OjF0lHPA053Tcr9b36Gzyg076NT7CiOtjk+u5yw4cS6Q
         1nXMc1gKZqC/CL3V9ms1ww3HkV/hsNpEaAG3ySDwlvt5AgzwSePAj00Q13g/NK8aTbzj
         uymLGWG12cGUTrTmIfr5/7XHoOoATjcuibPXYrdTpM5iaSoW93sq5y8CGm8l6xjNp8jY
         WnKQ==
X-Gm-Message-State: APjAAAWR7BdNhzc7ix2xtfS2RsthZ7Ro9IUYuyHgdc/gxZXqfqAOrEfd
        mXSEppxw+ynbwGuoMV4kCxvdb1m3
X-Google-Smtp-Source: APXvYqzfscBrFw5EmjpnSpfquJOSIq3N+HwcT2Tl+TY93m1mXOMSf1LY7cIxwnzVzMP/zSd5yCrZlg==
X-Received: by 2002:a65:6288:: with SMTP id f8mr1370614pgv.292.1565827063277;
        Wed, 14 Aug 2019 16:57:43 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:42 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 27/42] lpfc: Fix nvme sg_seg_cnt display if HBA does not support NVME
Date:   Wed, 14 Aug 2019 16:56:57 -0700
Message-Id: <20190814235712.4487-28-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver is currently reporting a non-zero nvme sg_seg_cnt value
of 256 when nvme is disabled. It should be zero.

Fix by ensuring the value is cleared.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 98db1f7e536e..1e43890f9ae1 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11697,6 +11697,7 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 			phba->nvme_support = 0;
 			phba->nvmet_support = 0;
 			phba->cfg_nvmet_mrq = 0;
+			phba->cfg_nvme_seg_cnt = 0;
 
 			/* If no FC4 type support, move to just SCSI support */
 			if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP))
-- 
2.13.7


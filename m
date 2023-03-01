Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C43C7EE30
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Mar 2023 23:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjCAXHY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 18:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCAXHW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 18:07:22 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D28532BD
        for <linux-scsi@vger.kernel.org>; Wed,  1 Mar 2023 15:07:21 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id cf14so16214265qtb.10
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2023 15:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677712041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HManWOjPmFUq2jVBu5Nnyv5SDU2R/VQCUqB9Sa7inlM=;
        b=e2abyrabU3jk9rbp2/jG1e5AXL7bo6o7CJUO+lDsw4PwIw2QAfHwB0O7bWStMdLu7Y
         rjPUZTNZhwh4IseypT2Eq3v96WlRB4PWK9QCptce1P0pxaFqDfrQylPU6EzZX2CjxNBd
         agt3w/6GwESqW7vD0ljwtkKUDjNPteUN+4ZE7cZT5ldIdtyJAPdRAKWJg+GdQNxvZsF4
         7+gEPpKQixdcvz28Opz8qUzjrW173IsprGO/7gG4a+Pw/RGdGgxh8rS9HDfBaPuDMG8H
         luVj+s9CWFHcTVFnbh3YBSFJ6Nv2tKg4tP1rOgzeNv+VBCfm5GdqrK0XKI7jL0hoXB3S
         ai7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677712041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HManWOjPmFUq2jVBu5Nnyv5SDU2R/VQCUqB9Sa7inlM=;
        b=lUOS0d8WmF+BXocj88QHEd4FRJNOO6+iBH4ir3WP0EBH9YFe/neB0q+MUhDxsAd+cd
         I6kM0wn5ZJaamq9WRB/1sBfTSDIChx8BEmqzthl/a0eZAnjLsFmZMTem058jpo8/cIpb
         OM9hPfZzFiu28awnMgwCW+NQFpyTqIIQ/TtKIEAo/+4yscAvDk40t8Yh2aGO3+OePWJa
         ohixWehFKln6jAlAkgB1D/6WTu5kTii/z2vWEeq5hM5Edz1su3LXf3nHfXpZL41mJB4C
         avAHoWZIMEmp8DgTHDuoVBysSc+vu0iVBmUqXc2VTFK+k6F6NYCV7Dwfl/R/qe8bAe9y
         rIgA==
X-Gm-Message-State: AO0yUKXgS+HHBccimSYg6ERMoL5un+1V1+mcLuJ7ztNobIaA254/TpDZ
        Qo6K7YltVBr6/xeiT9n9lHfGiQD4VQE=
X-Google-Smtp-Source: AK7set89gM0u9TPC/vt9HKcd8/vrDEPuPcRZCawrTmHZWrYk2ZrSb8AtRDjZJ1olJ7LuhUWoPvkv+Q==
X-Received: by 2002:ac8:5c86:0:b0:3b6:309e:dfe1 with SMTP id r6-20020ac85c86000000b003b6309edfe1mr15763675qta.3.1677712041178;
        Wed, 01 Mar 2023 15:07:21 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9-20020ac85509000000b003b86b99690fsm9047572qtq.62.2023.03.01.15.07.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Mar 2023 15:07:20 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 04/10] lpfc: Record LOGO state with discovery engine even if aborted
Date:   Wed,  1 Mar 2023 15:16:20 -0800
Message-Id: <20230301231626.9621-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230301231626.9621-1-justintee8345@gmail.com>
References: <20230301231626.9621-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A target vendor array reboot in P2P topology can sometimes result in
unsuccessful rediscovery.

Rework the lpfc_cmpl_els_logo routine such that when the LOGO completes
as a failure because of driver abort, the LOGO state is still recorded with
the discovery state machine.

This is a small rework to set LOGO completion without forcing a device
removal state change.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 35b252f1ef73..459e50836853 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3037,15 +3037,16 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 ndlp->nlp_DID, ulp_status,
 				 ulp_word4);
 
-		if (lpfc_error_lost_link(ulp_status, ulp_word4)) {
+		if (lpfc_error_lost_link(ulp_status, ulp_word4))
 			skip_recovery = 1;
-			goto out;
-		}
 	}
 
 	/* Call state machine. This will unregister the rpi if needed. */
 	lpfc_disc_state_machine(vport, ndlp, cmdiocb, NLP_EVT_CMPL_LOGO);
 
+	if (skip_recovery)
+		goto out;
+
 	/* The driver sets this flag for an NPIV instance that doesn't want to
 	 * log into the remote port.
 	 */
-- 
2.38.0


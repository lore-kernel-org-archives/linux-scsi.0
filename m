Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9475EB64D8
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 18:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjFNSAs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 14:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjFNSAi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 14:00:38 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA67AC7
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 11:00:37 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 46e09a7af769-6b2d6da8c26so441506a34.1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 11:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686765637; x=1689357637;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=88phL2MiZJ0VYW8vGMEiRCKdWjZZS1290FCIMpA4y50=;
        b=HlgR2hUDHaUsEicCHp4Bqde37QvuAMG9BqF/3KSpLfN3B947fTPiVzWdqjRlMvNDN2
         dJCRP6hE/4XQo+pKOxuYLd/+vTw37dsX9VcLbsODziH+q9iYOuzX+Ll2d+8aBaJcLSHX
         NnkCh1OfbLViaxhFW6xrJYZwpX+p8nOvBM+v90KEnwJrw7langc5i/cr9TK/wI3o5byh
         tH2Re0cjfhS3MrweSeT/hZ700sKHV2Gog66WEuitYdlvmeI4ji7inPgNRwxEqmfXcqfI
         uJGyvJnqJj1eWLAUrYUqeonoJUuInTWW5OB0Y+JNurs+xZZWt5ZRfiZpEyUHAlqM6xmq
         tBIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686765637; x=1689357637;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=88phL2MiZJ0VYW8vGMEiRCKdWjZZS1290FCIMpA4y50=;
        b=YA/1x/zVTj1bcgmhb1nRSLu05aXzHFm+6WZc6NzeTTwGYDVYNyhRAyhLC4dRlGIUEX
         jsldIQ18cd0XWCitjeSC2S5RYqqMRM0/DoU+C9z1mMH+PN1iVdB1p1xz0CiKLZF4EMYs
         V+OiKkKJyg2ppJEfjlSWc+ZjeEpD6KDbGm1YTPFMsp0NJo+4FId34mXfAdKfkvYq58jt
         LmaEP0e5bDWmTf4UTGHrmT0qXzS3mCQWMnvA6oIJ6BO9cD4Z6kQKEWOkPN7vnocjkMWe
         64i0ZKNeYht3+juwBQk53ZA7zVeBE2RZDEn5FuZ1NyAI73jG6hDW48i9PU7KST7GYwkv
         TWmQ==
X-Gm-Message-State: AC+VfDxca+UvbEdMSupCJFsQchSUN3w7a0TaFsTbM5AFWfQhhYCQP/Ap
        esowGwvBjyExvDRygJBguvVzrHPP6CS6MA==
X-Google-Smtp-Source: ACHHUZ7TI7GVw7mOeXw3xbsDnHb4fxSRmaABOUvxluxgNSEK5TtZ5et7msQdrD0EQd71cAKTv/gVXA==
X-Received: by 2002:a05:6830:a94:b0:6af:8ab6:7b1e with SMTP id n20-20020a0568300a9400b006af8ab67b1emr9763036otu.0.1686765636951;
        Wed, 14 Jun 2023 11:00:36 -0700 (PDT)
Received: from localhost.localdomain ([2600:380:4a65:92f3:3ed:7ba2:d6fd:c3d5])
        by smtp.gmail.com with ESMTPSA id g5-20020a05690203c500b00b9eeffa1abfsm3631652ybs.39.2023.06.14.11.00.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Jun 2023 11:00:36 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 1/1] lpfc: Fix incorrect big endian type assignment in bsg loopback path
Date:   Wed, 14 Jun 2023 10:59:44 -0700
Message-Id: <20230614175944.3577-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The kernel test robot reported sparse warnings regarding incorrect type
assignment for __be16 variables in bsg loopback path.

Change the flagged lines to use the be16_to_cpu and cpu_to_be16 macros
appropriately.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306110819.sDIKiGgg-lkp@intel.com/
---
 drivers/scsi/lpfc/lpfc_bsg.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 9a322a3a2150..595dca92e8db 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -889,7 +889,7 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			struct lpfc_iocbq *piocbq)
 {
 	uint32_t evt_req_id = 0;
-	uint32_t cmd;
+	u16 cmd;
 	struct lpfc_dmabuf *dmabuf = NULL;
 	struct lpfc_bsg_event *evt;
 	struct event_data *evt_dat = NULL;
@@ -915,7 +915,7 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 	ct_req = (struct lpfc_sli_ct_request *)bdeBuf1->virt;
 	evt_req_id = ct_req->FsType;
-	cmd = ct_req->CommandResponse.bits.CmdRsp;
+	cmd = be16_to_cpu(ct_req->CommandResponse.bits.CmdRsp);
 
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	list_for_each_entry(evt, &phba->ct_ev_waiters, node) {
@@ -3186,8 +3186,8 @@ lpfc_bsg_diag_loopback_run(struct bsg_job *job)
 			ctreq->RevisionId.bits.InId = 0;
 			ctreq->FsType = SLI_CT_ELX_LOOPBACK;
 			ctreq->FsSubType = 0;
-			ctreq->CommandResponse.bits.CmdRsp = ELX_LOOPBACK_DATA;
-			ctreq->CommandResponse.bits.Size   = size;
+			ctreq->CommandResponse.bits.CmdRsp = cpu_to_be16(ELX_LOOPBACK_DATA);
+			ctreq->CommandResponse.bits.Size   = cpu_to_be16(size);
 			segment_offset = ELX_LOOPBACK_HEADER_SZ;
 		} else
 			segment_offset = 0;
-- 
2.38.0


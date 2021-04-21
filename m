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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 090A9C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 23:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCA9E613DC
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 23:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240975AbhDUXp0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 19:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237429AbhDUXp0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 19:45:26 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF464C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 16:44:52 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id w6so15859934pfc.8
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 16:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rp7iu/FAqkEIoUxz6dPO0hiEmqU/X2aKGCajVMcyrfU=;
        b=a0x8yd9mL3jxVduJ8/H3gM5ccV6oNlAVYlI1eHFOdHoVg5lSB3L2WgACt5PoZRTHIK
         PlRPu9VMEZgeZF/B2bmJx/9Dakqt5XPkLwd4/KbfzSWhztYRRKlZbsILMhYkdmLQAzNz
         Rv+LEXPo/hMpAbGTq2/BRNpbVBYFCBPS7bMP5yyQJO+6f+/Mx5JQ0ZUo1gRLEFQuesrZ
         Ok2PUpjRk/lVPNmc3IPrknyzV1TpS7LVrGqpZzbFDJs9TTjJG26pY2EhoHOgUwIXSE3w
         RXfmjlOdpnXDoSBJtXL4mbsKUDgwVHb6gXjU79RpUqOta2jZ/QgqHPjH6hPryLPhyJyD
         ZFsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rp7iu/FAqkEIoUxz6dPO0hiEmqU/X2aKGCajVMcyrfU=;
        b=IoN/GFLyi4SAOGwj0Uuh+OiAqadQt7la/lAjrQ67AFmjmCjEqGrg/rJa8/kZxUGPeF
         vs0ggC7P5hT5OYo5S1j3l+wYKecuPyvKHklNAKaO20RAdAzwUZP/btgU1WC/T72umNk4
         i9REh1EtHbpdIQdLVRa8JkNeQePZ+EoW8UegPjqCQ1VsTKDHv5ekD22zAj6ZyPy8UXYG
         cM17MTSfkZ3+qk2AxqpkYoMlqSB0WjEM1VTZkNdait85PsuedeLFodhMFmkNzpbpiH6W
         jW7eZE+9sReTKiPGprTrCWAeDf2Nr9xg3andL9OI1WdM1OyJ0J9uXGOyRJOFluG2LheU
         HFtw==
X-Gm-Message-State: AOAM530zwpc5lwHjoz3Cq54ZSdi6XXHHFSMahdU/8QQN0ka7A8xrExBn
        z56U4HD1ludfBLWmOetmF5YWr8NL2/8=
X-Google-Smtp-Source: ABdhPJyfIVkAKaKhaf9krI1WSFq1hEDkYbbAwBC4k9ukY/cq3CQ8j4j0Zt33bK3BxWCW7YofvnawTw==
X-Received: by 2002:a62:7944:0:b029:253:f31f:fad5 with SMTP id u65-20020a6279440000b0290253f31ffad5mr593403pfc.43.1619048692335;
        Wed, 21 Apr 2021 16:44:52 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c193sm329500pfc.11.2021.04.21.16.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 16:44:52 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH][REPOST] lpfc: Fix dma virtual address ptr assignment in bsg
Date:   Wed, 21 Apr 2021 16:44:48 -0700
Message-Id: <20210421234448.102132-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

lpfc_bsg_ct_unsol_event routine acts assigns a ct_request to the
wrong structure address, resulting in a bad address that results
in bsg related timeouts.

Correct the ct_request assignment to use the kernel virtual buffer
address (not the control structure address).

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
 drivers/scsi/lpfc/lpfc_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index c2776b88d493..38cfe1bc6a4d 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -934,7 +934,7 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	INIT_LIST_HEAD(&head);
 	list_add_tail(&head, &piocbq->list);
 
-	ct_req = (struct lpfc_sli_ct_request *)bdeBuf1;
+	ct_req = (struct lpfc_sli_ct_request *)bdeBuf1->virt;
 	evt_req_id = ct_req->FsType;
 	cmd = ct_req->CommandResponse.bits.CmdRsp;
 
-- 
2.26.2


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC884C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Mar 2022 20:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240826AbiCWU53 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Mar 2022 16:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239385AbiCWU50 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2022 16:57:26 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2099A8B6C7
        for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2022 13:55:56 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id z128so2172084pgz.2
        for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2022 13:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F4xUjka7VgCXSVu4TpGpu5Q5hXqYQhaOUslri8F6FtE=;
        b=Jh5ZJRmdvdzB95LuMBJ9JSKkpXSMvMGAQWG3AAHB0ZeBXgzCIJuJgr23Gt3Sdh6i1c
         2IVtQE8BmfaZHvk2ViZgjT/SVMKpO73LqebcHF7MdxryeCQ6zK3wATc6DzGV4goGe12e
         XJ+EVGlPqRaUtQkWs40+gSy0y2DFBTEVChV1SDMRbEFCQH3QN0DxNOg8degVFBEMdbzL
         YVjuscLCwNKEHL1Ge3BNMjS0oTa8x10mRSUSjPJaNqS4HYBFoTC98Z5LqAMITNKro5y+
         FAVCW5agkfwGCfI3kCsaJSI5djGh3OR+nVBIZF8ST/aJh+IhP5tMViOKwgxRKyU0FthT
         4F2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F4xUjka7VgCXSVu4TpGpu5Q5hXqYQhaOUslri8F6FtE=;
        b=qbe1RS4uvtiVcCQr34JhHzrkJUaByoSPeCrlVAA/mMaKVIY8bC3h9vAjHeunpFInUP
         VMfRCjVnRixWkM8+eSQYHy5Gq0Ou7i7mUjlZmTzZfvwkBVoJ3X+zJ+vzp3l4rKcjyGAr
         d+6Es3WHELmUXXNHxts9+noNJlcAeCyXr15F7eB6WigF5eKIn5GpObJfy7UwxQCzfEh1
         GMH7mq+Mv0LWR6Q1x7DVaMxGc5OIT0+/AmRUWqdDvG+b5qeHep5Bv8QAhoS4sxAqxgXD
         kVOsLogAImpgzcJhhqco+hoZHebAeixWL4rarEbA5H4XXqfOqVJ8H2eIGO+DIS3Z5G3p
         7BjQ==
X-Gm-Message-State: AOAM530A2pV+I7/A4rj6avU7ygQiEl0kHJ4I33MTyDTLBZ/V0MfAi1Bk
        5E3dGvGyD7ihCnoLPYE9dxqrNb9CiGs=
X-Google-Smtp-Source: ABdhPJy9XrbmSMr/fE4QSJr6rpw0ogDJ8i7zH43Z/GTbMzCl+UDOZNZl0M0xzS0HpiTO2HWPt6Eqig==
X-Received: by 2002:a05:6a00:1acd:b0:4fa:778f:8570 with SMTP id f13-20020a056a001acd00b004fa778f8570mr1360604pfv.75.1648068955505;
        Wed, 23 Mar 2022 13:55:55 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x7-20020a056a00188700b004fae6f0d3e5sm600521pfh.175.2022.03.23.13.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 13:55:55 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 2/2] lpfc: Fix locking for lpfc_sli_iocbq_lookup
Date:   Wed, 23 Mar 2022 13:55:45 -0700
Message-Id: <20220323205545.81814-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220323205545.81814-1-jsmart2021@gmail.com>
References: <20220323205545.81814-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The rules changed for lpfc_sli_iocbq_lookup vs locking. Prior, the
routine properly took out the lock. In newly refactored code, the locks
must be held when calling the routine.

Fix lpfc_sli_process_sol_iocb() to take the locks before calling the
routine.

Fix lpfc_sli_handle_fast_ring_event() to not release the locks to call
the routine.

Fixes: 1b64aa9eae28 ("scsi: lpfc: SLI path split: Refactor fast and slow paths to native SLI4")
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 20d40957a385..b6a0da28b00f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3715,7 +3715,15 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	unsigned long iflag;
 	u32 ulp_command, ulp_status, ulp_word4, ulp_context, iotag;
 
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		spin_lock_irqsave(&pring->ring_lock, iflag);
+	else
+		spin_lock_irqsave(&phba->hbalock, iflag);
 	cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring, saveq);
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		spin_unlock_irqrestore(&pring->ring_lock, iflag);
+	else
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
 
 	ulp_command = get_job_cmnd(phba, saveq);
 	ulp_status = get_job_ulpstatus(phba, saveq);
@@ -4052,10 +4060,8 @@ lpfc_sli_handle_fast_ring_event(struct lpfc_hba *phba,
 				break;
 			}
 
-			spin_unlock_irqrestore(&phba->hbalock, iflag);
 			cmdiocbq = lpfc_sli_iocbq_lookup(phba, pring,
 							 &rspiocbq);
-			spin_lock_irqsave(&phba->hbalock, iflag);
 			if (unlikely(!cmdiocbq))
 				break;
 			if (cmdiocbq->cmd_flag & LPFC_DRIVER_ABORTED)
-- 
2.26.2


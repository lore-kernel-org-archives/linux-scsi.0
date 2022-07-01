Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE9B9CCA479
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 21:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbiGAVPL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 17:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiGAVPG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 17:15:06 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC2B3F325
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 14:15:05 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id p11so2696618qkg.12
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2022 14:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o1BoedHY+/BUpNs4HUOtEZDRirjp+gbUbvFbEaPAn1o=;
        b=IdKUx1f+SQiVcuHPZ1cKdqSVehKKhYLJfgmSKF2KpoeC7sOsXjtcbRa/tLj+12Fu0A
         j3HhWAwS6B1M7+YeFKKZjX5vU8ylxhZRPpZ4qmhFvCl6ws29JMTnLocFwu3zJZDOX+b/
         8c7fiY1n1HDoLUImFmPtkMTM3za5Fg6ivCnxW33d7HQbA48gSO0hInWgSfdFaxOteJY1
         FyNxizWSK8ZGMqyEGoH32NgTkJ5thTV7ndo+FumOMO07lEc9qXKhjOCSf+3IWYB0EpQ7
         87sq+sW41J9wCcVEf4/pOWNLummJksySMLegDQA1BORqtk24FIjOVUhak5XXrQGSy+R3
         VwfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o1BoedHY+/BUpNs4HUOtEZDRirjp+gbUbvFbEaPAn1o=;
        b=kA2lkkdYkJFj/iaKcrRDRC+ExA+zkzYRToYjp8PLZpXpwCli9lCt4JrFPn5UEHaHXY
         IfbkVVj/GpsonjXcxZeWelDmRBcE9R4phEg/OU+rReJEStM/7Oj8pMCa8xDcjlXyrOQj
         fxgcR1ejvePD2HFhKZh37FHiDMowJLzwQQXuZVAMIPJjZyNwRUUJydz99VuuZCP8QowM
         vIcTTJBbltFpGf8rnQCGUVvVQNzUfm4V2oIYvfv9qCO1qYdhshHnoFsn2ZBa4RPx3sD8
         XlrENQ5AVLGrtaltVOaXfSkU+6/9EuyUO9E57RQjK0U/BOtm4TfIY1y73yMJ7Xq+LMZm
         fguQ==
X-Gm-Message-State: AJIora/G0Lrw15fmfj0JGhJbnFGEzKbAjf+C4wzMGYUKwVrPHdaScVsB
        4catr6bJeaGZQg+AfZoj6wMwVlGQZc0=
X-Google-Smtp-Source: AGRyM1v73Ax9N4Ao5FximnN8zoRd8Tb4EfrFscgeQW+h8UdQnxQn9QADwrRus+BARCJH+iyHuGYq7g==
X-Received: by 2002:a05:620a:2682:b0:67e:1a58:c947 with SMTP id c2-20020a05620a268200b0067e1a58c947mr12486888qkp.650.1656710104715;
        Fri, 01 Jul 2022 14:15:04 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g6-20020ac842c6000000b00317ccc66971sm14584509qtm.52.2022.07.01.14.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 14:15:04 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 05/12] lpfc: Fix possible memory leak when failing to issue CMF WQE
Date:   Fri,  1 Jul 2022 14:14:18 -0700
Message-Id: <20220701211425.2708-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220701211425.2708-1-jsmart2021@gmail.com>
References: <20220701211425.2708-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no corresponding free routine if lpfc_sli4_issue_wqe fails to
issue the CMF WQE in lpfc_issue_cmf_sync_wqe.

If ret_val is non-zero, then free the iocbq request structure.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 98fef6353b60..81c61d377e43 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2003,10 +2003,12 @@ lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total)
 
 	sync_buf->cmd_flag |= LPFC_IO_CMF;
 	ret_val = lpfc_sli4_issue_wqe(phba, &phba->sli4_hba.hdwq[0], sync_buf);
-	if (ret_val)
+	if (ret_val) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
 				"6214 Cannot issue CMF_SYNC_WQE: x%x\n",
 				ret_val);
+		__lpfc_sli_release_iocbq(phba, sync_buf);
+	}
 out_unlock:
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	return ret_val;
-- 
2.26.2


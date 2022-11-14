Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A451AC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Nov 2022 23:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235468AbiKNXau (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Nov 2022 18:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbiKNXat (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2022 18:30:49 -0500
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB3D20E
        for <linux-scsi@vger.kernel.org>; Mon, 14 Nov 2022 15:30:49 -0800 (PST)
Received: by mail-pj1-f53.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso15275383pjg.5
        for <linux-scsi@vger.kernel.org>; Mon, 14 Nov 2022 15:30:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qhpsSRd+sh7fMuBpCA+5Kp+5Usq20ul1RE111qw+YEQ=;
        b=aFimFCx7D8iu5llK1EDw0UMjnL4onQFgy9EJgKpHAzolhSksiHRx3Ybrqrg/rbOS+u
         6n10Pl0O2hgOMAlwYBSYT+CUTOtOP11Cl9iskwAd/jbVFajX8l2K4EzZKs5epkI1MuqU
         J46o1YjVGNJhTPlmjNLGgoP1EpL2mglWuWOEA+zSG3UZg2bH2VFtwnLv4RX6PO+IJys3
         R7JgTl/9rXS/ZLSRBZZQj8zGUYvvMTXAjAkWjacNL0nEmnz+/HtCIdtGx3l1zIvs+TG1
         d7V/7nRbyJ26u8sYC5ow+2urRvBgiz8Ie2x0ELaEoGgzHTDK6XAXupKOXT9PyJBahiBm
         +XGQ==
X-Gm-Message-State: ANoB5plFphi3vb+hTVB9zu3aGsOZmrRoJliPI0JuWQqpfws3cKKgA0cE
        gE3vEvb4fckKZAouoUsAm+o=
X-Google-Smtp-Source: AA0mqf7hwtc+4OKZtpaheIrQf5Y5psSCKtL0txu5lLEwoJkAHJTnYmi28VsCQMVcTIuNQ696NBL2wg==
X-Received: by 2002:a17:90b:3949:b0:214:1648:687d with SMTP id oe9-20020a17090b394900b002141648687dmr15982171pjb.78.1668468648526;
        Mon, 14 Nov 2022 15:30:48 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:637b:9535:5168:c84f])
        by smtp.gmail.com with ESMTPSA id p13-20020a17090b010d00b002009db534d1sm7083235pjz.24.2022.11.14.15.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 15:30:47 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH] scsi: ufs: Fix the polling implementation
Date:   Mon, 14 Nov 2022 15:30:38 -0800
Message-Id: <20221114233042.3199381-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.493.g58b659f92b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Certain code in the block layer assumes that requests submitted on a
polling queue (HCTX_TYPE_POLL) are completed in thread context. Hence
this patch that modifies ufshcd_poll() such that only requests are
completed for the hardware queue that is being examined instead of all
hardware queues. The block layer code that makes this assumption is the
bio caching code. From block/bio.c:

    If REQ_ALLOC_CACHE is set, the final put of the bio MUST be done
    from process context, not hard/soft IRQ.

The REQ_ALLOC_CACHE flag is set for polled I/O (REQ_POLLED) since
kernel v5.15. See also commit be4d234d7aeb ("bio: add allocation cache
abstraction").

Fixes: eaab9b573054 ("scsi: ufs: Implement polling support")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 05925939af35..f80d09aea669 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5430,6 +5430,7 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	struct ufs_hba *hba = shost_priv(shost);
 	unsigned long completed_reqs, flags;
 	u32 tr_doorbell;
+	int tag;
 
 	spin_lock_irqsave(&hba->outstanding_lock, flags);
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
@@ -5437,6 +5438,18 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
 		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
 		  hba->outstanding_reqs);
+	for_each_set_bit(tag, &completed_reqs, hba->nutrs) {
+		struct ufshcd_lrb *lrbp = &hba->lrb[tag];
+
+		if (lrbp->cmd) {
+			struct request *rq = scsi_cmd_to_rq(lrbp->cmd);
+			u32 unique_tag = blk_mq_unique_tag(rq);
+			u16 hwq = blk_mq_unique_tag_to_hwq(unique_tag);
+
+			if (hwq != queue_num)
+				__clear_bit(tag, &completed_reqs);
+		}
+	}
 	hba->outstanding_reqs &= ~completed_reqs;
 	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
 

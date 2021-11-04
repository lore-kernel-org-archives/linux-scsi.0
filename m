Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDF1C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 18:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15098611EF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 18:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhKDSNq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 14:13:46 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:44015 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbhKDSNp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 14:13:45 -0400
Received: by mail-pl1-f179.google.com with SMTP id y1so8571743plk.10
        for <linux-scsi@vger.kernel.org>; Thu, 04 Nov 2021 11:11:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kPYC5wSvfCLZfPyQy3TiIiAFSRQFmdMtzG5OFNlfgfI=;
        b=SESeYOM3+HBNAlJdeWV7QrBUZYHWOW+GND006L2HSwnxjwyjrGUO/1fVFENrvEWVVk
         XNcEepVEbTMHN4A1qzdwy4WOheIqoiITz7DdxW7JlIHWxAQ2NVT7SLlxXJ6J5KduPP2p
         Nd3QL+CEOkM2V8A8JFQJmVfFDS23voyRBHHpqWnjromHub/k9jPXCtytJNNp7pNs7oPI
         PvNK3T6wDID4VM9WCHXkjuk3gsXNJXObo/pVLaqkNdBma6o+KDxapWqmjp9dta9jwvvy
         1nxUwYlzyLJ5PskBnSBxSiAVY278Cq2B0X75taedP+oNrnCcT42HUVcOs6hdGKRXJmwn
         85MQ==
X-Gm-Message-State: AOAM533xOHLTQRZEvT2PmX9xjId5c7ruuNNJX+kl7WZpRROCfKVygamV
        Pc+cL0qRdlTeuo+PwWi5p/s=
X-Google-Smtp-Source: ABdhPJyAYRj8yDwNvnyLhaHMfTv7mv1gIAeNikZWR+UmYzKHh/aGvSMp8p89ZbRGFcg/JQybfjPa3A==
X-Received: by 2002:a17:90b:4b43:: with SMTP id mi3mr23973658pjb.27.1636049466648;
        Thu, 04 Nov 2021 11:11:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6f63:8570:36af:9b56])
        by smtp.gmail.com with ESMTPSA id nr14sm4425525pjb.24.2021.11.04.11.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 11:11:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        Vishak G <vishak.g@samsung.com>,
        Girish K S <girish.shivananjappa@linaro.org>,
        Santosh Yaraganavi <santoshsy@gmail.com>
Subject: [PATCH] scsi: ufs: Improve SCSI abort handling
Date:   Thu,  4 Nov 2021 11:10:53 -0700
Message-Id: <20211104181059.4129537-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following has been observed on a test setup:

WARNING: CPU: 4 PID: 250 at drivers/scsi/ufs/ufshcd.c:2737 ufshcd_queuecommand+0x468/0x65c
Call trace:
 ufshcd_queuecommand+0x468/0x65c
 scsi_send_eh_cmnd+0x224/0x6a0
 scsi_eh_test_devices+0x248/0x418
 scsi_eh_ready_devs+0xc34/0xe58
 scsi_error_handler+0x204/0x80c
 kthread+0x150/0x1b4
 ret_from_fork+0x10/0x30

That warning is triggered by the following statement:

	WARN_ON(lrbp->cmd);

Fix this warning by clearing lrbp->cmd from the abort handler.

Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3b4a714e2f68..d8a59258b1dc 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7069,6 +7069,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto release;
 	}
 
+	lrbp->cmd = NULL;
 	err = SUCCESS;
 
 release:

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E870AC4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF9E061078
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242893AbhHETT2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:28 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:36395 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242802AbhHETTY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:24 -0400
Received: by mail-pj1-f49.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so17324015pjr.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wjHPmJeqPk5ydGEPAsbeM+wR0ly8Ex7oFJ5KgXs11aQ=;
        b=CYWwhJYfPxilRjOzokGQUh6kzjDRp7OoAlxkAev9fR2V0H1tAX1MA4pTdtGyRCqDsn
         0zRvfwRE+VoQEPITwPV0vvAEELsanGkqLeBI4hHcAqu7oHtp2xhkA2uBSRH1yRHkAf5D
         uN/vca/u5hs00J7cRZtn2teCSNa5uMfAKPMBziONOefXNFB/m1HEQvHFhabi8mEZTPmp
         oY8Z75GeCOKPIFMQkzPrZhuR/+cxuJYGb693BfuymZ9y22Qr7mMTztdoYpyQaJXiV3Pf
         pjw4C4osOfkSxBEnKQo0Wb17SmO2CLkEgI4nD/QIH89dUU0SZwheRLSdzn4FqA1iLOGu
         RuvA==
X-Gm-Message-State: AOAM530BH3rwELkaiIgmSnoD6kFwX+Bk6nFymT+V6YeJ6+s/6znK8yjb
        bpjWZ+i3LSUWBq3UwJQUQEw=
X-Google-Smtp-Source: ABdhPJz9ZpKlnjShrW5TWE5i+7d7lBbJiM3oxDz3wCsO01+afoOMW7T/nfQivpRQ4WoQRbnrS8t9bg==
X-Received: by 2002:a63:6645:: with SMTP id a66mr604905pgc.339.1628191149560;
        Thu, 05 Aug 2021 12:19:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH v4 17/52] csiostor: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:17:53 -0700
Message-Id: <20210805191828.3559897-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/csiostor/csio_scsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 56b9ad0a1ca0..3b2eb6ce1fcf 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1786,7 +1786,7 @@ csio_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmnd)
 	struct csio_scsi_qset *sqset;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 
-	sqset = &hw->sqset[ln->portid][blk_mq_rq_cpu(cmnd->request)];
+	sqset = &hw->sqset[ln->portid][blk_mq_rq_cpu(scsi_cmd_to_rq(cmnd))];
 
 	nr = fc_remote_port_chkready(rport);
 	if (nr) {
@@ -1989,13 +1989,13 @@ csio_eh_abort_handler(struct scsi_cmnd *cmnd)
 		csio_info(hw,
 			"Aborted SCSI command to (%d:%llu) tag %u\n",
 			cmnd->device->id, cmnd->device->lun,
-			cmnd->request->tag);
+			scsi_cmd_to_rq(cmnd)->tag);
 		return SUCCESS;
 	} else {
 		csio_info(hw,
 			"Failed to abort SCSI command, (%d:%llu) tag %u\n",
 			cmnd->device->id, cmnd->device->lun,
-			cmnd->request->tag);
+			scsi_cmd_to_rq(cmnd)->tag);
 		return FAILED;
 	}
 }

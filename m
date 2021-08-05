Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E523C4320E
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57BDA6112F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242802AbhHETTn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:43 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:41705 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242634AbhHETTg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:36 -0400
Received: by mail-pj1-f41.google.com with SMTP id u5-20020a17090ae005b029017842fe8f82so2728362pjy.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i2V8/BN2iPNBw51OsSyudNN7wtqGW0C1CVr1gqNgEZw=;
        b=T1NYox9IWclXONo5zSLOfz32yi3bqrLf4hIHYRfPidvCKfEGygnvpCyyT/xMIZDC/q
         kIoZfUCByGyr2mSmPSR+XW6A2fxYAP1dIju+2Uyfh0lal+HiKENkrqbcNHnARw6Bm/Xo
         kmOWiHn6GKrG2McddKMdIXDZ5QDR1rwxuN/ksByWL4kGEpiz0hvXnBcN0HS+QEctcshi
         8rXzce3vyELVRLDLfgyYjDRhUVaXrjWBs1vi3XsOHpIe3+JvNefzsJ8f+DBa+fwQtOjx
         O/bd47CBQSd5zjUJJ/tJlGn2kLSD5apM0p88z1tXPUmSJl4xkLZ+oKyaaGtOAKvLBnbR
         jBeQ==
X-Gm-Message-State: AOAM530+iEDP9M80pm5NbTaO3Y2H6OC+z3+8kVH5m1JEX5nOyJ7NUBZB
        ONBbjhHtmjZxMwo/2VMv9QU=
X-Google-Smtp-Source: ABdhPJwxJfnn3Fy0OMPPkNpIIeVjsItUsMBzpBl7EMzOwFNAN7/SIPA2BHn0/61WRXo9W8hOSBFxxg==
X-Received: by 2002:a05:6a00:84e:b029:3ae:5c9:a48d with SMTP id q14-20020a056a00084eb02903ae05c9a48dmr970287pfk.20.1628191160450;
        Thu, 05 Aug 2021 12:19:20 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 23/52] ibmvfc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:17:59 -0700
Message-Id: <20210805191828.3559897-24-bvanassche@acm.org>
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
 drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index bee1bec49c09..c372bbc5e218 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1911,7 +1911,7 @@ static int ibmvfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	struct ibmvfc_cmd *vfc_cmd;
 	struct ibmvfc_fcp_cmd_iu *iu;
 	struct ibmvfc_event *evt;
-	u32 tag_and_hwq = blk_mq_unique_tag(cmnd->request);
+	u32 tag_and_hwq = blk_mq_unique_tag(scsi_cmd_to_rq(cmnd));
 	u16 hwq = blk_mq_unique_tag_to_hwq(tag_and_hwq);
 	u16 scsi_channel;
 	int rc;

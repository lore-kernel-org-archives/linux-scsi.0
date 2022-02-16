Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B7EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiBPVEB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:04:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbiBPVDo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:03:44 -0500
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467082221A9
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:31 -0800 (PST)
Received: by mail-pg1-f176.google.com with SMTP id 75so3179145pgb.4
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mPpFGanc5O2VtDF8xLPur0DYQVt1vugjv+KVWyukjrk=;
        b=rwu3uX21XhuswxuSwvf4aTjLRu6eDVw1nL/XFYfRaWwKIS/6Djez9Gjdhe9JGfdqgS
         YGLQ+MgwqAa2kjYtMUsh/sfJW3Ec98ds5m2ayJ4w/GBrBQ1SLJTMoTtbFmekmdOv8o2b
         ZkuHlGDdRIilM4mJrqeJoIubwFdKcmIGezskaLaKGpd4yDGorJOYaRi5sNNibVUje5UI
         FwwG2DXGKiHk84wUu20OlPl19EEdeoLR+IDwz5pFUmhsVSD53jkzb9Egexf1awcU3gIV
         wTYxN1P+0wZ8yRS/iu1lEO96UHSWKFwOtlvH3A8VlRz5uoVbHwOhvRfu86pa6Hz4hIR6
         UvuQ==
X-Gm-Message-State: AOAM531doLX/VHoLk1dUVRStKg4u9ZpB5XiryRqQ88nUNojpCshx4seI
        2hXooTa0GRZL3+P9bFwNd39SnWnCJRlTnEtS
X-Google-Smtp-Source: ABdhPJz7w7AL1ErBJAbWyzHswSZn5OEHTEdocTWtA8xnj5f2UqLAllmaXP2Ip2Akn7De4UCYvieoAQ==
X-Received: by 2002:a62:770a:0:b0:4e0:2547:9219 with SMTP id s10-20020a62770a000000b004e025479219mr4864800pfc.43.1645045410602;
        Wed, 16 Feb 2022 13:03:30 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:03:29 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hiral Patel <hiralpat@cisco.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH v4 22/50] scsi: fnic: Fix a tracing statement
Date:   Wed, 16 Feb 2022 13:02:05 -0800
Message-Id: <20220216210233.28774-23-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Report both the command flags and command state instead of only the
command state.

Cc: Hiral Patel <hiralpat@cisco.com>
Fixes: 4d7007b49d52 ("[SCSI] fnic: Fnic Trace Utility")
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fnic/fnic_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 88c549f257db..549754245f7a 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -604,7 +604,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc)
 
 	FNIC_TRACE(fnic_queuecommand, sc->device->host->host_no,
 		  tag, sc, io_req, sg_count, cmd_trace,
-		  (((u64)CMD_FLAGS(sc) >> 32) | CMD_STATE(sc)));
+		  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
 
 	/* if only we issued IO, will we have the io lock */
 	if (io_lock_acquired)

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D78C432BE
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62DDE60F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236940AbhHIXFH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:07 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:41797 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236986AbhHIXFB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:01 -0400
Received: by mail-pj1-f49.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so2489487pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eMqFVEuFWl1HmCq0tOtP+C4GAxmEPY2IcI6/DJJ1ex8=;
        b=Rg7S3sq6yqcbHiYAnlRnv4wi7dLJC0vt7VRQBZobih8rpLp729EN12HKNpaGpnSB/4
         xTlNeLCyykrqgntuKWopnb3FatXiYox55bcqv1mvrOfwG9MhX+OfiZ3rK9/WXTUxUJw0
         evhDVTP3CKPBa9AmB8B/mO8LtumOBqgB2hNLLeyBK9nv6IRCsxFHhVxcW5KeAYrLaFgO
         xGO+GajA2nfvP5S2a7T6e3SdMZyDjy01scXv7/RG6j8BjKqQxAj7M86NfKdG4M807H3C
         xqUWejg25H9MEf/5BpoFu22WHnPl9NIc2QlaCq0SCfO1bE9vBFp6QaV2vvt0HsABEKRt
         M9ZQ==
X-Gm-Message-State: AOAM530Ne2kCkQ3K32eJ7D6NN0mRmhGLEgxQb9pS+zdk0m4GySu3neWw
        xKeaIkKGap9XV+hKehkJ3uY=
X-Google-Smtp-Source: ABdhPJzpXFMscmcm4WEr2VsMwzEHXmYnEcFxjvklmszPXCYSTZQahCVyy+6nfHOPUyrW8jj1ooBQ5Q==
X-Received: by 2002:a17:90a:cc8:: with SMTP id 8mr28581804pjt.194.1628550279946;
        Mon, 09 Aug 2021 16:04:39 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 24/52] ibmvscsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:27 -0700
Message-Id: <20210809230355.8186-25-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index e6a3eaaa57d9..50df7dd9cb91 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1072,7 +1072,7 @@ static int ibmvscsi_queuecommand_lck(struct scsi_cmnd *cmnd,
 	init_event_struct(evt_struct,
 			  handle_cmd_rsp,
 			  VIOSRP_SRP_FORMAT,
-			  cmnd->request->timeout/HZ);
+			  scsi_cmd_to_rq(cmnd)->timeout / HZ);
 
 	evt_struct->cmnd = cmnd;
 	evt_struct->cmnd_done = done;

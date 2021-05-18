Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E30C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9330611AC
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351262AbhERRqo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:44 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:36654 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351261AbhERRqm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:42 -0400
Received: by mail-pf1-f169.google.com with SMTP id e19so7966276pfv.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cMAEdkQgVrf9p9mJWu6Kkyft4o4pi8sIjXqTY9i64qg=;
        b=mvmpHjn4cqC1t/VuirIcVi5/aTKpwPpcoZEBUty4D905OTwK7jOb1WkOrdKtFr7muz
         fyp5gtgUue+mhfnVjb8pFJ4MfG5rPt1mvK02RUC96Zk/UwOANIIDnpldJexKlzxzYzvF
         FYyduxYLfyQJEuXT5Xn4NK3mEUofz0sKHWT10oCAvgiZG2S7hvkpG9zIYFxjeFOEFhKX
         q9m8ThXMZLKC5qYwiiHBQk6j6bK/LC63ZFd0XXSC1Xau53oxjsHRn8k2d3o9NUqE71V+
         y5AK+Zoz7MbJH2+5a79LOWtNNZrDJyWbwysmEtdkO5VWEX1gCEDV7y/zCLSHDM/Kc0s7
         kbBg==
X-Gm-Message-State: AOAM533G2JTbtaEd3HS8VBPH+3IJYuuCVqVl6XOw9tclUBrq4h91GzMv
        /Uob8uB0sp6+//52341H3huQe1uF1qmGxQ==
X-Google-Smtp-Source: ABdhPJy/CeWjAR1n2K9PuBw+cxIsZSGMk6YNgzT1P1tVo1nOE5DHMwZ2Ee+hsl3DiaQtn5VwMd3GTQ==
X-Received: by 2002:a63:5110:: with SMTP id f16mr6272908pgb.51.1621359923364;
        Tue, 18 May 2021 10:45:23 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 23/50] ibmvscsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:23 -0700
Message-Id: <20210518174450.20664-24-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
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
index e75b0068ad84..d8ed85624bf9 100644
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

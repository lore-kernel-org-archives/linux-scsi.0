Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB11C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EE506115C
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhEXDLQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:16 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:38807 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbhEXDLL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:11 -0400
Received: by mail-pf1-f181.google.com with SMTP id e17so9075739pfl.5
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cMAEdkQgVrf9p9mJWu6Kkyft4o4pi8sIjXqTY9i64qg=;
        b=GRe1f+tH2EqeOiHENKGLyxK3FYnW/pnTSKIhuq8jx8cP3PoDal+xf+y5jlN1uAEhDG
         nMHJ/2Qz3dhhUqxMqVS24lhXsP6frZuCGUFGj3ERaTZAOGwbMP5wxEdk/ng6qeL++thF
         nOteQ82v/lfXcjjcsbfSEgIdWl3V90H9i0yy0zU4PWzwP6EFCg8iBPUdaNquUo7aQuj5
         7q8zxv0R1gUYD/edWrKSxBBP9e0pmeif7dKAoKDd750Xo3G+8KBLW0IHjLwwpXUv5t+g
         f7KSPYizZfNxkeV9Gg3b2z3w2zC1f6fDYoJ+STvPMEnKVRuw4EXqyctshKiSvNyPURoM
         EixQ==
X-Gm-Message-State: AOAM530iDzbUOvQRNESy+vd9ZBCB09FRBAEsBUnxob4xilmGeRVkdzV9
        Hgc7THbGr5y4aXEciusPZI0=
X-Google-Smtp-Source: ABdhPJxAHzWf3N1KEx505bCX7HNDginJAmXfBE/zKPfDdEM91LXGXaweiPqB7mwWJgt10NoYjdp1ew==
X-Received: by 2002:a63:465b:: with SMTP id v27mr11028526pgk.445.1621825783091;
        Sun, 23 May 2021 20:09:43 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 24/51] ibmvscsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:29 -0700
Message-Id: <20210524030856.2824-25-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
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

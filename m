Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D11C47083
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 626926115C
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhEXDLZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:25 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:34631 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbhEXDLY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:24 -0400
Received: by mail-pf1-f176.google.com with SMTP id q25so1628600pfn.1
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nG69elz3fRIik+x0xPzidwBogqJG1UGznFLcOfDZOZo=;
        b=ODNb6QRVwKOZF+1dTXTn+Wo4b28wRpnQBhtB1kBqlTz3pf+Y2T8BX/kbc4fjJ7OjIG
         g0SE8L8VQF82Nt7881ERZ0JZ08v0yUeGlovKtZCh2JngOuTVnTNJtHYzYhMOckvXd5gK
         GEvBB+6curout/KqNBp9nd6K/eoUcgqIOJNDxtUCVjUbaQWN2BUwQtSyUhCeJdvDM/a5
         aBhQYp0l+WiFaQjRgKeZXi5wWyT13lUcvx+rhnZIVGKhopEUo/7reAeZm2n6bAuSzR1k
         MNWPAw0U9Rv1AIZWTuC2idZOcn+zRvWme1DW9/i6oqgwZjuVwBusOXMAQh1ex5e8w606
         NqoA==
X-Gm-Message-State: AOAM532YzEQ+y0I4afBXHaFGi00ZTdEQ0BP7tRZqbCblqncM1GVaGFIZ
        B1SAOlc8r6LisCwo9QNFNM4=
X-Google-Smtp-Source: ABdhPJzIQxaFSTFQ9W9teGjNgKA9ZvDldcbPeVc+togYcyfUhYtDtxUoBt8PGm2EKXfNUbqZtSIi3Q==
X-Received: by 2002:a62:e21a:0:b029:2de:4440:3a with SMTP id a26-20020a62e21a0000b02902de4440003amr21966772pfi.23.1621825796297;
        Sun, 23 May 2021 20:09:56 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 30/51] mvumi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:35 -0700
Message-Id: <20210524030856.2824-31-bvanassche@acm.org>
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
 drivers/scsi/mvumi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 9d5743627604..94b2b207d391 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -702,7 +702,7 @@ static int mvumi_host_reset(struct scsi_cmnd *scmd)
 	mhba = (struct mvumi_hba *) scmd->device->host->hostdata;
 
 	scmd_printk(KERN_NOTICE, scmd, "RESET -%u cmd=%x retries=%x\n",
-			scmd->request->tag, scmd->cmnd[0], scmd->retries);
+			scsi_cmd_to_rq(scmd)->tag, scmd->cmnd[0], scmd->retries);
 
 	return mhba->instancet->reset_host(mhba);
 }

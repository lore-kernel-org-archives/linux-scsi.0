Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C2E0C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD39E6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbhDTAKI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:08 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:43781 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233258AbhDTAJy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:54 -0400
Received: by mail-pg1-f178.google.com with SMTP id p12so25395256pgj.10
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HRAywc+wYKR14aBGGME5mwCtOfuNOyXvxePe8lGxNuI=;
        b=Ez3Xea5WimLE0QUah1UVdJQKWEmI+Ocq3ePPYkTlcwtUiF5GbUVED27gNxq+bt2pMc
         OdDxjW0PS9ENJdVja1QFbUjGCZ9sPNMWgfYbYy8mqvxLf+qrsuNjCLXAc7zgDFSfhfPB
         0BLXEyVuFQp0VtYucwCTxWIHYQmKt9dr2mYWJbKxb52F3j9daa0bNEECba+/MQ2W0Xc9
         R7wixs9/NeAAPR60hARgwrJTjZTEJ1E1DIGwOteA9nh8N5HDwzc4hRkMR64QJsUk4+3w
         7arBImaIuGraVCMBrsgxVH810qazS8EwECkMbxgz+Z9LXmiEgraq3QJUcIgJ7T4M3NWy
         Xi/Q==
X-Gm-Message-State: AOAM533aBcpj7CQ0h3JfzC9OPn+jr7/E0UJUYRUB8LV+Iqrq/5KHjLYn
        v+yZvy4FtSum9IU7fnDZs18HbUaz9vRESQ==
X-Google-Smtp-Source: ABdhPJzytwdMkvm6pyjr5lhBwO0m1giGoEXP/cNHuXNOfLGJO8yzX/pYQvSBTNrWcUjNhxs2jq2QSw==
X-Received: by 2002:a62:ee09:0:b029:211:1113:2e7c with SMTP id e9-20020a62ee090000b029021111132e7cmr21979381pfi.49.1618877363490;
        Mon, 19 Apr 2021 17:09:23 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 027/117] advansys: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:15 -0700
Message-Id: <20210420000845.25873-28-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/advansys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index e9516de8c18b..9b8d463e1bfd 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -5980,7 +5980,7 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	/*
 	 * 'done_status' contains the command's ending status.
 	 */
-	scp->result = 0;
+	scp->status.combined = 0;
 	switch (scsiqp->done_status) {
 	case QD_NO_ERROR:
 		ASC_DBG(2, "QD_NO_ERROR\n");
@@ -6732,7 +6732,7 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 	/*
 	 * 'qdonep' contains the command's ending status.
 	 */
-	scp->result = 0;
+	scp->status.combined = 0;
 	switch (qdonep->d3.done_stat) {
 	case QD_NO_ERROR:
 		ASC_DBG(2, "QD_NO_ERROR\n");

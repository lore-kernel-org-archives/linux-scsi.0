Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9890EC43462
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77ED3613AC
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhDTAKP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:15 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:34574 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233342AbhDTAKB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:01 -0400
Received: by mail-pl1-f172.google.com with SMTP id t22so18351349ply.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zy47bq6JIKF2ImCAQMRHizEVvEkDoTMsU3s+1ysuba4=;
        b=l3p5fAex8a9I6exdJsvDGz9z+afEhFDGMBBKE1fXC/WON/usHONJJWetIEM5vx3Ft3
         d71x7W4PaACtbFa/rxP2viQ46pwpHFHiF+g48c/TwHQOBKfIrw2FhUs+DvmHgJiaANwW
         nWv0bDxaX14BgeCQm/cAiobobjTc+gNzM6Oq9AxJQ+zcZsvKY3MU87ZUauIGlYrFqC0Q
         ig3TaO6DscQxP904uoMypOcfGYZvemLJVWWRPDYiWIpLJk2AJyjRwCyX5RB4xSXBq2KB
         EOfEfAmezIRVso6j6lADiiIyl1qd5uiyns50VKNBK+kOm/nqx8lTsb+YlwwUonY3Pn/k
         i/yg==
X-Gm-Message-State: AOAM532fNDBb31lSPyVNVtk5cTbHwOV4IeiiHl1QyMskYhq3aXciHFri
        M/QADtPO+YyrLnseME8uBjs=
X-Google-Smtp-Source: ABdhPJwRzzKH7THpYrseAjax12HchJ+f7HU0084h7PO1Ij9u2NTbhvW/bh9MnSeVhIhIT2kvWOL9Pw==
X-Received: by 2002:a17:902:ea0c:b029:eb:7b6:13ba with SMTP id s12-20020a170902ea0cb02900eb07b613bamr25547833plg.25.1618877370345;
        Mon, 19 Apr 2021 17:09:30 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 033/117] be2iscsi: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:21 -0700
Message-Id: <20210420000845.25873-34-bvanassche@acm.org>
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

Cc: Subbu Seetharaman <subbu.seetharaman@broadcom.com>
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/be2iscsi/be_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 22cf7f4b8d8c..ba9ea9858bdf 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1125,22 +1125,22 @@ be_complete_io(struct beiscsi_conn *beiscsi_conn,
 
 		return;
 	}
-	task->sc->result = (DID_OK << 16) | status;
+	task->sc->status.combined = (DID_OK << 16) | status;
 	if (rsp != ISCSI_STATUS_CMD_COMPLETED) {
-		task->sc->result = DID_ERROR << 16;
+		task->sc->status.combined = DID_ERROR << 16;
 		goto unmap;
 	}
 
 	/* bidi not initially supported */
 	if (flags & (ISCSI_FLAG_CMD_UNDERFLOW | ISCSI_FLAG_CMD_OVERFLOW)) {
 		if (!status && (flags & ISCSI_FLAG_CMD_OVERFLOW))
-			task->sc->result = DID_ERROR << 16;
+			task->sc->status.combined = DID_ERROR << 16;
 
 		if (flags & ISCSI_FLAG_CMD_UNDERFLOW) {
 			scsi_set_resid(task->sc, resid);
 			if (!status && (scsi_bufflen(task->sc) - resid <
 			    task->sc->underflow))
-				task->sc->result = DID_ERROR << 16;
+				task->sc->status.combined = DID_ERROR << 16;
 		}
 	}
 
@@ -4877,8 +4877,8 @@ static int beiscsi_bsg_request(struct bsg_job *job)
 				    nonemb_cmd.va, (resp->response_length
 				    + sizeof(*resp)));
 		bsg_reply->reply_payload_rcv_len = resp->response_length;
-		bsg_reply->result = status;
-		bsg_job_done(job, bsg_reply->result,
+		bsg_reply->status.combined = status;
+		bsg_job_done(job, bsg_reply->status.combined,
 			     bsg_reply->reply_payload_rcv_len);
 		dma_free_coherent(&phba->ctrl.pdev->dev, nonemb_cmd.size,
 				    nonemb_cmd.va, nonemb_cmd.dma);

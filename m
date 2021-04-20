Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4F9C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7FFB6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbhDTALo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:11:44 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:38688 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234302AbhDTALE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:11:04 -0400
Received: by mail-pf1-f180.google.com with SMTP id g16so11017337pfq.5
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=13Z5prKfPZbyA8SZjiVEQIObHKOl5ga5b7LyLQpdpPY=;
        b=flMrdtN9vUTfagSxo3bj1TL3RH7Bdg67jNQ3Ci1rdkuqxgeQjB/xWfRYN7fl6xQAtP
         4cx7a5AESAIT5aFFWpcphw21xrBOamaGz+sl3rnkFr1pwHpJyApmAE5LnMJ5wcHP9jNd
         JGuVCzOWoghsusmc/fcu/eA2NhjN4rTY81w9vbgsEUYKCriiGEapwwtZ8fRaWPbHrGa5
         +ooVackREGVw+koXdL50p1D10QKu57AdyvwqOkj1LslJ757Ga0LP2iSu8esYVOMvTOQE
         u27pNVlhqYSMNEB32R9u6gWRHJyLhiCQSCLXO1F7m+oblWbKbDNX17BnY2DHczP6UBUQ
         ktQQ==
X-Gm-Message-State: AOAM532IWOcBNXhPkBWK5Hi/vjLUydO5OnzyW6xFsjVT6nETN3HX2bO7
        4eNP+yeSMzHefHhV8odUOPTnKI43D1dStA==
X-Google-Smtp-Source: ABdhPJzNG2nbMsO2mSU0QodSf7BbQNeAG0GOWu/qKuJHCDJdCu3IYzOxKaWa1kPbGJipFSrnYbsnSg==
X-Received: by 2002:a63:7842:: with SMTP id t63mr4440352pgc.233.1618877433334;
        Mon, 19 Apr 2021 17:10:33 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: [PATCH 088/117] qlogicpti: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:08:16 -0700
Message-Id: <20210420000845.25873-89-bvanassche@acm.org>
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

Cc: GR-QLogic-Storage-Upstream@marvell.com
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qlogicpti.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index d84e218d32cb..31d070a7f138 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1057,7 +1057,7 @@ static int qlogicpti_queuecommand_lck(struct scsi_cmnd *Cmnd, void (*done)(struc
 	 * we don't, the midlayer will ignore the return value,
 	 * which is insane.  We pick up the pieces like this.
 	 */
-	Cmnd->result = DID_BUS_BUSY;
+	Cmnd->status.combined = DID_BUS_BUSY;
 	done(Cmnd);
 	return 1;
 }
@@ -1180,10 +1180,10 @@ static struct scsi_cmnd *qlogicpti_intr_handler(struct qlogicpti *qpti)
 			       SCSI_SENSE_BUFFERSIZE);
 
 		if (sts->hdr.entry_type == ENTRY_STATUS)
-			Cmnd->result =
+			Cmnd->status.combined =
 			    qlogicpti_return_status(sts, qpti->qpti_id);
 		else
-			Cmnd->result = DID_ERROR << 16;
+			Cmnd->status.combined = DID_ERROR << 16;
 
 		if (scsi_bufflen(Cmnd))
 			dma_unmap_sg(&qpti->op->dev,

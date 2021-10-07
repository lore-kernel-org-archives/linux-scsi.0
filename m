Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F7BC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0B9B60E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242355AbhJGUch (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:37 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:42897 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242408AbhJGUcd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:33 -0400
Received: by mail-pl1-f170.google.com with SMTP id l6so4648149plh.9
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E5fkFkSHyFWPVXob8UZiLA1Jol6Iml3b/JDVx1APD6c=;
        b=w7ehtGVzxo3981y9Rn6xzBIdGka334KaXFtfKt+32MTVeN+t7BRaIKA6hqJcwA6uNs
         KvXDimO7Ei19amCPmGDTT1jBw4QXZMh/ELcQigcIsMri1gp8FTeuWiBORNbAEpWZaibU
         j/2Pb818I6WLK5FYK2D14I0sGL5PIE6l28COiuQQH7G9fkW3ktY46L5cdWPnbnIxyd39
         C2tekXbv3ZBy1e3lovnlepN3Fq3hb3r4U2oMPKZBgv/Ks6quCYOdGEn6n2nICbZiALpV
         6s/hBlZ/6eB32VjfH7g2QvGUvkLL/dkkmkYDzC2V4fzOnEBLXGlfYxRV6r53KiCgbXmX
         jOew==
X-Gm-Message-State: AOAM532Rx+g69F2rec9Uj89S2QRZGkYiQLieDICNBiEU9Tkj0a+cKt//
        GyRiQcSk/YiiM9FGk6dMbmjyTY5Itqk=
X-Google-Smtp-Source: ABdhPJyfe6G5pvfUqy1nRNQmDWQMN83ps/GPzERkXj/UBe7MiAAb6hGGypd10T575ErxWgUDlO8PnA==
X-Received: by 2002:a17:902:d50d:b0:13e:a44e:2d2a with SMTP id b13-20020a170902d50d00b0013ea44e2d2amr5591552plg.89.1633638639061;
        Thu, 07 Oct 2021 13:30:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 38/88] ibmvscsi: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:33 -0700
Message-Id: <20211007202923.2174984-39-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 1f1586ad48fe..63f42eebe0ba 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1046,7 +1046,7 @@ static void ibmvfc_scsi_eh_done(struct ibmvfc_event *evt)
 
 	if (cmnd) {
 		scsi_dma_unmap(cmnd);
-		cmnd->scsi_done(cmnd);
+		scsi_done(cmnd);
 	}
 
 	ibmvfc_free_event(evt);
@@ -1848,7 +1848,7 @@ static void ibmvfc_scsi_done(struct ibmvfc_event *evt)
 			cmnd->result = (DID_ERROR << 16);
 
 		scsi_dma_unmap(cmnd);
-		cmnd->scsi_done(cmnd);
+		scsi_done(cmnd);
 	}
 
 	ibmvfc_free_event(evt);
@@ -1934,7 +1934,7 @@ static int ibmvfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	if (unlikely((rc = fc_remote_port_chkready(rport))) ||
 	    unlikely((rc = ibmvfc_host_chkready(vhost)))) {
 		cmnd->result = rc;
-		cmnd->scsi_done(cmnd);
+		scsi_done(cmnd);
 		return 0;
 	}
 
@@ -1974,7 +1974,7 @@ static int ibmvfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 			    "Failed to map DMA buffer for command. rc=%d\n", rc);
 
 	cmnd->result = DID_ERROR << 16;
-	cmnd->scsi_done(cmnd);
+	scsi_done(cmnd);
 	return 0;
 }
 

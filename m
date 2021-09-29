Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81ACDC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C60861406
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347138AbhI2WJB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:01 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:38574 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347129AbhI2WI7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:59 -0400
Received: by mail-pl1-f176.google.com with SMTP id x4so2524003pln.5
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E5fkFkSHyFWPVXob8UZiLA1Jol6Iml3b/JDVx1APD6c=;
        b=EGekqQZ4dDoKXD1DsAOTByx/tjuF0/vbdU9NCLghygzSzjl34xNjUgGQ+b5PE57q7D
         h0eDJZtVsFLAQ04Qshb91pL9Qn/8fC4oZs3C3bXPDAea0C1rMsRNMExWTFOkMhPurFCF
         SLvx1kREw0gk2o7rv05sm0XMlZ36w6lIygbrJVuJ3LMkBjkG5dAEY9cEegqgmnG+bofv
         SHfDu2xviiK6OALBd2n8HP0jsZhmHP7pF/EU2K5Jbsafpc9D+jlsdonaVMdTiE1Olp+Z
         eNC3BqQLYF93YHOzSdvcAzSsDaPCYzVvRn0+U3yHkAFktMEyLHnm/xZiuoL9D3xs7gAU
         WudQ==
X-Gm-Message-State: AOAM533Frtiv6k0h9xIvNUysPWN722fcUKTrupxru+/aJV4c+6OkKFr6
        2LjPQJLDxUKw+BXasu7nvLk=
X-Google-Smtp-Source: ABdhPJwUHAjY1syH/vobFNCjTxAQnpYP5H6K1zcXpWCsw5WAiMx2gwtHtzbq3dy7mhXBflrq4WVfkw==
X-Received: by 2002:a17:902:e889:b0:13e:691b:4e1d with SMTP id w9-20020a170902e88900b0013e691b4e1dmr773862plg.70.1632953237555;
        Wed, 29 Sep 2021 15:07:17 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 38/84] ibmvscsi: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:14 -0700
Message-Id: <20210929220600.3509089-39-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
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
 

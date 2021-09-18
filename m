Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F3BC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F33CF60F46
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344982AbhIRAIx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:53 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:38414 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344464AbhIRAIl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:41 -0400
Received: by mail-pl1-f178.google.com with SMTP id 5so7226444plo.5
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E5fkFkSHyFWPVXob8UZiLA1Jol6Iml3b/JDVx1APD6c=;
        b=5ikvT5cR3J9sRSKDM76L1DHDHHoX5Xq0ike6gF5ssB7oGOjKZBK42YT1CfEUv/57Lz
         DUG4+MSOVZTRswXE9fs9TiatkJlzjccZtjk3e2tO2j9IEolZr6n84GpDLSJhLdT5ga7t
         98ScZaJEpGIZkUoWB6tycmrWcnxahE7On1Ay5P7kRoFDvVVjIbqUsy2mEtPEdpQ9CVQD
         +ScF8HKzR8lxiZBHX7eHgWRQqtp06odjcloglLOgaB7Rpt6LvdlhbfHLfK4ZJ8YlGIfO
         EEi6hLEUV6LKKB9v8C3buWiTRA3RTiADE5jY9nBBcp3ump/TdXoxKwnuN8+JAiOc4ncT
         W3GA==
X-Gm-Message-State: AOAM533gZVtXnK+rHR7tIXE480/SfuhV0S2ghz8hcvYt58AyCDxYwr3O
        ehtSret4vcqzh/FYHhpWmok=
X-Google-Smtp-Source: ABdhPJycJmQHJtPWIa2z807433IuDZ74uOnB1VjtiuamX/KMnPjdfnzrU1R+kO1kTTrNqYfnYpTRxQ==
X-Received: by 2002:a17:903:11c8:b0:138:d85a:7f09 with SMTP id q8-20020a17090311c800b00138d85a7f09mr12047924plh.75.1631923638221;
        Fri, 17 Sep 2021 17:07:18 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 38/84] ibmvscsi: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:21 -0700
Message-Id: <20210918000607.450448-39-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
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
 

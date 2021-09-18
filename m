Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0381EC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5FA160F51
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbhIRAK1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:10:27 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:42767 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345079AbhIRAJ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:29 -0400
Received: by mail-pf1-f172.google.com with SMTP id q23so8554486pfs.9
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:08:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=urS2XjYsdGd+sO9di0sTi7CmC+0ofkzpdFIqCfBC0cc=;
        b=ss+u/mK6mFAwdTHwspWixRkQLtXpqcAA6fO4ynQWKpvo8ePxbRITbvBcGypqx2EH7E
         O+glnLzTQXtzEDuPEOD5KvadeKXlBFrFZdUCRf0Ieo4bBNzXFCM5ETpgnAcEk+bCCAMf
         w1TnFiLZPuEVOeTkYyDY/wk3ExQXbvepRlejF5ncMkR+l5Jcj6wa2E+MQbSUxy+IQfF/
         Hecni4uhnNmk1LHuhANV+WXLq9ZQ1lfuFTLFV//M1ijgXSpvIcUslXU2TYTn6rMe5tW9
         C44WtC7xlaKoEmw+KNT9T4ebUW3/B48mk8owfl2h/pjzygpW8sNh/vbJYjHLe4F3N7Ay
         csJQ==
X-Gm-Message-State: AOAM533H/vE5h5I1uzi7yuEWlqkQhbCw2KF+N6I4fkFLyuUMKhMTmCFh
        iIFKNMX2qukMoH+OC+LIWWU=
X-Google-Smtp-Source: ABdhPJxaMdBu8ESX729jwWuFUHViktGcKnPULcSVrh3dXE7ELWl2XJMMU0X6Av/aeyDKm7iJHM4aFQ==
X-Received: by 2002:aa7:9149:0:b0:40c:7aa0:5305 with SMTP id 9-20020aa79149000000b0040c7aa05305mr13237275pfi.46.1631923686419;
        Fri, 17 Sep 2021 17:08:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:08:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 67/84] qlogicpti: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:50 -0700
Message-Id: <20210918000607.450448-68-bvanassche@acm.org>
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
 drivers/scsi/qlogicpti.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 8e7e833a36cc..30b5e98b5de0 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1021,8 +1021,6 @@ static int qlogicpti_queuecommand_lck(struct scsi_cmnd *Cmnd, void (*done)(struc
 	u_int out_ptr;
 	int in_ptr;
 
-	Cmnd->scsi_done = done;
-
 	in_ptr = qpti->req_in_ptr;
 	cmd = (struct Command_Entry *) &qpti->req_cpu[in_ptr];
 	out_ptr = sbus_readw(qpti->qregs + MBOX4);
@@ -1214,7 +1212,7 @@ static irqreturn_t qpti_intr(int irq, void *dev_id)
 			struct scsi_cmnd *next;
 
 			next = (struct scsi_cmnd *) dq->host_scribble;
-			dq->scsi_done(dq);
+			scsi_done(dq);
 			dq = next;
 		} while (dq != NULL);
 	}

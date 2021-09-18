Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5ADDC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9012B60F23
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243574AbhIRAH4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:07:56 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:41521 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243316AbhIRAHy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:07:54 -0400
Received: by mail-pj1-f50.google.com with SMTP id m21-20020a17090a859500b00197688449c4so8580109pjn.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cpY/lBLTe7tQQ0l8dXTUh8Aq73Wg1MJRRB+jRfiBtws=;
        b=GX2hWnSGknBfe2DolDgEWXAflVUiGLoAMuiZp+TTidob+ZNcqxWvNJ/sxRT5f6hqbQ
         zhE4dOARuf7RBrRRsXQCKtKVFx3KeNp5kH/Tov8QEIy5NyuApyTve8Q6iN9Jx8WbYXpx
         YmcNnuxjbv7JgzcZVioQiv/Ryt6g53/M/F/AXPlnl8cQ8pPNyaWSsjn+e9RbsVw43mLs
         HRnbY50l6RUDqU+K9bcmCFJKP4tY6KQYi4+L/lZ4//TlmOpBIR1ChP3gg2r3g+QFg6RP
         I1VYorXYFvr510Sg2dnonaqwr/oL1awF5BS5ZrmynBOYevd16j8jWWsy0JQojhwYyWWa
         S/rQ==
X-Gm-Message-State: AOAM531xOe0646CZkMw0j8h2Otdm95277xHf7ztLx5xiy0IL3T/t0Rnm
        Y8gLsPaH++pShsx6e3gt3ke5f52WCTw=
X-Google-Smtp-Source: ABdhPJzPdIGvTvtnPga9L4/kR7BJ8ACNdoYo8o3XnfT5iKR7GG71Dj6joUB26spfZASH166S4qdHfQ==
X-Received: by 2002:a17:90a:a513:: with SMTP id a19mr24580567pjq.26.1631923591413;
        Fri, 17 Sep 2021 17:06:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 12/84] 53c700: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:04:55 -0700
Message-Id: <20210918000607.450448-13-bvanassche@acm.org>
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
 drivers/scsi/53c700.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index a12e3525977d..e7ed2fd6cdec 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -634,7 +634,7 @@ NCR_700_scsi_done(struct NCR_700_Host_Parameters *hostdata,
 
 		SCp->host_scribble = NULL;
 		SCp->result = result;
-		SCp->scsi_done(SCp);
+		scsi_done(SCp);
 	} else {
 		printk(KERN_ERR "53c700: SCSI DONE HAS NULL SCp\n");
 	}
@@ -1571,7 +1571,7 @@ NCR_700_intr(int irq, void *dev_id)
 				 * deadlock on the
 				 * hostdata->state_lock */
 				SCp->result = DID_RESET << 16;
-				SCp->scsi_done(SCp);
+				scsi_done(SCp);
 			}
 			mdelay(25);
 			NCR_700_chip_setup(host);
@@ -1792,7 +1792,6 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *)
 
 	slot->cmnd = SCp;
 
-	SCp->scsi_done = done;
 	SCp->host_scribble = (unsigned char *)slot;
 	SCp->SCp.ptr = NULL;
 	SCp->SCp.buffer = NULL;

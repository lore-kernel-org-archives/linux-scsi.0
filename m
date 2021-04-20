Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8CB8C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC67C613AA
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhDTAKO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:14 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:36848 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbhDTAJ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:59 -0400
Received: by mail-pl1-f173.google.com with SMTP id g16so1821149plq.3
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uct9dVj7soP7jCycwyDRbNVMWwDhX5fyZFVnfezsjlU=;
        b=dpNaA+VYTpQkk7m6jnvabD033nmDu7827hEy1u7+IgcUxKJSRi6ONAFGdiOptshlwL
         hnqfhKpT1Lgic/vYKUtTam9AQ/t+TQ1fCLtC5Eq2BOrM7vL2rpQZ6fZGNEKb6q6IC0hV
         iXhwGQ6uMSs9LRPH/WijbWo9h5LgM8219ZBDdH3xgDBBRmyM89g4WUFLE2tU/5Rhs0Jy
         qddGFXNrUdGklxaeJOtaLYMZWbJ+vhqi6DMdWe6qAAIRlyeZSVBWFEhdei8TtCwo/s2w
         uA6kQ/y0TUkREhW4qi7kkcylM3JxLHSkN56pkmQnn5+L0OiocxsJ/3XvTPFOQCqrx+QD
         Ighg==
X-Gm-Message-State: AOAM530nk6xgHVT14Mogbm46k0qk/eef99FQ5saN07sSSsNFJoIUopCb
        nFL1No9lquXP/x+MgBE9axWnbpLEHBZLww==
X-Google-Smtp-Source: ABdhPJzfFoMNZB1xXW+mcsZaQlJfBAu+NGnQJnNPxKWaVG6eJECwMMlCEJWcoWNwrH2K9AiUnwQh3A==
X-Received: by 2002:a17:903:304b:b029:eb:4cf:8321 with SMTP id u11-20020a170903304bb02900eb04cf8321mr25973336pla.40.1618877369158;
        Mon, 19 Apr 2021 17:09:29 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 032/117] atp870u: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:20 -0700
Message-Id: <20210420000845.25873-33-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/atp870u.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 9d179cd15bb8..0fb5af026229 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -494,13 +494,13 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 			   dev->last_cmd[c] = 0xff;
 			}
 			if (i == 0x16) {
-				workreq->result = atp_readb_io(dev, c, 0x0f);
+				workreq->status.combined = atp_readb_io(dev, c, 0x0f);
 				if (((dev->r1f[c][target_id] & 0x10) != 0) && is885(dev)) {
 					printk(KERN_WARNING "AEC67162 CRC ERROR !\n");
-					workreq->result = SAM_STAT_CHECK_CONDITION;
+					workreq->status.combined = SAM_STAT_CHECK_CONDITION;
 				}
 			} else
-				workreq->result = SAM_STAT_CHECK_CONDITION;
+				workreq->status.combined = SAM_STAT_CHECK_CONDITION;
 
 			if (is885(dev)) {
 				j = atp_readb_base(dev, 0x29) | 0x01;
@@ -630,7 +630,7 @@ static int atp870u_queuecommand_lck(struct scsi_cmnd *req_p,
 	req_p->sense_buffer[0]=0;
 	scsi_set_resid(req_p, 0);
 	if (scmd_channel(req_p) > 1) {
-		req_p->result = DID_BAD_TARGET << 16;
+		req_p->status.combined = DID_BAD_TARGET << 16;
 		done(req_p);
 #ifdef ED_DBGP
 		printk("atp870u_queuecommand : req_p->device->channel > 1\n");
@@ -649,7 +649,7 @@ static int atp870u_queuecommand_lck(struct scsi_cmnd *req_p,
 	 */
 
 	if ((m & dev->active_id[c]) == 0) {
-		req_p->result = DID_BAD_TARGET << 16;
+		req_p->status.combined = DID_BAD_TARGET << 16;
 		done(req_p);
 		return 0;
 	}
@@ -660,7 +660,7 @@ static int atp870u_queuecommand_lck(struct scsi_cmnd *req_p,
 #ifdef ED_DBGP
 		printk( "atp870u_queuecommand: done can't be NULL\n");
 #endif
-		req_p->result = 0;
+		req_p->status.combined = 0;
 		done(req_p);
 		return 0;
 	}
@@ -684,7 +684,7 @@ static int atp870u_queuecommand_lck(struct scsi_cmnd *req_p,
 		printk("atp870u_queuecommand : dev->quhd[c] == dev->quend[c]\n");
 #endif
 		dev->quend[c]--;
-		req_p->result = DID_BUS_BUSY << 16;
+		req_p->status.combined = DID_BUS_BUSY << 16;
 		done(req_p);
 		return 0;
 	}

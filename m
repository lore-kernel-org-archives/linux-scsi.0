Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFCBCC4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACB3760E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbhJGUdD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:03 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:41871 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233837AbhJGUdB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:01 -0400
Received: by mail-pg1-f181.google.com with SMTP id v11so908201pgb.8
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x0dkhOmZg9WzrTEZz0mKY79kQvhLQfr5TATysJhqe6s=;
        b=S2t6hlgRqYgOofkKRNgt1u2lB1cD+fiaTu9Ns2Dv8Gkq91iXx3cydszGHeqk2YLn0H
         /eF99H5Ovis2SWKoQl2IGt2KNBX8IZffI1sp1RmEVHEc9NxdmFeXUQFhDhiY4mAZHEaG
         w6uWzUm85/wXeidIIDf+dVOpkCMfR1MFyxi8iW/WUZIL0PY2ZU/ZSL39PvNqcFXTPtBd
         SqaxlWcfEvl/SQ4t3FeoteuMCAxcmH9OVzzns20z4UId+DzA7+3sPtE2CB0TmgJApDOU
         uGx6yoevzQx2xI3WCsJn8FQtM3oUJre8WdfzG90/XkDPLnlPFEiSwXXEHplMqX6ObZGp
         WJdw==
X-Gm-Message-State: AOAM532GL/zDcO4odye0vqHY9GNRfCIaQAQ9lVFGzzKZSujkYrde79+E
        CvIOnAURjbexg0OmXA23RHo=
X-Google-Smtp-Source: ABdhPJw2Aj489Io599zT/ojeoiMwCCN8LYLx1KgpmDhuFe4oMIe2UzN49urG94hOiwytspHEbBguhg==
X-Received: by 2002:a63:ed4f:: with SMTP id m15mr1336518pgk.471.1633638667433;
        Thu, 07 Oct 2021 13:31:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 56/88] ncr53c8xx: Remove unused code
Date:   Thu,  7 Oct 2021 13:28:51 -0700
Message-Id: <20211007202923.2174984-57-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Neither the remove_from_waiting_list() macro nor the
retrieve_from_waiting_list() function are used by any NCR53c8xx driver.
Hence remove both.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ncr53c8xx.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 7a4f5d4dd670..2b8c6fa5e775 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -1939,11 +1939,8 @@ static	void	ncr_start_next_ccb (struct ncb *np, struct lcb * lp, int maxn);
 static	void	ncr_put_start_queue(struct ncb *np, struct ccb *cp);
 
 static void insert_into_waiting_list(struct ncb *np, struct scsi_cmnd *cmd);
-static struct scsi_cmnd *retrieve_from_waiting_list(int to_remove, struct ncb *np, struct scsi_cmnd *cmd);
 static void process_waiting_list(struct ncb *np, int sts);
 
-#define remove_from_waiting_list(np, cmd) \
-		retrieve_from_waiting_list(1, (np), (cmd))
 #define requeue_waiting_list(np) process_waiting_list((np), DID_OK)
 #define reset_waiting_list(np) process_waiting_list((np), DID_RESET)
 
@@ -7997,26 +7994,6 @@ static void insert_into_waiting_list(struct ncb *np, struct scsi_cmnd *cmd)
 	}
 }
 
-static struct scsi_cmnd *retrieve_from_waiting_list(int to_remove, struct ncb *np, struct scsi_cmnd *cmd)
-{
-	struct scsi_cmnd **pcmd = &np->waiting_list;
-
-	while (*pcmd) {
-		if (cmd == *pcmd) {
-			if (to_remove) {
-				*pcmd = (struct scsi_cmnd *) cmd->next_wcmd;
-				cmd->next_wcmd = NULL;
-			}
-#ifdef DEBUG_WAITING_LIST
-	printk("%s: cmd %lx retrieved from waiting list\n", ncr_name(np), (u_long) cmd);
-#endif
-			return cmd;
-		}
-		pcmd = (struct scsi_cmnd **) &(*pcmd)->next_wcmd;
-	}
-	return NULL;
-}
-
 static void process_waiting_list(struct ncb *np, int sts)
 {
 	struct scsi_cmnd *waiting_list, *wcmd;

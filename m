Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5E1C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDC0560EFE
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237794AbhHTDFj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 23:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234853AbhHTDFi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 23:05:38 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB2CC061575;
        Thu, 19 Aug 2021 20:05:01 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id e15so6429862qtx.1;
        Thu, 19 Aug 2021 20:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2m9YrpUpbG665Kce7B5iRqtDD9fG0mGaBNdNqOrZoO0=;
        b=k8r3Rgu5ciYf9vekI0OhngK/c7DIucjwDyetJ1Ke2zIz5tf0fFH0naWx76Yau+gI/J
         1XXToUM0JHSTn5biSjhLovYDRBsZIx2GGi7qACrF5iOCcjnNxTJ4UCcfbR3QcLydJkry
         gJLPh3fMA/A9QT+VQukGTSv3d3hF7VgdbxAitWzYiVAf4hqtaoEulhmi2FmszUFd7A+y
         S/lai4eYWLRYQ8Xs7OhSqVlAvXWFlZ9yMNI2HZst7Lc8MGXk4GNjxLlmpgTQzJyy+ayx
         S88CmlM3pLoeRnkh5A/f7625QbfTQyhx42jTwpvrmaw4avAFuJpcSQWG0F0dEuojHv4l
         9sNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2m9YrpUpbG665Kce7B5iRqtDD9fG0mGaBNdNqOrZoO0=;
        b=uIU1DSLmcDILqyNqCSOvIvwJ3//fOwxRsfE67FDQgblcjn3hFhWOFYjRBZ9H1gs1tH
         SmUu6MVskECbkb4L69gGXhzDOneQkmUsuaysoe6uGMyFygrqvHtCp78FZ4xlAc0UNH4i
         bi3nZuM5d4DRbBAj1XyZ2RYoWaGWpZun/bpEHTWE/UWvO9iV+cEUP7/4IItMoq/Al1WO
         1dY3+fygnBYwHPK6cT9lMbmLgxFhF5toZr2JrCaeplg0Hyum7nK7IX1Bz43iN5hwM9fe
         C26DsTsGCQQOWHz/XT5l/akEjkaoZdsGtdz7CycDA+C3sAtVQoMkWFHSilX1i5s0KIBE
         Inag==
X-Gm-Message-State: AOAM5301NGBgEPDcqAn6uTQlnwH3QRfyofZRXV+rnpLYKl0N1ov+BbJp
        g7c+6Ttxx7c2xV67I/FUD5Y=
X-Google-Smtp-Source: ABdhPJx1JmDT349WoeGN9WEAKRn8L/PgL7UjV1e5Dkz4YQ5/tPwuA/DSw4hhuvfj1KCT7fLizIqkCQ==
X-Received: by 2002:aed:304c:: with SMTP id 70mr16030157qte.2.1629428700532;
        Thu, 19 Aug 2021 20:05:00 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id x3sm2502097qkx.62.2021.08.19.20.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 20:05:00 -0700 (PDT)
From:   CGEL <cgel.zte@gmail.com>
X-Google-Original-From: CGEL <jing.yangyang@zte.com.cn>
To:     Oliver Neukum <oliver@neukum.org>
Cc:     Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dc395x@twibble.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        jing yangyang <jing.yangyang@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] scsi/dc395x: Use bitwise instead of arithmetic operator for flags
Date:   Thu, 19 Aug 2021 20:04:07 -0700
Message-Id: <20210820030407.12313-1-jing.yangyang@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: jing yangyang <jing.yangyang@zte.com.cn>

This silences the following coccinelle warning:

"WARNING: sum of probable bitmasks, consider |"

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: jing yangyang <jing.yangyang@zte.com.cn>
---
 drivers/scsi/dc395x.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 24c7cef..fbac95b 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -761,7 +761,7 @@ static void waiting_process_next(struct AdapterCtlBlk *acb)
 	struct list_head *dcb_list_head = &acb->dcb_list;
 
 	if (acb->active_dcb
-	    || (acb->acb_flag & (RESET_DETECT + RESET_DONE + RESET_DEV)))
+	    || (acb->acb_flag & (RESET_DETECT | RESET_DONE | RESET_DEV)))
 		return;
 
 	if (timer_pending(&acb->waiting_timer))
@@ -844,7 +844,7 @@ static void send_srb(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
 
 	if (dcb->max_command <= list_size(&dcb->srb_going_list) ||
 	    acb->active_dcb ||
-	    (acb->acb_flag & (RESET_DETECT + RESET_DONE + RESET_DEV))) {
+	    (acb->acb_flag & (RESET_DETECT | RESET_DONE | RESET_DEV))) {
 		list_add_tail(&srb->list, &dcb->srb_waiting_list);
 		waiting_process_next(acb);
 		return;
@@ -1127,7 +1127,7 @@ static void reset_dev_param(struct AdapterCtlBlk *acb)
 	list_for_each_entry(dcb, &acb->dcb_list, list) {
 		u8 period_index;
 
-		dcb->sync_mode &= ~(SYNC_NEGO_DONE + WIDE_NEGO_DONE);
+		dcb->sync_mode &= ~(SYNC_NEGO_DONE | WIDE_NEGO_DONE);
 		dcb->sync_period = 0;
 		dcb->sync_offset = 0;
 
@@ -1685,7 +1685,7 @@ static void msgout_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "msgout_phase0: (0x%p)\n", srb->cmd);
-	if (srb->state & (SRB_UNEXPECT_RESEL + SRB_ABORT_SENT))
+	if (srb->state & (SRB_UNEXPECT_RESEL | SRB_ABORT_SENT))
 		*pscsi_status = PH_BUS_FREE;	/*.. initial phase */
 
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
@@ -2901,7 +2901,7 @@ static void disconnect(struct AdapterCtlBlk *acb)
 		doing_srb_done(acb, DID_ABORT, srb->cmd, 1);
 		waiting_process_next(acb);
 	} else {
-		if ((srb->state & (SRB_START_ + SRB_MSGOUT))
+		if ((srb->state & (SRB_START_ | SRB_MSGOUT))
 		    || !(srb->
 			 state & (SRB_DISCONNECT | SRB_COMPLETED))) {
 			/*
-- 
1.8.3.1



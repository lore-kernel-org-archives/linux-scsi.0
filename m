Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACBCCC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 939D561074
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351268AbhERRqn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:43 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:40495 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351251AbhERRqk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:40 -0400
Received: by mail-pg1-f169.google.com with SMTP id j12so7532368pgh.7
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lCKW2l7mY7+VHiX8bOSqsDYSuMRCMjaHYqY3c+w6fbk=;
        b=gm/Ax9p/Ui6c88VuXwZxc7dpC2fpwi6gCjZ11Psa6agkUDZUbmp1sgd1g1b02pcW7O
         YIcytDEZS3Ndazi5GTS23pfy+U3iRX3IcV4mpelPMWvuctRmw5+UKtqh92OfVPLVnpxj
         Rkm8pFC/70L0Dgqp9yGZWkaMXzqYgUsut0wTh8OnSCrCXxuZPtD+WtDu3R+GWHHEVj50
         46nrPPcOeqDArapb74lFkD8rWeaVGK2XKBaOO6J1EvBEUYeg+Asn63zf/2tux6ocwqxn
         PgIIMixZxi3OfXE4/mHB+a/QhGP2r3WpM080idOYVxmj4SqOu2QNittIzqAm6QfHiCS3
         BnDQ==
X-Gm-Message-State: AOAM531FwrqNlbMWS+nFoRI7U0BNBM01/hhmm8U9ihkTDjfItPP6VMPs
        PihVKbashGxZDPcv0KYv1lE=
X-Google-Smtp-Source: ABdhPJzBBnx+lr/i7oHcgMOJeAHmx2P9wDLU6XkgJDe80b5CoxJ1YuDi+inQSYMWzmuz67MXJCPBKQ==
X-Received: by 2002:a63:4550:: with SMTP id u16mr6265116pgk.440.1621359921409;
        Tue, 18 May 2021 10:45:21 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 21/50] hpsa: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:21 -0700
Message-Id: <20210518174450.20664-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hpsa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f135a10f582b..3faa87fa296a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5686,7 +5686,7 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	/* Get the ptr to our adapter structure out of cmd->host. */
 	h = sdev_to_hba(cmd->device);
 
-	BUG_ON(cmd->request->tag < 0);
+	BUG_ON(scsi_cmd_to_rq(cmd)->tag < 0);
 
 	dev = cmd->device->hostdata;
 	if (!dev) {
@@ -5729,7 +5729,7 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	 *       and is therefore a brand-new command.
 	 */
 	if (likely(cmd->retries == 0 &&
-			!blk_rq_is_passthrough(cmd->request) &&
+			!blk_rq_is_passthrough(scsi_cmd_to_rq(cmd)) &&
 			h->acciopath_status)) {
 		/* Submit with the retry_pending flag unset. */
 		rc = hpsa_ioaccel_submit(h, c, cmd, false);
@@ -5894,7 +5894,7 @@ static int hpsa_scsi_add_host(struct ctlr_info *h)
  */
 static int hpsa_get_cmd_index(struct scsi_cmnd *scmd)
 {
-	int idx = scmd->request->tag;
+	int idx = scsi_cmd_to_rq(scmd)->tag;
 
 	if (idx < 0)
 		return idx;

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA581C432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C411B61078
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242746AbhHETTm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:42 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:51111 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242687AbhHETTe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:34 -0400
Received: by mail-pj1-f45.google.com with SMTP id l19so11380756pjz.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lCKW2l7mY7+VHiX8bOSqsDYSuMRCMjaHYqY3c+w6fbk=;
        b=E9AezAWU0juxECwbjP/tCChCD0kNS2hQl+xXpn7fDptOFshAbTF7NcuZTJdRiXwGcz
         01TbAQTa5g5Lq+3EWkWRG9jK9MUYVDYWlBBtjn8H6Oj7kGlHdetBbpilEqt/h11/xXkS
         J7vbU0gpAv7ILGRXxR8WYiW9wAq5r3Lur9NqRBCRrdkn30OdqwnUpMy+R3wTkyw5mA8G
         BFPF7L6Epin872C7dgk3gxu77SnjHK8Pg3xioLLGS+86ig0iM7NIZRzS8+DuW64TpGtw
         scq29Jvy00rGy7/h70XJ0+XLhVzXBgCOzKOMXMh7ejs4TA4yW2lRwRiFN7gYSZzl1kIh
         6kKw==
X-Gm-Message-State: AOAM533wYmjTxhl9ezlM8zjHELGvpCCgh5+HCD6yDz+L1cnIIuVX5cbV
        L6uswnbefBBXTvxxuUdeU2g=
X-Google-Smtp-Source: ABdhPJzxD2AKVD1O1HSQXwLsbUtseVF7AgWGDfh1jQ9rakujHZ6Q6mbGkNjKFmHJZBEmCueVVGbL5Q==
X-Received: by 2002:a05:6a00:1903:b029:3b6:7918:7ddf with SMTP id y3-20020a056a001903b02903b679187ddfmr901317pfi.53.1628191158947;
        Thu, 05 Aug 2021 12:19:18 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 22/52] hpsa: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:17:58 -0700
Message-Id: <20210805191828.3559897-23-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
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

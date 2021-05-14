Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2519C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8745613C5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhENVfz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:35:55 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:43752 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbhENVfx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:35:53 -0400
Received: by mail-pg1-f175.google.com with SMTP id k15so239296pgb.10
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6CTnkeKhcotq5OMfqrz/2VKArxZCP+Flz3k3xUHSvnE=;
        b=BRTaSjUDeTxRLSG6oRErSYRRSJ+A0nZAmBQKqhmDRFXOQtiFRRmWfmkE6zHxG2vkkU
         x4PL2zzGXEHtnj0ZN0fxtD/fh3TierHu2qRm+9sLok7RjKj3nM2Ztop+nJvrMJIufx5Y
         AiJoE/9QwSy5hUsV9RIu3BvLIdKKK8nMGQbCqbycx4XNpliyepqvWzMWe8dWmA9lvRK+
         WHsjvjO7FtW21TUFNlxhoMFtrpfl/PdgNXNA1eVfd/c6s41nQLQnXmNgODnlvm1NskPz
         0D3Nr9mejXYoLJaKevpn66lShgX6ESbOvr9NCE/GBcNeCEFnI/OGiIT9C7WBXw780bfh
         X3QA==
X-Gm-Message-State: AOAM5319g6X64ZhIiG8scg38aBAXMfhKvAgEY9Dnd25Z7fGWAEaMZRmP
        qXURGHJBUNiepS8a2xK2GlI=
X-Google-Smtp-Source: ABdhPJx80quJ3b87xUeyczLFwU4RPILHMZMlRXsjXMkV41/b/fHDVvRLZ1AdxayZzW5RXD831ZUbmw==
X-Received: by 2002:a63:ba5b:: with SMTP id l27mr49480016pgu.343.1621028080734;
        Fri, 14 May 2021 14:34:40 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 21/50] hpsa: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:36 -0700
Message-Id: <20210514213356.5264-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hpsa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f135a10f582b..9fcbe9a84de6 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5686,7 +5686,7 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	/* Get the ptr to our adapter structure out of cmd->host. */
 	h = sdev_to_hba(cmd->device);
 
-	BUG_ON(cmd->request->tag < 0);
+	BUG_ON(blk_req(cmd)->tag < 0);
 
 	dev = cmd->device->hostdata;
 	if (!dev) {
@@ -5729,7 +5729,7 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	 *       and is therefore a brand-new command.
 	 */
 	if (likely(cmd->retries == 0 &&
-			!blk_rq_is_passthrough(cmd->request) &&
+			!blk_rq_is_passthrough(blk_req(cmd)) &&
 			h->acciopath_status)) {
 		/* Submit with the retry_pending flag unset. */
 		rc = hpsa_ioaccel_submit(h, c, cmd, false);
@@ -5894,7 +5894,7 @@ static int hpsa_scsi_add_host(struct ctlr_info *h)
  */
 static int hpsa_get_cmd_index(struct scsi_cmnd *scmd)
 {
-	int idx = scmd->request->tag;
+	int idx = blk_req(scmd)->tag;
 
 	if (idx < 0)
 		return idx;

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E20C4320E
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A983F61002
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbhHIXFF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:05 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:34579 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237028AbhHIXE6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:58 -0400
Received: by mail-pl1-f181.google.com with SMTP id d1so18372519pll.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qxkdetmdrpfLQoo+LOofZ2HZfP6SSDkx6wUjDJ2KiEY=;
        b=OrmZwgAl+/UktVggOlhQbmRzSD1ONWVXZXT6yJn9tKjFlNKTTCk5N5ZVgxy7lBTBCe
         HlEg85WWH047frRUIEI0LhToX2M8TsiahbKFmbHIsWDx93MmcfDD4QAgpuAwv5Q/nHfI
         vs2QWBl20zqwtk+r+u80jdlEja3HxJCzKhITJ9Kknaq6njxPBG4XmFEMGpPFl/N+vFN5
         22/vHG9akBNozD7xV9KJqqGFJ/joKLqs9gM4LuF5AqFo3t+153T/N0o1xuxRrNoRtQcr
         W4UiQYDalqiUeHkVwfuV207Su/t7AOEG/cb3rc0vtcYGDPLK+Edfmh7DRSB2BvGUMQ4J
         e3Xg==
X-Gm-Message-State: AOAM532R75b9QpVtWdS8415TCw/sRS9jAAsWfkca4BBoG/XdgFwc1lEK
        SdgwYooDXDSTr2Xb4719OdI=
X-Google-Smtp-Source: ABdhPJx9VPcpuAHgxWbIJiVTdADcfzxV0c9avyLu2oyIOTnFEFIIAhbNS8BMjvib5sMdhxviWtYhdg==
X-Received: by 2002:a17:90a:6c45:: with SMTP id x63mr1512483pjj.0.1628550276980;
        Mon, 09 Aug 2021 16:04:36 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:36 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 22/52] hpsa: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:25 -0700
Message-Id: <20210809230355.8186-23-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Acked-by: Don Brace <don.brace@microchip.com>
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

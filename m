Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E6CC47084
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C932161151
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbhEXDLJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:09 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:35517 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbhEXDLH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:07 -0400
Received: by mail-pj1-f53.google.com with SMTP id lx17-20020a17090b4b11b029015f3b32b8dbso8657041pjb.0
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lCKW2l7mY7+VHiX8bOSqsDYSuMRCMjaHYqY3c+w6fbk=;
        b=hAvL3h/ROOVoq0wWMvu6go1tNwWsXE9AfPeg36vgFNdZpSCC0phZQ9JY3IizferJzm
         UD+4GESimQq0+a0aoGxUbP1M4UJElevXe9rHNRkTAKcjo01tBnc0QwUnx13LjLi5GWdN
         dF3qv78KckyvDKoHpdUoYFB4Zq/uWit90zDBryNhVxqNvgSVlJaEdE1K2vK8Yq21y+wi
         XWuPUzmDqX6ri9oTFgcIWrMhjiLlAHGHZAyQ39o5Oy9U5TYQsG1cVIAUl7/fPuTV8qHE
         v1me7AzJ/yjYwkdQiEtqsZI7NEpuIYc9OWFjOD0baUTTOieoJDaNjBamFEBMBLnHkROX
         GoUg==
X-Gm-Message-State: AOAM5320/T9RKzKPS+racyxTIR76EwRf+JM3mGXO+rT592HXe74m0TGh
        oicQR6QYOkf4pEE+5PvWP+8=
X-Google-Smtp-Source: ABdhPJxeYIGG8/OKzc3hvQv2PkjbUw/FeYyjyIGLQnMPrzcIV0g/vBirJ/9713Vhny4PZhJaNdWDRg==
X-Received: by 2002:a17:902:d2ce:b029:f4:4a5:9a8b with SMTP id n14-20020a170902d2ceb02900f404a59a8bmr23175979plc.70.1621825779613;
        Sun, 23 May 2021 20:09:39 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 22/51] hpsa: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:27 -0700
Message-Id: <20210524030856.2824-23-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
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

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0266C47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE4036117A
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbhEXDLR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:17 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:41740 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbhEXDLM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:12 -0400
Received: by mail-pg1-f173.google.com with SMTP id r1so4203602pgk.8
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q5il6nx3Gp1/6GeYsovY6bMg95WmmBnoyKcZpLwRi+Y=;
        b=Lmcz64f5W4RMOyHonyA8H5TkleQ5FhAAV4RRx8wKCkC55uNSUKj4jLfeqtY8fr8wQK
         MVftxMY1RDLKfnHuOz0uutx+bk4+NyF/Snvg06tTJGNd9vCgllcYRaUWYzX6Eg0YEMTP
         8SA/XMheT+BJj2I+dbM3782rBMf/FZloop09qX1dBvnLAn51OYr70sH78eI85YzP84SV
         H1HGv+nS+g/EYWP93hdNEXCJ27oho6yJbV3e1QjAUHk98Nox4/9/pouSOrFglquJmM/w
         UQGoccG1/mUB1wqamQSKJleaAfNGYlvYKTKG2zKpB5F+GdaRo5eMtnGOv3Jvb45H20Fh
         yotQ==
X-Gm-Message-State: AOAM530Ga3Bum94tqbWoEXyB9na+6dAbWGXEVXyusH1MLClpFfVZAfP0
        asDQ3RJl4e2RoVQ8g2B/n40=
X-Google-Smtp-Source: ABdhPJzcg/qTpQHxZtl0Tg8ygrsZy+YIvX/iSYIrXq5KcDtDa2H8oZuLhr7YsQ4T0UA6UmjiFAghHg==
X-Received: by 2002:a62:4e10:0:b029:2cb:cf3b:d195 with SMTP id c16-20020a624e100000b02902cbcf3bd195mr22331642pfb.74.1621825784517;
        Sun, 23 May 2021 20:09:44 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 25/51] ips: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:30 -0700
Message-Id: <20210524030856.2824-26-bvanassche@acm.org>
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
 drivers/scsi/ips.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index bc33d54a4011..66152888ad8c 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3733,7 +3733,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 		scb->cmd.dcdb.segment_4G = 0;
 		scb->cmd.dcdb.enhanced_sg = 0;
 
-		TimeOut = scb->scsi_cmd->request->timeout;
+		TimeOut = scsi_cmd_to_rq(scb->scsi_cmd)->timeout;
 
 		if (ha->subsys->param[4] & 0x00100000) {	/* If NEW Tape DCDB is Supported */
 			if (!scb->sg_len) {

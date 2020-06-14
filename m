Return-Path: <SRS0=XB8t=73=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A10FC433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E100206D7
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgFNWjl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Jun 2020 18:39:41 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39310 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbgFNWjk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Jun 2020 18:39:40 -0400
Received: by mail-pl1-f193.google.com with SMTP id v24so5999747plo.6
        for <linux-scsi@vger.kernel.org>; Sun, 14 Jun 2020 15:39:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BDOmZksr0Y5yxPjuSZ5zpWwzkMWSDNJDEwgMiKyrVTs=;
        b=EJZio7gH+5LHvQV72xIPWZ3j1tcl6zDkGVkdwE2PpT8qT9vIbIrAIe8i0PEP/cWufu
         w/lPF0Xe3xjJOPbgkmL38HzbsAaaQhBAaJhvbRRsJlO9pjXHlZhRmgAZw8wMMhzjAJZp
         G685txayIBDHAnRFqroNrenRcaBQxuR71Gyu2wVe37ZVXrbwekSu2WzS3Ab3JKYIhIhq
         5RHh5KyHo/XBcDwj9L2pFIN0NIVk+H4ys4i7NYi6l8c0iv1kxMN/6bG7b9FGip7Xf0Bz
         P9oXIulchfkpOCIka8HQRDh/N42S4ZvRnzyl3GF9yTDf2Dd46i92doe+0S9XdMp4vtOE
         Bddw==
X-Gm-Message-State: AOAM531bV6QrHYzxx1+mA84Zk85dQbOk4k+4VD30Hk2yXByFIYvg6M1t
        6uPfsQDnVxE2D+cLckRaqlg=
X-Google-Smtp-Source: ABdhPJzpxabTS+HPAmBq5K9J7VAqEDP8/MyqmAwODy/LYeNbsb8VAg1obqt2jkq/GsJvUEanS+H3qA==
X-Received: by 2002:a17:90a:326d:: with SMTP id k100mr9632625pjb.191.1592174379723;
        Sun, 14 Jun 2020 15:39:39 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u25sm11768711pfm.115.2020.06.14.15.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 15:39:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 8/9] qla2xxx: Make qla2x00_restart_isp() easier to read
Date:   Sun, 14 Jun 2020 15:39:20 -0700
Message-Id: <20200614223921.5851-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200614223921.5851-1-bvanassche@acm.org>
References: <20200614223921.5851-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of using complicated control flow to only have one return statement
at the end of qla2x00_restart_isp(), return an error status as soon as it is
known that this function will fail.

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 39 +++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9e12018e0105..f39a1a40d4c3 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -6998,36 +6998,41 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 static int
 qla2x00_restart_isp(scsi_qla_host_t *vha)
 {
-	int status = 0;
+	int status;
 	struct qla_hw_data *ha = vha->hw;
 
 	/* If firmware needs to be loaded */
 	if (qla2x00_isp_firmware(vha)) {
 		vha->flags.online = 0;
 		status = ha->isp_ops->chip_diag(vha);
-		if (!status)
-			status = qla2x00_setup_chip(vha);
+		if (status)
+			return status;
+		status = qla2x00_setup_chip(vha);
+		if (status)
+			return status;
 	}
 
-	if (!status && !(status = qla2x00_init_rings(vha))) {
-		clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
-		ha->flags.chip_reset_done = 1;
+	status = qla2x00_init_rings(vha);
+	if (status)
+		return status;
 
-		/* Initialize the queues in use */
-		qla25xx_init_queues(ha);
+	clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
+	ha->flags.chip_reset_done = 1;
 
-		status = qla2x00_fw_ready(vha);
-		if (!status) {
-			/* Issue a marker after FW becomes ready. */
-			qla2x00_marker(vha, ha->base_qpair, 0, 0, MK_SYNC_ALL);
-			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
-		}
+	/* Initialize the queues in use */
+	qla25xx_init_queues(ha);
 
+	status = qla2x00_fw_ready(vha);
+	if (status) {
 		/* if no cable then assume it's good */
-		if ((vha->device_flags & DFLG_NO_CABLE))
-			status = 0;
+		return vha->device_flags & DFLG_NO_CABLE ? 0 : status;
 	}
-	return (status);
+
+	/* Issue a marker after FW becomes ready. */
+	qla2x00_marker(vha, ha->base_qpair, 0, 0, MK_SYNC_ALL);
+	set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+
+	return 0;
 }
 
 static int

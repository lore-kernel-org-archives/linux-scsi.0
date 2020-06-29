Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E504AC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF30B2063A
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgF2WzS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 18:55:18 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35854 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728557AbgF2WzS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 18:55:18 -0400
Received: by mail-pl1-f196.google.com with SMTP id j4so7677360plk.3
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 15:55:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c4qWr2leQEMpUXEVFjPfdW12G03OefomdvgWKeskTnI=;
        b=i28hM9IOhmjXWFrn+XKLODT7c+H8sqoG5+yDfO9tVPX52inyjgl1pPt3iKPtNIQFyF
         I8DbsFWv6K1x5YnH6udO/HR9uF28uelvh3YShKlPsGxieKvfI5p4DXq9u7X8BoOcL94c
         i+sriiUlbbC3Kf0ha6sItCL2EjfAUxJS5ypmucdnAdyEbGc7u28zsMLuSQYM1VFQWqTT
         Ojv5yh5lu4wfCP6TpBzwXUcJckKuXFJSGfcq9SC84WcHAb5gMEG0pEvLQssa5qPZQ3Cy
         Waw+5XZFtEStzxhDCpxyMoOtRGlUATEeeHlAJhWop9UM8ryd9xC+mmVejpoHxMJroHhN
         +hww==
X-Gm-Message-State: AOAM53022BqzfeGy5bTp/3bzHwShW//KZCRL7TGzmmk27IPCEqZ0jUT0
        XIW+XtLPPqudeCn5JUw5kHc=
X-Google-Smtp-Source: ABdhPJzfnXHIApUxnEgvl16qYX5ucRlWfiwZ4U2ymLrFhzNQWjP42/x0oT1Nf7yDQTEz2Q09x4CvQg==
X-Received: by 2002:a17:90b:801:: with SMTP id bk1mr20363180pjb.2.1593471317392;
        Mon, 29 Jun 2020 15:55:17 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id mr8sm478379pjb.5.2020.06.29.15.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 15:55:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 8/9] qla2xxx: Make qla2x00_restart_isp() easier to read
Date:   Mon, 29 Jun 2020 15:54:53 -0700
Message-Id: <20200629225454.22863-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629225454.22863-1-bvanassche@acm.org>
References: <20200629225454.22863-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of using complicated control flow to only have one return statement
at the end of qla2x00_restart_isp(), return an error status as soon as it is
known that this function will fail.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 39 +++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d2717e7cf22a..8c739abf5589 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -6996,36 +6996,41 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
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

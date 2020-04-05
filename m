Return-Path: <SRS0=3U4t=5V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC9BC2BA19
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 22:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A380206F8
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 22:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbgDEW7N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Apr 2020 18:59:13 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37760 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgDEW7N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Apr 2020 18:59:13 -0400
Received: by mail-pf1-f195.google.com with SMTP id u65so6642189pfb.4
        for <linux-scsi@vger.kernel.org>; Sun, 05 Apr 2020 15:59:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cu0K+RAxDn64fQ9+VF/JwBGSpcWi63gyVFtcSmWZZbU=;
        b=XNb0IOodayS1ngOGvx26RPHP+RSv23Y1IHlItE/FfAwoQ4TA0B50QbmeZi7LDDCjsX
         0oBrXxC6KZg/R982t2KL4mD9PH6bPCgsOKJFk64Tk6xML3JUl5oa2tUj7tRKPcVJyUyB
         rNEnxhqD3deqskZbQAjqqrTweYYXLpoCxfm+6N2sxQ75i80xSQsSfglUOyywCCfH8bA5
         g7c5vIYgVkxz3I1UNUnD0HZ2pV2JYGuHV1+XKciiN6X3SdhfjXOIgm0/HkbVewrSaC8k
         6KBBvBKPkam6OfqxJp5sgqZ7Z7unXD+FgO9uipCbiDQfOcn2uVLeWoCZoB8nFd68Y2y8
         aLyw==
X-Gm-Message-State: AGi0PuYjM+bEZt35ctJtDhq6wfg3wifLzCTgXujGwejIa2ZtabNjpE8f
        if/gi2Rp2MJfz0wavMjsaPo=
X-Google-Smtp-Source: APiQypLOx0ekWVCJmeynZrlLPGeLwq2D8YvQyMNuAOJIH6BhAiNZoGImv9iO7dRpwuJL1/CeEfrnWw==
X-Received: by 2002:a63:5d42:: with SMTP id o2mr18009831pgm.265.1586127552416;
        Sun, 05 Apr 2020 15:59:12 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7d7b:4f16:40c2:d1f9])
        by smtp.gmail.com with ESMTPSA id r59sm10947626pjb.45.2020.04.05.15.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2020 15:59:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH] qla2xxx: Split qla2x00_configure_local_loop()
Date:   Sun,  5 Apr 2020 15:59:05 -0700
Message-Id: <20200405225905.17171-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The size of the function qla2x00_configure_local_loop() hurts its
readability. Hence split that function. This patch does not change
any functionality.

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 92 ++++++++++++++++++---------------
 1 file changed, 50 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5b2deaa730bf..80390d3f3236 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5081,6 +5081,54 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 	return (rval);
 }
 
+static int qla2x00_configure_n2n_loop(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags;
+	fc_port_t *fcport;
+	int rval;
+
+	if (test_and_clear_bit(N2N_LOGIN_NEEDED, &vha->dpc_flags)) {
+		/* borrowing */
+		u32 *bp, sz;
+
+		memset(ha->init_cb, 0, ha->init_cb_size);
+		sz = min_t(int, sizeof(struct els_plogi_payload),
+			   ha->init_cb_size);
+		rval = qla24xx_get_port_login_templ(vha, ha->init_cb_dma,
+						    ha->init_cb, sz);
+		if (rval == QLA_SUCCESS) {
+			__be32 *q = &ha->plogi_els_payld.data[0];
+
+			bp = (uint32_t *)ha->init_cb;
+			cpu_to_be32_array(q, bp, sz / 4);
+			memcpy(bp, q, sizeof(ha->plogi_els_payld.data));
+		} else {
+			ql_dbg(ql_dbg_init, vha, 0x00d1,
+			       "PLOGI ELS param read fail.\n");
+			goto skip_login;
+		}
+	}
+
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
+		if (fcport->n2n_flag) {
+			qla24xx_fcport_handle_login(vha, fcport);
+			return QLA_SUCCESS;
+		}
+	}
+
+skip_login:
+	spin_lock_irqsave(&vha->work_lock, flags);
+	vha->scan.scan_retry++;
+	spin_unlock_irqrestore(&vha->work_lock, flags);
+
+	if (vha->scan.scan_retry < MAX_SCAN_RETRIES) {
+		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
+		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+	}
+	return QLA_FUNCTION_FAILED;
+}
+
 /*
  * qla2x00_configure_local_loop
  *	Updates Fibre Channel Device Database with local loop devices.
@@ -5098,7 +5146,6 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 	int		found_devs;
 	int		found;
 	fc_port_t	*fcport, *new_fcport;
-
 	uint16_t	index;
 	uint16_t	entries;
 	struct gid_list_info *gid;
@@ -5108,47 +5155,8 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 	unsigned long flags;
 
 	/* Inititae N2N login. */
-	if (N2N_TOPO(ha)) {
-		if (test_and_clear_bit(N2N_LOGIN_NEEDED, &vha->dpc_flags)) {
-			/* borrowing */
-			u32 *bp, sz;
-
-			memset(ha->init_cb, 0, ha->init_cb_size);
-			sz = min_t(int, sizeof(struct els_plogi_payload),
-			    ha->init_cb_size);
-			rval = qla24xx_get_port_login_templ(vha,
-			    ha->init_cb_dma, (void *)ha->init_cb, sz);
-			if (rval == QLA_SUCCESS) {
-				__be32 *q = &ha->plogi_els_payld.data[0];
-
-				bp = (uint32_t *)ha->init_cb;
-				cpu_to_be32_array(q, bp, sz / 4);
-
-				memcpy(bp, q, sizeof(ha->plogi_els_payld.data));
-			} else {
-				ql_dbg(ql_dbg_init, vha, 0x00d1,
-				    "PLOGI ELS param read fail.\n");
-				goto skip_login;
-			}
-		}
-
-		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			if (fcport->n2n_flag) {
-				qla24xx_fcport_handle_login(vha, fcport);
-				return QLA_SUCCESS;
-			}
-		}
-skip_login:
-		spin_lock_irqsave(&vha->work_lock, flags);
-		vha->scan.scan_retry++;
-		spin_unlock_irqrestore(&vha->work_lock, flags);
-
-		if (vha->scan.scan_retry < MAX_SCAN_RETRIES) {
-			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
-			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
-		}
-		return QLA_FUNCTION_FAILED;
-	}
+	if (N2N_TOPO(ha))
+		return qla2x00_configure_n2n_loop(vha);
 
 	found_devs = 0;
 	new_fcport = NULL;

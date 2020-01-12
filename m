Return-Path: <SRS0=w4/B=3B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79CF1C33CA2
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 21:08:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D6EB214D8
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 21:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733212AbgALVIw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jan 2020 16:08:52 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37894 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732825AbgALVIw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2020 16:08:52 -0500
Received: by mail-pf1-f194.google.com with SMTP id x185so3878066pfc.5
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jan 2020 13:08:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N5h+fck02B06YMBkT6krPXgUckgYWYUSKtoiUlCjsiA=;
        b=MH3i+y+vvrgh0svgR4puaVzL+IJI/Ga46JCPDcKiLloQ8ggAEvflj3hjGtHuT7AEYR
         lwaZKt11mBZG8FG/7NXa1JAUNFb93X09I75Pf9lBIpqBY4qWTwj9aJ2NcKC7247DHyXQ
         91cPxiDTMFj65tocR8XfRI++tNrD8ridw4XCMMfACYp6N3WVZL+H8t+/5sYk2WCOmOwN
         iluk+5MUIAyQHagKHdoo/7mAu/DydB1rmoA+RwuDuDf/DX6BVzE+giR5P241QtyNYzOf
         Owq1rS2GSm92tMbwjIrQS24QqF6IaNznYnJ5byM/sj561BG2gnp/NnvyARQwTZtqMblD
         OhRg==
X-Gm-Message-State: APjAAAWg2fk3nCMba3ALnjH64xMN40cABJscYaI5eLwjKwvwOekg92DR
        qmuUSKtkQL3GJTFHiYYL8HiUvaoei4o=
X-Google-Smtp-Source: APXvYqwFOV3DH/epI654mC1QQcwP9sOMiv/pn7EIs42JZlX15BwlXGuwJqcrKuG1HIO2QcSfbq6qNQ==
X-Received: by 2002:a62:e912:: with SMTP id j18mr16621879pfh.4.1578863331813;
        Sun, 12 Jan 2020 13:08:51 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:100c:e7d0:aa02:3146])
        by smtp.gmail.com with ESMTPSA id 83sm10483488pgh.12.2020.01.12.13.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 13:08:51 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH] qla2xxx: Fix a NULL pointer dereference in an error path
Date:   Sun, 12 Jan 2020 13:08:46 -0800
Message-Id: <20200112210846.13421-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following Coverity complaint:

FORWARD_NULL

qla_init.c: 5275 in qla2x00_configure_local_loop()
5269
5270     		if (fcport->scan_state == QLA_FCPORT_FOUND)
5271     			qla24xx_fcport_handle_login(vha, fcport);
5272     	}
5273
5274     cleanup_allocation:
>>>     CID 353340:    (FORWARD_NULL)
>>>     Passing null pointer "new_fcport" to "qla2x00_free_fcport", which dereferences it.
5275     	qla2x00_free_fcport(new_fcport);
5276
5277     	if (rval != QLA_SUCCESS) {
5278     		ql_dbg(ql_dbg_disc, vha, 0x2098,
5279     		    "Configure local loop error exit: rval=%x.\n", rval);
5280     	}
qla_init.c: 5275 in qla2x00_configure_local_loop()
5269
5270     		if (fcport->scan_state == QLA_FCPORT_FOUND)
5271     			qla24xx_fcport_handle_login(vha, fcport);
5272     	}
5273
5274     cleanup_allocation:
>>>     CID 353340:    (FORWARD_NULL)
>>>     Passing null pointer "new_fcport" to "qla2x00_free_fcport", which dereferences it.
5275     	qla2x00_free_fcport(new_fcport);
5276
5277     	if (rval != QLA_SUCCESS) {
5278     		ql_dbg(ql_dbg_disc, vha, 0x2098,
5279     		    "Configure local loop error exit: rval=%x.\n", rval);
5280     	}

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Fixes: 3dae220595ba ("scsi: qla2xxx: Use common routine to free fcport struct")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c4e087217484..6560908ed50e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4895,6 +4895,8 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
 void
 qla2x00_free_fcport(fc_port_t *fcport)
 {
+	if (!fcport)
+		return;
 	if (fcport->ct_desc.ct_sns) {
 		dma_free_coherent(&fcport->vha->hw->pdev->dev,
 			sizeof(struct ct_sns_pkt), fcport->ct_desc.ct_sns,

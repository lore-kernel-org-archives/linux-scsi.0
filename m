Return-Path: <SRS0=XB8t=73=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81045C433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68B53206D7
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgFNWjf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Jun 2020 18:39:35 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42525 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbgFNWjd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Jun 2020 18:39:33 -0400
Received: by mail-pf1-f193.google.com with SMTP id b5so6974926pfp.9
        for <linux-scsi@vger.kernel.org>; Sun, 14 Jun 2020 15:39:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IXJAeZclbULJLz3UV/odnTbAv/WR1lO/sH/hFhYb9Gk=;
        b=gtZXNza6FOSBZcqhD/AdVxYf0h96GgTaixQzFYCy5eHv3lWMYti63X0g+lgxi4ahtZ
         MxC4LP81knqcle47alVlb6y+H8FRmTNUBerdC7s7QkFe7eA5TNSsZ1pNiXjOYCy4Qjh7
         ZSpliQZ8zhCb6IjpQNEUb6vHDKCVHzpVIzeGNYal7dGqlXPJX/dq3ihxZb4+QkKxG8yK
         AXBq08W5wlavXw+TmJFNobldEJKkyctF0qRk3udekW9J0fnDXv8PaftN3BD76Sd45aDo
         +fZDqOd8SCbpWqqXNt9sg5oZ0D0wepktTHxSXNptG9C+VWvMQ90+S/vx8DvxoXBOV8sv
         Edug==
X-Gm-Message-State: AOAM530i3YxPYY9pD1YhkHsskNmLNoi6sjIBdMNThngDnOaeSo0dyP4A
        ThG9Oz4BdwdbM+8VPcvpf58=
X-Google-Smtp-Source: ABdhPJyzvVEEUXCLQRLa13yiZft924EuxQ4foqlS7YU55DrgomhHENbnPyPGDMkv2nCJL2/u09/H7g==
X-Received: by 2002:a63:8b4c:: with SMTP id j73mr9565644pge.209.1592174372554;
        Sun, 14 Jun 2020 15:39:32 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u25sm11768711pfm.115.2020.06.14.15.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 15:39:31 -0700 (PDT)
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
Subject: [PATCH 3/9] qla2xxx: Make qla82xx_flash_wait_write_finish() easier to read
Date:   Sun, 14 Jun 2020 15:39:15 -0700
Message-Id: <20200614223921.5851-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200614223921.5851-1-bvanassche@acm.org>
References: <20200614223921.5851-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Return early instead of having a single return statement at the end of this
function. This patch fixes the following sparse warning:

qla_nx.c:1018: qla82xx_flash_wait_write_finish() error: uninitialized symbol 'val'.

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_nx.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 0baf55b7e88f..ff365b434a02 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -966,26 +966,21 @@ qla82xx_read_status_reg(struct qla_hw_data *ha, uint32_t *val)
 static int
 qla82xx_flash_wait_write_finish(struct qla_hw_data *ha)
 {
-	long timeout = 0;
-	uint32_t done = 1 ;
 	uint32_t val;
-	int ret = 0;
+	int i, ret;
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ABYTE_CNT, 0);
-	while ((done != 0) && (ret == 0)) {
+	for (i = 0; i < 50000; i++) {
 		ret = qla82xx_read_status_reg(ha, &val);
-		done = val & 1;
-		timeout++;
+		if (ret < 0 || (val & 1) == 0)
+			return ret;
 		udelay(10);
 		cond_resched();
-		if (timeout >= 50000) {
-			ql_log(ql_log_warn, vha, 0xb00d,
-			    "Timeout reached waiting for write finish.\n");
-			return -1;
-		}
 	}
-	return ret;
+	ql_log(ql_log_warn, vha, 0xb00d,
+	       "Timeout reached waiting for write finish.\n");
+	return -1;
 }
 
 static int

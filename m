Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3423EC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19C4220702
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgF2WzL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 18:55:11 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35846 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728467AbgF2WzK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 18:55:10 -0400
Received: by mail-pl1-f194.google.com with SMTP id j4so7677227plk.3
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 15:55:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HZ7cTZEpamxkssXb8i/G6iTr/lV89FSt/1GQloGQWP8=;
        b=kTgNIY+0+08Qk4A/11R6235fiB98CYt0aO4MkfGQwpkJajB/t3ZjslKJvWCfpsjDbG
         MZ65wdravZpNM5U5PuGL7RTfKxFnM8L9dhVnEBxqZkkiXt+aWoXmEYuNtScDH+tsk8Du
         z/uhQenHkABECFtNJciUbhpAvChJQI2jlBqISktJUtcHqxaEqDotlH9i2amXxRDAOyTM
         UidokMuptj1o2Dyp1xp9uCAOBGxruOlPaABjHs5TP0zPjroVl1wF7DbVi6l42NERvU3S
         UrWazmZYTs+y5z1zh9uAdY0uuNY16DQHHpWTtgiwCSvPVRJHEJ6tbFSprZqNpPQqHT2Q
         lMhA==
X-Gm-Message-State: AOAM533d3w5xfZjTmM5CSk512jj9Sp2kB/9Yfy1P8AmUIxhxL3y4BJJS
        /N+WZj5w7D6WypLFf0jgB8E=
X-Google-Smtp-Source: ABdhPJxyVp1sNRk9M+h+4gggPOTGcDEMbVZVQ2vIJTpe9bQgbkvJyypEbL/ZBD2PXPXDBFKMBqP2ZA==
X-Received: by 2002:a17:90b:2350:: with SMTP id ms16mr11288250pjb.224.1593471309534;
        Mon, 29 Jun 2020 15:55:09 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id mr8sm478379pjb.5.2020.06.29.15.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 15:55:08 -0700 (PDT)
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
Subject: [PATCH v2 3/9] qla2xxx: Make qla82xx_flash_wait_write_finish() easier to read
Date:   Mon, 29 Jun 2020 15:54:48 -0700
Message-Id: <20200629225454.22863-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629225454.22863-1-bvanassche@acm.org>
References: <20200629225454.22863-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Return early instead of having a single return statement at the end of this
function. This patch fixes the following sparse warning:

qla_nx.c:1018: qla82xx_flash_wait_write_finish() error: uninitialized symbol 'val'.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
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

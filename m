Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9EE5C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 00:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A26C0227BF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 00:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfLSAoV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 19:44:21 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42725 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLSAoV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 19:44:21 -0500
Received: by mail-pl1-f193.google.com with SMTP id p9so1732564plk.9
        for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2019 16:44:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mKPMDKjSI53OAMdReROyWuLFmNrLfp4yUuJMrpqd9PE=;
        b=lSPQkIcJYTce+oerBwtVc2dXv5iZ7g+NestU/A7dj2T5dPas0pLqeWSLTGB3498Bpq
         jthF5vckfUWXB7PZ19BDen5w28LvRC8FcVRgQjtprpAsraA4MZHKhUx0kJ9Rv+iN1+Qj
         3gqP9nuaCZT82emOx6iDMkJcaKkXUeFLon11JOii/1MQmkmb1+AjYyjMl0zg9k6eS4Fb
         83t+48sBSi21DYJdzwCylxQGCJtM8XHqObJSF8+9y1VXN9JJYqJKIIor3QoA94JH5ksb
         q4Z6bvyxG/Xrm0MdTiMU6vNx4TN9kHurs3fpe3fmplX+rzJ4qEQSyjpM5SZ2GneFNH0y
         RdKw==
X-Gm-Message-State: APjAAAViNqrNlHZJamMC14lTBnwqu3KVX4IsmAFGj/Ydmpe2C1r3xuz9
        e1Mm0b5UgZqikLVZC9WtPAd3T79L
X-Google-Smtp-Source: APXvYqwlSXH3wp8hsY4/EM4a4Tr2bBfrHkKiwmAS3iSvoMqamxG8Lw02YSFtbSIR9ey8uLy2abLM/Q==
X-Received: by 2002:a17:90a:8a08:: with SMTP id w8mr6177941pjn.125.1576716260357;
        Wed, 18 Dec 2019 16:44:20 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 203sm5073481pfy.185.2019.12.18.16.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 16:44:19 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH] qla2xxx: Fix sparse warnings triggered by the PCI state checking code
Date:   Wed, 18 Dec 2019 16:44:12 -0800
Message-Id: <20191219004412.37639-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following sparse warnings:

drivers/scsi/qla2xxx/qla_mbx.c:120:21: warning: restricted pci_channel_state_t degrades to integer
drivers/scsi/qla2xxx/qla_mbx.c:120:37: warning: restricted pci_channel_state_t degrades to integer

This patch does not change any functionality. From include/linux/pci.h:

enum pci_channel_state {
	/* I/O channel is in normal state */
	pci_channel_io_normal = (__force pci_channel_state_t) 1,

	/* I/O to channel is blocked */
	pci_channel_io_frozen = (__force pci_channel_state_t) 2,

	/* PCI card is dead */
	pci_channel_io_perm_failure = (__force pci_channel_state_t) 3,
};

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 5 ++---
 drivers/scsi/qla2xxx/qla_mr.c  | 5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b7c1108c48e2..935af77e519f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -117,10 +117,9 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 
 	ql_dbg(ql_dbg_mbx, vha, 0x1000, "Entered %s.\n", __func__);
 
-	if (ha->pdev->error_state > pci_channel_io_frozen) {
+	if (ha->pdev->error_state == pci_channel_io_perm_failure) {
 		ql_log(ql_log_warn, vha, 0x1001,
-		    "error_state is greater than pci_channel_io_frozen, "
-		    "exiting.\n");
+		    "PCI channel failed permanently, exiting.\n");
 		return QLA_FUNCTION_TIMEOUT;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 605b59c76c90..5f7efdb0cce7 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -53,10 +53,9 @@ qlafx00_mailbox_command(scsi_qla_host_t *vha, struct mbx_cmd_32 *mcp)
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
-	if (ha->pdev->error_state > pci_channel_io_frozen) {
+	if (ha->pdev->error_state == pci_channel_io_perm_failure) {
 		ql_log(ql_log_warn, vha, 0x115c,
-		    "error_state is greater than pci_channel_io_frozen, "
-		    "exiting.\n");
+		    "PCI channel failed permanently, exiting.\n");
 		return QLA_FUNCTION_TIMEOUT;
 	}
 

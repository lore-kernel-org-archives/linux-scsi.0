Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124A6C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 04:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E437724676
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 04:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgAWEX7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 23:23:59 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:32852 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAWEX7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 23:23:59 -0500
Received: by mail-pl1-f195.google.com with SMTP id ay11so797505plb.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2020 20:23:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9e5hMIV71CaH6APz7IMhqhksRnmdpm3TpSukMvY5/fc=;
        b=rYkuXLmj+/QP9sUf2FzknM/ns8hlcYsT+9gDT3EkjzHfpo0Y20hAOfW9JIKb2FeySd
         jxGz4/JKQwFWdE9pp3py/R4o7h5bMF9HqvR2vb+ejZc/7jjS60nvNE2PN3yKVgST5xrB
         honipp91E40gtgs6e/hbh4KrxiITWgdygm1EAb4jF3eF4m2UDH4Y0csFO6uHpQoGB/cB
         q5YD193n+nt+IDscgvw9pSRFFAwtrtjUwGfOT/uwmZbpRWe2mRuQLo9PafktqOrDjP7t
         KiTQTW80xvMr74zpMpNHDh/46oq/LbL7K2K4y5QuiF+1TDM8MBkmDoNS1P9lodVtKnoj
         GGyg==
X-Gm-Message-State: APjAAAXZfADHtwMS4e2iq5ufv4wvKt+yvQe6O988oC/TqAFMUlBgMFov
        UjgG2x1hyfqzuCsCqQoOqJQ=
X-Google-Smtp-Source: APXvYqzHtiiU6eUB+lP2InSP5gjPE0FbN+ZX5CFoIwOe0XvUtwrm2C8SoOvZNunBN+cyfa5bLTjKhQ==
X-Received: by 2002:a17:902:7883:: with SMTP id q3mr14138223pll.113.1579753438507;
        Wed, 22 Jan 2020 20:23:58 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:d957:4568:237a:bc62])
        by smtp.gmail.com with ESMTPSA id p16sm492879pfq.184.2020.01.22.20.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 20:23:57 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 4/6] qla2xxx: Fix sparse warnings triggered by the PCI state checking code
Date:   Wed, 22 Jan 2020 20:23:43 -0800
Message-Id: <20200123042345.23886-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200123042345.23886-1-bvanassche@acm.org>
References: <20200123042345.23886-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following sparse warnings:

drivers/scsi/qla2xxx/qla_mbx.c:120:21: warning: restricted pci_channel_state_t degrades to integer
drivers/scsi/qla2xxx/qla_mbx.c:120:37: warning: restricted pci_channel_state_t degrades to integer

From include/linux/pci.h:

enum pci_channel_state {
	/* I/O channel is in normal state */
	pci_channel_io_normal = (__force pci_channel_state_t) 1,

	/* I/O to channel is blocked */
	pci_channel_io_frozen = (__force pci_channel_state_t) 2,

	/* PCI card is dead */
	pci_channel_io_perm_failure = (__force pci_channel_state_t) 3,
};

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
index 9e09964f5c0e..ff945d35ba8e 100644
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
index bad043c40622..33161af2c16a 100644
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
 

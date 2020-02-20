Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 701C4C34031
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 04:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FC8F24673
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 04:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgBTEez (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Feb 2020 23:34:55 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39000 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbgBTEey (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Feb 2020 23:34:54 -0500
Received: by mail-pl1-f195.google.com with SMTP id g6so1031901plp.6
        for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2020 20:34:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+IZXfLOeb7cen8x8dsCzQHprKaq9WvC73vzMGNpMDIU=;
        b=ZgOLR0cx2lHG6CcYGBerFoNN/JeSTF22KWVNgNseM/B1S+EIKBQUDIbzEunDd8Owwo
         bsE+pZ38+4odJA9i8sbAMVBkLzxYJA/K03DKSBFhxG3vBZ3Uyz3yoBwcP8ykB26Ce9xk
         oXtC0mwGwGyuQXqi57nrF4UY+pHL7fsQhXNtNHY6k1xk5Zsl60wHP41HWqxK/nFeQ7Be
         xvHgYNuMtkTMyT7MqbWWo7t/1RFB8Oke7mIJEX4rIccFNjtc99AtN72bEFapAJXiKSx5
         BamC3UMBTTFeYgsimcJczWfxHd11PrqAHTSPTr6c9RnT8kGvXEGFbRdl49HuihnTsKrB
         P7zQ==
X-Gm-Message-State: APjAAAWQj8nRC/7xjPSXYQKUvMJP0sCbG9wfDR9bmqQgMpseE4rrLgzc
        U3JPVHDh5ULXpewVNFMj6aA=
X-Google-Smtp-Source: APXvYqz/xDmGUEzjSZRQ7M/nlU2hT8r9BsMyK+SlHgrvmOG4+f+V3yrheevpJtwKxNdnY2keD8aGEw==
X-Received: by 2002:a17:902:59da:: with SMTP id d26mr29004479plj.287.1582173292665;
        Wed, 19 Feb 2020 20:34:52 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:29a7:b1bb:5b40:3d61])
        by smtp.gmail.com with ESMTPSA id b5sm1236263pfb.179.2020.02.19.20.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 20:34:51 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v3 3/5] qla2xxx: Fix sparse warnings triggered by the PCI state checking code
Date:   Wed, 19 Feb 2020 20:34:39 -0800
Message-Id: <20200220043441.20504-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200220043441.20504-1-bvanassche@acm.org>
References: <20200220043441.20504-1-bvanassche@acm.org>
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

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
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
index cad1fc2a1b28..6d120457478e 100644
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
 

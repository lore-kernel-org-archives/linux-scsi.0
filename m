Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 559C5C433E1
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 331C020715
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="l5zpMKNF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgGFMdu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 08:33:50 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:37661 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728917AbgGFMds (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 08:33:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594038828; x=1625574828;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TK1kohfiyJx5lgy+zcMRHkGDBhsN/JpSMDtWmtP20ag=;
  b=l5zpMKNFjxjOYpahkhjXXJz2xED+JmK6PA5L0zMDn4njyH77x6BgOeTf
   I9ESDb393pmpk1ho2aOX5gEgURofQuP/GEzIWtuWRtXxcCjnxFaflHcmp
   dctkUIX/UsGhcyBNRXdwL7GSaSBatmofNRTtDVx830Ts35cV2tqIThNpW
   n/aECgjXf1XDwCKf9carlraTIOyXtQLwq1aOAib8eBEl8UMwDBpoE+87f
   hHvFlSs1+cRgY5RSwc3i3B8xP+bO1Y3hZ2QwUMv++0G7ClT/WocGGjfeD
   GMQoabo2dM6yrj1a2SZ/qfbuNeUzh5H7edWgYJIrL8N8w3wreR5ipMEV5
   g==;
IronPort-SDR: wQ4O/AKtBWunDeVrmHL1FEc20+CZKwIoTWSPuEXcCTprqC94DiTbyRnOlVIPU5ilu9xamDZnDi
 PYodppcr8zOjM4snLE9cPMCzMYyBdYMH/Eu0i0RKrtq/UTiVa+709X0COE6S9JAOAhpf9Bjya7
 XKuotnU4ooaYsx5DJenVVE7zg7HokkIzV0kdyuhAaWrq8kMqgYETQjQanQnS+5F9GatIhhl3Lw
 cop2yP3HKygfr4TwO0nd4EH67TTeBCK9yPudPz4zrtUNN/piKyQzD3quPbNGgcoFJZYoUKdNaW
 LNE=
X-IronPort-AV: E=Sophos;i="5.75,318,1589212800"; 
   d="scan'208";a="146052058"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2020 20:33:48 +0800
IronPort-SDR: ymQ1dd5njpHnP6/qfc4r6nIVZBSqhMcC//IzZ7vWUqh3n/76J/QBsG395tQkgMSQoZ4rcBFnXV
 KHxeQ+5GS+r0OJG5GBDmZ33N23iMTxvOE=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 05:21:56 -0700
IronPort-SDR: +VywGPojNOe7CnPu6JMH7RMUGiHXobg6Q3TbqELUxsxNMazX7b7adoCND7mF8XLASdXPBqyxvE
 vShOkxWaTWEA==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2020 05:33:47 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 02/10] scsi: megaraid: Fix compilation warnings
Date:   Mon,  6 Jul 2020 21:33:46 +0900
Message-Id: <20200706123346.451827-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move functions declarations to megaraid_sas.h to avoid warnings such as

warning: no previous prototype for ‘xxx'

No functional changes.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        | 20 ++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas_base.c   |  4 ----
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 15 ---------------
 3 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index af2c7a2a9565..5e4137f10e0e 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2709,4 +2709,24 @@ int megasas_adp_reset_wait_for_ready(struct megasas_instance *instance,
 				     int ocr_context);
 int megasas_irqpoll(struct irq_poll *irqpoll, int budget);
 void megasas_dump_fusion_io(struct scsi_cmnd *scmd);
+u32 megasas_readl(struct megasas_instance *instance,
+		  const volatile void __iomem *addr);
+struct megasas_cmd *megasas_get_cmd(struct megasas_instance *instance);
+void megasas_return_cmd(struct megasas_instance *instance,
+			struct megasas_cmd *cmd);
+int megasas_issue_polled(struct megasas_instance *instance,
+			 struct megasas_cmd *cmd);
+void megaraid_sas_kill_hba(struct megasas_instance *instance);
+void megasas_check_and_restore_queue_depth(struct megasas_instance *instance);
+void megasas_start_timer(struct megasas_instance *instance);
+int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
+				  int initial);
+int megasas_alloc_cmds(struct megasas_instance *instance);
+void megasas_free_cmds(struct megasas_instance *instance);
+
+void megasas_init_debugfs(void);
+void megasas_exit_debugfs(void);
+void megasas_setup_debugfs(struct megasas_instance *instance);
+void megasas_destroy_debugfs(struct megasas_instance *instance);
+
 #endif				/*LSI_MEGARAID_SAS_H */
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 2fda0dca122a..8038467e446d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -202,10 +202,6 @@ static bool support_pci_lane_margining;
 static spinlock_t poll_aen_lock;
 
 extern struct dentry *megasas_debugfs_root;
-extern void megasas_init_debugfs(void);
-extern void megasas_exit_debugfs(void);
-extern void megasas_setup_debugfs(struct megasas_instance *instance);
-extern void megasas_destroy_debugfs(struct megasas_instance *instance);
 
 void
 megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index c4f15a52f86b..bb3427898177 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -48,9 +48,6 @@
 #include "megaraid_sas.h"
 
 
-extern void megasas_free_cmds(struct megasas_instance *instance);
-extern struct megasas_cmd *megasas_get_cmd(struct megasas_instance
-					   *instance);
 extern void
 megasas_complete_cmd(struct megasas_instance *instance,
 		     struct megasas_cmd *cmd, u8 alt_status);
@@ -58,24 +55,14 @@ int
 wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
 	      int seconds);
 
-void
-megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd);
-int megasas_alloc_cmds(struct megasas_instance *instance);
 int
 megasas_clear_intr_fusion(struct megasas_instance *instance);
-int
-megasas_issue_polled(struct megasas_instance *instance,
-		     struct megasas_cmd *cmd);
-void
-megasas_check_and_restore_queue_depth(struct megasas_instance *instance);
 
 int megasas_transition_to_ready(struct megasas_instance *instance, int ocr);
-void megaraid_sas_kill_hba(struct megasas_instance *instance);
 
 extern u32 megasas_dbg_lvl;
 int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 				  int initial);
-void megasas_start_timer(struct megasas_instance *instance);
 extern struct megasas_mgmt_info megasas_mgmt_info;
 extern unsigned int resetwaittime;
 extern unsigned int dual_qdepth_disable;
@@ -84,8 +71,6 @@ static void megasas_free_reply_fusion(struct megasas_instance *instance);
 static inline
 void megasas_configure_queue_sizes(struct megasas_instance *instance);
 static void megasas_fusion_crash_dump(struct megasas_instance *instance);
-extern u32 megasas_readl(struct megasas_instance *instance,
-			 const volatile void __iomem *addr);
 
 /**
  * megasas_adp_reset_wait_for_ready -	initiate chip reset and wait for
-- 
2.26.2


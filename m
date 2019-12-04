Return-Path: <SRS0=+pba=Z2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F45C2BD09
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 14:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1929F2084F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 14:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbfLDO72 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Dec 2019 09:59:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:36336 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728120AbfLDO71 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Dec 2019 09:59:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BF449AF7A;
        Wed,  4 Dec 2019 14:59:25 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        Balsundar P <balsundar.p@microchip.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Subject: [PATCH 06/13] aacraid: replace aac_flush_ios() with midlayer helper
Date:   Wed,  4 Dec 2019 15:59:11 +0100
Message-Id: <20191204145918.143134-7-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191204145918.143134-1-hare@suse.de>
References: <20191204145918.143134-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the midlayer helper scsi_host_complete_all_commands() to flush all
outstanding commands.

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Balsundar P <balsundar.p@microchip.com>
---
 drivers/scsi/aacraid/linit.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index ee6bc2f9b80a..4d5b34e0d3a9 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1977,26 +1977,6 @@ static void aac_remove_one(struct pci_dev *pdev)
 	}
 }
 
-static void aac_flush_ios(struct aac_dev *aac)
-{
-	int i;
-	struct scsi_cmnd *cmd;
-
-	for (i = 0; i < aac->scsi_host_ptr->can_queue; i++) {
-		cmd = (struct scsi_cmnd *)aac->fibs[i].callback_data;
-		if (cmd && (cmd->SCp.phase == AAC_OWNER_FIRMWARE)) {
-			scsi_dma_unmap(cmd);
-
-			if (aac->handle_pci_error)
-				cmd->result = DID_NO_CONNECT << 16;
-			else
-				cmd->result = DID_RESET << 16;
-
-			cmd->scsi_done(cmd);
-		}
-	}
-}
-
 static pci_ers_result_t aac_pci_error_detected(struct pci_dev *pdev,
 					enum pci_channel_state error)
 {
@@ -2013,7 +1993,7 @@ static pci_ers_result_t aac_pci_error_detected(struct pci_dev *pdev,
 
 		scsi_block_requests(aac->scsi_host_ptr);
 		aac_cancel_rescan_worker(aac);
-		aac_flush_ios(aac);
+		scsi_host_complete_all_commands(shost, DID_NO_CONNECT);
 		aac_release_resources(aac);
 
 		pci_disable_pcie_error_reporting(pdev);
@@ -2023,7 +2003,7 @@ static pci_ers_result_t aac_pci_error_detected(struct pci_dev *pdev,
 	case pci_channel_io_perm_failure:
 		aac->handle_pci_error = 1;
 
-		aac_flush_ios(aac);
+		scsi_host_complete_all_commands(shost, DID_NO_CONNECT);
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
-- 
2.16.4


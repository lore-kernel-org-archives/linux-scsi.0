From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v3] ahci_xgene: Fix the dma state machine lockup for the ATA_CMD_SMART PIO mode command.
Date: Mon,  2 Feb 2015 23:37:19 +0530
Message-ID: <1422900439-5541-2-git-send-email-stripathi@apm.com>
References: <1422900439-5541-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:58073 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932292AbbBBSIQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Feb 2015 13:08:16 -0500
In-Reply-To: <1422900439-5541-1-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>

This patch addresses the issue with ATA_CMD_SMART pio mode
command for enumeration and device detection with ATA devices.
The X-Gene AHCI controller has an errata in which it cannot clear
the BSY bit after the PIO setup FIS. The dma state machine enters
CMFatalErrorUpdate state and locks up. It is the same issue as
in the commit 2a0bdff6b958d1b2523d2754b6cd5e0ea4053016 (ahci-xgene:
fix the dma state machine lockup for the IDENTIFY DEVICE PIO mode
command).

For example :  without this patch it results in READ DMA command failure
as shown below :

 [  126.700072] ata2.00: exception Emask 0x0 SAct 0x0
		SErr 0x0 action 0x6 frozen
 [  126.707089] ata2.00: failed command: READ DMA
 [  126.711426] ata2.00: cmd c8/00:08:00:55:57/00:00:00:00:00/e1 tag 1
                dma 4096 in
 [  126.711426]  res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask
		0x4 (timeout)
 [  126.725956] ata2.00: status: { DRDY }

Signed-off-by: Suman Tripathi <stripathi@apm.com>
Reported-by:   Mark Langsdorf <mlangsdo@redhat.com>
---
---
 drivers/ata/ahci_xgene.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 7f68875..506cf5f 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -211,7 +211,8 @@ static unsigned int xgene_ahci_qc_issue(struct ata_queued_cmd *qc)
 	}

 	if (unlikely((ctx->last_cmd[ap->port_no] == ATA_CMD_ID_ATA) ||
-	    (ctx->last_cmd[ap->port_no] == ATA_CMD_PACKET)))
+	    (ctx->last_cmd[ap->port_no] == ATA_CMD_PACKET) ||
+	    (ctx->last_cmd[ap->port_no] == ATA_CMD_SMART)))
 		xgene_ahci_restart_engine(ap);

 	rc = ahci_qc_issue(qc);
--
1.8.2.1


From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/8] tmscsim: Move 'last_reset' into host structure
Date: Wed, 23 Oct 2013 10:51:18 +0200
Message-ID: <1382518282-107606-5-git-send-email-hare@suse.de>
References: <1382518282-107606-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab3JWIv1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Oct 2013 04:51:27 -0400
In-Reply-To: <1382518282-107606-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Hannes Reinecke <hare@suse.de>

The 'last_reset' value is only used internally, so move it into
the internal host structure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/tmscsim.c | 14 +++++++-------
 drivers/scsi/tmscsim.h |  1 +
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 9327f5f..1142361 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -521,7 +521,7 @@ dc390_StartSCSI( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_sr
 	pACB->SelConn++;
 	return 1;
     }
-    if (time_before (jiffies, pACB->pScsiHost->last_reset))
+    if (time_before (jiffies, pACB->last_reset))
     {
 	DEBUG0(printk ("DC390: We were just reset and don't accept commands yet!\n"));
 	return 1;
@@ -1863,7 +1863,7 @@ dc390_ScsiRstDetect( struct dc390_acb* pACB )
     /* delay half a second */
     udelay (1000);
     DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
-    pACB->pScsiHost->last_reset = jiffies + 5*HZ/2
+    pACB->last_reset = jiffies + 5*HZ/2
 		    + HZ * dc390_eepromBuf[pACB->AdapterIndex][EE_DELAY];
     pACB->Connected = 0;
 
@@ -2048,9 +2048,9 @@ static int DC390_bus_reset (struct scsi_cmnd *cmd)
 
 	dc390_ResetDevParam(pACB);
 	mdelay(1);
-	pACB->pScsiHost->last_reset = jiffies + 3*HZ/2 
+	pACB->last_reset = jiffies + 3*HZ/2
 		+ HZ * dc390_eepromBuf[pACB->AdapterIndex][EE_DELAY];
-    
+
 	DC390_write8(ScsiCmd, CLEAR_FIFO_CMD);
 	DC390_read8(INT_Status);		/* Reset Pending INT */
 
@@ -2383,7 +2383,7 @@ static void dc390_init_hw(struct dc390_acb *pACB, u8 index)
 	if (pACB->Gmode2 & RST_SCSI_BUS) {
 		dc390_ResetSCSIBus(pACB);
 		udelay(1000);
-		shost->last_reset = jiffies + HZ/2 +
+		pACB->last_reset = jiffies + HZ/2 +
 			HZ * dc390_eepromBuf[pACB->AdapterIndex][EE_DELAY];
 	}
 
@@ -2455,8 +2455,8 @@ static int dc390_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->irq = pdev->irq;
 	shost->base = io_port;
 	shost->unique_id = io_port;
-	shost->last_reset = jiffies;
-	
+
+	pACB->last_reset = jiffies;
 	pACB->pScsiHost = shost;
 	pACB->IOPortBase = (u16) io_port;
 	pACB->IRQLevel = pdev->irq;
diff --git a/drivers/scsi/tmscsim.h b/drivers/scsi/tmscsim.h
index 77adc54..3d1bb4a 100644
--- a/drivers/scsi/tmscsim.h
+++ b/drivers/scsi/tmscsim.h
@@ -143,6 +143,7 @@ u8		Ignore_IRQ;	/* Not used */
 
 struct pci_dev	*pdev;
 
+unsigned long   last_reset;
 unsigned long	Cmds;
 u32		SelLost;
 u32		SelConn;
-- 
1.8.1.4


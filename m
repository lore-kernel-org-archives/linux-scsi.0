From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH 2/8][SCSI] mpt2sas: Change in
 MPI2_RAID_ACTION_SYSTEM_SHUTDOWN_INITIATED notification methodology
Date: Thu, 25 Jul 2013 11:25:57 +0530
Message-ID: <20130725055557.GA29883@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:7278
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202Ab3GYF4o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jul 2013 01:56:44 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com

The intent of this patch is to perform a graceful shutdown of target drives even if
volume doesn't exits. Changes done in this patch

1. Removed the check for the presence of volumes before sending down
   MPI2_RAID_ACTION_SYSTEM_SHUTDOWN_INITIATED. Therefore, this RAID action
   would be sent if the card is IR Firmware.

2. The MPI2_RAID_ACTION_SYSTEM_SHUTDOWN_INITIATED is sent even when the
   system undergoes suspend (in addition to remove/shutdown which was already
   present)

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 344db2e..75e6812 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -7710,10 +7710,6 @@ _scsih_ir_shutdown(struct MPT2SAS_ADAPTER *ioc)
 	if (!ioc->ir_firmware)
 		return;
 
-	/* are there any volumes ? */
-	if (list_empty(&ioc->raid_device_list))
-		return;
-
 	mutex_lock(&ioc->scsih_cmds.mutex);
 
 	if (ioc->scsih_cmds.status != MPT2_CMD_NOT_USED) {
@@ -8279,6 +8275,7 @@ _scsih_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	mpt2sas_base_stop_watchdog(ioc);
 	scsi_block_requests(shost);
+	_scsih_ir_shutdown(ioc);
 	device_state = pci_choose_state(pdev, state);
 	printk(MPT2SAS_INFO_FMT "pdev=0x%p, slot=%s, entering "
 	    "operating state [D%d]\n", ioc->name, pdev,
-- 
1.7.3



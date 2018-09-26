From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: megaraid: remove set but not used variables
Date: Wed, 26 Sep 2018 19:09:40 +0800
Message-ID: <20180926110940.16024-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/megaraid/megaraid_mbox.c: In function 'megaraid_mbox_sync_scb':
drivers/scsi/megaraid/megaraid_mbox.c:2193:14: warning:
 variable 'ccb' set but not used [-Wunused-but-set-variable]

drivers/scsi/megaraid/megaraid_mbox.c: In function 'megaraid_reset_handler':
drivers/scsi/megaraid/megaraid_mbox.c:2580:7: warning:
 variable 'recovering' set but not used [-Wunused-but-set-variable]

drivers/scsi/megaraid/megaraid_mbox.c: In function 'mbox_post_sync_cmd':
drivers/scsi/megaraid/megaraid_mbox.c:2728:12: warning:
 variable 'mbox64' set but not used [-Wunused-but-set-variable]

drivers/scsi/megaraid/megaraid_mbox.c: In function 'megaraid_mbox_support_random_del':
drivers/scsi/megaraid/megaraid_mbox.c:3138:11: warning:
 variable 'mbox' set but not used [-Wunused-but-set-variable]

drivers/scsi/megaraid/megaraid_mbox.c: In function 'megaraid_mbox_flush_cache':
drivers/scsi/megaraid/megaraid_mbox.c:3266:10: warning:
 variable 'mbox' set but not used [-Wunused-but-set-variable]

drivers/scsi/megaraid/megaraid_mbox.c: In function 'megaraid_mbox_fire_sync_cmd':
drivers/scsi/megaraid/megaraid_mbox.c:3302:12: warning:
 variable 'mbox64' set but not used [-Wunused-but-set-variable]

drivers/scsi/megaraid/megaraid_mbox.c: In function 'gather_hbainfo':
drivers/scsi/megaraid/megaraid_mbox.c:3797:10: warning:
 variable 'dmajor' set but not used [-Wunused-but-set-variable]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/megaraid/megaraid_mbox.c | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 530358c..e9030c9 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -202,13 +202,6 @@ static void megaraid_mbox_prepare_epthru(adapter_t *, scb_t *,
 MODULE_PARM_DESC(debug_level, "Debug level for driver (default=0)");
 
 /*
- * ### global data ###
- */
-static uint8_t megaraid_mbox_version[8] =
-	{ 0x02, 0x20, 0x04, 0x06, 3, 7, 20, 5 };
-
-
-/*
  * PCI table for all supported controllers.
  */
 static struct pci_device_id pci_id_table_g[] =  {
@@ -2190,10 +2183,6 @@ static DEF_SCSI_QCMD(megaraid_queue_command)
 static void
 megaraid_mbox_sync_scb(adapter_t *adapter, scb_t *scb)
 {
-	mbox_ccb_t	*ccb;
-
-	ccb	= (mbox_ccb_t *)scb->ccb;
-
 	if (scb->dma_direction == PCI_DMA_FROMDEVICE)
 		pci_dma_sync_sg_for_cpu(adapter->pdev,
 					scsi_sglist(scb->scp),
@@ -2577,7 +2566,6 @@ static DEF_SCSI_QCMD(megaraid_queue_command)
 	uint8_t		raw_mbox[sizeof(mbox_t)];
 	int		rval;
 	int		recovery_window;
-	int		recovering;
 	int		i;
 	uioc_t		*kioc;
 
@@ -2591,7 +2579,6 @@ static DEF_SCSI_QCMD(megaraid_queue_command)
 		return FAILED;
 	}
 
-
 	// Under exceptional conditions, FW can take up to 3 minutes to
 	// complete command processing. Wait for additional 2 minutes for the
 	// pending commands counter to go down to 0. If it doesn't, let the
@@ -2640,8 +2627,6 @@ static DEF_SCSI_QCMD(megaraid_queue_command)
 
 	recovery_window = MBOX_RESET_WAIT + MBOX_RESET_EXT_WAIT;
 
-	recovering = adapter->outstanding_cmds;
-
 	for (i = 0; i < recovery_window; i++) {
 
 		megaraid_ack_sequence(adapter);
@@ -2725,13 +2710,10 @@ static DEF_SCSI_QCMD(megaraid_queue_command)
 mbox_post_sync_cmd(adapter_t *adapter, uint8_t raw_mbox[])
 {
 	mraid_device_t	*raid_dev = ADAP2RAIDDEV(adapter);
-	mbox64_t	*mbox64;
 	mbox_t		*mbox;
 	uint8_t		status;
 	int		i;
 
-
-	mbox64	= raid_dev->mbox64;
 	mbox	= raid_dev->mbox;
 
 	/*
@@ -3135,7 +3117,6 @@ static DEF_SCSI_QCMD(megaraid_queue_command)
 static int
 megaraid_mbox_support_random_del(adapter_t *adapter)
 {
-	mbox_t		*mbox;
 	uint8_t		raw_mbox[sizeof(mbox_t)];
 	int		rval;
 
@@ -3157,8 +3138,6 @@ static DEF_SCSI_QCMD(megaraid_queue_command)
 		return 0;
 	}
 
-	mbox = (mbox_t *)raw_mbox;
-
 	memset((caddr_t)raw_mbox, 0, sizeof(mbox_t));
 
 	raw_mbox[0] = FC_DEL_LOGDRV;
@@ -3263,12 +3242,8 @@ static DEF_SCSI_QCMD(megaraid_queue_command)
 static void
 megaraid_mbox_flush_cache(adapter_t *adapter)
 {
-	mbox_t	*mbox;
 	uint8_t	raw_mbox[sizeof(mbox_t)];
 
-
-	mbox = (mbox_t *)raw_mbox;
-
 	memset((caddr_t)raw_mbox, 0, sizeof(mbox_t));
 
 	raw_mbox[0] = FLUSH_ADAPTER;
@@ -3299,7 +3274,6 @@ static DEF_SCSI_QCMD(megaraid_queue_command)
 	mbox_t	*mbox;
 	uint8_t	raw_mbox[sizeof(mbox_t)];
 	mraid_device_t	*raid_dev = ADAP2RAIDDEV(adapter);
-	mbox64_t *mbox64;
 	int	status = 0;
 	int i;
 	uint32_t dword;
@@ -3310,7 +3284,6 @@ static DEF_SCSI_QCMD(megaraid_queue_command)
 
 	raw_mbox[0] = 0xFF;
 
-	mbox64	= raid_dev->mbox64;
 	mbox	= raid_dev->mbox;
 
 	/* Wait until mailbox is free */
@@ -3794,10 +3767,6 @@ static DEF_SCSI_QCMD(megaraid_queue_command)
 static int
 gather_hbainfo(adapter_t *adapter, mraid_hba_info_t *hinfo)
 {
-	uint8_t	dmajor;
-
-	dmajor			= megaraid_mbox_version[0];
-
 	hinfo->pci_vendor_id	= adapter->pdev->vendor;
 	hinfo->pci_device_id	= adapter->pdev->device;
 	hinfo->subsys_vendor_id	= adapter->pdev->subsystem_vendor;
-- 
1.8.3.1

From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH 2/2] pm80xx: Enable BAR shift to avoid BIOS conflict with MPI space for ATTO pm8001 based HBAs.
Date: Thu, 19 Dec 2013 10:50:57 -0500
Message-ID: <1387468257-3177-3-git-send-email-bgrove@attotech.com>
References: <1387468257-3177-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:49148 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754746Ab3LSPvb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2013 10:51:31 -0500
In-Reply-To: <1387468257-3177-1-git-send-email-bgrove@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, xjtuwjp@gmail.com, vasanthalakshmi.tharmarajan@pmcs.com, suresh.thiagarajan@pmcs.com, viswas.g@pmcs.com, Bradley Grove <bgrove@attotech.com>

Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 46ace52..561ca2c 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -644,7 +644,7 @@ static int pm8001_chip_init(struct pm8001_hba_info *pm8001_ha)
 	pci_read_config_word(pm8001_ha->pdev, PCI_DEVICE_ID, &deviceid);
 	/* 8081 controllers need BAR shift to access MPI space
 	* as this is shared with BIOS data */
-	if (deviceid == 0x8081) {
+	if (deviceid == 0x8081 || deviceid == 0x0042) {
 		if (-1 == pm8001_bar4_shift(pm8001_ha, GSM_SM_BASE)) {
 			PM8001_FAIL_DBG(pm8001_ha,
 				pm8001_printk("Shift Bar4 to 0x%x failed\n",
@@ -673,7 +673,7 @@ static int pm8001_chip_init(struct pm8001_hba_info *pm8001_ha)
 	for (i = 0; i < PM8001_MAX_OUTB_NUM; i++)
 		update_outbnd_queue_table(pm8001_ha, i);
 	/* 8081 controller donot require these operations */
-	if (deviceid != 0x8081) {
+	if (deviceid != 0x8081 && deviceid != 0x0042) {
 		mpi_set_phys_g3_with_ssc(pm8001_ha, 0);
 		/* 7->130ms, 34->500ms, 119->1.5s */
 		mpi_set_open_retry_interval_reg(pm8001_ha, 119);
@@ -701,7 +701,7 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
 	u32 gst_len_mpistate;
 	u16 deviceid;
 	pci_read_config_word(pm8001_ha->pdev, PCI_DEVICE_ID, &deviceid);
-	if (deviceid == 0x8081) {
+	if (deviceid == 0x8081 || deviceid == 0x0042) {
 		if (-1 == pm8001_bar4_shift(pm8001_ha, GSM_SM_BASE)) {
 			PM8001_FAIL_DBG(pm8001_ha,
 				pm8001_printk("Shift Bar4 to 0x%x failed\n",
-- 
1.8.3.1


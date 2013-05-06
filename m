From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH V5 07/12] pm80xx: SPC new firmware changes for device id 0x8081
 alone
Date: Mon, 06 May 2013 09:30:30 -0700
Message-ID: <5187DAA6.2000507@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:34079 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754242Ab3EFQ2Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 May 2013 12:28:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Rich.Bono@pmcs.com, xjtuwjp@gmail.com, Vishwanath.Maram@pmcs.com, sakthivel.sk@hcl.com, Sangeetha.Gnanasekaran@pmcs.com, Harry.Yang@pmcs.com

>From 2ce3ecb52358fcd358e1ea93a02522084fc7f968 Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Tue, 19 Mar 2013 18:05:55 +0530
Subject: [PATCH V5 07/12] pm80xx: SPC new firmware changes for device id 0x8081 alone

Additional bar shift for new SPC firmware, applicable to device
id 0x8081 only.

Signed-off-by: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
Acked-by: Jack Wang <jack_wang@usish.com>
Reviewed-by: Hannes Reinecke <hare@suse.de> 
---
 drivers/scsi/pm8001/pm8001_hwi.c |   31 ++++++++++++++++++++++++++++---
 drivers/scsi/pm8001/pm8001_hwi.h |    2 ++
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index c335ae8..3adf499 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -640,6 +640,18 @@ static void init_pci_device_addresses(struct pm8001_hba_info *pm8001_ha)
 static int pm8001_chip_init(struct pm8001_hba_info *pm8001_ha)
 {
 	u8 i = 0;
+	u16 deviceid;
+	pci_read_config_word(pm8001_ha->pdev, PCI_DEVICE_ID, &deviceid);
+	/* 8081 controllers need BAR shift to access MPI space
+	* as this is shared with BIOS data */
+	if (deviceid == 0x8081) {
+		if (-1 == pm8001_bar4_shift(pm8001_ha, GSM_SM_BASE)) {
+			PM8001_FAIL_DBG(pm8001_ha,
+				pm8001_printk("Shift Bar4 to 0x%x failed\n",
+					GSM_SM_BASE));
+			return -1;
+		}
+	}
 	/* check the firmware status */
 	if (-1 == check_fw_ready(pm8001_ha)) {
 		PM8001_FAIL_DBG(pm8001_ha,
@@ -660,9 +672,12 @@ static int pm8001_chip_init(struct pm8001_hba_info *pm8001_ha)
 		update_inbnd_queue_table(pm8001_ha, i);
 	for (i = 0; i < PM8001_MAX_OUTB_NUM; i++)
 		update_outbnd_queue_table(pm8001_ha, i);
-	mpi_set_phys_g3_with_ssc(pm8001_ha, 0);
-	/* 7->130ms, 34->500ms, 119->1.5s */
-	mpi_set_open_retry_interval_reg(pm8001_ha, 119);
+	/* 8081 controller donot require these operations */
+	if (deviceid != 0x8081) {
+		mpi_set_phys_g3_with_ssc(pm8001_ha, 0);
+		/* 7->130ms, 34->500ms, 119->1.5s */
+		mpi_set_open_retry_interval_reg(pm8001_ha, 119);
+	}
 	/* notify firmware update finished and check initialization status */
 	if (0 == mpi_init_check(pm8001_ha)) {
 		PM8001_INIT_DBG(pm8001_ha,
@@ -684,6 +699,16 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
 	u32 max_wait_count;
 	u32 value;
 	u32 gst_len_mpistate;
+	u16 deviceid;
+	pci_read_config_word(pm8001_ha->pdev, PCI_DEVICE_ID, &deviceid);
+	if (deviceid == 0x8081) {
+		if (-1 == pm8001_bar4_shift(pm8001_ha, GSM_SM_BASE)) {
+			PM8001_FAIL_DBG(pm8001_ha,
+				pm8001_printk("Shift Bar4 to 0x%x failed\n",
+					GSM_SM_BASE));
+			return -1;
+		}
+	}
 	init_pci_device_addresses(pm8001_ha);
 	/* Write bit1=1 to Inbound DoorBell Register to tell the SPC FW the
 	table is stop */
diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
index 2399aab..d7c1e20 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -131,6 +131,8 @@
 #define LINKRATE_30			(0x02 << 8)
 #define LINKRATE_60			(0x04 << 8)
 
+/* for new SPC controllers MEMBASE III is shared between BIOS and DATA */
+#define GSM_SM_BASE			0x4F0000
 struct mpi_msg_hdr{
 	__le32	header;	/* Bits [11:0]  - Message operation code */
 	/* Bits [15:12] - Message Category */
-- 
1.7.1


From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 10/30] scsi: aacraid: Change phy luns function to use common bmic function
Date: Tue, 26 Dec 2017 20:34:31 -0800
Message-ID: <20171227043451.27813-11-RaghavaAditya.Renukunta@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0054.outbound.protection.outlook.com ([104.47.42.54]:7488
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751814AbdL0EfM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:35:12 -0500
In-Reply-To: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

Edit function that retrieves phy lun information to use common
bmic function

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
Added missing colon to match kernel coding style

 drivers/scsi/aacraid/aachba.c  | 75 +++++++++++++-----------------------------
 drivers/scsi/aacraid/aacraid.h |  2 +-
 drivers/scsi/aacraid/commsup.c | 11 +------
 3 files changed, 25 insertions(+), 63 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index e02158d..1853bd2 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1853,66 +1853,37 @@ void aac_update_hba_map(struct aac_dev *dev,
 /**
  *	aac_report_phys_luns()	Process topology change
  *	@dev:		aac_dev structure
- *	@fibptr:	fib pointer
+ *	@rescan:	Indicates rescan
  *
  *	Execute a CISS REPORT PHYS LUNS and process the results into
  *	the current hba_map.
  */
-int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr, int rescan)
+int aac_report_phys_luns(struct aac_dev *dev, int rescan)
 {
-	int fibsize, datasize;
-	struct aac_ciss_phys_luns_resp *phys_luns;
+	int rcode = -ENOMEM;
+	int datasize;
 	struct aac_srb *srbcmd;
-	struct sgmap64 *sg64;
-	dma_addr_t addr;
-	u32 vbus, vid;
-	int rcode = 0;
-
-	/* Thor SA Firmware -> CISS_REPORT_PHYSICAL_LUNS */
-	fibsize = sizeof(struct aac_srb) - sizeof(struct sgentry)
-			+ sizeof(struct sgentry64);
-	datasize = sizeof(struct aac_ciss_phys_luns_resp)
-			+ (AAC_MAX_TARGETS - 1) * sizeof(struct _ciss_lun);
-
-	phys_luns = dma_alloc_coherent(&dev->pdev->dev, datasize, &addr,
-				       GFP_KERNEL);
-	if (phys_luns == NULL) {
-		rcode = -ENOMEM;
-		goto err_out;
-	}
-
-	vbus = (u32) le16_to_cpu(
-			dev->supplement_adapter_info.virt_device_bus);
-	vid = (u32) le16_to_cpu(
-			dev->supplement_adapter_info.virt_device_target);
-
-	aac_fib_init(fibptr);
+	struct aac_srb_unit srbu;
+	struct aac_ciss_phys_luns_resp *phys_luns;
 
-	srbcmd = (struct aac_srb *) fib_data(fibptr);
-	srbcmd->function = cpu_to_le32(SRBF_ExecuteScsi);
-	srbcmd->channel = cpu_to_le32(vbus);
-	srbcmd->id = cpu_to_le32(vid);
-	srbcmd->lun = 0;
-	srbcmd->flags = cpu_to_le32(SRB_DataIn);
-	srbcmd->timeout = cpu_to_le32(10);
-	srbcmd->retry_limit = 0;
-	srbcmd->cdb_size = cpu_to_le32(12);
-	srbcmd->count = cpu_to_le32(datasize);
+	datasize = sizeof(struct aac_ciss_phys_luns_resp) +
+		(AAC_MAX_TARGETS - 1) * sizeof(struct _ciss_lun);
+	phys_luns = kmalloc(datasize, GFP_KERNEL);
+	if (phys_luns == NULL)
+		goto err_out;
 
-	memset(srbcmd->cdb, 0, sizeof(srbcmd->cdb));
-	srbcmd->cdb[0] = CISS_REPORT_PHYSICAL_LUNS;
-	srbcmd->cdb[1] = 2; /* extended reporting */
-	srbcmd->cdb[8] = (u8)(datasize >> 8);
-	srbcmd->cdb[9] = (u8)(datasize);
+	memset(&srbu, 0, sizeof(struct aac_srb_unit));
 
-	sg64 = (struct sgmap64 *) &srbcmd->sg;
-	sg64->count = cpu_to_le32(1);
-	sg64->sg[0].addr[1] = cpu_to_le32(upper_32_bits(addr));
-	sg64->sg[0].addr[0] = cpu_to_le32(lower_32_bits(addr));
-	sg64->sg[0].count = cpu_to_le32(datasize);
+	srbcmd = &srbu.srb;
+	srbcmd->flags	= cpu_to_le32(SRB_DataIn);
+	srbcmd->cdb[0]	= CISS_REPORT_PHYSICAL_LUNS;
+	srbcmd->cdb[1]	= 2; /* extended reporting */
+	srbcmd->cdb[8]	= (u8)(datasize >> 8);
+	srbcmd->cdb[9]	= (u8)(datasize);
 
-	rcode = aac_fib_send(ScsiPortCommand64, fibptr, fibsize,
-			FsaNormal, 1, 1, NULL, NULL);
+	rcode = aac_send_safw_bmic_cmd(dev, &srbu, phys_luns, datasize);
+	if (unlikely(rcode < 0))
+		goto err_out;
 
 	/* analyse data */
 	if (rcode >= 0 && phys_luns->resp_flag == 2) {
@@ -1920,7 +1891,7 @@ int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr, int rescan)
 		aac_update_hba_map(dev, phys_luns, rescan);
 	}
 
-	dma_free_coherent(&dev->pdev->dev, datasize, phys_luns, addr);
+	kfree(phys_luns);
 err_out:
 	return rcode;
 }
@@ -2030,7 +2001,7 @@ int aac_get_adapter_info(struct aac_dev* dev)
 	if (!dev->sync_mode && dev->sa_firmware &&
 		dev->supplement_adapter_info.virt_device_bus != 0xffff) {
 		/* Thor SA Firmware -> CISS_REPORT_PHYSICAL_LUNS */
-		rcode = aac_report_phys_luns(dev, fibptr, AAC_INIT);
+		rcode = aac_report_phys_luns(dev, AAC_INIT);
 	}
 
 	if (!dev->in_reset) {
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index bc2a0bc..3a20168 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2639,7 +2639,7 @@ static inline int aac_adapter_check_health(struct aac_dev *dev)
 
 int aac_acquire_irq(struct aac_dev *dev);
 void aac_free_irq(struct aac_dev *dev);
-int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr, int rescan);
+int aac_report_phys_luns(struct aac_dev *dev, int rescan);
 const char *aac_driverinfo(struct Scsi_Host *);
 void aac_fib_vector_assign(struct aac_dev *dev);
 struct fib *aac_fib_alloc(struct aac_dev *dev);
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 9840bd3..f70f112 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1919,7 +1919,6 @@ static void aac_handle_sa_aif(struct aac_dev *dev, struct fib *fibptr)
 {
 	int i, bus, target, container, rcode = 0;
 	u32 events = 0;
-	struct fib *fib;
 	struct scsi_device *sdev;
 
 	if (fibptr->hbacmd_size & SA_AIF_HOTPLUG)
@@ -1942,19 +1941,11 @@ static void aac_handle_sa_aif(struct aac_dev *dev, struct fib *fibptr)
 	case SA_AIF_LDEV_CHANGE:
 	case SA_AIF_BPCFG_CHANGE:
 
-		fib = aac_fib_alloc(dev);
-		if (!fib) {
-			pr_err("aac_handle_sa_aif: out of memory\n");
-			return;
-		}
 		for (bus = 0; bus < AAC_MAX_BUSES; bus++)
 			for (target = 0; target < AAC_MAX_TARGETS; target++)
 				dev->hba_map[bus][target].new_devtype = 0;
 
-		rcode = aac_report_phys_luns(dev, fib, AAC_RESCAN);
-
-		if (rcode != -ERESTARTSYS)
-			aac_fib_free(fib);
+		rcode = aac_report_phys_luns(dev, AAC_RESCAN);
 
 		aac_resolve_luns(dev);
 
-- 
2.9.4

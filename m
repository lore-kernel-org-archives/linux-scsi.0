From: Paul Gortmaker <p_gortmaker@yahoo.com>
Subject: [PATCH] 2.6.9 scsi/advansys.c and !CONFIG_PCI
Date: Mon, 20 Dec 2004 05:27:39 -0500
Message-ID: <41C6A91B.1030403@yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000209030805020002050004"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gold.muskoka.com ([216.123.107.5]:65250 "EHLO gold.muskoka.com")
	by vger.kernel.org with ESMTP id S261291AbULTK0i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Dec 2004 05:26:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000209030805020002050004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

advansys.c fails to build for old ISA cards when CONFIG_PCI is not
enabled.  Patch is against 
http://linux-scsi.bkbits.net:8080/scsi-for-linus-2.6
but should apply to straight 2.6.9

Signed-off-by: Paul Gortmaker <p_gortmaker@yahoo.com>




--------------000209030805020002050004
Content-Type: text/plain;
 name="2.6.9-advansys_diff0"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6.9-advansys_diff0"

--- linux-386/drivers/scsi/advansys.c~	Mon Dec 20 04:59:12 2004
+++ linux-386/drivers/scsi/advansys.c	Mon Dec 20 05:04:35 2004
@@ -4322,12 +4322,12 @@ advansys_detect(struct scsi_host_templat
     int                 ioport = 0;
     int                 share_irq = FALSE;
     int                 iolen = 0;
+    struct device	*dev = NULL;
 #ifdef CONFIG_PCI
     int                 pci_init_search = 0;
     struct pci_dev      *pci_devicep[ASC_NUM_BOARD_SUPPORTED];
     int                 pci_card_cnt_max = 0;
     int                 pci_card_cnt = 0;
-    struct device	*dev = NULL;
     struct pci_dev      *pci_devp = NULL;
     int                 pci_device_id_cnt = 0;
     unsigned int        pci_device_id[ASC_PCI_DEVICE_ID_CNT] = {
@@ -8944,7 +8944,7 @@ DvcAdvWritePCIConfigByte(
 #ifdef CONFIG_PCI
     pci_write_config_byte(to_pci_dev(asc_dvc->cfg->dev), offset, byte_data);
 #else /* CONFIG_PCI */
-    return 0;
+    return;
 #endif /* CONFIG_PCI */
 }
 
@@ -12014,13 +12014,13 @@ AscInitFromAscDvcVar(
     PortAddr            iop_base;
     ushort              cfg_msw;
     ushort              warn_code;
-    ushort              pci_device_id;
+    ushort              pci_device_id = 0;
 
     iop_base = asc_dvc->iop_base;
+#ifdef CONFIG_PCI
     if (asc_dvc->cfg->dev)
         pci_device_id = to_pci_dev(asc_dvc->cfg->dev)->device;
-    else
-	pci_device_id = 0;
+#endif
     warn_code = 0;
     cfg_msw = AscGetChipCfgMsw(iop_base);
     if ((cfg_msw & ASC_CFG_MSW_CLR_MASK) != 0) {

--------------000209030805020002050004--



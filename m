From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/dpt_i2o.c: remove dead code
Date: Mon, 9 Oct 2006 01:16:27 +0200
Message-ID: <20061008231627.GO6755@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:54289 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S932104AbWJHXQc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 Oct 2006 19:16:32 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

The Coverity checker spotted this dead code introduced by
commit a07f353701acae77e023f6270e8af353b37af7c4.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6/drivers/scsi/dpt_i2o.c.old	2006-10-09 00:28:41.000000000 +0200
+++ linux-2.6/drivers/scsi/dpt_i2o.c	2006-10-09 00:29:10.000000000 +0200
@@ -185,28 +185,26 @@
 
         /* search for all Adatpec I2O RAID cards */
 	while ((pDev = pci_get_device( PCI_DPT_VENDOR_ID, PCI_ANY_ID, pDev))) {
 		if(pDev->device == PCI_DPT_DEVICE_ID ||
 		   pDev->device == PCI_DPT_RAPTOR_DEVICE_ID){
 			if(adpt_install_hba(sht, pDev) ){
 				PERROR("Could not Init an I2O RAID device\n");
 				PERROR("Will not try to detect others.\n");
 				return hba_count-1;
 			}
 			pci_dev_get(pDev);
 		}
 	}
-	if (pDev)
-		pci_dev_put(pDev);
 
 	/* In INIT state, Activate IOPs */
 	for (pHba = hba_chain; pHba; pHba = pHba->next) {
 		// Activate does get status , init outbound, and get hrt
 		if (adpt_i2o_activate_hba(pHba) < 0) {
 			adpt_i2o_delete_hba(pHba);
 		}
 	}
 
 
 	/* Active IOPs in HOLD state */
 
 rebuild_sys_tab:


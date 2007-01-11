From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 14/21] aic94xx: Match request_firmware with release_firmware
Date: Thu, 11 Jan 2007 14:15:26 -0800
Message-ID: <20070111221526.3543.14966.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40333 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184AbXAKWPH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:15:07 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMF6Ou015657
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:06 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMF6Wl293098
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:06 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMF6lo018235
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:06 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


The vmalloc() blob holding the sequencer firmware wasn't being released at
module unload time, which resulted in a memory leak.

Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>
Acked-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/aic94xx/aic94xx_init.c |    1 +
 drivers/scsi/aic94xx/aic94xx_seq.c  |    7 +++++++
 drivers/scsi/aic94xx/aic94xx_seq.h  |    1 +
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 9a9ea74..6faa10f 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -886,6 +886,7 @@ static void __exit aic94xx_exit(void)
 	asd_remove_driver_attrs(&aic94xx_pci_driver.driver);
 	pci_unregister_driver(&aic94xx_pci_driver);
 	sas_release_transport(aic94xx_transport_template);
+	asd_release_firmware();
 	asd_destroy_global_caches();
 	asd_printk("%s version %s unloaded\n", ASD_DRIVER_DESCRIPTION,
 		   ASD_DRIVER_VERSION);
diff --git a/drivers/scsi/aic94xx/aic94xx_seq.c b/drivers/scsi/aic94xx/aic94xx_seq.c
index 8451125..21569ec 100644
--- a/drivers/scsi/aic94xx/aic94xx_seq.c
+++ b/drivers/scsi/aic94xx/aic94xx_seq.c
@@ -1232,6 +1232,13 @@ static int asd_seq_start_lseq(struct asd
 	return asd_seq_unpause_lseq(asd_ha, lseq);
 }
 
+int asd_release_firmware(void)
+{
+	if (sequencer_fw)
+		release_firmware(sequencer_fw);
+	return 0;
+}
+
 static int asd_request_firmware(struct asd_ha_struct *asd_ha)
 {
 	int err, i;
diff --git a/drivers/scsi/aic94xx/aic94xx_seq.h b/drivers/scsi/aic94xx/aic94xx_seq.h
index 9e715e5..9437ff0 100644
--- a/drivers/scsi/aic94xx/aic94xx_seq.h
+++ b/drivers/scsi/aic94xx/aic94xx_seq.h
@@ -63,6 +63,7 @@ int asd_pause_lseq(struct asd_ha_struct 
 int asd_unpause_lseq(struct asd_ha_struct *asd_ha, u8 lseq_mask);
 int asd_init_seqs(struct asd_ha_struct *asd_ha);
 int asd_start_seqs(struct asd_ha_struct *asd_ha);
+int asd_release_firmware(void);
 
 void asd_update_port_links(struct asd_ha_struct *asd_ha, struct asd_phy *phy);
 #endif

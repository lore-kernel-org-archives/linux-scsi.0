From: James.Smart@Emulex.Com
Subject: [PATCH 5 of 7] lpfc driver 8.0.30 :  fix get_stats panic
Date: Wed, 10 Aug 2005 15:03:01 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F43A1@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:6286 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1030199AbVHJTDD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 15:03:03 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j7AJ32r7000765
	for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2005 12:03:02 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix panic in lpfc_get_stats()

Symptoms: Panic on sysfs stats access

Cause: In lpfc_get_stats() we are writing to memory that we do not
own.

Fix: Fix our stats structure allocation. Embed phba->link_stats in
struct lpfc_hba and stop treating it like rogue structure.

Note: Embedding midlayer/transport structure in our structure caused
need for more files to include midlayer/transport headers.

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1339,14 +1339,12 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	if (pci_request_regions(pdev, LPFC_DRIVER_NAME))
 		goto out_disable_device;
 
-	host = scsi_host_alloc(&lpfc_template,
-			sizeof (struct lpfc_hba) + sizeof (unsigned long));
+	host = scsi_host_alloc(&lpfc_template, sizeof (struct lpfc_hba));
 	if (!host)
 		goto out_release_regions;
 
 	phba = (struct lpfc_hba*)host->hostdata;
 	memset(phba, 0, sizeof (struct lpfc_hba));
-	phba->link_stats = (void *)&phba[1];
 	phba->host = host;
 
 	phba->fc_flag |= FC_LOADING;
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -23,6 +23,9 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport_fc.h>
+
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
 #include "lpfc_disc.h"
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -29,6 +29,7 @@
 
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_fc.h>
 
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -988,8 +988,7 @@ lpfc_get_stats(struct Scsi_Host *shost)
 {
 	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata[0];
 	struct lpfc_sli *psli = &phba->sli;
-	struct fc_host_statistics *hs =
-			(struct fc_host_statistics *)phba->link_stats;
+	struct fc_host_statistics *hs = &phba->link_stats;
 	LPFC_MBOXQ_t *pmboxq;
 	MAILBOX_t *pmb;
 	int rc=0;
@@ -1020,6 +1019,8 @@ lpfc_get_stats(struct Scsi_Host *shost)
 		return NULL;
 	}
 
+	memset(hs, 0, sizeof (struct fc_host_statistics));
+
 	hs->tx_frames = pmb->un.varRdStatus.xmitFrameCnt;
 	hs->tx_words = (pmb->un.varRdStatus.xmitByteCnt * 256);
 	hs->rx_frames = pmb->un.varRdStatus.rcvFrameCnt;
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -23,6 +23,9 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport_fc.h>
+
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
 #include "lpfc_disc.h"
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -342,9 +342,6 @@ struct lpfc_hba {
 #define VPD_MASK            0xf         /* mask for any vpd data */
 
 	struct timer_list els_tmofunc;
-
-	void *link_stats;
-
 	/*
 	 * stat  counters
 	 */
@@ -370,6 +367,8 @@ struct lpfc_hba {
 	struct list_head freebufList;
 	struct list_head ctrspbuflist;
 	struct list_head rnidrspbuflist;
+
+	struct fc_host_statistics link_stats;
 };
 
 
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -27,6 +27,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_fc.h>
 
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"

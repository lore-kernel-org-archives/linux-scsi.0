From: ojab <ojab@ojab.ru>
Subject: [PATCH] mpt3sas: disable ASPM for MPI2 controllers
Date: Wed, 28 Dec 2016 11:00:56 +0000
Message-ID: <20161228110056.6250-1-ojab@ojab.ru>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33933 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751292AbcL1LB2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Dec 2016 06:01:28 -0500
Received: by mail-lf0-f68.google.com with SMTP id d16so17340782lfb.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2016 03:01:26 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, ojab <ojab@ojab.ru>

MPI2 controllers sometimes got lost (i. e. disappears from
/sys/bus/pci/devices) if ASMP is enabled.

Signed-off-by: ojab <ojab@ojab.ru>
Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=60644
---
Not sure if it's a complete fix, but at least I can't reproduce the issue
locally with it applied.

Also it's my first patch, so I've surely screwed up some formatting etc.

 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b5c966e..203651a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -51,6 +51,7 @@
 #include <linux/workqueue.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
+#include <linux/pci-aspm.h>
 #include <linux/interrupt.h>
 #include <linux/aer.h>
 #include <linux/raid_class.h>
@@ -8734,6 +8735,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)

 	switch (hba_mpi_version) {
 	case MPI2_VERSION:
+		pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
+			PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_CLKPM);
 		/* Use mpt2sas driver host template for SAS 2.0 HBA's */
 		shost = scsi_host_alloc(&mpt2sas_driver_template,
 		  sizeof(struct MPT3SAS_ADAPTER));
--
2.10.0

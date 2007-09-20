From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] Clean up IOC reset code to obey coding style
Date: Thu, 20 Sep 2007 15:28:56 -0700
Message-ID: <20070920222856.GD24047@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41479 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbXITW2v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2007 18:28:51 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8KMUIaQ007973
	for <linux-scsi@vger.kernel.org>; Thu, 20 Sep 2007 18:30:18 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8KMSo3q675880
	for <linux-scsi@vger.kernel.org>; Thu, 20 Sep 2007 18:28:50 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8KMSoMU004011
	for <linux-scsi@vger.kernel.org>; Thu, 20 Sep 2007 18:28:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, support@lsi.com, DL-MPTFusionLinux@lsi.com, Eric.Moore@lsi.com

Randy Dunlap scolded me for introducing poorly styled code.  Since it
was a copy-and-paste block from mpt_suspend(), fix both.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/message/fusion/mptbase.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 40b8b41..2952a54 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1721,10 +1721,9 @@ mpt_suspend(struct pci_dev *pdev, pm_message_t state)
 	pci_save_state(pdev);
 
 	/* put ioc into READY_STATE */
-	if(SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, CAN_SLEEP)) {
+	if (SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, CAN_SLEEP))
 		printk(MYIOC_s_ERR_FMT
 		"pci-suspend:  IOC msg unit reset failed!\n", ioc->name);
-	}
 
 	/* disable interrupts */
 	CHIPREG_WRITE32(&ioc->chip->IntMask, 0xFFFFFFFF);
@@ -1773,10 +1772,9 @@ mpt_resume(struct pci_dev *pdev)
 		CHIPREG_READ32(&ioc->chip->Doorbell));
 
 	/* put ioc into READY_STATE */
-	if(SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, CAN_SLEEP)) {
+	if (SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, CAN_SLEEP))
 		printk(MYIOC_s_ERR_FMT
 		"pci-resume:  IOC msg unit reset failed!\n", ioc->name);
-	}
 
 	/* bring ioc to operational state */
 	if ((recovery_state = mpt_do_ioc_recovery(ioc,

From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 3/6] cxlflash: Fix to avoid EEH and host reset collisions
Date: Fri,  2 Sep 2016 15:39:30 -0500
Message-ID: <1472848770-65034-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1472848612-64888-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59265 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753912AbcIBUjo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2016 16:39:44 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u82KXFXT143880
        for <linux-scsi@vger.kernel.org>; Fri, 2 Sep 2016 16:39:44 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 257639xqtc-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 02 Sep 2016 16:39:44 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Fri, 2 Sep 2016 14:39:43 -0600
In-Reply-To: <1472848612-64888-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

The EEH reset handler is ignorant to the current state of the
driver when processing a frozen event and initiating a device
reset. This can be an issue if an EEH event occurs while a user
or stack initiated reset is executing. More specifically, if an
EEH occurs while the SCSI host reset handler is active, the reset
initiated by the EEH thread will likely collide with the host reset
thread. This can leave the device in an inconsistent state, or worse,
cause a system crash.

As a remedy, the EEH handler is updated to evaluate the device state
and take appropriate action (proceed, wait, or disconnect host). The
host reset handler is also updated to handle situations where an EEH
occurred during a host reset. In such situations, the host reset handler
will delay reporting back a success to give the EEH reset an opportunity
to complete.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 4c2559a..4ef5235 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -2042,6 +2042,11 @@ retry:
  * cxlflash_eh_host_reset_handler() - reset the host adapter
  * @scp:	SCSI command from stack identifying host.
  *
+ * Following a reset, the state is evaluated again in case an EEH occurred
+ * during the reset. In such a scenario, the host reset will either yield
+ * until the EEH recovery is complete or return success or failure based
+ * upon the current device state.
+ *
  * Return:
  *	SUCCESS as defined in scsi/scsi.h
  *	FAILED as defined in scsi/scsi.h
@@ -2074,7 +2079,8 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
 		} else
 			cfg->state = STATE_NORMAL;
 		wake_up_all(&cfg->reset_waitq);
-		break;
+		ssleep(1);
+		/* fall through */
 	case STATE_RESET:
 		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
 		if (cfg->state == STATE_NORMAL)
@@ -2590,6 +2596,9 @@ out_remove:
  * @pdev:	PCI device struct.
  * @state:	PCI channel state.
  *
+ * When an EEH occurs during an active reset, wait until the reset is
+ * complete and then take action based upon the device state.
+ *
  * Return: PCI_ERS_RESULT_NEED_RESET or PCI_ERS_RESULT_DISCONNECT
  */
 static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
@@ -2603,6 +2612,10 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
 
 	switch (state) {
 	case pci_channel_io_frozen:
+		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
+		if (cfg->state == STATE_FAILTERM)
+			return PCI_ERS_RESULT_DISCONNECT;
+
 		cfg->state = STATE_RESET;
 		scsi_block_requests(cfg->host);
 		drain_ioctls(cfg);
-- 
2.1.0


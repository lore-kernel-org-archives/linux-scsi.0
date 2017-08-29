From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH] scsi: csiostor: enable PCIe relax ordering if supported
Date: Tue, 29 Aug 2017 21:18:46 +0530
Message-ID: <1504021726-12777-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:56811 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751241AbdH2Ps7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 11:48:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, varun@chelsio.com, rajesh.kumar@chelsio.com

Set PCIe relax ordering bits in FW_IQ_CMD if
relax ordering is enabled in the PCIe device.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/csiostor/csio_hw.h   | 3 +++
 drivers/scsi/csiostor/csio_init.c | 3 +++
 drivers/scsi/csiostor/csio_mb.c   | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/drivers/scsi/csiostor/csio_hw.h b/drivers/scsi/csiostor/csio_hw.h
index 9acb895..49e190b 100644
--- a/drivers/scsi/csiostor/csio_hw.h
+++ b/drivers/scsi/csiostor/csio_hw.h
@@ -368,6 +368,9 @@ struct csio_hw_stats {
 #define	CSIO_HWF_HOST_INTR_ENABLED	0x00000200	/* Are host interrupts
 							 * enabled?
 							 */
+#define CSIO_HWF_ROOT_NO_RELAXED_ORDERING 0x00000400	/* Is PCIe relaxed
+							 * ordering enabled
+							 */
 
 #define csio_is_hw_intr_enabled(__hw)	\
 				((__hw)->flags & CSIO_HWF_HW_INTR_ENABLED)
diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index dcd0741..3e6f33c 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -967,6 +967,9 @@ static int csio_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_pci_exit;
 	}
 
+	if (!pcie_relaxed_ordering_enabled(pdev))
+		hw->flags |= CSIO_HWF_ROOT_NO_RELAXED_ORDERING;
+
 	pci_set_drvdata(pdev, hw);
 
 	rv = csio_hw_start(hw);
diff --git a/drivers/scsi/csiostor/csio_mb.c b/drivers/scsi/csiostor/csio_mb.c
index 9451787..7e74ec8 100644
--- a/drivers/scsi/csiostor/csio_mb.c
+++ b/drivers/scsi/csiostor/csio_mb.c
@@ -491,6 +491,7 @@ csio_mb_iq_write(struct csio_hw *hw, struct csio_mb *mbp, void *priv,
 	uint32_t iq_start_stop = (iq_params->iq_start)	?
 					FW_IQ_CMD_IQSTART_F :
 					FW_IQ_CMD_IQSTOP_F;
+	int relaxed = !(hw->flags & CSIO_HWF_ROOT_NO_RELAXED_ORDERING);
 
 	/*
 	 * If this IQ write is cascaded with IQ alloc request, do not
@@ -537,6 +538,8 @@ csio_mb_iq_write(struct csio_hw *hw, struct csio_mb *mbp, void *priv,
 		cmdp->iqns_to_fl0congen |= htonl(
 			FW_IQ_CMD_FL0HOSTFCMODE_V(iq_params->fl0hostfcmode)|
 			FW_IQ_CMD_FL0CPRIO_V(iq_params->fl0cprio)	|
+			FW_IQ_CMD_FL0FETCHRO_V(relaxed)			|
+			FW_IQ_CMD_FL0DATARO_V(relaxed)			|
 			FW_IQ_CMD_FL0PADEN_V(iq_params->fl0paden)	|
 			FW_IQ_CMD_FL0PACKEN_V(iq_params->fl0packen));
 		cmdp->fl0dcaen_to_fl0cidxfthresh |= htons(
-- 
2.0.2

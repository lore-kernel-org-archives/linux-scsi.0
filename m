From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 14/19] lpfc: Fix crash in lpfc_nvme_fcp_io_submit during LIP
Date: Thu, 21 Sep 2017 23:17:36 -0700
Message-ID: <20170922061741.12347-15-jsmart2021@gmail.com>
References: <20170922061741.12347-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36743 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751881AbdIVGSK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 02:18:10 -0400
Received: by mail-pg0-f68.google.com with SMTP id d8so120665pgt.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 23:18:10 -0700 (PDT)
In-Reply-To: <20170922061741.12347-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

The driver is seeing a NULL pointer in lpfc_nvme_fcp_io_submit.
This was ultimately due to a transport AER being send on a terminated
controller, thus some of the values were not set. In case we're in a
system without a corrected transport and in case a race condition
occurs where we enter the routine as the teardown is happening in a
separate thread, validate the parameters before starting the io.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index e6948945a2f2..02ba06f364c4 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1235,6 +1235,16 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 	vport = lport->vport;
 	phba = vport->phba;
 
+	/* Validate pointers. */
+	if (!pnvme_lport || !pnvme_rport || !freqpriv) {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR | LOG_NODE,
+				 "6117 No Send:IO submit ptrs NULL, lport %p, "
+				 "rport %p fcreq_priv %p\n",
+				 pnvme_lport, pnvme_rport, freqpriv);
+		ret = -ENODEV;
+		goto out_fail;
+	}
+
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (phba->ktime_on)
 		start = ktime_get_ns();
-- 
2.13.1

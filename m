From: jsmart2021@gmail.com
Subject: ["PATCH-v2" 13/22] Fix nvme initiator handling when not enabled.
Date: Thu, 20 Apr 2017 15:04:39 -0700
Message-ID: <20170420220448.27095-14-jsmart2021@gmail.com>
References: <20170420220448.27095-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33276 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S947914AbdDTWFX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 18:05:23 -0400
Received: by mail-oi0-f66.google.com with SMTP id a189so14132504oib.0
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2017 15:05:23 -0700 (PDT)
In-Reply-To: <20170420220448.27095-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

Fix nvme initiator handline when CONFIG_LPFC_NVME_INITIATOR is not enabled.

With update nvme upstream driver sources, loading
the driver with nvme enabled resulting in this Oops.

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
 IP: lpfc_nvme_update_localport+0x23/0xd0 [lpfc]
 PGD 0
 Oops: 0000 [#1] SMP
 CPU: 0 PID: 10256 Comm: lpfc_worker_0 Tainted
 Hardware name: ...
 task: ffff881028191c40 task.stack: ffff880ffdf00000
 RIP: 0010:lpfc_nvme_update_localport+0x23/0xd0 [lpfc]
 RSP: 0018:ffff880ffdf03c20 EFLAGS: 00010202

Cause: As the initiator driver completes discovery at different stages,
it call lpfc_nvme_update_localport to hint that the DID and role may have
changed.  In the implementation of lpfc_nvme_update_localport, the driver
was not validating the localport or the lport during the execution
of the update_localport routine.  With the recent upstream additions to
the driver, the create_localport routine didn't run and so the localport
was NULL causing the page-fault Oops.

Fix: Add the CONFIG_LPFC_NVME_INITIATOR preprocessor inclusions to
lpfc_nvme_update_localport to turn off all routine processing when
the running kernel does not have NVME configured.  Add NULL pointer
checks on the localport and lport in lpfc_nvme_update_localport and
dump messages if they are NULL and just exit.
Also one alingment issue fixed.
Repalces the ifdef with the IS_ENABLED macro.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_attr.c |  2 +-
 drivers/scsi/lpfc/lpfc_nvme.c | 15 +++++++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 22819af..4b32d02 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3335,7 +3335,7 @@ LPFC_ATTR_R(enable_fc4_type, LPFC_ENABLE_FCP,
  * percentage will go to NVME.
  */
 LPFC_ATTR_R(xri_split, 50, 10, 90,
-	     "Division of XRI resources between SCSI and NVME");
+	    "Division of XRI resources between SCSI and NVME");
 
 /*
 # lpfc_log_verbose: Only turn this flag on if you are willing to risk being
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index ee1a285..264da8f 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2264,12 +2264,23 @@ lpfc_nvme_destroy_localport(struct lpfc_vport *vport)
 void
 lpfc_nvme_update_localport(struct lpfc_vport *vport)
 {
+#if (IS_ENABLED(CONFIG_NVME_FC))
 	struct nvme_fc_local_port *localport;
 	struct lpfc_nvme_lport *lport;
 
 	localport = vport->localport;
+	if (!localport) {
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_NVME,
+				 "6710 Update NVME fail. No localport\n");
+		return;
+	}
 	lport = (struct lpfc_nvme_lport *)localport->private;
-
+	if (!lport) {
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_NVME,
+				 "6171 Update NVME fail. localP %p, No lport\n",
+				 localport);
+		return;
+	}
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME,
 			 "6012 Update NVME lport %p did x%x\n",
 			 localport, vport->fc_myDID);
@@ -2283,7 +2294,7 @@ lpfc_nvme_update_localport(struct lpfc_vport *vport)
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
 			 "6030 bound lport %p to DID x%06x\n",
 			 lport, localport->port_id);
-
+#endif
 }
 
 int
-- 
2.9.3

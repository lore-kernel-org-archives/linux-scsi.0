From: jsmart2021@gmail.com
Subject: [PATCH v3 02/22] Fix nvme unregister port timeout.
Date: Fri, 21 Apr 2017 16:04:46 -0700
Message-ID: <20170421230506.925-3-jsmart2021@gmail.com>
References: <20170421230506.925-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34311 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426476AbdDUXFO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 19:05:14 -0400
Received: by mail-oi0-f67.google.com with SMTP id y11so21736140oie.1
        for <linux-scsi@vger.kernel.org>; Fri, 21 Apr 2017 16:05:14 -0700 (PDT)
In-Reply-To: <20170421230506.925-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

During some link event testing it was observed that the
wait_for_completion_timeout in the lpfc_nvme_unregister_port
was timing out all the time.

The initiator is claiming the nvme_fc_unregister_remoteport upcall is
not completing the unregister in the time allotted.
[ 2186.151317] lpfc 0000:07:00.0: 0:(0):6169 Unreg nvme wait failed 0

 The wait_for_completion_timeout returns 0 when the wait has
been outstanding for the jiffies passed by the caller.  In this error
message, the nvme initiator passed value 5 - meaning 5 jiffies -
and this is just wrong.

Calculate 5 seconds in Jiffies and pass that value
from the current jiffies.

Also the log message for the unregister timeout was reduced
because timeout failure is the same as timeout.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 0024de1..a39d72c 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2409,6 +2409,7 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	struct lpfc_nvme_lport *lport;
 	struct lpfc_nvme_rport *rport;
 	struct nvme_fc_remote_port *remoteport;
+	unsigned long wait_tmo;
 
 	localport = vport->localport;
 
@@ -2451,11 +2452,12 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		 * before proceeding.  This guarantees the transport and driver
 		 * have completed the unreg process.
 		 */
-		ret = wait_for_completion_timeout(&rport->rport_unreg_done, 5);
+		wait_tmo = msecs_to_jiffies(5000);
+		ret = wait_for_completion_timeout(&rport->rport_unreg_done,
+						  wait_tmo);
 		if (ret == 0) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_DISC,
-					 "6169 Unreg nvme wait failed %d\n",
-					 ret);
+					 "6169 Unreg nvme wait timeout\n");
 		}
 	}
 	return;
-- 
2.9.3

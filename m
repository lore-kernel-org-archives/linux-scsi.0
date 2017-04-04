From: Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [lpfc 08/19] Fix nvme initiator handling when CONFIG_LPFC_NVME_INITIATOR is not enabled.
Date: Tue,  4 Apr 2017 10:17:01 -0700
Message-ID: <1491326232-11255-9-git-send-email-rkennedy@broadcom.com>
References: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:38162 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755168AbdDDRZo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 13:25:44 -0400
Received: from pallmd1.broadcom.com (pallmd1.ash.broadcom.net [10.85.232.165])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 050D430C095
        for <linux-scsi@vger.kernel.org>; Tue,  4 Apr 2017 10:17:30 -0700 (PDT)
In-Reply-To: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <rkennedy@lvnvda1400.lvn.broadcom.net>

With update nvme upstream driver sources, loading
the driver with nvme enabled resulting in this Oops.

Mar  6 10:09:55 NVME-init kernel: BUG: unable to handle kernel NULL pointer dere
ference at 0000000000000018
Mar  6 10:09:55 NVME-init kernel: IP: lpfc_nvme_update_localport+0x23/0xd0 [lpfc
]
Mar  6 10:09:55 NVME-init kernel: PGD 0
Mar  6 10:09:55 NVME-init kernel:
Mar  6 10:09:55 NVME-init kernel: Oops: 0000 [#1] SMP
Mar  6 10:09:55 NVME-init kernel: CPU: 0 PID: 10256 Comm: lpfc_worker_0 Tainted:
 G           O    4.10.0-rc7 #1
Mar  6 10:09:55 NVME-init kernel: Hardware name: Supermicro Super Server/X10DRL-
i, BIOS 2.0 12/18/2015
Mar  6 10:09:55 NVME-init kernel: task: ffff881028191c40 task.stack: ffff880ffdf
00000
Mar  6 10:09:55 NVME-init kernel: RIP: 0010:lpfc_nvme_update_localport+0x23/0xd0
 [lpfc]
Mar  6 10:09:55 NVME-init kernel: RSP: 0018:ffff880ffdf03c20 EFLAGS: 00010202
Mar  6 10:09:55 NVME-init kernel: RAX: 0000000000000003 RBX: ffff88103285b7d0 RC
X: 0000000000000001
Mar  6 10:09:55 NVME-init kernel: RDX: ffff881031c13400 RSI: 0000000000000292 RD
I: ffff88103285b7d0
Mar  6 10:09:55 NVME-init kernel: RBP: ffff880ffdf03c40 R08: 0000000000fffffc R0
9: ffff880fff6c66c0
Mar  6 10:09:55 NVME-init kernel: R10: ffff880fff01f200 R11: ffff880fff6c6680 R1
2: 0000000000000000
Mar  6 10:09:55 NVME-init kernel: R13: ffff8810308ac000 R14: 0000000000000000 R1
5: 0000000000000028
Mar  6 10:09:55 NVME-init kernel: FS:  0000000000000000(0000) GS:ffff88103f20000
0(0000) knlGS:0000000000000000
Mar  6 10:09:55 NVME-init kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050
033
Mar  6 10:09:55 NVME-init kernel: CR2: 0000000000000018 CR3: 0000000001009000 CR
4: 00000000001406f0

Cause: As the initiator driver completes discovery at different stages, it call
lpfc_nvme_update_localport to hint that the DID and role may have changed.  In
the implementation of lpfc_nvme_update_localport, the driver was not
validating the localport or the lport during the execution
of the update_localport routine.  With the recent upstream additions to
the driver, the create_localport routine didn't run and so the localport
was NULL causing the page-fault Oops.

Fix: Add the CONFIG_LPFC_NVME_INITIATOR preprocessor inclusions to
lpfc_nvme_update_localport to turn off all routine processing when
the running kernel does not have NVME configured.  Add NULL pointer
checks on the localport and lport in lpfc_nvme_update_localport and
dump messages if they are NULL and just exit.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 6465aa6..9726c95 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2264,12 +2264,23 @@ lpfc_nvme_destroy_localport(struct lpfc_vport *vport)
 void
 lpfc_nvme_update_localport(struct lpfc_vport *vport)
 {
+#ifdef CONFIG_LPFC_NVME_INITIATOR
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
2.1.0

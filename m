From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 2/9] lpfc: Fix DMA faults observed upon plugging loopback
 connector
Date: Thu, 31 Mar 2016 14:12:28 -0700
Message-ID: <56fd92bc.Lq9Dbv4kVnhvTsYi%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:33270 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160AbcCaVMc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2016 17:12:32 -0400
Received: by mail-pf0-f177.google.com with SMTP id 4so77809717pfd.0
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2016 14:12:32 -0700 (PDT)
Received: from flash (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id e6sm15477303pfj.71.2016.03.31.14.12.29
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Mar 2016 14:12:31 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix DMA faults observed upon plugging loopback connector

Driver didn't program the REG_VFI mailbox correctly, giving the adapter
bad addresses.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_mbox.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index f87f90e..1e34b54 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -2145,10 +2145,12 @@ lpfc_reg_vfi(struct lpfcMboxq *mbox, struct lpfc_vport *vport, dma_addr_t phys)
 	reg_vfi->wwn[1] = cpu_to_le32(reg_vfi->wwn[1]);
 	reg_vfi->e_d_tov = phba->fc_edtov;
 	reg_vfi->r_a_tov = phba->fc_ratov;
-	reg_vfi->bde.addrHigh = putPaddrHigh(phys);
-	reg_vfi->bde.addrLow = putPaddrLow(phys);
-	reg_vfi->bde.tus.f.bdeSize = sizeof(vport->fc_sparam);
-	reg_vfi->bde.tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+	if (phys) {
+		reg_vfi->bde.addrHigh = putPaddrHigh(phys);
+		reg_vfi->bde.addrLow = putPaddrLow(phys);
+		reg_vfi->bde.tus.f.bdeSize = sizeof(vport->fc_sparam);
+		reg_vfi->bde.tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+	}
 	bf_set(lpfc_reg_vfi_nport_id, reg_vfi, vport->fc_myDID);
 
 	/* Only FC supports upd bit */
-- 
2.5.0


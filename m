From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 10/13] lpfc: Fix nvme embedded io length on new hardware
Date: Tue,  6 Feb 2018 18:28:48 -0800
Message-ID: <20180207022851.11800-11-jsmart2021@gmail.com>
References: <20180207022851.11800-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:38417 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752944AbeBGC3I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2018 21:29:08 -0500
Received: by mail-ot0-f195.google.com with SMTP id h14so2989107otj.5
        for <linux-scsi@vger.kernel.org>; Tue, 06 Feb 2018 18:29:08 -0800 (PST)
In-Reply-To: <20180207022851.11800-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Newer hardware more strictly enforces buffer lenghts, causing an
mis-set value to be identified. Older hardware won't catch it.
The difference is benign on old hardware.

Set the right embedded buffer length for nvme ios.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 5a1a6e24a27f..c75958daf799 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -655,7 +655,7 @@ lpfc_nvme_adj_fcp_sgls(struct lpfc_vport *vport,
 
 	/* Word 0-2 - NVME CMND IU (embedded payload) */
 	wqe->generic.bde.tus.f.bdeFlags = BUFF_TYPE_BDE_IMMED;
-	wqe->generic.bde.tus.f.bdeSize = 60;
+	wqe->generic.bde.tus.f.bdeSize = 56;
 	wqe->generic.bde.addrHigh = 0;
 	wqe->generic.bde.addrLow =  64;  /* Word 16 */
 
-- 
2.13.1

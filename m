From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 10/15] lpfc: Fix NVME I+T not registering NVME as a supported FC4 type
Date: Wed, 10 May 2017 12:07:08 -0700
Message-ID: <20170510190713.30171-11-jsmart2021@gmail.com>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34248 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753931AbdEJTHf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2017 15:07:35 -0400
Received: by mail-qk0-f195.google.com with SMTP id u75so726483qka.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 May 2017 12:07:35 -0700 (PDT)
In-Reply-To: <20170510190713.30171-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

When the driver send the RPA command, it does not
send supported FC4 Type NVME to the management server.

Encode NVME (type x28) in the AttribEntry in the
RPA command.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index c7962dae4dab..f2cd19c6c2df 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2092,6 +2092,7 @@ lpfc_fdmi_port_attr_fc4type(struct lpfc_vport *vport,
 
 	ae->un.AttrTypes[3] = 0x02; /* Type 1 - ELS */
 	ae->un.AttrTypes[2] = 0x01; /* Type 8 - FCP */
+	ae->un.AttrTypes[6] = 0x01; /* Type 40 - NVME */
 	ae->un.AttrTypes[7] = 0x01; /* Type 32 - CT */
 	size = FOURBYTES + 32;
 	ad->AttrLen = cpu_to_be16(size);
-- 
2.11.0

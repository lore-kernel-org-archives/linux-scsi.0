From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 19/21] lpfc: Disable FDMI probing if not connected to a
 fabric
Date: Wed, 06 Jul 2016 12:36:12 -0700
Message-ID: <577d5dac.IWJT5/2li7EwQBnO%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37447 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbcGFTgS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:36:18 -0400
Received: by mail-wm0-f49.google.com with SMTP id a66so5735992wme.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:36:17 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id kc7sm2433295wjb.10.2016.07.06.12.36.14
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:36:15 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Disable FDMI probing if not connected to a fabric

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index a38816e..63e48d4 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1510,6 +1510,10 @@ lpfc_fdmi_num_disc_check(struct lpfc_vport *vport)
 	if (!lpfc_is_link_up(phba))
 		return;
 
+	/* Must be connected to a Fabric */
+	if (!(vport->fc_flag & FC_FABRIC))
+		return;
+
 	if (!(vport->fdmi_port_mask & LPFC_FDMI_PORT_ATTR_num_disc))
 		return;
 
-- 
2.5.0


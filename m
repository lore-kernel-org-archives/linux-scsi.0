From: Satish Kharat <satishkh@cisco.com>
Subject: [PATCH 1/1] fnic: bug fix for fip.fip_subcode in fnic_fcoe_send_vlan_req
Date: Wed, 22 Mar 2017 16:55:01 -0700
Message-ID: <1490226901-24504-1-git-send-email-satishkh@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-7.cisco.com ([173.37.86.78]:30983 "EHLO
        rcdn-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754796AbdCVXzS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2017 19:55:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: satishkh@cisco.com, sebaddel@cisco.com

This is a bug introduced when they moved the fip subcodes
to central place. Was sending FIP_SC_VL_NOTE in fip.fip_subcode
for VLAN request in fnic_fcoe_send_vlan_req. Change is to use
FIP_SC_VL_REQ instead.

Signed-off-by: Satish Kharat <satishkh@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/fnic/fnic_fcs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 3b7da66..f5e632f 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -359,7 +359,7 @@ static void fnic_fcoe_send_vlan_req(struct fnic *fnic)
 
 	vlan->fip.fip_ver = FIP_VER_ENCAPS(FIP_VER);
 	vlan->fip.fip_op = htons(FIP_OP_VLAN);
-	vlan->fip.fip_subcode = FIP_SC_VL_NOTE;
+	vlan->fip.fip_subcode = FIP_SC_VL_REQ;
 	vlan->fip.fip_dl_len = htons(sizeof(vlan->desc) / FIP_BPW);
 
 	vlan->desc.mac.fd_desc.fip_dtype = FIP_DT_MAC;
-- 
2.7.4

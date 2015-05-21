From: james.smart@avagotech.com (James Smart)
Subject: [PATCH v2 01/15] lpfc: The lpfc driver does not issue RFF_ID and
 RFT_ID in the correct sequence
Date: Thu, 21 May 2015 13:55:16 -0400
Message-ID: <555e1c04.iUZP5CxxteUR0DUk%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:36076 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbbEURzW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2015 13:55:22 -0400
Received: by qkx62 with SMTP id 62so14709785qkx.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2015 10:55:21 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id v1sm13627834qge.47.2015.05.21.10.55.20
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Thu, 21 May 2015 10:55:21 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The lpfc driver does not issue RFF_ID and RFT_ID in the correct sequence

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2500f15..f2db89f 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3868,11 +3868,11 @@ out:
 
 	if (vport->port_state < LPFC_VPORT_READY) {
 		/* Link up discovery requires Fabric registration. */
-		lpfc_ns_cmd(vport, SLI_CTNS_RFF_ID, 0, 0); /* Do this first! */
 		lpfc_ns_cmd(vport, SLI_CTNS_RNN_ID, 0, 0);
 		lpfc_ns_cmd(vport, SLI_CTNS_RSNN_NN, 0, 0);
 		lpfc_ns_cmd(vport, SLI_CTNS_RSPN_ID, 0, 0);
 		lpfc_ns_cmd(vport, SLI_CTNS_RFT_ID, 0, 0);
+		lpfc_ns_cmd(vport, SLI_CTNS_RFF_ID, 0, 0);
 
 		/* Issue SCR just before NameServer GID_FT Query */
 		lpfc_issue_els_scr(vport, SCR_DID, 0);
-- 
1.7.11.7


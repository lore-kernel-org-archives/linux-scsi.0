From: Maninder Singh <maninder1.s@samsung.com>
Subject: [PATCH 1/1] SCSI/bfa: Use port pointer after NULL check
Date: Mon, 29 Jun 2015 10:51:03 +0530
Message-ID: <1435555263-7954-1-git-send-email-maninder1.s@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:53871 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbbF2FVV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2015 01:21:21 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NQO00OZVXJJQ0D0@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 29 Jun 2015 14:21:19 +0900 (KST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, JBottomley@odin.com, linux-scsi@vger.kernel.org
Cc: pankaj.m@samsung.com, Maninder Singh <maninder1.s@samsung.com>

Currently port pointer is derefrenced before NULL check.
So NULL check is misleading, Thus it is better to use port
pointer after NULL Check.

Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Reviewed-by: Akhilesh Kumar <akhilesh.k@samsung.com>
---
 drivers/scsi/bfa/bfa_fcs_lport.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index ff75ef8..542d5c6 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -5826,12 +5826,13 @@ bfa_fcs_lport_get_rport_max_speed(bfa_fcs_lport_t *port)
 	bfa_port_speed_t max_speed = 0;
 	struct bfa_port_attr_s port_attr;
 	bfa_port_speed_t port_speed, rport_speed;
-	bfa_boolean_t trl_enabled = bfa_fcport_is_ratelim(port->fcs->bfa);
+	bfa_boolean_t trl_enabled;
 
 
 	if (port == NULL)
 		return 0;
 
+	trl_enabled = bfa_fcport_is_ratelim(port->fcs->bfa);
 	fcs = port->fcs;
 
 	/* Get Physical port's current speed */
-- 
1.7.9.5


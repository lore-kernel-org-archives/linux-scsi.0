From: Jakob Normark <jakobnormark@gmail.com>
Subject: [PATCH 1/1] bfa: Fix for possible null pointer dereference
Date: Sun, 26 May 2013 21:51:17 +0200
Message-ID: <1369597877-3160-1-git-send-email-jakobnormark@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:64122 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab3EZTv2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 May 2013 15:51:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jakob Normark <jakobnormark@gmail.com>

Fix for cppcheck error in bfa_fcs_lport.c

Kernel version: v3.10-rc2

Signed-off-by: Jakob Normark <jakobnormark@gmail.com>
---
 drivers/scsi/bfa/bfa_fcs_lport.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 1224d04..a37c45a 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -5615,13 +5615,14 @@ bfa_fcs_lport_get_rport_max_speed(bfa_fcs_lport_t *port)
 	bfa_port_speed_t max_speed = 0;
 	struct bfa_port_attr_s port_attr;
 	bfa_port_speed_t port_speed, rport_speed;
-	bfa_boolean_t trl_enabled = bfa_fcport_is_ratelim(port->fcs->bfa);
+	bfa_boolean_t trl_enabled;
 
 
 	if (port == NULL)
 		return 0;
 
 	fcs = port->fcs;
+	trl_enabled = bfa_fcport_is_ratelim(port->fcs->bfa);
 
 	/* Get Physical port's current speed */
 	bfa_fcport_get_attr(port->fcs->bfa, &port_attr);
-- 
1.7.9.5


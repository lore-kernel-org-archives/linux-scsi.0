From: Syam Sidhardhan <syamsidhardh@gmail.com>
Subject: [PATCH] bfa: Fix possible NULL pointer dereference & magic no
Date: Mon, 25 Feb 2013 04:37:51 +0530
Message-ID: <1361747271-29352-1-git-send-email-s.syam@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:59835 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3BXXIC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2013 18:08:02 -0500
Received: by mail-pb0-f41.google.com with SMTP id um15so1334747pbc.28
        for <linux-scsi@vger.kernel.org>; Sun, 24 Feb 2013 15:08:01 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: syamsidhardh@gmail.com, agurumur@brocade.com, vmohan@brocade.com, JBottomley@parallels.com

Check for (port == NULL) has to be done before accessing port.
Also fixes the magic number.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 drivers/scsi/bfa/bfa_fcs_lport.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 1224d04..69cf977 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -5615,11 +5615,13 @@ bfa_fcs_lport_get_rport_max_speed(bfa_fcs_lport_t *port)
 	bfa_port_speed_t max_speed = 0;
 	struct bfa_port_attr_s port_attr;
 	bfa_port_speed_t port_speed, rport_speed;
-	bfa_boolean_t trl_enabled = bfa_fcport_is_ratelim(port->fcs->bfa);
+	bfa_boolean_t trl_enabled;
 
 
 	if (port == NULL)
-		return 0;
+		return BFA_PORT_SPEED_UNKNOWN;
+
+	trl_enabled = bfa_fcport_is_ratelim(port->fcs->bfa);
 
 	fcs = port->fcs;
 
-- 
1.7.9.5


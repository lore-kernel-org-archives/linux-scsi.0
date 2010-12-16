From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] thaw FC local port
Date: Fri, 17 Dec 2010 00:07:37 +0800
Message-ID: <AANLkTi=4waDVnmLg9VRvrwRej+TLe4KGsL58XdWdG091@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54587 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624Ab0LPQHi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Dec 2010 11:07:38 -0500
Received: by wwa36 with SMTP id 36so2596429wwa.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2010 08:07:37 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: Joe Eykholt <jeykholt@cisco.com>, linux-scsi@vger.kernel.org

The state machine of local port is freezed if it could not get ready,
so thawing is necessary.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_lport.c	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/scsi/libfc/fc_lport.c	2010-12-17 00:08:06.000000000 +0800
@@ -1514,11 +1514,11 @@ void fc_lport_enter_flogi(struct fc_lpor

 	fc_lport_state_enter(lport, LPORT_ST_FLOGI);

-	if (lport->point_to_multipoint) {
-		if (lport->port_id)
+	if (lport->point_to_multipoint)
+		if (lport->port_id) {
 			fc_lport_enter_ready(lport);
-		return;
-	}
+			return;
+		}

 	fp = fc_frame_alloc(lport, sizeof(struct fc_els_flogi));
 	if (!fp)

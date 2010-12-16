From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] fix computation related to FC_EX_CLOSED in FC local port
Date: Thu, 16 Dec 2010 23:54:25 +0800
Message-ID: <AANLkTinZ04+m0-TOrv3vbLNH43b4VqKNJ9EyXdJYgj1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42626 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab0LPPy0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Dec 2010 10:54:26 -0500
Received: by wwa36 with SMTP id 36so2582822wwa.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2010 07:54:25 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: Joe Eykholt <jeykholt@cisco.com>, linux-scsi@vger.kernel.org

In fc_lport_error(), FC_EX_CLOSED could be understood to be no more
rettries, so resetting local port is reasonable and necessary.

When processing response to flogi request, FC_EX_CLOSED should be
treated as other errors, since the state machine of local port could
reach reset.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_lport.c	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/scsi/libfc/fc_lport.c	2010-12-16 23:46:06.000000000 +0800
@@ -1013,7 +1013,7 @@ static void fc_lport_error(struct fc_lpo
 		     lport->retry_count);

 	if (PTR_ERR(fp) == -FC_EX_CLOSED)
-		return;
+		goto reset;

 	/*
 	 * Memory allocation failure, or the exchange timed out
@@ -1029,6 +1029,7 @@ static void fc_lport_error(struct fc_lpo

 		schedule_delayed_work(&lport->retry_work, delay);
 	} else
+ reset:
 		fc_lport_enter_reset(lport);
 }

@@ -1428,9 +1429,6 @@ void fc_lport_flogi_resp(struct fc_seq *

 	FC_LPORT_DBG(lport, "Received a FLOGI %s\n", fc_els_resp_type(fp));

-	if (fp == ERR_PTR(-FC_EX_CLOSED))
-		return;
-
 	mutex_lock(&lport->lp_mutex);

 	if (lport->state != LPORT_ST_FLOGI) {

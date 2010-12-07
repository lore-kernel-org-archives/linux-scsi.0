From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] remove return in remote port
Date: Tue, 7 Dec 2010 21:46:47 +0800
Message-ID: <AANLkTimmHCdAW9aEDLcWvMGsst-Rt=0rSVfpReNPn+_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63306 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab0LGNqt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Dec 2010 08:46:49 -0500
Received: by wwa36 with SMTP id 36so14160456wwa.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Dec 2010 05:46:47 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org

Though hard to read, the removed looks unnecessary.

Then it is clear.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_rport.c	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/scsi/libfc/fc_rport.c	2010-12-07 20:47:40.000000000 +0800
@@ -575,7 +575,7 @@ static void fc_rport_error_retry(struct

 	/* make sure this isn't an FC_EX_CLOSED error, never retry those */
 	if (PTR_ERR(fp) == -FC_EX_CLOSED)
-		return fc_rport_error(rdata, fp);
+		goto out;

 	if (rdata->retries < rdata->local_port->max_rport_retry_count) {
 		FC_RPORT_DBG(rdata, "Error %ld in state %s, retrying\n",
@@ -585,10 +585,10 @@ static void fc_rport_error_retry(struct
 		if (PTR_ERR(fp) == -FC_EX_TIMEOUT)
 			delay = 0;
 		schedule_delayed_work(&rdata->retry_work, delay);
-		return;
 	}
-
-	return fc_rport_error(rdata, fp);
+	else
+ out:
+		fc_rport_error(rdata, fp);
 }

 /**

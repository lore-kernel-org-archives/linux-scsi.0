From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] Invalid request_limit unnoticed?
Date: Sat, 02 May 2009 22:14:54 +0200
Message-ID: <49FCA9BE.3030408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:42145 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbZEBUOz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 May 2009 16:14:55 -0400
Received: by ewy24 with SMTP id 24so2993470ewy.37
        for <linux-scsi@vger.kernel.org>; Sat, 02 May 2009 13:14:54 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Remove redundant test on unsigned.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com> 
---
Maybe a different test is required? 

To see that it is unsigned:

git grep -E -n "(req_lim_delta|__be32;$)"

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index c9aa761..8d3925f 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -910,9 +910,6 @@ static void login_rsp(struct srp_event_struct *evt_struct)
 
 	dev_info(hostdata->dev, "SRP_LOGIN succeeded\n");
 
-	if (evt_struct->xfer_iu->srp.login_rsp.req_lim_delta < 0)
-		dev_err(hostdata->dev, "Invalid request_limit.\n");
-
 	/* Now we know what the real request-limit is.
 	 * This value is set rather than added to request_limit because
 	 * request_limit could have been set to -1 by this client.

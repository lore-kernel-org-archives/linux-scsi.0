From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] libfc: fix error handling in fc_exch_rrq_resp()
Date: Fri, 22 Oct 2010 23:21:20 +0800
Message-ID: <AANLkTik3GbuiEGVPigGZp+=RH7qRMarn0cdZJ49Toso7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48380 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab0JVPVV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Oct 2010 11:21:21 -0400
Received: by wyf28 with SMTP id 28so955698wyf.19
        for <linux-scsi@vger.kernel.org>; Fri, 22 Oct 2010 08:21:20 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org

There seems no cleanup left when FC_EX_CLOSED encountered, which may
be from fc_exch_reset().

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_exch.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/libfc/fc_exch.c	2010-10-22 23:17:50.000000000 +0800
@@ -1827,7 +1827,9 @@ static void fc_exch_rrq_resp(struct fc_s
 	if (IS_ERR(fp)) {
 		int err = PTR_ERR(fp);

-		if (err == -FC_EX_CLOSED || err == -FC_EX_TIMEOUT)
+		if (err == -FC_EX_CLOSED)
+			return;
+		if (err == -FC_EX_TIMEOUT)
 			goto cleanup;
 		FC_EXCH_DBG(aborted_ep, "Cannot process RRQ, "
 			    "frame error %d\n", err);

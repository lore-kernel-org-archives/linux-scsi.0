From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH 1/2] libfc: fix memory leakage in local port
Date: Wed, 27 Oct 2010 20:40:01 +0800
Message-ID: <AANLkTi=dLRNj0r8aUehqtVPgzpJsbGqnX2t-7AOkQfkS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42940 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab0J0MkC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Oct 2010 08:40:02 -0400
Received: by wyf28 with SMTP id 28so653944wyf.19
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2010 05:40:01 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org

There seems info should get freed when error encountered.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_lport.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/libfc/fc_lport.c	2010-10-27 20:33:36.000000000 +0800
@@ -1766,8 +1766,10 @@ static int fc_lport_ct_request(struct fc
 	info->sg = job->reply_payload.sg_list;

 	if (!lport->tt.exch_seq_send(lport, fp, fc_lport_bsg_resp,
-				     NULL, info, tov))
+				     NULL, info, tov)) {
+		kfree(info);
 		return -ECOMM;
+	}
 	return 0;
 }

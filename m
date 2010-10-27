From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH 2/2] libfc: fix memory leakage in local port
Date: Wed, 27 Oct 2010 20:43:30 +0800
Message-ID: <AANLkTikU6J5_uJ0k-EdmzKP0ORYrHkd1jdQjwY0B_jf-@mail.gmail.com>
References: <AANLkTi=dLRNj0r8aUehqtVPgzpJsbGqnX2t-7AOkQfkS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34296 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761154Ab0J0Mnc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Oct 2010 08:43:32 -0400
Received: by wyf28 with SMTP id 28so656884wyf.19
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2010 05:43:30 -0700 (PDT)
In-Reply-To: <AANLkTi=dLRNj0r8aUehqtVPgzpJsbGqnX2t-7AOkQfkS@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org

There seems info should get freed when error encountered.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_lport.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/libfc/fc_lport.c	2010-10-27 20:35:10.000000000 +0800
@@ -1707,8 +1707,10 @@ static int fc_lport_els_request(struct f
 	info->sg = job->reply_payload.sg_list;

 	if (!lport->tt.exch_seq_send(lport, fp, fc_lport_bsg_resp,
-				     NULL, info, tov))
+				     NULL, info, tov)) {
+		kfree(info);
 		return -ECOMM;
+	}
 	return 0;
 }

From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] libfc: fix memory leakage in remote port
Date: Wed, 27 Oct 2010 20:46:50 +0800
Message-ID: <AANLkTi=8SzXGAR=B9MB91wUawhOm1GkuA-CbvxLbOCLq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41752 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761156Ab0J0Mqv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Oct 2010 08:46:51 -0400
Received: by wwe15 with SMTP id 15so737074wwe.1
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2010 05:46:50 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org

There seems rdata should get put before return.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_rport.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/libfc/fc_rport.c	2010-10-27 20:37:30.000000000 +0800
@@ -652,7 +652,7 @@ void fc_rport_flogi_resp(struct fc_seq *
 	FC_RPORT_DBG(rdata, "Received a FLOGI %s\n", fc_els_resp_type(fp));

 	if (fp == ERR_PTR(-FC_EX_CLOSED))
-		return;
+		goto put;

 	mutex_lock(&rdata->rp_mutex);

@@ -689,6 +689,7 @@ out:
 	fc_frame_free(fp);
 err:
 	mutex_unlock(&rdata->rp_mutex);
+put:
 	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
 	return;
 bad:

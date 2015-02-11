From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] [SCSI] sg: fix read() error reporting
Date: Wed, 11 Feb 2015 11:32:06 -0500
Message-ID: <54DB8406.4020804@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cybernetics.com ([173.71.130.66]:27042 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbbBKQcH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Feb 2015 11:32:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-kernel@vger.kernel.org

Fix SCSI generic read() incorrectly returning success after detecting an
error.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

For inclusion in kernel 3.20.

--- linux-3.19.0/drivers/scsi/sg.c.orig	2015-02-08 21:54:22.000000000 -0500
+++ linux-3.19.0/drivers/scsi/sg.c	2015-02-10 09:26:09.000000000 -0500
@@ -546,7 +546,7 @@ static ssize_t
 sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
 {
 	sg_io_hdr_t *hp = &srp->header;
-	int err = 0;
+	int err = 0, err2;
 	int len;
 
 	if (count < SZ_SG_IO_HDR) {
@@ -575,8 +575,8 @@ sg_new_read(Sg_fd * sfp, char __user *bu
 		goto err_out;
 	}
 err_out:
-	err = sg_finish_rem_req(srp);
-	return (0 == err) ? count : err;
+	err2 = sg_finish_rem_req(srp);
+	return err ? : err2 ? : count;
 }
 
 static ssize_t


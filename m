From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [1/5]  qla2xxx: EH host-reset fixes
Date: Mon, 12 Jul 2004 07:04:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040712140458.GA6947@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:44949 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263204AbUGLVQg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2004 17:16:36 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

ChangeSet
  1.1865 04/07/12 09:28:00 andrew.vasquez@apc.qlogic.com +1 -0
  Fix issue where host-reset would incorrectly return a
  FAILED status.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-07-12 09:54:16 -07:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-07-12 09:54:16 -07:00
@@ -1663,7 +1663,7 @@
 		goto out;
 
 	/* Waiting for our command in done_queue to be returned to OS.*/
-	if (qla2x00_eh_wait_for_pending_commands(ha))
+	if (!qla2x00_eh_wait_for_pending_commands(ha))
 		rval = FAILED;
 
  out:

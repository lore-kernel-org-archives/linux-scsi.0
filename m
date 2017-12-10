From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH 1/1] scsi: fnic: add a space after %p in printf format
Date: Sun, 10 Dec 2017 20:23:11 +0100
Message-ID: <20171210192311.5334-1-nicolas.iooss_linux@m4x.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.polytechnique.org ([129.104.30.34]:58334 "EHLO
        mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751999AbdLJTcQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Dec 2017 14:32:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satish Kharat <satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Karan Tilak Kumar <kartilak@cisco.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicolas Iooss <nicolas.iooss_linux@m4x.org>

fnic_fcpio_icmnd_cmpl_handler() displays the value of sc with:

    FNIC_SCSI_DBG(KERN_INFO...
        "... sc = 0x%p"
        "scsi_status ..."
        ...

As the literal strings get merged, the function uses %ps instead of the
intended raw %p format. Fix this by inserting a space.

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 drivers/scsi/fnic/fnic_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 242e2ee494a1..8cbd3c9f0b4c 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -906,7 +906,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 
 		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
 			"icmnd_cmpl abts pending "
-			  "hdr status = %s tag = 0x%x sc = 0x%p"
+			  "hdr status = %s tag = 0x%x sc = 0x%p "
 			  "scsi_status = %x residual = %d\n",
 			  fnic_fcpio_status_to_str(hdr_status),
 			  id, sc,
-- 
2.15.0

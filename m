From: Anton Blanchard <anton@samba.org>
Subject: sym2 oops in 2.6.9-rc2-BK
Date: Tue, 28 Sep 2004 23:58:26 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928135826.GA3373@krispykreme.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:31637 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S267880AbUI1N67 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:58:59 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

Ive got a 2.6.9-rc2-bk tree from about September 16 which exploded in
sym_prepare_nego. It turns out sdev is NULL, and scsi_device_dt(sdev)
causes the trouble.

A few lines above there is a check for sdev != NULL, so assuming it is
valid to be NULL add a check before scsi_device_dt() too.

Anton

Signed-off-by: Anton Blanchard <anton@samba.org>

diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.c~fix-sym2 drivers/scsi/sym53c8xx_2/sym_hipd.c
--- gr_work/drivers/scsi/sym53c8xx_2/sym_hipd.c~fix-sym2	2004-09-28 03:03:26.493627814 -0500
+++ gr_work-anton/drivers/scsi/sym53c8xx_2/sym_hipd.c	2004-09-28 03:03:50.247458823 -0500
@@ -1550,7 +1550,7 @@ static int sym_prepare_nego(hcb_p np, cc
 	/*
 	 *  negotiate using PPR ?
 	 */
-	if (scsi_device_dt(sdev)) {
+	if (sdev && scsi_device_dt(sdev)) {
 		nego = NS_PPR;
 	} else {
 		/*

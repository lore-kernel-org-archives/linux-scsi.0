From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 6/6] mptctl : -mm patch: shutup uninitialized variable warnings
Date: Sat, 29 Sep 2007 10:22:54 -0600
Message-ID: <20070929162254.GA4380@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42420 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbXI2QWu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Sep 2007 12:22:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

This fix's compilier warnings that was reported by Satyam Sharma.  Currently this patch is there in -mm.


Signed-off-by: Eric Moore <Eric.Moore@lsi.com>
Signed-off-by: Satyam Sharma <satyam@infradead.org>


diff -uarpN b/drivers/message/fusion/mptctl.c a/drivers/message/fusion/mptctl.c
--- b/drivers/message/fusion/mptctl.c	2007-09-17 17:17:50.000000000 -0600
+++ a/drivers/message/fusion/mptctl.c	2007-09-28 17:41:14.000000000 -0600
@@ -1774,7 +1774,10 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	ulong 		timeout;
 	struct scsi_device *sdev;
 
+	/* bufIn and bufOut are used for user to kernel space transfers
+	 */
 	bufIn.kptr = bufOut.kptr = NULL;
+	bufIn.len = bufOut.len = 0;
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
@@ -2108,11 +2111,6 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	psge = (char *) (((int *) mf) + karg.dataSgeOffset);
 	flagsLength = 0;
 
-	/* bufIn and bufOut are used for user to kernel space transfers
-	 */
-	bufIn.kptr = bufOut.kptr = NULL;
-	bufIn.len = bufOut.len = 0;
-
 	if (karg.dataOutSize > 0)
 		sgSize ++;
 

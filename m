From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ibmvfc: Reduce error recovery timeout
Date: Tue, 20 Apr 2010 14:21:35 -0500
Message-ID: <201004201221.o3KCLZpd001649@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51840 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab0DTTVm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2010 15:21:42 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e4.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o3KJ9gv9024008
	for <linux-scsi@vger.kernel.org>; Tue, 20 Apr 2010 15:09:42 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o3KJLfkZ142970
	for <linux-scsi@vger.kernel.org>; Tue, 20 Apr 2010 15:21:41 -0400
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o3KCLapm001686
	for <linux-scsi@vger.kernel.org>; Tue, 20 Apr 2010 06:21:37 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


If a command times out resulting in EH getting invoked, we wait for the
aborted commands to come back after sending the abort. Shorten
the amount of time we wait for these responses, to ensure we don't
get stuck in EH for several minutes.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    2 +-
 drivers/scsi/ibmvscsi/ibmvfc.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_shorter_abort_wait drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_shorter_abort_wait	2010-04-20 09:49:01.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2010-04-20 09:50:54.000000000 -0500
@@ -2244,7 +2244,7 @@ static int ibmvfc_wait_for_ops(struct ib
 	DECLARE_COMPLETION_ONSTACK(comp);
 	int wait;
 	unsigned long flags;
-	signed long timeout = init_timeout * HZ;
+	signed long timeout = IBMVFC_ABORT_WAIT_TIMEOUT * HZ;
 
 	ENTER;
 	do {
diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_shorter_abort_wait drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_shorter_abort_wait	2010-04-20 09:49:07.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2010-04-20 09:49:43.000000000 -0500
@@ -38,6 +38,7 @@
 #define IBMVFC_ADISC_PLUS_CANCEL_TIMEOUT	\
 		(IBMVFC_ADISC_TIMEOUT + IBMVFC_ADISC_CANCEL_TIMEOUT)
 #define IBMVFC_INIT_TIMEOUT		120
+#define IBMVFC_ABORT_WAIT_TIMEOUT	40
 #define IBMVFC_MAX_REQUESTS_DEFAULT	100
 
 #define IBMVFC_DEBUG			0
_

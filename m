From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvscsi: Fix module load hang
Date: Tue, 23 Jun 2009 17:14:01 -0500
Message-ID: <200906232214.n5NME27i012089@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:51264 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbZFWWOC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Jun 2009 18:14:02 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e7.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n5NM1YS2030793
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2009 18:01:34 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5NME4XY115346
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2009 18:14:04 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5NME347012146
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2009 18:14:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, rcjenn@linux.vnet.ibm.com, benh@kernel.crashing.org, anton@samba.org, brking@linux.vnet.ibm.com


Fixes a regression seen in the ibmvscsi driver when using the VSCSI
server in SLES 9 and SLES 10. The VSCSI server in these releases
has a bug in it in which it does not send responses to unknown MADs.
Check the OS Type field in the adapter info response and do not send
these unsupported commands when talking to an older server.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_fix_cap_regression drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_fix_cap_regression	2009-06-18 09:13:24.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2009-06-23 10:00:33.000000000 -0500
@@ -1095,9 +1095,14 @@ static void adapter_info_rsp(struct srp_
 				MAX_INDIRECT_BUFS);
 			hostdata->host->sg_tablesize = MAX_INDIRECT_BUFS;
 		}
+
+		if (hostdata->madapter_info.os_type == 3) {
+			enable_fast_fail(hostdata);
+			return;
+		}
 	}
 
-	enable_fast_fail(hostdata);
+	send_srp_login(hostdata);
 }
 
 /**
_

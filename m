From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 1/1] mpt fusion: DMPT_DEBUG_FC conditional code doesn't compile
Date: Mon, 27 Feb 2006 10:00:51 -0600
Message-ID: <44032233.30407@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090208020606020309060205"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:21680 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751478AbWB0QA5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Feb 2006 11:00:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric Dean" <Eric.Moore@lsil.com>

This is a multi-part message in MIME format.
--------------090208020606020309060205
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

mptfc.c doesn't compile when DMPT_DEBUG_FC is defined.

Signed-off-by: Michael Reed <mdr@sgi.com>
---

--------------090208020606020309060205
Content-Type: text/x-patch;
 name="1a-mptfc-debug-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="1a-mptfc-debug-fix.patch"

diff -ru a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
--- a/drivers/message/fusion/mptfc.c	2006-02-27 09:47:07.000000000 -0600
+++ b/drivers/message/fusion/mptfc.c	2006-02-27 09:51:01.000000000 -0600
@@ -432,7 +432,7 @@
 				"mptfc_reg_dev.%d: %x, %llx / %llx, tid %d, "
 				"rport tid %d, tmo %d\n",
 					ioc->name,
-					oc->sh->host_no,
+					ioc->sh->host_no,
 					pg0->PortIdentifier,
 					pg0->WWNN,
 					pg0->WWPN,
@@ -562,14 +562,20 @@
 
 	vtarget->num_luns++;
 
+#ifdef DMPT_DEBUG_FC
+	{
+	struct mptfc_rport_info	*ri;
+	ri = *((struct mptfc_rport_info **)rport->dd_data);
 	dfcprintk ((MYIOC_s_INFO_FMT
 		"mptfc_slv_alloc.%d: num_luns %d, sdev.id %d, "
 	        "CurrentTargetID %d, %x %llx %llx\n",
-		ioc->name,
+		hd->ioc->name,
 		sdev->host->host_no,
 		vtarget->num_luns,
 		sdev->id, ri->pg0.CurrentTargetID,
 		ri->pg0.PortIdentifier, ri->pg0.WWPN, ri->pg0.WWNN));
+	}
+#endif
 
 	return 0;
 }

--------------090208020606020309060205--

From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] libfc: fix printk format warnings
Date: Wed, 18 Feb 2009 13:12:38 -0800
Message-ID: <20090218131238.10050b14.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:36300 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbZBRVMc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Feb 2009 16:12:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, jejb <James.Bottomley@HansenPartnership.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix libfc printk format warnings:

drivers/scsi/libfc/fc_lport.c:788: warning: long long unsigned int format, u64 arg (arg 3)
drivers/scsi/libfc/fc_lport.c:792: warning: long long unsigned int format, u64 arg (arg 3)
drivers/scsi/libfc/fc_rport.c:968: warning: long long unsigned int format, u64 arg (arg 4)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/libfc/fc_lport.c |    5 +++--
 drivers/scsi/libfc/fc_rport.c |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- lnx2629-rc5-docsrc.orig/drivers/scsi/libfc/fc_lport.c
+++ lnx2629-rc5-docsrc/drivers/scsi/libfc/fc_lport.c
@@ -786,10 +786,11 @@ static void fc_lport_recv_flogi_req(stru
 	remote_wwpn = get_unaligned_be64(&flp->fl_wwpn);
 	if (remote_wwpn == lport->wwpn) {
 		FC_DBG("FLOGI from port with same WWPN %llx "
-		       "possible configuration error\n", remote_wwpn);
+		       "possible configuration error\n",
+		       (unsigned long long)remote_wwpn);
 		goto out;
 	}
-	FC_DBG("FLOGI from port WWPN %llx\n", remote_wwpn);
+	FC_DBG("FLOGI from port WWPN %llx\n", (unsigned long long)remote_wwpn);
 
 	/*
 	 * XXX what is the right thing to do for FIDs?
--- lnx2629-rc5-docsrc.orig/drivers/scsi/libfc/fc_rport.c
+++ lnx2629-rc5-docsrc/drivers/scsi/libfc/fc_rport.c
@@ -966,7 +966,7 @@ static void fc_rport_recv_plogi_req(stru
 	switch (rdata->rp_state) {
 	case RPORT_ST_INIT:
 		FC_DEBUG_RPORT("incoming PLOGI from %6x wwpn %llx state INIT "
-			       "- reject\n", sid, wwpn);
+			       "- reject\n", sid, (unsigned long long)wwpn);
 		reject = ELS_RJT_UNSUP;
 		break;
 	case RPORT_ST_PLOGI:

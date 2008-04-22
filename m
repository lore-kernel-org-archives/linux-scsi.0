From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] fc_user_scan correction
Date: Tue, 22 Apr 2008 13:28:39 -0400
Message-ID: <1208885319.12659.7.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:40882 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756977AbYDVR2T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Apr 2008 13:28:19 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m3MHSIG9019094
	for <linux-scsi@vger.kernel.org>; Tue, 22 Apr 2008 10:28:18 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Way back when, when the fc_user_scan routine was created, it kept some
of its original logic that walked the rport list and kicked off a scan.
Unfortunately, it didn't keep any of the locking around the rport list,
nor did it consider the synchronous nature of the scan invoked. The result,
there are some scan requests where the rport list changes, thus a subsequent
scan is called on a bogus rport structure and the system NMI's.

The fix is to defer to the midlayer scan routine and not deal with locking
in the user scan function.

Patch was cut against scsi-misc-2.6

-- james s


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 scsi_scan.c         |    1 +
 scsi_transport_fc.c |   21 +--------------------
 2 files changed, 2 insertions(+), 20 deletions(-)


diff -upNr a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	2008-04-22 13:09:23.000000000 -0400
+++ b/drivers/scsi/scsi_scan.c	2008-04-22 13:10:02.000000000 -0400
@@ -1669,6 +1669,7 @@ int scsi_scan_host_selected(struct Scsi_
 
 	return 0;
 }
+EXPORT_SYMBOL(scsi_scan_host_selected);
 
 static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 {
diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2008-04-22 12:51:22.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2008-04-22 12:53:30.000000000 -0400
@@ -1929,29 +1929,10 @@ fc_timed_out(struct scsi_cmnd *scmd)
 	return EH_NOT_HANDLED;
 }
 
-/*
- * Must be called with shost->host_lock held
- */
 static int fc_user_scan(struct Scsi_Host *shost, uint channel,
 		uint id, uint lun)
 {
-	struct fc_rport *rport;
-
-	list_for_each_entry(rport, &fc_host_rports(shost), peers) {
-		if (rport->scsi_target_id == -1)
-			continue;
-
-		if (rport->port_state != FC_PORTSTATE_ONLINE)
-			continue;
-
-		if ((channel == SCAN_WILD_CARD || channel == rport->channel) &&
-		    (id == SCAN_WILD_CARD || id == rport->scsi_target_id)) {
-			scsi_scan_target(&rport->dev, rport->channel,
-					 rport->scsi_target_id, lun, 1);
-		}
-	}
-
-	return 0;
+ 	return scsi_scan_host_selected(shost, channel, id, lun, 1);
 }
 
 static int fc_tsk_mgmt_response(struct Scsi_Host *shost, u64 nexus, u64 tm_id,



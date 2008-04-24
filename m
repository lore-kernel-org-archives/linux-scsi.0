From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH][REPOST] fc_user_scan correction
Date: Thu, 24 Apr 2008 12:12:46 -0400
Message-ID: <1209053566.4005.5.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:55917 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbYDXQMt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 12:12:49 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m3OGChnZ018337
	for <linux-scsi@vger.kernel.org>; Thu, 24 Apr 2008 09:12:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This should be the correct implementation for FC now...

-----

Way back when, when the fc_user_scan routine was created, it kept some
of its original logic that walked the rport list and kicked off a scan.
Unfortunately, it didn't keep any of the locking around the rport list,
nor did it consider the synchronous nature of the scan invoked. The result,
there are some scan requests where the rport list changes, thus a subsequent
scan is called on a bogus rport structure and the system NMI's.

Patch was cut against scsi-misc-2.6

-- james s


 Signed-off-by: James Smart <james.smart@emulex.com>



 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 scsi_transport_fc.c |   60 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 53 insertions(+), 7 deletions(-)


diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2008-04-24 08:47:38.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2008-04-24 11:38:30.000000000 -0400
@@ -1961,12 +1961,17 @@ fc_timed_out(struct scsi_cmnd *scmd)
 }
 
 /*
- * Must be called with shost->host_lock held
+ * Called by fc_user_scan to locate an rport on the shost that
+ * matches the channel and target id, and invoke scsi_scan_target()
+ * on the rport.
  */
-static int fc_user_scan(struct Scsi_Host *shost, uint channel,
-		uint id, uint lun)
+static void
+fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, uint lun)
 {
 	struct fc_rport *rport;
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
 
 	list_for_each_entry(rport, &fc_host_rports(shost), peers) {
 		if (rport->scsi_target_id == -1)
@@ -1975,13 +1980,54 @@ static int fc_user_scan(struct Scsi_Host
 		if (rport->port_state != FC_PORTSTATE_ONLINE)
 			continue;
 
-		if ((channel == SCAN_WILD_CARD || channel == rport->channel) &&
-		    (id == SCAN_WILD_CARD || id == rport->scsi_target_id)) {
-			scsi_scan_target(&rport->dev, rport->channel,
-					 rport->scsi_target_id, lun, 1);
+		if ((channel == rport->channel) &&
+		    (id == rport->scsi_target_id)) {
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			scsi_scan_target(&rport->dev, channel, id, lun, 1);
+			return;
 		}
 	}
 
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
+/*
+ * Called via sysfs scan routines. Necessary, as the FC transport
+ * wants to place all target objects below the rport object. So this
+ * routine must invoke the scsi_scan_target() routine with the rport
+ * object as the parent.
+ */
+static int
+fc_user_scan(struct Scsi_Host *shost, uint channel, uint id, uint lun)
+{
+	uint chlo, chhi;
+	uint tgtlo, tgthi;
+
+	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
+	    ((id != SCAN_WILD_CARD) && (id >= shost->max_id)) ||
+	    ((lun != SCAN_WILD_CARD) && (lun > shost->max_lun)))
+		return -EINVAL;
+
+	if (channel == SCAN_WILD_CARD) {
+		chlo = 0;
+		chhi = shost->max_channel + 1;
+	} else {
+		chlo = channel;
+		chhi = channel + 1;
+	}
+
+	if (id == SCAN_WILD_CARD) {
+		tgtlo = 0;
+		tgthi = shost->max_id;
+	} else {
+		tgtlo = id;
+		tgthi = id + 1;
+	}
+
+	for ( ; chlo < chhi; chlo++)
+		for ( ; tgtlo < tgthi; tgtlo++)
+			fc_user_scan_tgt(shost, chlo, tgtlo, lun);
+
 	return 0;
 }
 



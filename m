From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH 3/3] scsi_dh_alua: Optimize the STPG command
Date: Tue, 27 Mar 2012 20:56:20 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B02C401@SACEXCMBX02-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:60424 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab2C0U41 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Mar 2012 16:56:27 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, "hare@suse.de" <hare@suse.de>, "Qi, Yanling" <Yanling.Qi@netapp.com>, "Stankey, Robert" <Robert.Stankey@netapp.com>

This patch optimizes the set target port group(STPG) command. During our
testing, we found that it is not optimal to send stpg command every time
the path group switch happens. This patch uses PREF (preferred target port)
bit with combination of flags passed by multipath user level tool to 
optimize this behaviour. If PREF bit is set then it issues a STPG command,
otherwise it will let implicit transfer take place.

By default there is no change in the behaviour. User tool needs to pass the
parameter to make this change take effect. Patch has been tested on NetApp
E series storage.

Signed-off-by: Babu Moger <babu.moger@netapp.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
--- linux-3.3-rc6/drivers/scsi/device_handler/scsi_dh_alua.c.orig	2012-03-27 14:43:26.000000000 -0500
+++ linux-3.3-rc6/drivers/scsi/device_handler/scsi_dh_alua.c	2012-03-27 14:44:25.000000000 -0500
@@ -675,14 +675,37 @@ static int alua_activate(struct scsi_dev
 {
 	struct alua_dh_data *h = get_alua_data(sdev);
 	int err = SCSI_DH_OK;
+	int stpg = 0;
 
 	err = alua_rtpg(sdev, h);
 	if (err != SCSI_DH_OK)
 		goto out;
 
-	if (h->tpgs & TPGS_MODE_EXPLICIT &&
-	    h->state != TPGS_STATE_OPTIMIZED &&
-	    h->state != TPGS_STATE_LBA_DEPENDENT) {
+	if (h->tpgs & TPGS_MODE_EXPLICIT) {
+		switch (h->state) {
+		case TPGS_STATE_NONOPTIMIZED:
+			stpg = 1;
+			if ((h->flags & ALUA_OPTIMIZE_STPG) &&
+			    (!h->pref) &&
+			    (h->tpgs & TPGS_MODE_IMPLICIT))
+				stpg = 0;
+			break;
+		case TPGS_STATE_STANDBY:
+			stpg = 1;
+			break;
+		case TPGS_STATE_UNAVAILABLE:
+		case TPGS_STATE_OFFLINE:
+			err = SCSI_DH_IO;
+			break;
+		case TPGS_STATE_TRANSITIONING:
+			err = SCSI_DH_RETRY;
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (stpg) {
 		h->callback_fn = fn;
 		h->callback_data = data;
 		err = submit_stpg(h);



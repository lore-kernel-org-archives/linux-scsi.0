From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: [dm-devel] [PATCH] [RESEND] scsi_dh_alua: Add module parameter to
 allow failover to non preferred path without STPG
Date: Thu, 4 Apr 2013 14:54:47 +0000
Message-ID: <8255ED565A0EAA4A960625E27D49DBF21FF97F35@SACEXCMBX04-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx12.netapp.com ([216.240.18.77]:1775 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762207Ab3DDOyt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Apr 2013 10:54:49 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "snitzer@redhat.com" <snitzer@redhat.com>

Resending with requested rewording of the parameter description.
Currently ALUA device handler sends STPG command during failover and failback.
Failover can be optimized by implicit failover (by not to sending STPG command), when 1 is passed as hwhandler parameter in multipath.conf. ex "2 alua 1". We may need to pass the parameter through module param for alua device handler to optimize failover if incase retain_attached_hwhandler set in multipath.conf and hwhandler is set with non-tpgs device handler ex: '1 rdac'.

Signed-off-by: Vijay Chauhan <vijay.chauhan@netapp.com>
Signed-off-by: Sean Stewart <Sean.Stewart@netapp.com>

---
--- a/drivers/scsi/device_handler/scsi_dh_alua.c.orig	2013-03-27 12:18:35.000000000 +0530
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c	2013-03-27 13:23:16.000000000 +0530
@@ -710,6 +710,10 @@ static int alua_set_params(struct scsi_d
 	return result;
 }
 
+static uint optimize_stpg;
+module_param(optimize_stpg, uint, S_IRUGO|S_IWUSR); 
+MODULE_PARM_DESC(optimize_stpg, "Allow use of a non-optimized path, 
+rather than sending a STPG, when implicit TPGS is supported (0=No,1=Yes). Default is 0.");
+
 /*
  * alua_activate - activate a path
  * @sdev: device on the path to be activated @@ -731,6 +735,9 @@ static int alua_activate(struct scsi_dev
 	if (err != SCSI_DH_OK)
 		goto out;
 
+	if (optimize_stpg)
+		h->flags |= ALUA_OPTIMIZE_STPG;
+
 	if (h->tpgs & TPGS_MODE_EXPLICIT) {
 		switch (h->state) {
 		case TPGS_STATE_NONOPTIMIZED:
--

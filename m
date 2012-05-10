From: James Smart <james.smart@emulex.com>
Subject: [PATCH 13/20] lpfc 8.3.31: Fix driver crash during back-to-back
 ramp events
Date: Wed, 9 May 2012 21:18:40 -0400
Message-ID: <1336612721.1996.42.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:27894 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756541Ab2EJBTB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2012 21:19:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix driver crash during back-to-back ramp events.


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-05-07 10:01:16.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-05-07 10:01:18.000000000 -0400
@@ -399,6 +399,14 @@ lpfc_ramp_down_queue_handler(struct lpfc
 	num_rsrc_err = atomic_read(&phba->num_rsrc_err);
 	num_cmd_success = atomic_read(&phba->num_cmd_success);
 
+	/*
+	 * The error and success command counters are global per
+	 * driver instance.  If another handler has already
+	 * operated on this error event, just exit.
+	 */
+	if (num_rsrc_err == 0)
+		return;
+
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {




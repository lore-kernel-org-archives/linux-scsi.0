From: James Smart <james.smart@emulex.com>
Subject: [PATCH 19/22] lpfc 8.3.39: Add log message when completes with
 clean address bit set to zero
Date: Wed, 17 Apr 2013 20:19:25 -0400
Message-ID: <1366244365.1513.20.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:24339 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827Ab3DRAT2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:19:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add log message when completes with clean address bit set to zero


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c |    3 +++
 1 file changed, 3 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2013-04-15 18:26:26.898040889 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2013-04-15 18:26:54.238041512 -0400
@@ -7072,6 +7072,9 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *ph
 	spin_lock_irq(shost->host_lock);
 	if (vport->fc_flag & FC_DISC_DELAYED) {
 		spin_unlock_irq(shost->host_lock);
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
+				"3334 Delay fc port discovery for %d seconds\n",
+				phba->fc_ratov);
 		mod_timer(&vport->delayed_disc_tmo,
 			jiffies + msecs_to_jiffies(1000 * phba->fc_ratov));
 		return;




From: James Smart <james.smart@emulex.com>
Subject: [PATCH 09/20] lpfc 8.3.31: Fix kernel panic when going into to
 sleep state
Date: Wed, 9 May 2012 21:17:43 -0400
Message-ID: <1336612674.1996.38.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:27886 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756818Ab2EJBSG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2012 21:18:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix kernel panic when going into to sleep state


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |    1 +
 1 file changed, 1 insertion(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-05-07 10:01:03.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-05-07 10:01:13.000000000 -0400
@@ -713,6 +713,7 @@ lpfc_do_work(void *p)
 	int rc;
 
 	set_user_nice(current, -20);
+	current->flags |= PF_NOFREEZE;
 	phba->data_flags = 0;
 
 	while (!kthread_should_stop()) {




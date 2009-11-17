From: akpm@linux-foundation.org
Subject: [patch 07/18] drivers/scsi/lpfc/lpfc_vport.c: fix read buffer overflow
Date: Tue, 17 Nov 2009 14:53:18 -0800
Message-ID: <200911172253.nAHMrIx8019842@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756645AbZKQW5S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2009 17:57:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com, James.Smart@Emulex.Com, jeykholt@cisco.com

From: Roel Kluin <roel.kluin@gmail.com>

Check whether index is within bounds before testing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James Smart <James.Smart@Emulex.Com>
Cc: Joe Eykholt <jeykholt@cisco.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_vport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/lpfc/lpfc_vport.c~drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c~drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow
+++ a/drivers/scsi/lpfc/lpfc_vport.c
@@ -769,7 +769,7 @@ lpfc_destroy_vport_work_array(struct lpf
 	int i;
 	if (vports == NULL)
 		return;
-	for (i = 0; vports[i] != NULL && i <= phba->max_vports; i++)
+	for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++)
 		scsi_host_put(lpfc_shost_from_vport(vports[i]));
 	kfree(vports);
 }
_

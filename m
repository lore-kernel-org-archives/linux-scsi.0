From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] lpfc: fix 8.3.1 for do_div warning [Bug 13022]
Date: Tue, 7 Apr 2009 14:03:54 -0400
Message-ID: <1239127434.27087.4.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33162 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbZDGSEC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 14:04:02 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n37I41PB013362
	for <linux-scsi@vger.kernel.org>; Tue, 7 Apr 2009 11:04:01 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Correct do_div warning reported by:
[Bug 13022] New: comparison of distinct pointer types lacks a cast
http://marc.info/?l=linux-scsi&m=123900867611315&w=2

To be applied on top of lpfc 8.3.1 patch set.

-- james s 

 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2009-04-06 18:34:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2009-04-07 13:56:27.000000000 -0400
@@ -1393,7 +1393,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba,
 		 */
 		cmd->sense_buffer[8] = 0;     /* Information */
 		cmd->sense_buffer[9] = 0xa;   /* Add. length */
-		do_div(bghm, cmd->device->sector_size);
+		bghm /= cmd->device->sector_size;
 
 		failing_sector = scsi_get_lba(cmd);
 		failing_sector += bghm;



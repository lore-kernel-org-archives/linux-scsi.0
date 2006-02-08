From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 6/22] lpfc 8.1.2 :  Fix lpfc_sli_send_reset on ERATT interrupt
Date: Wed, 08 Feb 2006 10:41:44 -0500
Message-ID: <43EA1138.9090005@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:32141 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030440AbWBHPls
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 10:41:48 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k18Ffkrf011846
	for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2006 07:41:47 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Explicitly initialize the skip_post argument to lpfc_sli_send_reset
   on a ERATT interrupt.


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2983,7 +2983,7 @@ lpfc_intr_handler(int irq, void *dev_id,
  			 * to shutdown interrupt when there is a
  			 * ERROR.
  			 */
-			lpfc_sli_send_reset(phba, phba->hba_state);
+			lpfc_sli_send_reset(phba, 1);
  		}

  		spin_lock(phba->host->host_lock);


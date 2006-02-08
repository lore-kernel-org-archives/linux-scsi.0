From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 8/22] lpfc 8.1.2 :  Fixed a double insertion of mail box object
 to the SLI mailbox list.
Date: Wed, 08 Feb 2006 10:41:55 -0500
Message-ID: <43EA1143.8080004@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:37517 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030446AbWBHPl6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 10:41:58 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k18Ffvrf011865
	for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2006 07:41:57 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Fixed a double insertion of mail box object to the SLI mailbox list.


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2867,11 +2867,10 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba
  		pmboxq->context1 = NULL;
  		/* if schedule_timeout returns 0, we timed out and were not
  		   woken up */
-		if (timeleft == 0) {
+		if ((timeleft == 0) || signal_pending(current))
  			retval = MBX_TIMEOUT;
-		} else {
+		else
  			retval = MBX_SUCCESS;
-		}
  	}




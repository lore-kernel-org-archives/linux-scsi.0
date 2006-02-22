From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 7/9] lpfc 8.1.3 : Fix polling mode panic
Date: Wed, 22 Feb 2006 12:33:56 -0500
Message-ID: <43FCA084.5030705@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:64985 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030326AbWBVRd7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 12:33:59 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k1MHXwrf029939
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 09:33:58 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Fix polling mode panic

Cause: Race between interrupt driven and polling path in harvesting iocbs from
the response ring.


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -467,6 +467,11 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba
  	sdev = cmd->device;
  	cmd->scsi_done(cmd);

+	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
+		lpfc_release_scsi_buf(phba, lpfc_cmd);
+		return;
+	}
+
  	if (!result && pnode != NULL &&
  	   ((jiffies - pnode->last_ramp_up_time) >
  		LPFC_Q_RAMP_UP_INTERVAL * HZ) &&
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1154,12 +1154,17 @@ lpfc_sli_handle_fast_ring_event(struct l
  			cmdiocbq = lpfc_sli_iocbq_lookup(phba, pring,
  							 &rspiocbq);
  			if ((cmdiocbq) && (cmdiocbq->iocb_cmpl)) {
-				spin_unlock_irqrestore(
-				       phba->host->host_lock, iflag);
-				(cmdiocbq->iocb_cmpl)(phba, cmdiocbq,
-						      &rspiocbq);
-				spin_lock_irqsave(phba->host->host_lock,
-						  iflag);
+				if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
+					(cmdiocbq->iocb_cmpl)(phba, cmdiocbq,
+							      &rspiocbq);
+				} else {
+					spin_unlock_irqrestore(
+						phba->host->host_lock, iflag);
+					(cmdiocbq->iocb_cmpl)(phba, cmdiocbq,
+							      &rspiocbq);
+					spin_lock_irqsave(phba->host->host_lock,
+							  iflag);
+				}
  			}
  			break;
  		default:


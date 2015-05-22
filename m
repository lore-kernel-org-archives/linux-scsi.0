From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 2/9] lpfc: Fix vport deletion failure.
Date: Fri, 22 May 2015 10:42:36 -0400
Message-ID: <555f405c.KmVvOAygQVUDcayN%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:36529 "EHLO
	mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536AbbEVOmo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2015 10:42:44 -0400
Received: by qkx62 with SMTP id 62so12605568qkx.3
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2015 07:42:43 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id w139sm1413932qha.7.2015.05.22.07.42.42
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Fri, 22 May 2015 07:42:43 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix vport deletion failure.

If a vport was deleted while in the middle of discovery, we weren't
clearing the nport discovery flag. Correct by clearing the flag and
cancelling our discovery timeout timer.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 3aad09f..30021f3 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8410,8 +8410,10 @@ lpfc_cmpl_els_npiv_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	if (irsp->ulpStatus == IOSTAT_SUCCESS) {
 		spin_lock_irq(shost->host_lock);
+		vport->fc_flag &= ~FC_NDISC_ACTIVE;
 		vport->fc_flag &= ~FC_FABRIC;
 		spin_unlock_irq(shost->host_lock);
+		lpfc_can_disctmo(vport);
 	}
 }
 
-- 
1.7.11.7


From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 5/9] lpfc: Fix scsi prep dma buf error.
Date: Fri, 22 May 2015 10:42:39 -0400
Message-ID: <555f405f.+8s1UhcBRa83wieK%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:35792 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024AbbEVOms (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2015 10:42:48 -0400
Received: by qgew3 with SMTP id w3so9073758qge.2
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2015 07:42:48 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id b141sm1426170qka.11.2015.05.22.07.42.46
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Fri, 22 May 2015 07:42:47 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix scsi prep dma buf error.

Didn't check for less-than-or-equal zero. Means we may later call
scsi_dma_unmap() even though we don't have valid mappings.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 4a2a818..b3b195f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3257,7 +3257,7 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 		 */
 
 		nseg = scsi_dma_map(scsi_cmnd);
-		if (unlikely(!nseg))
+		if (unlikely(nseg <= 0))
 			return 1;
 		sgl += 1;
 		/* clear the last flag in the fcp_rsp map entry */
-- 
1.7.11.7


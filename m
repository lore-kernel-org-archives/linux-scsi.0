From: "ed.lin" <ed.lin@promise.com>
Subject: [PATCH 1/5][resend 2] stex: Fix for potential invalid request
Date: Tue, 27 Jan 2009 06:36:04 +0800
Message-ID: <200901270636.04129.ed.lin@promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:19240 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752175AbZA0GgC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jan 2009 01:36:02 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org

The interrupt routine is good for normal cases. However, if the firmware is 
abnormal and returns an invalid response, the driver may reuse a ccb 
structure that has already been handled. This may cause problem. Fix this by 
setting the req member to NULL. Next time we know the response is invalid and 
handle accordingly if req is NULL.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index a3a18ad..6129db4 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -746,6 +746,7 @@ static void stex_mu_intr(struct st_hba *hba, u32 doorbell)
     stex_copy_data(ccb, resp, size);
   }
 
+  ccb->req = NULL;
   ccb->srb_status = resp->srb_status;
   ccb->scsi_status = resp->scsi_status;
 

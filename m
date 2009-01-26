From: "Ed Lin - PTU" <ed.lin@promise.com>
Subject: [PATCH 1/5] stex: Fix for potential invalid response
Date: Mon, 26 Jan 2009 02:40:11 -0800
Message-ID: <85ABFDC4641C4847BA6088F2982EFD8F01DC8300@nonamew.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.2.ptr.us.xo.net ([67.111.72.2]:36552 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751368AbZAZKza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jan 2009 05:55:30 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Promise_Linux <Promise_Linux@promise.com>

The interrupt routine is good for normal cases. However, if the firmware
is abnormal and returns an invalid response, the driver may reuse a
ccb structure which has already been handled. This may cause problem.
Fix this by setting the req member to NULL. Next time we know the
response is invalid and handle accordingly if req is NULL.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index a3a18ad..6129db4 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -746,6 +746,7 @@ static void stex_mu_intr(struct st_hba *hba, u32
doorbell)
 				stex_copy_data(ccb, resp, size);
 		}
 
+		ccb->req = NULL;
 		ccb->srb_status = resp->srb_status;
 		ccb->scsi_status = resp->scsi_status;
 

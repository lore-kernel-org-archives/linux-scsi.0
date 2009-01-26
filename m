From: Ed Lin <ed.lin@promise.com>
Subject: [PATCH 1/5][resend] stex: Fix for potential invalid response
Date: Mon, 26 Jan 2009 15:33:17 -0800
Message-ID: <f60baa940901261533q1f15d39jed5c4a9da9234ead@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.186]:20366 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbZAZXdT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jan 2009 18:33:19 -0500
Received: by rn-out-0910.google.com with SMTP id k40so1963241rnd.17
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2009 15:33:18 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: promise_linux <promise_linux@promise.com>, linux-scsi <linux-scsi@vger.kernel.org>

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
@@ -746,6 +746,7 @@ static void stex_mu_intr(struct st_hba *hba, u32 doorbell)
 				stex_copy_data(ccb, resp, size);
 		}

+		ccb->req = NULL;
 		ccb->srb_status = resp->srb_status;
 		ccb->scsi_status = resp->scsi_status;

From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] libfc: fix mem leak in fc_fcp_srr_resp()
Date: Mon, 25 Oct 2010 20:47:21 +0800
Message-ID: <AANLkTik9+jAwcs0G9v2Nbwh-GfFc61V4=n7wYn0CaSc-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59276 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab0JYMrW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2010 08:47:22 -0400
Received: by wyf28 with SMTP id 28so3343208wyf.19
        for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2010 05:47:21 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org

There seems frame should be freed against memory leakage.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_fcp.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/libfc/fc_fcp.c	2010-10-25 20:33:58.000000000 +0800
@@ -1685,6 +1685,7 @@ static void fc_fcp_srr_resp(struct fc_se
 	 */
 	if (fh->fh_type == FC_TYPE_BLS) {
 		fc_fcp_unlock_pkt(fsp);
+		fc_frame_free(fp);
 		return;
 	}

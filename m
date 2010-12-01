From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 11/27] libfc: fix memory leakage in local port
Date: Tue, 30 Nov 2010 16:18:54 -0800
Message-ID: <20101201001854.18369.30655.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39632 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634Ab0LAASz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:18:55 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Hillf Danton <dhillf@gmail.com>

From: Hillf Danton <dhillf@gmail.com>

There seems info should get freed when error encountered.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_lport.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 9be63ed..9c1d6b8 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1762,8 +1762,10 @@ static int fc_lport_ct_request(struct fc_bsg_job *job,
 	info->sg = job->reply_payload.sg_list;
 
 	if (!lport->tt.exch_seq_send(lport, fp, fc_lport_bsg_resp,
-				     NULL, info, tov))
+				     NULL, info, tov)) {
+		kfree(info);
 		return -ECOMM;
+	}
 	return 0;
 }
 


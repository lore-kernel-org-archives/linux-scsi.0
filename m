From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 1/9] libfc: fix payload size passed to fc_frame_alloc() in
	fc_lport_els_request
Date: Fri, 20 Nov 2009 14:54:41 -0800
Message-ID: <20091120225441.495.13642.stgit@localhost.localdomain>
References: <20091120225436.495.88600.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27574 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbZKTWyf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2009 17:54:35 -0500
In-Reply-To: <20091120225436.495.88600.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

Frame header room is already incluced, just pass the length of payload.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index c841d54..bbf4152 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1679,8 +1679,7 @@ static int fc_lport_els_request(struct fc_bsg_job *job,
 	char *pp;
 	int len;
 
-	fp = fc_frame_alloc(lport, sizeof(struct fc_frame_header) +
-			    job->request_payload.payload_len);
+	fp = fc_frame_alloc(lport, job->request_payload.payload_len);
 	if (!fp)
 		return -ENOMEM;
 


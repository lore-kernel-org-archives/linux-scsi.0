From: giridhar.malavali@qlogic.com
Subject: [PATCH 3/4] fc-transport: Use packed modifier for fc_bsg_request structure.
Date: Tue, 12 Jan 2010 12:59:50 -0800
Message-ID: <1263329991-307-4-git-send-email-giridhar.malavali@qlogic.com>
References: <1263329991-307-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:54868 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753210Ab0ALU74 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2010 15:59:56 -0500
In-Reply-To: <1263329991-307-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

The 32bit kernel does not add padding bytes in the fc_bsg_request structure
whereas the 64bit kernel adds padding bytes in the fc_bsg_request structure.
Due to this, structure elements gets mismatched with 32bit application and
64bit kernel.To resolve this, used packed modifier to avoid adding padding bytes.
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 include/scsi/scsi_bsg_fc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/scsi/scsi_bsg_fc.h b/include/scsi/scsi_bsg_fc.h
index a4b2333..91a4e4f 100644
--- a/include/scsi/scsi_bsg_fc.h
+++ b/include/scsi/scsi_bsg_fc.h
@@ -292,7 +292,7 @@ struct fc_bsg_request {
 		struct fc_bsg_rport_els		r_els;
 		struct fc_bsg_rport_ct		r_ct;
 	} rqst_data;
-};
+} __attribute__((packed));
 
 
 /* response (request sense data) structure of the sg_io_v4 */
-- 
1.6.2.rc1.30.gd43c


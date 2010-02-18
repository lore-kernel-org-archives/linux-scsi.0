From: giridhar.malavali@qlogic.com
Subject: [PATCH 1/8] qla2xxx: Initialize payload receive lenght in failure path of vendor commands
Date: Thu, 18 Feb 2010 10:07:23 -0800
Message-ID: <1266516450-472-2-git-send-email-giridhar.malavali@qlogic.com>
References: <1266516450-472-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:54293 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751497Ab0BRSHd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2010 13:07:33 -0500
In-Reply-To: <1266516450-472-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Sarang Radke <sarang.radke@qlogic.com>, stable@kernel.org

From: Sarang Radke <sarang.radke@qlogic.com>

Since bsg_job->reply->reply_payload_rcv_len is uninitialized
in case of failure, fc-transport triggers a warning for each command
failed.
Cc: stable@kernel.org
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 5a19aea..cbce52e 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2284,6 +2284,7 @@ qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 			"scsi(%ld) Vendor request %s failed\n", vha->host_no, type));
 		rval = 0;
 		bsg_job->reply->result = (DID_ERROR << 16);
+		bsg_job->reply->reply_payload_rcv_len = 0;
 		fw_sts_ptr = ((uint8_t*)bsg_job->req->sense) + sizeof(struct fc_bsg_reply);
 		memcpy( fw_sts_ptr, response, sizeof(response));
 		fw_sts_ptr += sizeof(response);
-- 
1.6.2.rc1.30.gd43c


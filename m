From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 1/2] stex: cancel unused field in struct req_msg
Date: Wed, 27 Sep 2006 19:23:33 +0800
Message-ID: <NONAMEBGh05YFRcmVFO000003cd@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:51506 "EHLO
	nonameb.ptu.promise.com") by vger.kernel.org with ESMTP
	id S965573AbWI0LYE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Sep 2006 07:24:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "james.Bottomley" <james.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>


The payload_sz field in struct req_msg is not big enough to indicate
the size of req_msg, as its type is u8.
It is confirmed that this field is not used by firmware, so cancel
it here.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 3cf3106..cfb2971 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -181,7 +181,7 @@ struct req_msg {
 	u8 task_attr;
 	u8 task_manage;
 	u8 prd_entry;
-	u8 payload_sz;		/* payload size in 4-byte */
+	u8 payload_sz;		/* payload size in 4-byte, not used */
 	u8 cdb[STEX_CDB_LENGTH];
 	u8 variable[REQ_VARIABLE_LEN];
 };
@@ -489,7 +489,6 @@ stex_send_cmd(struct st_hba *hba, struct
 	req->tag = cpu_to_le16(tag);
 	req->task_attr = TASK_ATTRIBUTE_SIMPLE;
 	req->task_manage = 0; /* not supported yet */
-	req->payload_sz = (u8)(sizeof(struct req_msg)/sizeof(u32));
 
 	hba->ccb[tag].req = req;
 	hba->out_req_cnt++;


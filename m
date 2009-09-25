From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: [PATCH] qla2xxx: Fix Null ptr dereference in fail path in queue
 create code
Date: Fri, 25 Sep 2009 00:45:19 -0700 (PDT)
Message-ID: <alpine.OSX.1.00.0909250036530.1854@n4017av1qdvv31.qlogic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:26451 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbZIYIA3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2009 04:00:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>, James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>

Current code jumps to fail path in queue create functions and there it invokes 
the queue free call with a (NULL) pointer to the queue which could not be 
allocated. Fix it by returning ENOMEM directly without invoking the queue free 
call.

Signed-off-by Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mid.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 42b799a..a588152 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -568,7 +568,7 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	if (req == NULL) {
 		qla_printk(KERN_WARNING, ha, "could not allocate memory"
 			"for request que\n");
-		goto que_failed;
+		return ENOMEM;
 	}
 
 	req->length = REQUEST_ENTRY_CNT_24XX;
@@ -659,7 +659,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	if (rsp == NULL) {
 		qla_printk(KERN_WARNING, ha, "could not allocate memory for"
 				" response que\n");
-		goto que_failed;
+		return ENOMEM;
 	}
 
 	rsp->length = RESPONSE_ENTRY_CNT_MQ;
-- 
1.6.2


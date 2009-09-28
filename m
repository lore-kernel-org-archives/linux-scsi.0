From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: [PATCH] qla2xxx: Fix NULL ptr deref bug in fail path during queue
 create
Date: Mon, 28 Sep 2009 13:52:58 -0700 (PDT)
Message-ID: <alpine.OSX.1.00.0909281340560.3295@n4012av9w19yf1.qlogic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:51224 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZI1Uwz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2009 16:52:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>, James.Bottomley@suse.de

Current code attempts to clean up resources when queue create fails and there it 
invokes queue free call with a (NULL) pointer to the queue which could not be 
allocated in the first place. Fix it by returning directly without invoking the 
queue free call as no resources has been allocated at that point of time.

Please apply.
Thanks,
Anirban

Reported-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mid.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 42b799a..e07b361 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -568,7 +568,7 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	if (req == NULL) {
 		qla_printk(KERN_WARNING, ha, "could not allocate memory"
 			"for request que\n");
-		goto que_failed;
+		goto failed;
 	}
 
 	req->length = REQUEST_ENTRY_CNT_24XX;
@@ -632,6 +632,7 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 
 que_failed:
 	qla25xx_free_req_que(base_vha, req);
+failed:
 	return 0;
 }
 
@@ -659,7 +660,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	if (rsp == NULL) {
 		qla_printk(KERN_WARNING, ha, "could not allocate memory for"
 				" response que\n");
-		goto que_failed;
+		goto failed;
 	}
 
 	rsp->length = RESPONSE_ENTRY_CNT_MQ;
@@ -728,6 +729,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 
 que_failed:
 	qla25xx_free_rsp_que(base_vha, rsp);
+failed:
 	return 0;
 }
 
-- 
1.6.2


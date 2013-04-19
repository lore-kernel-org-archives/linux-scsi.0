From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] [SCSI] qla2xxx: fix error return code in qla2x00_probe_one()
Date: Fri, 19 Apr 2013 13:13:59 +0800
Message-ID: <CAPgLHd92aCMGJ-CGaJt34_bYKbRVTgYCORsCL3m+Ue05wpL9GA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:48622 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3DSFOA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Apr 2013 01:14:00 -0400
Received: by mail-bk0-f51.google.com with SMTP id y8so1574969bkt.38
        for <linux-scsi@vger.kernel.org>; Thu, 18 Apr 2013 22:13:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, JBottomley@parallels.com
Cc: yongjun_wei@trendmicro.com.cn, linux-driver@qlogic.com, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code in the queues alloc error handling
case instead of 0, as done elsewhere in this function.
And also fix to return 0 from qla2x00_alloc_queues() when no error, otherwise
this cause if (!qla2x00_alloc_queues(ha, req, rsp)) always be false.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/qla2xxx/qla_os.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5307bf8..16fe011 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -344,7 +344,7 @@ static int qla2x00_alloc_queues(struct qla_hw_data *ha, struct req_que *req,
 	ha->req_q_map[0] = req;
 	set_bit(0, ha->rsp_qid_map);
 	set_bit(0, ha->req_qid_map);
-	return 1;
+	return 0;
 
 fail_rsp_map:
 	kfree(ha->req_q_map);
@@ -2631,7 +2631,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 que_init:
 	/* Alloc arrays of request and response ring ptrs */
-	if (!qla2x00_alloc_queues(ha, req, rsp)) {
+	ret = qla2x00_alloc_queues(ha, req, rsp);
+	if (ret) {
 		ql_log(ql_log_fatal, base_vha, 0x003d,
 		    "Failed to allocate memory for queue pointers..."
 		    "aborting.\n");


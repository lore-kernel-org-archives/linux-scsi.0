From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 1/2] qla2xxx: Fix request queue null dereference.
Date: Thu, 3 Oct 2013 03:21:13 -0400
Message-ID: <1380784874-15457-2-git-send-email-saurav.kashyap@qlogic.com>
References: <1380784874-15457-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:38414 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374Ab3JCHwL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Oct 2013 03:52:11 -0400
In-Reply-To: <1380784874-15457-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

If an invalid IOCB is returned on the response queue then the index into the
request queue map could be invalid and could return to us a bogus value. This
could cause us to try to deference an invalid pointer and cause an exception.

If we encounter this condition, simply return as no context can be established
for this response.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c |    9 +++++++++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 2ef497e..ee5c183 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -20,7 +20,7 @@
  * | Device Discovery             |       0x2095       | 0x2020-0x2022, |
  * |                              |                    | 0x2011-0x2012, |
  * |                              |                    | 0x2016         |
- * | Queue Command and IO tracing |       0x3058       | 0x3006-0x300b  |
+ * | Queue Command and IO tracing |       0x3059       | 0x3006-0x300b  |
  * |                              |                    | 0x3027-0x3028  |
  * |                              |                    | 0x303d-0x3041  |
  * |                              |                    | 0x302d,0x3033  |
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index df1b30b..ff9c86b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1957,6 +1957,15 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	que = MSW(sts->handle);
 	req = ha->req_q_map[que];
 
+	/* Check for invalid queue pointer */
+	if (req == NULL ||
+	    que >= find_first_zero_bit(ha->req_qid_map, ha->max_req_queues)) {
+		ql_dbg(ql_dbg_io, vha, 0x3059,
+		    "Invalid status handle (0x%x): Bad req pointer. req=%p, "
+		    "que=%u.\n", sts->handle, req, que);
+		return;
+	}
+
 	/* Validate handle. */
 	if (handle < req->num_outstanding_cmds)
 		sp = req->outstanding_cmds[handle];
-- 
1.7.7


From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 24/29] qla2xxx: Move queue depth ramp down message to i/o debug level.
Date: Tue, 27 Aug 2013 01:37:50 -0400
Message-ID: <1377581875-8574-25-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:36435 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752920Ab3H0GGv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:51 -0400
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R63PaT019068
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:51 -0700
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1eg8v690wy-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:50 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Unless there is a need to observe them, the queue depth ramp up/down messages
are a nuisance and may cause the system to become unresponsive so move it a
non-default logging level.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e1808b9..9f01bbb 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1508,7 +1508,7 @@ qla2x00_host_ramp_down_queuedepth(scsi_qla_host_t *vha)
 			if (sdev->queue_depth > shost->cmd_per_lun) {
 				if (sdev->queue_depth < ha->cfg_lun_q_depth)
 					continue;
-				ql_log(ql_log_warn, vp, 0x3031,
+				ql_dbg(ql_dbg_io, vp, 0x3031,
 				    "%ld:%d:%d: Ramping down queue depth to %d",
 				    vp->host_no, sdev->id, sdev->lun,
 				    ha->cfg_lun_q_depth);
-- 
1.7.7


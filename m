From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 13/29] qla2xxx: Make log message that prints when a completion status requires a port down more readable.
Date: Tue, 27 Aug 2013 01:37:39 -0400
Message-ID: <1377581875-8574-14-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51778 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752691Ab3H0GGm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:42 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R64Oi6012247
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:42 -0700
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1e5gq13pa9-8
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:42 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b4fb8a6..4a9782c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2178,8 +2178,10 @@ check_scsi_status:
 		}
 
 		ql_dbg(ql_dbg_io, fcport->vha, 0x3021,
-		    "Port down status: port-state=0x%x.\n",
-		    atomic_read(&fcport->state));
+		    "Port to be marked lost on fcport=%02x%02x%02x, current "
+		    "port state= %s.\n", fcport->d_id.b.domain,
+		    fcport->d_id.b.area, fcport->d_id.b.al_pa,
+		    port_state_str[atomic_read(&fcport->state)]);
 
 		if (atomic_read(&fcport->state) == FCS_ONLINE)
 			qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
-- 
1.7.7


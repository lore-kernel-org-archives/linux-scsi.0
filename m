From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 4/6] qla4xxx: Fix smatch warning in func qla4xxx_get_ep_param
Date: Wed, 9 Apr 2014 21:12:27 -0400
Message-ID: <1397092349-25332-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1397092349-25332-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:3531 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933736AbaDJBuP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2014 21:50:15 -0400
In-Reply-To: <1397092349-25332-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, giridhar.malavali@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Fix following smatch warning:-
 drivers/scsi/qla4xxx/ql4_os.c:1752 qla4xxx_get_ep_param() warn: variable dereferenced before check 'qla_ep' (see line 1745)

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 9be829b..592f293 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1742,6 +1742,9 @@ static int qla4xxx_get_ep_param(struct iscsi_endpoint *ep,
 	struct sockaddr *dst_addr;
 	struct scsi_qla_host *ha;
 
+	if (!qla_ep)
+		return -ENOTCONN;
+
 	ha = to_qla_host(qla_ep->host);
 	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: host: %ld\n", __func__,
 			  ha->host_no));
@@ -1749,9 +1752,6 @@ static int qla4xxx_get_ep_param(struct iscsi_endpoint *ep,
 	switch (param) {
 	case ISCSI_PARAM_CONN_PORT:
 	case ISCSI_PARAM_CONN_ADDRESS:
-		if (!qla_ep)
-			return -ENOTCONN;
-
 		dst_addr = (struct sockaddr *)&qla_ep->dst_addr;
 		if (!dst_addr)
 			return -ENOTCONN;
-- 
1.8.2.GIT


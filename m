From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 05/24] qla4xxx: Improve loopback failure messages
Date: Mon, 16 Dec 2013 06:49:35 -0500
Message-ID: <1387194594-29817-6-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:20166 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753937Ab3LPMXl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:41 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Nilesh Javali <nilesh.javali@qlogic.com>

From: Nilesh Javali <nilesh.javali@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_bsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_bsg.c b/drivers/scsi/qla4xxx/ql4_bsg.c
index 04a0027..9f92cbf 100644
--- a/drivers/scsi/qla4xxx/ql4_bsg.c
+++ b/drivers/scsi/qla4xxx/ql4_bsg.c
@@ -517,7 +517,7 @@ static int qla4_83xx_wait_for_loopback_config_comp(struct scsi_qla_host *ha,
 						(ha->idc_extend_tmo * HZ))) {
 				ha->notify_idc_comp = 0;
 				ha->notify_link_up_comp = 0;
-				ql4_printk(KERN_WARNING, ha, "%s: IDC Complete notification not received",
+				ql4_printk(KERN_WARNING, ha, "%s: Aborting: IDC Complete notification not received",
 					   __func__);
 				status = QLA_ERROR;
 				goto exit_wait;
@@ -538,7 +538,7 @@ static int qla4_83xx_wait_for_loopback_config_comp(struct scsi_qla_host *ha,
 		if (!wait_for_completion_timeout(&ha->link_up_comp,
 						 (IDC_COMP_TOV * HZ))) {
 			ha->notify_link_up_comp = 0;
-			ql4_printk(KERN_WARNING, ha, "%s: LINK UP notification not received",
+			ql4_printk(KERN_WARNING, ha, "%s: Aborting: LINK UP notification not received",
 				   __func__);
 			status = QLA_ERROR;
 			goto exit_wait;
-- 
1.8.2.GIT


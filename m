From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 2/9] qla4xxx: Fix CPU lockups when ql4xdontresethba set
Date: Thu, 1 Dec 2011 22:42:07 -0800
Message-ID: <1322808134-21665-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1322808134-21665-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:25840
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751713Ab1LBGzv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2011 01:55:51 -0500
In-Reply-To: <1322808134-21665-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, poornima.vonti@qlogic.com, Mike Hernandez <michael.hernandez@qlogic.com>

From: Mike Hernandez <michael.hernandez@qlogic.com>

Fix issue where CPU lockup is seen when ql4xdontresethba is set and
driver is "stuck" in NEED_RESET state handler.

JIRA Key: UPSISCSI-120

Signed-off-by: Mike Hernandez <michael.hernandez@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index f484ff4..7fc29c6 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1836,6 +1836,10 @@ int qla4_8xxx_device_state_handler(struct scsi_qla_host *ha)
 				 * reset handler */
 				dev_init_timeout = jiffies +
 					(ha->nx_dev_init_timeout * HZ);
+			} else {
+				qla4_8xxx_idc_unlock(ha);
+				msleep(1000);
+				qla4_8xxx_idc_lock(ha);
 			}
 			qla4_8xxx_idc_unlock(ha);
 			break;
-- 
1.7.8.rc2.3.g0911



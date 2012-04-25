From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 4/5] qla2xxx: Properly check for current state after the fabric-login request.
Date: Wed, 25 Apr 2012 07:26:16 -0700
Message-ID: <1335363977-6816-5-git-send-email-chad.dupuis@qlogic.com>
References: <1335363977-6816-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:37519
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808Ab2DYOl5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Apr 2012 10:41:57 -0400
Received: from mail107-db3 (localhost [127.0.0.1])	by
 mail107-db3-R.bigfish.com (Postfix) with ESMTP id B6B0B4038C	for
 <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2012 14:41:55 +0000 (UTC)
In-Reply-To: <1335363977-6816-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a2f9992..39430c3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3577,9 +3577,25 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 						continue;
 					/* Attempt a retry. */
 					status = 1;
-				} else
+				} else {
 					status = qla2x00_fabric_login(vha,
 					    fcport, &next_loopid);
+					if (status ==  QLA_SUCCESS) {
+						int status2;
+						uint8_t opts;
+
+						opts = 0;
+						if (fcport->flags &
+						    FCF_FCP2_DEVICE)
+							opts |= BIT_1;
+							status2 =
+							    qla2x00_get_port_database(
+							        vha, fcport,
+							        opts);
+						if (status2 != QLA_SUCCESS)
+							status = 1;
+					}
+				}
 			} else
 				status = qla2x00_local_device_login(vha,
 								fcport);
-- 
1.6.0.2



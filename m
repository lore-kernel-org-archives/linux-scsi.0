From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 20/22] qla2xxx: Replace a constant with a macro definition for host->canqueue assigmnment.
Date: Wed, 30 Oct 2013 03:38:27 -0400
Message-ID: <1383118709-5569-21-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:65361 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752410Ab3J3IJw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:09:52 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.h |    3 +++
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.h b/drivers/scsi/qla2xxx/qla_mr.h
index 1416e5e..6cd7072 100644
--- a/drivers/scsi/qla2xxx/qla_mr.h
+++ b/drivers/scsi/qla2xxx/qla_mr.h
@@ -545,4 +545,7 @@ struct mr_data_fx00 {
 
 #define QLAFX00_CRITEMP_THRSHLD		80	/* Celsius degrees */
 
+/* Max conncurrent IOs that can be queued */
+#define QLAFX00_MAX_CANQUEUE		1024
+
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index edd2a52..8042d97 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2566,7 +2566,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	host = base_vha->host;
 	base_vha->req = req;
 	if (IS_QLAFX00(ha))
-		host->can_queue = 1024;
+		host->can_queue = QLAFX00_MAX_CANQUEUE;
 	else
 		host->can_queue = req->length + 128;
 	if (IS_QLA2XXX_MIDTYPE(ha))
-- 
1.7.7


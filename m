From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 03/23] qla2xxx: Avoid null pointer dereference in shutdown routine.
Date: Fri,  8 Feb 2013 01:57:44 -0500
Message-ID: <1360306684-8286-4-git-send-email-saurav.kashyap@qlogic.com>
References: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:41515 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759942Ab3BHHTJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Feb 2013 02:19:09 -0500
In-Reply-To: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Masanari Iida <standby24x7@gmail.com>

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0612d25..9e3ae1d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2808,6 +2808,9 @@ qla2x00_shutdown(struct pci_dev *pdev)
 	scsi_qla_host_t *vha;
 	struct qla_hw_data  *ha;
 
+	if (!atomic_read(&pdev->enable_cnt))
+		return;
+
 	vha = pci_get_drvdata(pdev);
 	ha = vha->hw;
 
-- 
1.7.7


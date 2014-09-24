From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 26/35] qla2xxx: Force use of mailbox interface for flash access commands for ISP27xx.
Date: Wed, 24 Sep 2014 03:08:29 -0400
Message-ID: <1411542518-2477-27-git-send-email-saurav.kashyap@qlogic.com>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:8433 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753184AbaIXHmv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 03:42:51 -0400
In-Reply-To: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 1b91771..51cabb9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1848,7 +1848,9 @@ enable_82xx_npiv:
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	}
 
-	if (rval == QLA_SUCCESS && IS_FAC_REQUIRED(ha)) {
+	if (IS_QLA27XX(ha))
+		ha->flags.fac_supported = 1;
+	else if (rval == QLA_SUCCESS && IS_FAC_REQUIRED(ha)) {
 		uint32_t size;
 
 		rval = qla81xx_fac_get_sector_size(vha, &size);
-- 
1.7.7


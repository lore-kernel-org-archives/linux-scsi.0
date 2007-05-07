From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/6] qla2xxx: Attempt to stop firmware only if it had been previously executed.
Date: Mon,  7 May 2007 07:43:00 -0700
Message-ID: <11785489832714-git-send-email-andrew.vasquez@qlogic.com>
References: <20070507144216.GC7207@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47147 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934189AbXEGOnb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 10:43:31 -0400
In-Reply-To: <20070507144216.GC7207@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3e296ab..6ad1588 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3931,6 +3931,8 @@ qla2x00_try_to_stop_firmware(scsi_qla_host_t *ha)
 
 	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
 		return;
+	if (!ha->fw_major_version)
+		return;
 
 	ret = qla2x00_stop_firmware(ha);
 	for (retries = 5; ret != QLA_SUCCESS && retries ; retries--) {
-- 
1.5.2.rc1.9.g6644


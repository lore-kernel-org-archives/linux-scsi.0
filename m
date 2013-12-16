From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 3/6] libata: resume in the background
Date: Mon, 16 Dec 2013 18:30:54 -0500
Message-ID: <1387236657-4852-4-git-send-email-psusi@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com>
 <1387236657-4852-1-git-send-email-psusi@ubuntu.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:63298 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3LPXbB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 18:31:01 -0500
In-Reply-To: <1387236657-4852-1-git-send-email-psusi@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: todd.e.brandt@linux.intel.com
Cc: tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Don't block the resume path waiting for the disk to
spin up.
---
 drivers/ata/libata-core.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 8f856bb..4a28caf 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5430,20 +5430,18 @@ static int __ata_port_resume_common(struct ata_port *ap, pm_message_t mesg,
 static int ata_port_resume_common(struct device *dev, pm_message_t mesg)
 {
 	struct ata_port *ap = to_ata_port(dev);
+	static int dontcare;
 
-	return __ata_port_resume_common(ap, mesg, NULL);
+	return __ata_port_resume_common(ap, mesg, &dontcare);
 }
 
 static int ata_port_resume(struct device *dev)
 {
 	int rc;
 
+	if (pm_runtime_suspended(dev))
+		return 0;
 	rc = ata_port_resume_common(dev, PMSG_RESUME);
-	if (!rc) {
-		pm_runtime_disable(dev);
-		pm_runtime_set_active(dev);
-		pm_runtime_enable(dev);
-	}
 
 	return rc;
 }
-- 
1.8.3.2


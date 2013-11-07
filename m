From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 2/3] libata: resume in the background
Date: Wed,  6 Nov 2013 20:57:50 -0500
Message-ID: <28bdcf248ad07b8b5d6be8bff6a8c94fdd09a435.1383789225.git.psusi@ubuntu.com>
References: <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:36806 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab3KGB5x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Nov 2013 20:57:53 -0500
In-Reply-To: <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com>
In-Reply-To: <527AF287.7020700@ubuntu.com>
References: <527AF287.7020700@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: todd.e.brandt@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: tj@kernel.org, JBottomley@parallels.com

Don't block the resume path waiting for the disk to
spin up.
---
 drivers/ata/libata-core.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 573d151..16f45dc 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5420,20 +5420,18 @@ static int __ata_port_resume_common(struct ata_port *ap, pm_message_t mesg,
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


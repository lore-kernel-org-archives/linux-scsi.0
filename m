From: boutcher@cs.umn.edu (Dave C Boutcher)
Subject: [PATCH 2/2] ibmvscsi: handle inactive SCSI target during probe
Date: Thu, 6 Jul 2006 22:08:49 -0500
Message-ID: <17581.53313.139646.861713@hound.rchland.ibm.com>
References: <17581.52781.675644.492909@hound.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.34.202]:40850 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S1751156AbWGGDJD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jul 2006 23:09:03 -0400
Received: from localhost (localhost [127.0.0.1])
	by augustus.cs.umn.edu (Postfix) with ESMTP id 3701F5C531
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jul 2006 22:09:03 -0500 (CDT)
Received: from mail.cs.umn.edu ([127.0.0.1])
 by localhost (mail.cs.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
 with LMTP id 03243-02 for <linux-scsi@vger.kernel.org>;
 Thu,  6 Jul 2006 22:09:02 -0500 (CDT)
Received: from tera.cs.umn.edu (tera.cs.umn.edu [128.101.35.163])
	by mail.cs.umn.edu (Postfix) with ESMTP id C05805C52B
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jul 2006 22:09:02 -0500 (CDT)
In-Reply-To: <17581.52781.675644.492909@hound.rchland.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Without this patch we register an interrupt with request_irq,
but then return a bad return code from the module probe.

---

 drivers/scsi/ibmvscsi/rpa_vscsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

280f9372694f1411cd416297eb7e3a2a0de1e435
diff --git a/drivers/scsi/ibmvscsi/rpa_vscsi.c b/drivers/scsi/ibmvscsi/rpa_vscsi.c
index 242b887..ed22b96 100644
--- a/drivers/scsi/ibmvscsi/rpa_vscsi.c
+++ b/drivers/scsi/ibmvscsi/rpa_vscsi.c
@@ -238,6 +238,7 @@ int ibmvscsi_init_crq_queue(struct crq_q
 	if (rc == 2) {
 		/* Adapter is good, but other end is not ready */
 		printk(KERN_WARNING "ibmvscsi: Partner adapter not ready\n");
+		retrc = 0;
 	} else if (rc != 0) {
 		printk(KERN_WARNING "ibmvscsi: Error %d opening adapter\n", rc);
 		goto reg_crq_failed;
-- 
1.2.4.gc98264


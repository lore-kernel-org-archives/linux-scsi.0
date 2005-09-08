From: "Ju, Seokmann" <sju@lsil.com>
Subject: [PATCH 1/1][BUG] undefined symbol in legacy megaraid driver on 2.
	6.12-mm1
Date: Thu, 8 Sep 2005 15:31:51 -0400
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703662B21@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:53144 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964952AbVIHTb5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2005 15:31:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Hi,

I've created a patch to address "legacy megaraid driver compilation error on
2.6.12-mm1 kernel.
Please take this patch and let me know for any further concern.

Thank you,

Seokmann

Sign-off by: Seokmann JU <seokmann.ju@lsil.com>
---
diff -Naur old/drivers/scsi/megaraid.c new/drivers/scsi/megaraid.c
--- old/drivers/scsi/megaraid.c	2005-09-08 16:24:12.017451400 -0400
+++ new/drivers/scsi/megaraid.c	2005-09-08 16:23:36.509849376 -0400
@@ -1975,9 +1975,11 @@
 static int
 megaraid_reset(Scsi_Cmnd *cmd)
 {
-	adapter = (adapter_t *)cmd->device->host->hostdata;
+	adapter_t *adapter;
 	int rc;
 
+	adapter = (adapter_t *)cmd->device->host->hostdata;
+
 	spin_lock_irq(&adapter->lock);
 	rc = __megaraid_reset(cmd);
 	spin_unlock_irq(&adapter->lock);
---

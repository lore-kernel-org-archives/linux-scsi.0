From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/6] qla2xxx: Error-out during probe() if we're unable to complete HBA initialization.
Date: Mon,  7 May 2007 07:42:58 -0700
Message-ID: <11785489833348-git-send-email-andrew.vasquez@qlogic.com>
References: <20070507144216.GC7207@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47106 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934155AbXEGOnQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 10:43:16 -0400
In-Reply-To: <20070507144216.GC7207@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Remove a stale check against ha->device_flags
(DFLG_NO_CABLE) as topology scanning is performed within the
DPC-thread context.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b78919a..0a36912 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1577,9 +1577,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto probe_failed;
 	}
 
-	if (qla2x00_initialize_adapter(ha) &&
-	    !(ha->device_flags & DFLG_NO_CABLE)) {
-
+	if (qla2x00_initialize_adapter(ha)) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to initialize adapter\n");
 
-- 
1.5.2.rc1.9.g6644


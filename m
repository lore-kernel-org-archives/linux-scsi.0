From: Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] [qla2xxx] Remove duplicate pci_disable_device() call
Date: Wed, 28 Mar 2007 00:49:49 +0200
Message-ID: <20070327224949.GB17095@strauss.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:60192 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934267AbXC0Wtv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Mar 2007 18:49:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

[PATCH] [qla2xxx] Remove duplicate pci_disable_device() call

On the path qla2x00_probe_one() -> probe_failed -> qla2x00_free_device(),
pci_disable_device() is executed twice, once in qla2x00_free_device()
and once in qla2x00_probe_one().

This patch removes the unnecessary call.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 drivers/scsi/qla2xxx/qla_os.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.21-rc5/drivers/scsi/qla2xxx/qla_os.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/scsi/qla2xxx/qla_os.c
+++ linux-2.6.21-rc5/drivers/scsi/qla2xxx/qla_os.c
@@ -1705,6 +1705,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	scsi_host_put(ha->host);
 
+	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 }
 
@@ -1747,8 +1748,6 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 	if (ha->iobase)
 		iounmap(ha->iobase);
 	pci_release_regions(ha->pdev);
-
-	pci_disable_device(ha->pdev);
 }
 
 static inline void


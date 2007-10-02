From: Jeff Garzik <jeff@garzik.org>
Subject: [git patch] SCSI aic94xx fix
Date: Tue, 2 Oct 2007 13:21:51 -0400
Message-ID: <20071002172151.GA28579@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:47320 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbXJBRVw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 13:21:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

The SCSI maintainer wants to wait until 2.6.25 for this obvious data
corruption fix.

I vehemently disagree.



Please pull from 'sas-fixes' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git sas-fixes

to receive the following updates:

 drivers/scsi/aic94xx/aic94xx_task.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Jeff Garzik (1):
      aic94xx: fix DMA data direction for SMP requests

diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index d5d8cab..ab13824 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -451,7 +451,7 @@ static int asd_build_smp_ascb(struct asd_ascb *ascb, struct sas_task *task,
 	struct scb *scb;
 
 	pci_map_sg(asd_ha->pcidev, &task->smp_task.smp_req, 1,
-		   PCI_DMA_FROMDEVICE);
+		   PCI_DMA_TODEVICE);
 	pci_map_sg(asd_ha->pcidev, &task->smp_task.smp_resp, 1,
 		   PCI_DMA_FROMDEVICE);
 
@@ -486,7 +486,7 @@ static void asd_unbuild_smp_ascb(struct asd_ascb *a)
 
 	BUG_ON(!task);
 	pci_unmap_sg(a->ha->pcidev, &task->smp_task.smp_req, 1,
-		     PCI_DMA_FROMDEVICE);
+		     PCI_DMA_TODEVICE);
 	pci_unmap_sg(a->ha->pcidev, &task->smp_task.smp_resp, 1,
 		     PCI_DMA_FROMDEVICE);
 }
